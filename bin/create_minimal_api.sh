#!/bin/bash
# Usage: ./create_minimal_api.sh [ProjectName]
# If no project name is given, the default "MinimalApiApp" is used.
# https://learn.microsoft.com/en-us/aspnet/core/fundamentals/minimal-apis/overview?view=aspnetcore-9.0

PROJECT_NAME=${1:-MinimalApiApp}

# Create a new Minimal API project using the provided name
dotnet new web -o "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Overwrite Program.cs with the minimal code for a Minimal API
cat << 'EOF' > Program.cs
var app = WebApplication.CreateBuilder(args).Build();
app.MapGet("/", () => "Hello, Minimal API!");
app.Run();
EOF
