package org.springframework.samples.petclinic.api.boundary.web;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.reactive.WebFluxTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.cloud.circuitbreaker.resilience4j.ReactiveResilience4JAutoConfiguration;
import org.springframework.context.annotation.Import;
import org.springframework.samples.petclinic.api.application.CustomersServiceClient;
import org.springframework.samples.petclinic.api.application.VisitsServiceClient;
import org.springframework.samples.petclinic.api.dto.OwnerDetails;
import org.springframework.samples.petclinic.api.dto.PetDetails;
import org.springframework.samples.petclinic.api.dto.VisitDetails;
import org.springframework.samples.petclinic.api.dto.Visits;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.reactive.server.WebTestClient;

import io.netty.handler.codec.http.websocketx.extensions.compression.PerMessageDeflateClientExtensionHandshaker;
import reactor.core.publisher.Mono;

import java.net.ConnectException;
import java.util.Collections;

@ExtendWith(SpringExtension.class)
@WebFluxTest(controllers = ApiGatewayController.class)
@Import({ReactiveResilience4JAutoConfiguration.class, CircuitBreakerConfiguration.class})
class ApiGatewayControllerTest {

    @MockBean
    private CustomersServiceClient customersServiceClient;

    @MockBean
    private VisitsServiceClient visitsServiceClient;

    @Autowired
    private WebTestClient client;


    @Test
    void getOwnerDetails_withAvailableVisitsService() {
        OwnerDetails owner = new OwnerDetails();
        owner.setId(1);
        owner.setFirstName("John");
        owner.setLastName("Doe");
        owner.setAddress("123 Main St");
        owner.setCity("Anytown");
        owner.setTelephone("555-1234");
        PetDetails cat = new PetDetails();//new PetDetails(1, "Leo", null, null, null);
        cat.setId(1);
        cat.setName("Leo");
        owner.getPets().add(cat);
        Mockito
            .when(customersServiceClient.getOwner(1))
            .thenReturn(Mono.just(owner));

        Visits visits = new Visits();
        VisitDetails visit = new VisitDetails();//new VisitDetails(1, 1, "2018-08-01", null);
        visit.setId(1);
        visit.setPetId(1);
        visit.setDate("2018-08-01");
        visits.getItems().add(visit);
        Mockito
            .when(visitsServiceClient.getVisitsForPets(Collections.singletonList(cat.getId())))
            .thenReturn(Mono.just(visits));

        client.get()
            .uri("/api/gateway/owners/1")
            .exchange();
            //.expectStatus().isOk()
            //.expectBody(String.class)
            //.consumeWith(response ->
            //    Assertions.assertThat(response.getResponseBody()).isEqualTo("Garfield"));
            //.expectBody()
            //.jsonPath("$.pets[0].name").isEqualTo("Leo")
            //.jsonPath("$.pets[0].visits[0].date").isEqualTo("2018-08-01");
    }

    /**
     * Test Resilience4j fallback method
     */
    @Test
    void getOwnerDetails_withServiceError() {
        OwnerDetails owner = new OwnerDetails();
        PetDetails cat = new PetDetails();//new PetDetails(1, "Leo", null, null, null);
        cat.setId(1);
        cat.setName("Leo");
        owner.getPets().add(cat);
        Mockito
            .when(customersServiceClient.getOwner(1))
            .thenReturn(Mono.just(owner));

        Mockito
            .when(visitsServiceClient.getVisitsForPets(Collections.singletonList(cat.getId())))
            .thenReturn(Mono.error(new ConnectException("Simulate error")));

        client.get()
            .uri("/api/gateway/owners/1")
            .exchange();
            //.expectStatus().isOk()
            //.expectBody()
            //.jsonPath("$.pets[0].name").isEqualTo("Leo")
            //.jsonPath("$.pets[0].visits").isEmpty();
    }

}
