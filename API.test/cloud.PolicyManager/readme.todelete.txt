In attesa di risposta dall'owner ecco le seguenti questioni da risolvere prima del commit su github

1) Manca solo da capire come far funzionare il GE senza le credenziali di amministrazione del FIWARE LAB
- forse non è possibile

2) Inserire nel fiware-cloto.cfg nel parametro CONTEXT_BROKER_URL l'IP pubblico di Orion
- deve farlo chi installa il GE (insieme all'aggiunta dei parametri per MySQL)

3) Nel test c'è il seguente errore sulla creazione del subscription (createSubscription)

response:
{
    "serverFault": {
        "message": "'subscribeResponse'", 
        "code": 500
    }
} 

HTTPConnectionPool(host='130.206.81.44', port=1026): Max retries exceeded with url: /NGSI10/subscribeContext (Caused by <class 'socket.error'>: [Errno 113] No route to host)

Questo forse perchè l'instanza pubblica usa come IP pubblico di Orion (da verificare) 

4) Le successive richieste (getSubscription e deleteSubscription) vanno in errore
- non dovrebbero dare problemi nel caso si risolve l'errore sopra ... passando il giusto 'subscriptionId'