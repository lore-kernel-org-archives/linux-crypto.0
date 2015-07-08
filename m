From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: api - Remove unused __crypto_dequeue_request
Date: Wed, 8 Jul 2015 11:55:30 +0800
Message-ID: <20150708035530.GA12627@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35936 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839AbbGHDzd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 23:55:33 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The function __crypto_dequeue_request is completely unused.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 3c079b7..ceebfcf 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -892,7 +892,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(crypto_enqueue_request);
 
-void *__crypto_dequeue_request(struct crypto_queue *queue, unsigned int offset)
+struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue)
 {
 	struct list_head *request;
 
@@ -907,14 +907,7 @@ void *__crypto_dequeue_request(struct crypto_queue *queue, unsigned int offset)
 	request = queue->list.next;
 	list_del(request);
 
-	return (char *)list_entry(request, struct crypto_async_request, list) -
-	       offset;
-}
-EXPORT_SYMBOL_GPL(__crypto_dequeue_request);
-
-struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue)
-{
-	return __crypto_dequeue_request(queue, 0);
+	return list_entry(request, struct crypto_async_request, list);
 }
 EXPORT_SYMBOL_GPL(crypto_dequeue_request);
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index d4ebf6e..9041a84 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -180,7 +180,6 @@ struct crypto_instance *crypto_alloc_instance(const char *name,
 void crypto_init_queue(struct crypto_queue *queue, unsigned int max_qlen);
 int crypto_enqueue_request(struct crypto_queue *queue,
 			   struct crypto_async_request *request);
-void *__crypto_dequeue_request(struct crypto_queue *queue, unsigned int offset);
 struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue);
 int crypto_tfm_in_queue(struct crypto_queue *queue, struct crypto_tfm *tfm);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
