start:
	@echo "Building and starting the LMS..."
	docker-compose -f main-api/docker-compose.yml up --build

restart:
	@echo "Restarting the LMS..."
	docker-compose -f main-api/docker-compose.yml down
	@make start

stop:
	@echo "Stopping the LMS..."
	docker-compose -f main-api/docker-compose.yml down