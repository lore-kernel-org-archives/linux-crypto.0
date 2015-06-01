From: Martin Willi <martin@strongswan.org>
Subject: [PATCH 7/9] crypto: chacha20poly1305 - Add an IPsec variant for RFC7539 AEAD
Date: Mon,  1 Jun 2015 13:44:02 +0200
Message-ID: <1433159044-30753-8-git-send-email-martin@strongswan.org>
References: <1433159044-30753-1-git-send-email-martin@strongswan.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from revosec.ch ([5.148.177.19]:40479 "EHLO revosec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbbFAMYl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 08:24:41 -0400
In-Reply-To: <1433159044-30753-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

draft-ietf-ipsecme-chacha20-poly1305 defines the use of ChaCha20/Poly1305 in
ESP. It uses additional four byte key material as a salt, which is then used
with an 8 byte IV to form the ChaCha20 nonce as defined in the RFC7539.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 crypto/chacha20poly1305.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
index 6171cf1..05fbc59 100644
--- a/crypto/chacha20poly1305.c
+++ b/crypto/chacha20poly1305.c
@@ -627,6 +627,11 @@ static struct crypto_instance *rfc7539_alloc(struct rtattr **tb)
 	return chachapoly_alloc(tb, "rfc7539", 12);
 }
 
+static struct crypto_instance *rfc7539esp_alloc(struct rtattr **tb)
+{
+	return chachapoly_alloc(tb, "rfc7539esp", 8);
+}
+
 static void chachapoly_free(struct crypto_instance *inst)
 {
 	struct chachapoly_instance_ctx *ctx = crypto_instance_ctx(inst);
@@ -643,13 +648,31 @@ static struct crypto_template rfc7539_tmpl = {
 	.module = THIS_MODULE,
 };
 
+static struct crypto_template rfc7539esp_tmpl = {
+	.name = "rfc7539esp",
+	.alloc = rfc7539esp_alloc,
+	.free = chachapoly_free,
+	.module = THIS_MODULE,
+};
+
 static int __init chacha20poly1305_module_init(void)
 {
-	return crypto_register_template(&rfc7539_tmpl);
+	int err;
+
+	err = crypto_register_template(&rfc7539_tmpl);
+	if (err)
+		return err;
+
+	err = crypto_register_template(&rfc7539esp_tmpl);
+	if (err)
+		crypto_unregister_template(&rfc7539_tmpl);
+
+	return err;
 }
 
 static void __exit chacha20poly1305_module_exit(void)
 {
+	crypto_unregister_template(&rfc7539esp_tmpl);
 	crypto_unregister_template(&rfc7539_tmpl);
 }
 
@@ -661,3 +684,4 @@ MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
 MODULE_DESCRIPTION("ChaCha20-Poly1305 AEAD");
 MODULE_ALIAS_CRYPTO("chacha20poly1305");
 MODULE_ALIAS_CRYPTO("rfc7539");
+MODULE_ALIAS_CRYPTO("rfc7539esp");
-- 
1.9.1
