Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D3BC33CB6
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9106C207E0
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgAPKPL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 05:15:11 -0500
Received: from foss.arm.com ([217.140.110.172]:47474 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgAPKPL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 05:15:11 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6792F31B;
        Thu, 16 Jan 2020 02:15:10 -0800 (PST)
Received: from e110176-lin.arm.com (unknown [10.50.4.173])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0CAFE3F534;
        Thu, 16 Jan 2020 02:15:08 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] crypto: ccree - turn errors to debug msgs
Date:   Thu, 16 Jan 2020 12:14:39 +0200
Message-Id: <20200116101447.20374-5-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200116101447.20374-1-gilad@benyossef.com>
References: <20200116101447.20374-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We have several loud error log messages that are already reported
via the normal return code mechanism and produce a lot of noise
when the new testmgr extra test are enabled. Turn these into
debug only messages

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_aead.c   | 20 ++++++++++----------
 drivers/crypto/ccree/cc_cipher.c |  6 +++---
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 754de302a3b5..2fc0e0da790b 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -385,13 +385,13 @@ static int validate_keys_sizes(struct cc_aead_ctx *ctx)
 			return -EINVAL;
 		break;
 	default:
-		dev_err(dev, "Invalid auth_mode=%d\n", ctx->auth_mode);
+		dev_dbg(dev, "Invalid auth_mode=%d\n", ctx->auth_mode);
 		return -EINVAL;
 	}
 	/* Check cipher key size */
 	if (ctx->flow_mode == S_DIN_to_DES) {
 		if (ctx->enc_keylen != DES3_EDE_KEY_SIZE) {
-			dev_err(dev, "Invalid cipher(3DES) key size: %u\n",
+			dev_dbg(dev, "Invalid cipher(3DES) key size: %u\n",
 				ctx->enc_keylen);
 			return -EINVAL;
 		}
@@ -399,7 +399,7 @@ static int validate_keys_sizes(struct cc_aead_ctx *ctx)
 		if (ctx->enc_keylen != AES_KEYSIZE_128 &&
 		    ctx->enc_keylen != AES_KEYSIZE_192 &&
 		    ctx->enc_keylen != AES_KEYSIZE_256) {
-			dev_err(dev, "Invalid cipher(AES) key size: %u\n",
+			dev_dbg(dev, "Invalid cipher(AES) key size: %u\n",
 				ctx->enc_keylen);
 			return -EINVAL;
 		}
@@ -1559,7 +1559,7 @@ static int config_ccm_adata(struct aead_request *req)
 	/* taken from crypto/ccm.c */
 	/* 2 <= L <= 8, so 1 <= L' <= 7. */
 	if (l < 2 || l > 8) {
-		dev_err(dev, "illegal iv value %X\n", req->iv[0]);
+		dev_dbg(dev, "illegal iv value %X\n", req->iv[0]);
 		return -EINVAL;
 	}
 	memcpy(b0, req->iv, AES_BLOCK_SIZE);
@@ -2056,7 +2056,7 @@ static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 	int rc = -EINVAL;
 
 	if (!valid_assoclen(req)) {
-		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		dev_dbg(dev, "invalid Assoclen:%u\n", req->assoclen);
 		goto out;
 	}
 
@@ -2106,7 +2106,7 @@ static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 	int rc = -EINVAL;
 
 	if (!valid_assoclen(req)) {
-		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		dev_dbg(dev, "invalid Assoclen:%u\n", req->assoclen);
 		goto out;
 	}
 
@@ -2225,7 +2225,7 @@ static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
 	int rc = -EINVAL;
 
 	if (!valid_assoclen(req)) {
-		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		dev_dbg(dev, "invalid Assoclen:%u\n", req->assoclen);
 		goto out;
 	}
 
@@ -2256,7 +2256,7 @@ static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 	int rc = -EINVAL;
 
 	if (!valid_assoclen(req)) {
-		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		dev_dbg(dev, "invalid Assoclen:%u\n", req->assoclen);
 		goto out;
 	}
 
@@ -2290,7 +2290,7 @@ static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
 	int rc = -EINVAL;
 
 	if (!valid_assoclen(req)) {
-		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		dev_dbg(dev, "invalid Assoclen:%u\n", req->assoclen);
 		goto out;
 	}
 
@@ -2321,7 +2321,7 @@ static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 	int rc = -EINVAL;
 
 	if (!valid_assoclen(req)) {
-		dev_err(dev, "invalid Assoclen:%u\n", req->assoclen);
+		dev_dbg(dev, "invalid Assoclen:%u\n", req->assoclen);
 		goto out;
 	}
 
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 7493a32f12b9..03aa4fb8e6cb 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -302,7 +302,7 @@ static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
 	keylen = hki.keylen;
 
 	if (validate_keys_sizes(ctx_p, keylen)) {
-		dev_err(dev, "Unsupported key size %d.\n", keylen);
+		dev_dbg(dev, "Unsupported key size %d.\n", keylen);
 		return -EINVAL;
 	}
 
@@ -392,7 +392,7 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 	/* STAT_PHASE_0: Init and sanity checks */
 
 	if (validate_keys_sizes(ctx_p, keylen)) {
-		dev_err(dev, "Unsupported key size %d.\n", keylen);
+		dev_dbg(dev, "Unsupported key size %d.\n", keylen);
 		return -EINVAL;
 	}
 
@@ -833,7 +833,7 @@ static int cc_cipher_process(struct skcipher_request *req,
 
 	/* TODO: check data length according to mode */
 	if (validate_data_size(ctx_p, nbytes)) {
-		dev_err(dev, "Unsupported data size %d.\n", nbytes);
+		dev_dbg(dev, "Unsupported data size %d.\n", nbytes);
 		rc = -EINVAL;
 		goto exit_process;
 	}
-- 
2.23.0

