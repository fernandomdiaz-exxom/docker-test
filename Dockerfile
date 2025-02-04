#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 4443
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["docker-test/docker-test.csproj", "docker-test/"]
RUN dotnet restore "docker-test/docker-test.csproj"
COPY . .
WORKDIR "/src/docker-test"
RUN dotnet build "docker-test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "docker-test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "docker-test.dll"] 
