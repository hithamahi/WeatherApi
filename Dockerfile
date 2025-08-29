# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY WeatherApi.sln .
COPY WeatherApi/WeatherApi/WeatherApi.csproj WeatherApi/

# Restore dependencies
RUN dotnet restore WeatherApi.sln

# Copy everything
COPY . .

# Build and publish
RUN dotnet publish WeatherApi/WeatherApi/WeatherApi.csproj -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "WeatherApi.dll"]
