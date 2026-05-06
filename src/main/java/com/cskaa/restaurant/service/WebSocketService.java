package com.cskaa.restaurant.service;


import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.cskaa.restaurant.model.Order;

@Service
public class WebSocketService {

    private final SimpMessagingTemplate messagingTemplate;

    @Autowired
    /**
     * Constructor for the WebSocketService class.
     *
     * @param messagingTemplate The SimpMessagingTemplate object used for sending WebSocket messages.
     */
    public WebSocketService(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    /**
     * Notifies the frontend about a new order by sending a WebSocket message.
     *
     * @param order The VMSOrder object representing the newly created order.
     * @throws JSONException
     */
    public void notifyFrontendForNewOrder(Order order) throws JSONException {

        JSONObject jsonObject=new JSONObject();

       
        jsonObject.put("orderId", order.getId());
        jsonObject.put("customerName", order.getCustomer().getFirstName());

        
        jsonObject.put("totalAmount", order.getTotalAmountAfterTax());

     
        int itemCount = (order.getItems() != null) ? order.getItems().size() : 0;
        jsonObject.put("numberOfItems", itemCount);

        jsonObject.put("status", order.getStatus().toString());
        jsonObject.put("statusInInteger", order.getStatus().ordinal());

        jsonObject.put("createdAt", order.getCreatedAt().toString());

        // Send to the restaurant-specific topic
        messagingTemplate.convertAndSend("/topic/" + order.getRestaurant().getId() + "/new-order", jsonObject.toString());

    }

}
