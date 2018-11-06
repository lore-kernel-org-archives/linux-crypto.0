Return-Path: <SRS0=45GR=NR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38311 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387401AbeKFRxQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Nov 2018 12:53:16 -0500
Received: by mail-pf1-f193.google.com with SMTP id b11-v6so5763138pfi.5
        for <linux-crypto@vger.kernel.org>; Tue, 06 Nov 2018 00:29:11 -0800 (PST)
From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Cc: bcm-kernel-feedback-list@broadcom.com,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: [PATCH] crypto: bcm: fix normal/non key hash algorithm failure
Date: Tue,  6 Nov 2018 13:58:58 +0530
Message-Id: <1541492938-29261-1-git-send-email-raveendra.padasalagi@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove setkey() callback handler for normal/non key
hash algorithms and keep it for AES-CBC/CMAC which needs key.

Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
---
 drivers/crypto/bcm/cipher.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 2d1f1db..4d67e22 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4652,12 +4652,16 @@ static int spu_register_ahash(struct iproc_alg_s *driver_alg)
 	hash->halg.statesize = sizeof(struct spu_hash_export_s);
 
 	if (driver_alg->auth_info.mode != HASH_MODE_HMAC) {
-		hash->setkey = ahash_setkey;
 		hash->init = ahash_init;
 		hash->update = ahash_update;
 		hash->final = ahash_final;
 		hash->finup = ahash_finup;
 		hash->digest = ahash_digest;
+		if ((driver_alg->auth_info.alg == HASH_ALG_AES) &&
+		    ((driver_alg->auth_info.mode == HASH_MODE_XCBC) ||
+		    (driver_alg->auth_info.mode == HASH_MODE_CMAC))) {
+			hash->setkey = ahash_setkey;
+		}
 	} else {
 		hash->setkey = ahash_hmac_setkey;
 		hash->init = ahash_hmac_init;
-- 
1.9.1
