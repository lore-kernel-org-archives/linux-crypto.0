Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7C1C2BB48
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 09:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2975F23B99
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 09:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732414AbgLJJJB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 04:09:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387489AbgLJJJA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 04:09:00 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH 1/2] chcr_ktls: use AES library for single use cipher
Date:   Thu, 10 Dec 2020 10:05:23 +0100
Message-Id: <20201210090524.18880-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201210090524.18880-1-ardb@kernel.org>
References: <20201210090524.18880-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allocating a cipher via the crypto API only to free it again after using
it to encrypt a single block is unnecessary in cases where the algorithm
is known at compile time. So replace this pattern with a call to the AES
library.

Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc: Rohit Maheshwari <rohitm@chelsio.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 5195f692f14d..e9b75cec34db 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -9,6 +9,7 @@
 #include <linux/ip.h>
 #include <net/ipv6.h>
 #include <linux/netdevice.h>
+#include <crypto/aes.h>
 #include "chcr_ktls.h"
 
 static LIST_HEAD(uld_ctx_list);
@@ -30,7 +31,7 @@ static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
 	unsigned char ghash_h[TLS_CIPHER_AES_GCM_256_TAG_SIZE];
 	struct tls12_crypto_info_aes_gcm_128 *info_128_gcm;
 	struct ktls_key_ctx *kctx = &tx_info->key_ctx;
-	struct crypto_cipher *cipher;
+	struct crypto_aes_ctx aes_ctx;
 	unsigned char *key, *salt;
 
 	switch (crypto_info->cipher_type) {
@@ -91,18 +92,14 @@ static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
 	/* Calculate the H = CIPH(K, 0 repeated 16 times).
 	 * It will go in key context
 	 */
-	cipher = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(cipher)) {
-		ret = -ENOMEM;
-		goto out;
-	}
 
-	ret = crypto_cipher_setkey(cipher, key, keylen);
+	ret = aes_expandkey(&aes_ctx, key, keylen);
 	if (ret)
-		goto out1;
+		goto out;
 
 	memset(ghash_h, 0, ghash_size);
-	crypto_cipher_encrypt_one(cipher, ghash_h, ghash_h);
+	aes_encrypt(&aes_ctx, ghash_h, ghash_h);
+	memzero_explicit(&aes_ctx, sizeof(aes_ctx));
 
 	/* fill the Key context */
 	if (direction == TLS_OFFLOAD_CTX_DIR_TX) {
@@ -111,7 +108,7 @@ static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
 						 key_ctx_size >> 4);
 	} else {
 		ret = -EINVAL;
-		goto out1;
+		goto out;
 	}
 
 	memcpy(kctx->salt, salt, tx_info->salt_size);
@@ -119,8 +116,6 @@ static int chcr_ktls_save_keys(struct chcr_ktls_info *tx_info,
 	memcpy(kctx->key + keylen, ghash_h, ghash_size);
 	tx_info->key_ctx_len = key_ctx_size;
 
-out1:
-	crypto_free_cipher(cipher);
 out:
 	return ret;
 }
-- 
2.17.1

