Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:1515 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbeLKKwV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 05:52:21 -0500
From: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        atul.gupta@chelsio.com, indranil@chelsio.com
Cc: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 6/6] crypto:chelsio: Fix wrong error counter increments
Date: Tue, 11 Dec 2018 16:21:42 +0530
Message-Id: <b7d40ca24faf9cda3f79bf34ff94c7e460d26c36.1544520025.git.harsh@chelsio.com>
In-Reply-To: <cover.1544520025.git.harsh@chelsio.com>
References: <cover.1544520025.git.harsh@chelsio.com>
In-Reply-To: <cover.1544520025.git.harsh@chelsio.com>
References: <cover.1544520025.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix error counter increment in AEAD decrypt operation when
validation of tag is done in Driver instead of H/W.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c |  9 +++++----
 drivers/crypto/chelsio/chcr_core.c | 11 +++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index df52641..eedc331 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -218,7 +218,7 @@ static inline void chcr_dec_wrcount(struct chcr_dev *dev)
 	atomic_dec(&dev->inflight);
 }
 
-static inline void chcr_handle_aead_resp(struct aead_request *req,
+static inline int chcr_handle_aead_resp(struct aead_request *req,
 					 unsigned char *input,
 					 int err)
 {
@@ -233,6 +233,8 @@ static inline void chcr_handle_aead_resp(struct aead_request *req,
 	}
 	chcr_dec_wrcount(dev);
 	req->base.complete(&req->base, err);
+
+	return err;
 }
 
 static void get_aes_decrypt_key(unsigned char *dec_key,
@@ -2072,14 +2074,13 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 
 	switch (tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_AEAD:
-		chcr_handle_aead_resp(aead_request_cast(req), input, err);
+		err = chcr_handle_aead_resp(aead_request_cast(req), input, err);
 		break;
 
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
-		 err = chcr_handle_cipher_resp(ablkcipher_request_cast(req),
+		 chcr_handle_cipher_resp(ablkcipher_request_cast(req),
 					       input, err);
 		break;
-
 	case CRYPTO_ALG_TYPE_AHASH:
 		chcr_handle_ahash_resp(ahash_request_cast(req), input, err);
 		}
diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index e04b3e8..239b933 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -169,12 +169,8 @@ static int cpl_fw6_pld_handler(struct chcr_dev *dev,
 
 	ack_err_status =
 		ntohl(*(__be32 *)((unsigned char *)&fw6_pld->data[0] + 4));
-	if (ack_err_status) {
-		if (CHK_MAC_ERR_BIT(ack_err_status) ||
-		    CHK_PAD_ERR_BIT(ack_err_status))
-			error_status = -EBADMSG;
-		atomic_inc(&adap->chcr_stats.error);
-	}
+	if (CHK_MAC_ERR_BIT(ack_err_status) || CHK_PAD_ERR_BIT(ack_err_status))
+		error_status = -EBADMSG;
 	/* call completion callback with failure status */
 	if (req) {
 		error_status = chcr_handle_resp(req, input, error_status);
@@ -182,6 +178,9 @@ static int cpl_fw6_pld_handler(struct chcr_dev *dev,
 		pr_err("Incorrect request address from the firmware\n");
 		return -EFAULT;
 	}
+	if (error_status)
+		atomic_inc(&adap->chcr_stats.error);
+
 	return 0;
 }
 
-- 
2.1.4
