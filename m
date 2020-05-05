Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2081AC47258
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 03:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF2F0206C0
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 03:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgEEDOR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 May 2020 23:14:17 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:51654 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbgEEDOQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 May 2020 23:14:16 -0400
Received: from beagle7.blr.asicdesigners.com (beagle7.blr.asicdesigners.com [10.193.80.123])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0453Dqv0019487;
        Mon, 4 May 2020 20:14:06 -0700
From:   Devulapally Shiva Krishna <shiva@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        secdev@chelsio.com, Devulapally Shiva Krishna <shiva@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 4/5] Crypto/chcr: support for 48 byte key_len in aes-xts
Date:   Tue,  5 May 2020 08:42:56 +0530
Message-Id: <20200505031257.9153-5-shiva@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200505031257.9153-1-shiva@chelsio.com>
References: <20200505031257.9153-1-shiva@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Added support for 48 byte key length for aes-xts.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Devulapally Shiva Krishna <shiva@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 6b1a656e0a89..0d25af42cadb 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1077,7 +1077,14 @@ static int chcr_update_tweak(struct skcipher_request *req, u8 *iv,
 
 	keylen = ablkctx->enckey_len / 2;
 	key = ablkctx->key + keylen;
-	ret = aes_expandkey(&aes, key, keylen);
+	/* For a 192 bit key remove the padded zeroes which was
+	 * added in chcr_xts_setkey
+	 */
+	if (KEY_CONTEXT_CK_SIZE_G(ntohl(ablkctx->key_ctx_hdr))
+			== CHCR_KEYCTX_CIPHER_KEY_SIZE_192)
+		ret = aes_expandkey(&aes, key, keylen - 8);
+	else
+		ret = aes_expandkey(&aes, key, keylen);
 	if (ret)
 		return ret;
 	aes_encrypt(&aes, iv, iv);
@@ -2264,12 +2271,28 @@ static int chcr_aes_xts_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	ablkctx->enckey_len = key_len;
 	get_aes_decrypt_key(ablkctx->rrkey, ablkctx->key, key_len << 2);
 	context_size = (KEY_CONTEXT_HDR_SALT_AND_PAD + key_len) >> 4;
-	ablkctx->key_ctx_hdr =
+	/* Both keys for xts must be aligned to 16 byte boundary
+	 * by padding with zeros. So for 24 byte keys padding 8 zeroes.
+	 */
+	if (key_len == 48) {
+		context_size = (KEY_CONTEXT_HDR_SALT_AND_PAD + key_len
+				+ 16) >> 4;
+		memmove(ablkctx->key + 32, ablkctx->key + 24, 24);
+		memset(ablkctx->key + 24, 0, 8);
+		memset(ablkctx->key + 56, 0, 8);
+		ablkctx->enckey_len = 64;
+		ablkctx->key_ctx_hdr =
+			FILL_KEY_CTX_HDR(CHCR_KEYCTX_CIPHER_KEY_SIZE_192,
+					 CHCR_KEYCTX_NO_KEY, 1,
+					 0, context_size);
+	} else {
+		ablkctx->key_ctx_hdr =
 		FILL_KEY_CTX_HDR((key_len == AES_KEYSIZE_256) ?
 				 CHCR_KEYCTX_CIPHER_KEY_SIZE_128 :
 				 CHCR_KEYCTX_CIPHER_KEY_SIZE_256,
 				 CHCR_KEYCTX_NO_KEY, 1,
 				 0, context_size);
+	}
 	ablkctx->ciph_mode = CHCR_SCMD_CIPHER_MODE_AES_XTS;
 	return 0;
 badkey_err:
-- 
2.18.1

