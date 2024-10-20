package org.springframework.samples.petclinic.api;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.context.annotation.Import;
import org.springframework.samples.TestConfig;

@SpringBootTest
@ActiveProfiles("test")
@Import(TestConfig.class)
class ApiGatewayApplicationTests {

	@Test
	void contextLoads() {
	}

}
