#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["docker-test/docker-test.csproj", "docker-test/"]
RUN dotnet restore "docker-test/docker-test.csproj"
COPY . .
WORKDIR "/src/docker-test"
RUN dotnet build "docker-test.csproj" -c Release -o /app/build
RUN dotnet publish "docker-test.csproj" -c Release -o /app/publish
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 8080
RUN dotnet dev-certs https --trust
ENTRYPOINT ["dotnet", "docker-test.dll"] 
