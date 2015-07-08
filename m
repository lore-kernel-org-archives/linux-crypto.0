From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2] crypto: aead - Add aead_queue interface
Date: Wed, 8 Jul 2015 12:15:14 +0800
Message-ID: <20150708041514.GA12840@gondor.apana.org.au>
References: <20150708035621.GB12627@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60666 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbbGHEPS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 00:15:18 -0400
Content-Disposition: inline
In-Reply-To: <20150708035621.GB12627@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This version adds aead_get_backlog.

---8<---

This patch adds a type-safe queueing interface for AEAD.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index 4b25471..c3942f4 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -34,6 +34,10 @@ struct crypto_aead_spawn {
 	struct crypto_spawn base;
 };
 
+struct aead_queue {
+	struct crypto_queue base;
+};
+
 extern const struct crypto_type crypto_aead_type;
 extern const struct crypto_type crypto_nivaead_type;
 
@@ -157,6 +161,37 @@ static inline unsigned int crypto_aead_maxauthsize(struct crypto_aead *aead)
 	return crypto_aead_alg_maxauthsize(crypto_aead_alg(aead));
 }
 
+static inline void aead_init_queue(struct aead_queue *queue,
+				   unsigned int max_qlen)
+{
+	crypto_init_queue(&queue->base, max_qlen);
+}
+
+static inline int aead_enqueue_request(struct aead_queue *queue,
+				       struct aead_request *request)
+{
+	return crypto_enqueue_request(&queue->base, &request->base);
+}
+
+static inline struct aead_request *aead_dequeue_request(
+	struct aead_queue *queue)
+{
+	struct crypto_async_request *req;
+
+	req = crypto_dequeue_request(&queue->base);
+
+	return req ? container_of(req, struct aead_request, base) : NULL;
+}
+
+static inline struct aead_request *aead_get_backlog(struct aead_queue *queue)
+{
+	struct crypto_async_request *req;
+
+	req = crypto_get_backlog(&queue->base);
+
+	return req ? container_of(req, struct aead_request, base) : NULL;
+}
+
 int crypto_register_aead(struct aead_alg *alg);
 void crypto_unregister_aead(struct aead_alg *alg);
 int crypto_register_aeads(struct aead_alg *algs, int count);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
