start:
	@echo "Building the project..."
	docker-compose -f main-api/docker-compose.yml up --build

restart:
	@echo "Restarting the project..."
	docker-compose -f main-api/docker-compose.yml down
	@make start
