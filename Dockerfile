FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /src
COPY ["Muti-Stage.csproj", "./"]
RUN dotnet restore "./Muti-Stage.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Muti-Stage.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Muti-Stage.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Muti-Stage.dll"]
