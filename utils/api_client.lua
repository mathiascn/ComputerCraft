-- APIClient Module
-- This module provides a simple API client for making HTTP GET and POST requests.
-- It uses JSON for data encoding and decoding.

local json = loadfile("json")()
APIClient = {}
APIClient.__index = APIClient

--- Creates a new APIClient instance.
-- @param baseURL The base URL of the API to interact with.
-- @return A new APIClient instance.
function APIClient.new(baseURL)
    local self = setmetatable({}, APIClient)
    self.baseURL = baseURL
    return self
end


--- Sends a GET request to the specified API endpoint.
-- @param endpoint The API endpoint to send the GET request to (relative to baseURL).
-- @return A Lua table containing the decoded JSON response data.
-- @error Raises an error if the HTTP request fails or the JSON decoding fails.
function APIClient:get(endpoint)
    local url = self.baseURL .. endpoint
    local response = http.get(url)
    if not response then
        error("Failed to get response from server")
    end

    local jsonString = response.readAll()
    response.close()
    local ok, data = pcall(json.decode, jsonString)
    if not ok then
        error("Error decoding JSON: " .. data)
    end

    return data
end


--- Sends a POST request to the specified API endpoint.
-- @param endpoint The API endpoint to send the POST request to (relative to baseURL).
-- @param data A Lua table containing the data to be sent in the POST request body.
-- @return A Lua table containing the decoded JSON response data.
-- @error Raises an error if the HTTP request fails or the JSON decoding fails.
function APIClient:post(endpoint, data)
    local url = self.baseURL .. endpoint
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local jsonData = json.encode(data)
    local response = http.post(url, jsonData, headers)
    if not response then
        error("Failed to post data to server")
    end

    local jsonString = response.readAll()
    response.close()
    local ok, result = pcall(json.decode, jsonString)
    if not ok then
        error("Error decoding JSON response: " .. result)
    end

    return result
end


return APIClient