Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA27C282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 11:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACFAB20870
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 11:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbfAWL74 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 06:59:56 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:40654 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfAWL74 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 06:59:56 -0500
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id 62EC918532;
        Wed, 23 Jan 2019 12:59:54 +0100 (CET)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id PDRNithDIyRe; Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from boulder03.se.axis.com (boulder03.se.axis.com [10.0.8.17])
        by bastet.se.axis.com (Postfix) with ESMTPS id C6CFC1849C;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A666E1E07B;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from boulder03.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 905C61E07C;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from seth.se.axis.com (unknown [10.0.2.172])
        by boulder03.se.axis.com (Postfix) with ESMTP;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from pc32929-1845.se.axis.com (pc32929-1845.se.axis.com [10.88.129.17])
        by seth.se.axis.com (Postfix) with ESMTP id 848F21CA2;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: by pc32929-1845.se.axis.com (Postfix, from userid 20456)
        id 82917409B9; Wed, 23 Jan 2019 12:59:50 +0100 (CET)
From:   Lars Persson <lars.persson@axis.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Lars Persson <larper@axis.com>
Subject: [PATCH 2/7] crypto: axis - remove sha512 support for artpec7
Date:   Wed, 23 Jan 2019 12:59:41 +0100
Message-Id: <1ac601e24ee59feb9631050d00152945c0b3231e.1548243646.git.larper@axis.com>
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

The hardware cannot restore the context correctly when it operates in
SHA512 mode. This is too restrictive when operating in a framework that
can interleave multiple hash sessions.

Signed-off-by: Lars Persson <larper@axis.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 126 +++--------------------------------
 1 file changed, 9 insertions(+), 117 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index e4cbb2d11514..43da19566a36 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -135,7 +135,6 @@
 #define regk_crypto_ext         0x00000001
 #define regk_crypto_hmac_sha1   0x00000007
 #define regk_crypto_hmac_sha256 0x00000009
-#define regk_crypto_hmac_sha512 0x0000000d
 #define regk_crypto_init        0x00000000
 #define regk_crypto_key_128     0x00000000
 #define regk_crypto_key_192     0x00000001
@@ -143,7 +142,6 @@
 #define regk_crypto_null        0x00000000
 #define regk_crypto_sha1        0x00000006
 #define regk_crypto_sha256      0x00000008
-#define regk_crypto_sha512      0x0000000c
 
 /* DMA descriptor structures */
 struct pdma_descr_ctrl  {
@@ -188,7 +186,6 @@ struct pdma_stat_descr {
 /* Hash modes (including HMAC variants) */
 #define ARTPEC6_CRYPTO_HASH_SHA1	1
 #define ARTPEC6_CRYPTO_HASH_SHA256	2
-#define ARTPEC6_CRYPTO_HASH_SHA512	4
 
 /* Crypto modes */
 #define ARTPEC6_CRYPTO_CIPHER_AES_ECB	1
@@ -288,11 +285,11 @@ struct artpec6_crypto_req_common {
 };
 
 struct artpec6_hash_request_context {
-	char partial_buffer[SHA512_BLOCK_SIZE];
-	char partial_buffer_out[SHA512_BLOCK_SIZE];
-	char key_buffer[SHA512_BLOCK_SIZE];
-	char pad_buffer[SHA512_BLOCK_SIZE + 32];
-	unsigned char digeststate[SHA512_DIGEST_SIZE];
+	char partial_buffer[SHA256_BLOCK_SIZE];
+	char partial_buffer_out[SHA256_BLOCK_SIZE];
+	char key_buffer[SHA256_BLOCK_SIZE];
+	char pad_buffer[SHA256_BLOCK_SIZE + 32];
+	unsigned char digeststate[SHA256_DIGEST_SIZE];
 	size_t partial_bytes;
 	u64 digcnt;
 	u32 key_md;
@@ -302,8 +299,8 @@ struct artpec6_hash_request_context {
 };
 
 struct artpec6_hash_export_state {
-	char partial_buffer[SHA512_BLOCK_SIZE];
-	unsigned char digeststate[SHA512_DIGEST_SIZE];
+	char partial_buffer[SHA256_BLOCK_SIZE];
+	unsigned char digeststate[SHA256_DIGEST_SIZE];
 	size_t partial_bytes;
 	u64 digcnt;
 	int oper;
@@ -311,7 +308,7 @@ struct artpec6_hash_export_state {
 };
 
 struct artpec6_hashalg_context {
-	char hmac_key[SHA512_BLOCK_SIZE];
+	char hmac_key[SHA256_BLOCK_SIZE];
 	size_t hmac_key_length;
 	struct crypto_shash *child_hash;
 };
@@ -2252,10 +2249,6 @@ artpec6_crypto_init_hash(struct ahash_request *req, u8 type, int hmac)
 	case ARTPEC6_CRYPTO_HASH_SHA256:
 		oper = hmac ? regk_crypto_hmac_sha256 : regk_crypto_sha256;
 		break;
-	case ARTPEC6_CRYPTO_HASH_SHA512:
-		oper = hmac ? regk_crypto_hmac_sha512 : regk_crypto_sha512;
-		break;
-
 	default:
 		pr_err("%s: Unsupported hash type 0x%x\n", MODULE_NAME, type);
 		return -EINVAL;
@@ -2351,31 +2344,11 @@ static int artpec6_crypto_sha256_digest(struct ahash_request *req)
 	return artpec6_crypto_prepare_submit_hash(req);
 }
 
-static int artpec6_crypto_sha512_init(struct ahash_request *req)
-{
-	return artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA512, 0);
-}
-
-static int artpec6_crypto_sha512_digest(struct ahash_request *req)
-{
-	struct artpec6_hash_request_context *req_ctx = ahash_request_ctx(req);
-
-	artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA512, 0);
-	req_ctx->hash_flags |= HASH_FLAG_UPDATE | HASH_FLAG_FINALIZE;
-
-	return artpec6_crypto_prepare_submit_hash(req);
-}
-
 static int artpec6_crypto_hmac_sha256_init(struct ahash_request *req)
 {
 	return artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA256, 1);
 }
 
-static int artpec6_crypto_hmac_sha512_init(struct ahash_request *req)
-{
-	return artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA512, 1);
-}
-
 static int artpec6_crypto_hmac_sha256_digest(struct ahash_request *req)
 {
 	struct artpec6_hash_request_context *req_ctx = ahash_request_ctx(req);
@@ -2386,16 +2359,6 @@ static int artpec6_crypto_hmac_sha256_digest(struct ahash_request *req)
 	return artpec6_crypto_prepare_submit_hash(req);
 }
 
-static int artpec6_crypto_hmac_sha512_digest(struct ahash_request *req)
-{
-	struct artpec6_hash_request_context *req_ctx = ahash_request_ctx(req);
-
-	artpec6_crypto_init_hash(req, ARTPEC6_CRYPTO_HASH_SHA512, 1);
-	req_ctx->hash_flags |= HASH_FLAG_UPDATE | HASH_FLAG_FINALIZE;
-
-	return artpec6_crypto_prepare_submit_hash(req);
-}
-
 static int artpec6_crypto_ahash_init_common(struct crypto_tfm *tfm,
 				    const char *base_hash_name)
 {
@@ -2430,11 +2393,6 @@ static int artpec6_crypto_ahash_init_hmac_sha256(struct crypto_tfm *tfm)
 	return artpec6_crypto_ahash_init_common(tfm, "sha256");
 }
 
-static int artpec6_crypto_ahash_init_hmac_sha512(struct crypto_tfm *tfm)
-{
-	return artpec6_crypto_ahash_init_common(tfm, "sha512");
-}
-
 static void artpec6_crypto_ahash_exit(struct crypto_tfm *tfm)
 {
 	struct artpec6_hashalg_context *tfm_ctx = crypto_tfm_ctx(tfm);
@@ -2705,56 +2663,6 @@ static struct ahash_alg hash_algos[] = {
 	},
 };
 
-static struct ahash_alg artpec7_hash_algos[] = {
-	/* SHA-512 */
-	{
-		.init = artpec6_crypto_sha512_init,
-		.update = artpec6_crypto_hash_update,
-		.final = artpec6_crypto_hash_final,
-		.digest = artpec6_crypto_sha512_digest,
-		.import = artpec6_crypto_hash_import,
-		.export = artpec6_crypto_hash_export,
-		.halg.digestsize = SHA512_DIGEST_SIZE,
-		.halg.statesize = sizeof(struct artpec6_hash_export_state),
-		.halg.base = {
-			.cra_name = "sha512",
-			.cra_driver_name = "artpec-sha512",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
-			.cra_blocksize = SHA512_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
-			.cra_alignmask = 3,
-			.cra_module = THIS_MODULE,
-			.cra_init = artpec6_crypto_ahash_init,
-			.cra_exit = artpec6_crypto_ahash_exit,
-		}
-	},
-	/* HMAC SHA-512 */
-	{
-		.init = artpec6_crypto_hmac_sha512_init,
-		.update = artpec6_crypto_hash_update,
-		.final = artpec6_crypto_hash_final,
-		.digest = artpec6_crypto_hmac_sha512_digest,
-		.import = artpec6_crypto_hash_import,
-		.export = artpec6_crypto_hash_export,
-		.setkey = artpec6_crypto_hash_set_key,
-		.halg.digestsize = SHA512_DIGEST_SIZE,
-		.halg.statesize = sizeof(struct artpec6_hash_export_state),
-		.halg.base = {
-			.cra_name = "hmac(sha512)",
-			.cra_driver_name = "artpec-hmac-sha512",
-			.cra_priority = 300,
-			.cra_flags = CRYPTO_ALG_ASYNC,
-			.cra_blocksize = SHA512_BLOCK_SIZE,
-			.cra_ctxsize = sizeof(struct artpec6_hashalg_context),
-			.cra_alignmask = 3,
-			.cra_module = THIS_MODULE,
-			.cra_init = artpec6_crypto_ahash_init_hmac_sha512,
-			.cra_exit = artpec6_crypto_ahash_exit,
-		}
-	},
-};
-
 /* Crypto */
 static struct skcipher_alg crypto_algos[] = {
 	/* AES - ECB */
@@ -3001,19 +2909,10 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 		goto disable_hw;
 	}
 
-	if (variant != ARTPEC6_CRYPTO) {
-		err = crypto_register_ahashes(artpec7_hash_algos,
-					      ARRAY_SIZE(artpec7_hash_algos));
-		if (err) {
-			dev_err(dev, "Failed to register ahashes\n");
-			goto unregister_ahashes;
-		}
-	}
-
 	err = crypto_register_skciphers(crypto_algos, ARRAY_SIZE(crypto_algos));
 	if (err) {
 		dev_err(dev, "Failed to register ciphers\n");
-		goto unregister_a7_ahashes;
+		goto unregister_ahashes;
 	}
 
 	err = crypto_register_aeads(aead_algos, ARRAY_SIZE(aead_algos));
@@ -3026,10 +2925,6 @@ static int artpec6_crypto_probe(struct platform_device *pdev)
 
 unregister_algs:
 	crypto_unregister_skciphers(crypto_algos, ARRAY_SIZE(crypto_algos));
-unregister_a7_ahashes:
-	if (variant != ARTPEC6_CRYPTO)
-		crypto_unregister_ahashes(artpec7_hash_algos,
-					  ARRAY_SIZE(artpec7_hash_algos));
 unregister_ahashes:
 	crypto_unregister_ahashes(hash_algos, ARRAY_SIZE(hash_algos));
 disable_hw:
@@ -3045,9 +2940,6 @@ static int artpec6_crypto_remove(struct platform_device *pdev)
 	int irq = platform_get_irq(pdev, 0);
 
 	crypto_unregister_ahashes(hash_algos, ARRAY_SIZE(hash_algos));
-	if (ac->variant != ARTPEC6_CRYPTO)
-		crypto_unregister_ahashes(artpec7_hash_algos,
-					  ARRAY_SIZE(artpec7_hash_algos));
 	crypto_unregister_skciphers(crypto_algos, ARRAY_SIZE(crypto_algos));
 	crypto_unregister_aeads(aead_algos, ARRAY_SIZE(aead_algos));
 
-- 
2.11.0

