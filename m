Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D010BC282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 12:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0E2F20870
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 12:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfAWL77 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 06:59:59 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:40661 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfAWL77 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 06:59:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 4D0B71852D;
        Wed, 23 Jan 2019 12:59:56 +0100 (CET)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id JboFulOGD33F; Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from boulder02.se.axis.com (boulder02.se.axis.com [10.0.8.16])
        by bastet.se.axis.com (Postfix) with ESMTPS id 807A118293;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A45F1A077;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 355041A075;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from seth.se.axis.com (unknown [10.0.2.172])
        by boulder02.se.axis.com (Postfix) with ESMTP;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from pc32929-1845.se.axis.com (pc32929-1845.se.axis.com [10.88.129.17])
        by seth.se.axis.com (Postfix) with ESMTP id 296D41CA2;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: by pc32929-1845.se.axis.com (Postfix, from userid 20456)
        id 26B72409B9; Wed, 23 Jan 2019 12:59:50 +0100 (CET)
From:   Lars Persson <lars.persson@axis.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Lars Persson <larper@axis.com>
Subject: [PATCH 1/7] crypto: axis - remove sha384 support for artpec7
Date:   Wed, 23 Jan 2019 12:59:40 +0100
Message-Id: <73c808537004b9f9aba1b321e8cd2084f4abdfb8.1548243646.git.larper@axis.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
X-TM-AS-GCONF: 00
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The hardware implementation of SHA384 was not correct and it cannot
be used in any situation.

Signed-off-by: Lars Persson <larper@axis.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 107 +----------------------------------
 1 file changed, 2 insertions(+), 105 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index f3442c2bdbdc..e4cbb2d11514 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -135,7 +135,6 @@
 #define regk_crypto_ext         0x00000001
 #define regk_crypto_hmac_sha1   0x00000007
 #define regk_crypto_hmac_sha256 0x00000009
-#define regk_crypto_hmac_sha384 0x0000000b
 #define regk_crypto_hmac_sha512 0x0000000d
 #define regk_crypto_init        0x00000000
 #define regk_crypto_key_128     0x00000000
@@ -144,7 +143,6 @@
 #define regk_crypto_null        0x00000000
 #define regk_crypto_sha1        0x00000006
 #define regk_crypto_sha256      0x00000008
-#define regk_crypto_sha384      0x0000000a
 #define regk_crypto_sha512      0x0000000c
 
 /* DMA descriptor structures */
@@ -190,7 +188,6 @@ struct pdma_stat_descr {
 /* Hash modes (including HMAC variants) */
 #define ARTPEC6_CRYPTO_HASH_SHA1	1
 #define ARTPEC6_CRYPTO_HASH_SHA256	2
-#define ARTPEC6_CRYPTO_HASH_SHA384	3
 #define ARTPEC6_CRYPTO_HASH_SHA512	4
 
 /* Crypto modes */
@@ -1315,8 +1312,7 @@ static int artpec6_crypto_prepare_hash(struct ahash_request *areq)
 	struct artpec6_hashalg_context *ctx = crypto_tfm_ctx(areq->base.tfm);
 	struct artpec6_hash_request_context *req_ctx = ahash_request_ctx(areq);
 	size_t digestsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(areq));
-	size_t contextsize = digestsize == SHA384_DIGEST_SIZE ?
-		SHA512_DIGEST_SIZE : digestsize;
+	size_t contextsize = digestsize;
 	size_t blocksize = crypto_tfm_alg_blocksize(
 		crypto_ahash_tfm(crypto_ahash_reqtfm(areq)));
 	struct artpec6_crypto_req_common *common = &req_ctx->common;
@@ -1456,7 +1452,6 @@ static int artpec6_crypto_prepare_hash(struct ahash_request *areq)
 
 	/* Finalize */
 	if (req_ctx->hash_flags & HASH_FLAG_FINALIZE) {
-		bool needtrim = contextsize != digestsize;
 		size_t hash_pad_len;
 		u64 digest_bits;
 		u32 oper;
@@ -1502,19 +1497,10 @@ static int artpec6_crypto_prepare_hash(struct ahash_request *areq)
 		/* Descriptor for the final result */
 		error = artpec6_crypto_setup_in_descr(common, areq->result,
 						      digestsize,
-						      !needtrim);
+						      true);
 		if (error)
 			return error;
 
-		if (needtrim) {
-			/* Discard the extra context bytes for SHA-384 */
-			error = artpec6_crypto_setup_in_descr(common,
-					req_ctx->partial_buffer,
-					digestsize - contextsize, true);
-			if (error)
-				return error;
-		}
-
 	} else { /* This is not the final operation for this request */
 		if (!run_hw)
 			return ARTPEC6_CRYPTO_PREPARE_HASH_NO_START;
@@ -2266,9 +2252,6 @@ artpec6_crypto_init_hash(struct ahash_request *req, u8 type, int hmac)
 	case ARTPEC6_CRYPTO_HASH_SHA256:
 		oper = hmac ? regk_crypto_hmac_sha256 : regk_crypto_sha256;
 		break;
-	case ARTPEC6_CRYPTO_HASH_SHA384:
-		oper = hmac ? regk_crypto_hmac_sha384 : regk_crypto_sha384;
-		break;
 	case ARTPEC6_CRYPTO_HASH_SHA512:
 		oper = hmac ? regk_crypto_hmac_sha512 : regk_crypto_sha512;
 		break;
@@ -2368,22 +2351,6 @@ static int artpec6_crypto_sha256_digest(struct ahash_request *req)
 	return artpec6_crypto_prepare_submit_hash(req);
 }
 
-static int __maybe_unused artpec6_crypto_sha384_init(struct ahash_request *req)
-{
-	return artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA384, 0);
-}
-
-static int __maybe_unused
-artpec6_crypto_sha384_digest(struct ahash_request *req)
-{
-	struct artpec6_hash_request_context *req_ctx = ahash_request_ctx(req);
-
-	artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA384, 0);
-	req_ctx->hash_flags |= HASH_FLAG_UPDATE | HASH_FLAG_FINALIZE;
-
-	return artpec6_crypto_prepare_submit_hash(req);
-}
-
 static int artpec6_crypto_sha512_init(struct ahash_request *req)
 {
 	return artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA512, 0);
@@ -2404,12 +2371,6 @@ static int artpec6_crypto_hmac_sha256_init(struct ahash_request *req)
 	return artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA256, 1);
 }
 
-static int __maybe_unused
-artpec6_crypto_hmac_sha384_init(struct ahash_request *req)
-{
-	return artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA384, 1);
-}
-
 static int artpec6_crypto_hmac_sha512_init(struct ahash_request *req)
 {
 	return artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA512, 1);
@@ -2425,17 +2386,6 @@ static int artpec6_crypto_hmac_sha256_digest(struct ahash_request *req)
 	return artpec6_crypto_prepare_submit_hash(req);
 }
 
-static int __maybe_unused
-artpec6_crypto_hmac_sha384_digest(struct ahash_request *req)
-{
-	struct artpec6_hash_request_context *req_ctx = ahash_request_ctx(req);
-
-	artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA384, 1);
-	req_ctx->hash_flags |= HASH_FLAG_UPDATE | HASH_FLAG_FINALIZE;
-
-	return artpec6_crypto_prepare_submit_hash(req);
-}
-
 static int artpec6_crypto_hmac_sha512_digest(struct ahash_request *req)
 {
 	struct artpec6_hash_request_context *req_ctx = ahash_request_ctx(req);
@@ -2480,12 +2430,6 @@ static int artpec6_crypto_ahash_init_hmac_sha256(struct crypto_tfm *tfm)
 	return artpec6_crypto_ahash_init_common(tfm, "sha256");
 }
 
-static int __maybe_unused
-artpec6_crypto_ahash_init_hmac_sha384(struct crypto_tfm *tfm)
-{
-	return artpec6_crypto_ahash_init_common(tfm, "sha384");
-}
-
 static int artpec6_crypto_ahash_init_hmac_sha512(struct crypto_tfm *tfm)
 {
 	return artpec6_crypto_ahash_init_common(tfm, "sha512");
@@ -2762,53 +2706,6 @@ static struct ahash_alg hash_algos[] = {
 };
 
 static struct ahash_alg artpec7_hash_algos[] = {
-	/* SHA-384 */
-	{
-		.init = artpec6_crypto_sha384_init,
-		.update = artpec6_crypto_hash_update,
-		.final = artpec6_crypto_hash_final,
-		.digest = artpec6_crypto_sha384_digest,
-		.import = artpec6_crypto_hash_import,
-		.export = artpec6_crypto_hash_export,
-		.halg.digestsize = SHA384_DIGEST_SIZE,
-		.halg.statesize = sizeof(struct artpec6_hash_export_state),
-		.halg.base = {
-			.cra_name = "sha384",
-			.cra_driver_name = "artpec-sha384",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
-			.cra_blocksize = SHA384_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
-			.cra_alignmask = 3,
-			.cra_module = THIS_MODULE,
-			.cra_init = artpec6_crypto_ahash_init,
-			.cra_exit = artpec6_crypto_ahash_exit,
-		}
-	},
-	/* HMAC SHA-384 */
-	{
-		.init = artpec6_crypto_hmac_sha384_init,
-		.update = artpec6_crypto_hash_update,
-		.final = artpec6_crypto_hash_final,
-		.digest = artpec6_crypto_hmac_sha384_digest,
-		.import = artpec6_crypto_hash_import,
-		.export = artpec6_crypto_hash_export,
-		.setkey = artpec6_crypto_hash_set_key,
-		.halg.digestsize = SHA384_DIGEST_SIZE,
-		.halg.statesize = sizeof(struct artpec6_hash_export_state),
-		.halg.base = {
-			.cra_name = "hmac(sha384)",
-			.cra_driver_name = "artpec-hmac-sha384",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
-			.cra_blocksize = SHA384_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
-			.cra_alignmask = 3,
-			.cra_module = THIS_MODULE,
-			.cra_init = artpec6_crypto_ahash_init_hmac_sha384,
-			.cra_exit = artpec6_crypto_ahash_exit,
-		}
-	},
 	/* SHA-512 */
 	{
 		.init = artpec6_crypto_sha512_init,
-- 
2.11.0

