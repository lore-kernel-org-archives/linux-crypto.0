From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 4/5] crypto: talitos - containerof related codingstyle
Date: Fri, 27 Mar 2009 22:57:42 -0500
Message-ID: <20090327225742.2b923d8d.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Lee Nipper <lee.nipper@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:44990 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbZC1DqS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2009 23:46:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

no functional changes.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   26 ++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a073e6b..1cc1c41 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -841,13 +841,14 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 				   int err)
 {
 	struct aead_request *areq = context;
-	struct talitos_edesc *edesc =
-		 container_of(desc, struct talitos_edesc, desc);
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct talitos_edesc *edesc;
 	struct scatterlist *sg;
 	void *icvdata;
 
+	edesc = container_of(desc, struct talitos_edesc, desc);
+
 	ipsec_esp_unmap(dev, edesc, areq);
 
 	/* copy the generated ICV to dst */
@@ -869,13 +870,14 @@ static void ipsec_esp_decrypt_swauth_done(struct device *dev,
 					  void *context, int err)
 {
 	struct aead_request *req = context;
-	struct talitos_edesc *edesc =
-		 container_of(desc, struct talitos_edesc, desc);
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct talitos_edesc *edesc;
 	struct scatterlist *sg;
 	void *icvdata;
 
+	edesc = container_of(desc, struct talitos_edesc, desc);
+
 	ipsec_esp_unmap(dev, edesc, req);
 
 	if (!err) {
@@ -901,8 +903,9 @@ static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
 					  void *context, int err)
 {
 	struct aead_request *req = context;
-	struct talitos_edesc *edesc =
-		 container_of(desc, struct talitos_edesc, desc);
+	struct talitos_edesc *edesc;
+
+	edesc = container_of(desc, struct talitos_edesc, desc);
 
 	ipsec_esp_unmap(dev, edesc, req);
 
@@ -1308,8 +1311,9 @@ static void ablkcipher_done(struct device *dev,
 			    int err)
 {
 	struct ablkcipher_request *areq = context;
-	struct talitos_edesc *edesc =
-		 container_of(desc, struct talitos_edesc, desc);
+	struct talitos_edesc *edesc;
+
+	edesc = container_of(desc, struct talitos_edesc, desc);
 
 	common_nonsnoop_unmap(dev, edesc, areq);
 
@@ -1686,12 +1690,14 @@ struct talitos_crypto_alg {
 static int talitos_cra_init(struct crypto_tfm *tfm)
 {
 	struct crypto_alg *alg = tfm->__crt_alg;
-	struct talitos_crypto_alg *talitos_alg =
-		 container_of(alg, struct talitos_crypto_alg, crypto_alg);
+	struct talitos_crypto_alg *talitos_alg;
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
 
+	talitos_alg =  container_of(alg, struct talitos_crypto_alg, crypto_alg);
+
 	/* update context with ptr to dev */
 	ctx->dev = talitos_alg->dev;
+
 	/* copy descriptor header template value */
 	ctx->desc_hdr_template = talitos_alg->desc_hdr_template;
 
-- 
1.6.1.3

