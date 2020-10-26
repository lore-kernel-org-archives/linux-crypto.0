Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB4BC4363A
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 13:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD78320790
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 13:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1776170AbgJZNFT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 09:05:19 -0400
Received: from foss.arm.com ([217.140.110.172]:38330 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391920AbgJZNFS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 09:05:18 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCA6D1516;
        Mon, 26 Oct 2020 06:05:17 -0700 (PDT)
Received: from e110176-lin.arm.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 645CB3F68F;
        Mon, 26 Oct 2020 06:05:15 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH 3/4] dm crypt: switch to EBOIV crypto API template
Date:   Mon, 26 Oct 2020 15:04:46 +0200
Message-Id: <20201026130450.6947-4-gilad@benyossef.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026130450.6947-1-gilad@benyossef.com>
References: <20201026130450.6947-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the explicit EBOIV handling in the dm-crypt driver with calls
into the crypto API, which now possesses the capability to perform
this processing within the crypto subsystem.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

---
 drivers/md/Kconfig    |  1 +
 drivers/md/dm-crypt.c | 61 ++++++++++++++-----------------------------
 2 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 30ba3573626c..ca6e56a72281 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -273,6 +273,7 @@ config DM_CRYPT
 	select CRYPTO
 	select CRYPTO_CBC
 	select CRYPTO_ESSIV
+	select CRYPTO_EBOIV
 	help
 	  This device-mapper target allows you to create a device that
 	  transparently encrypts the data on it. You'll need to activate
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 148960721254..cad8f4e3f5d9 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -716,47 +716,18 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
 	return 0;
 }
 
-static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
-			    const char *opts)
-{
-	if (crypt_integrity_aead(cc)) {
-		ti->error = "AEAD transforms not supported for EBOIV";
-		return -EINVAL;
-	}
-
-	if (crypto_skcipher_blocksize(any_tfm(cc)) != cc->iv_size) {
-		ti->error = "Block size of EBOIV cipher does "
-			    "not match IV size of block cipher";
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 			    struct dm_crypt_request *dmreq)
 {
-	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
-	struct skcipher_request *req;
-	struct scatterlist src, dst;
-	struct crypto_wait wait;
-	int err;
-
-	req = skcipher_request_alloc(any_tfm(cc), GFP_NOIO);
-	if (!req)
-		return -ENOMEM;
-
-	memset(buf, 0, cc->iv_size);
-	*(__le64 *)buf = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
 
-	sg_init_one(&src, page_address(ZERO_PAGE(0)), cc->iv_size);
-	sg_init_one(&dst, iv, cc->iv_size);
-	skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
-	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
-	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
-	skcipher_request_free(req);
+	/*
+	 * ESSIV encryption of the IV is handled by the crypto API,
+	 * so compute and pass the sector offset here.
+	 */
+	memset(iv, 0, cc->iv_size);
+	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
 
-	return err;
+	return 0;
 }
 
 static void crypt_iv_elephant_dtr(struct crypt_config *cc)
@@ -777,13 +748,9 @@ static int crypt_iv_elephant_ctr(struct crypt_config *cc, struct dm_target *ti,
 	if (IS_ERR(elephant->tfm)) {
 		r = PTR_ERR(elephant->tfm);
 		elephant->tfm = NULL;
-		return r;
 	}
 
-	r = crypt_iv_eboiv_ctr(cc, ti, NULL);
-	if (r)
-		crypt_iv_elephant_dtr(cc);
-	return r;
+	return 0;
 }
 
 static void diffuser_disk_to_cpu(u32 *d, size_t n)
@@ -1092,7 +1059,6 @@ static struct crypt_iv_operations crypt_iv_random_ops = {
 };
 
 static struct crypt_iv_operations crypt_iv_eboiv_ops = {
-	.ctr	   = crypt_iv_eboiv_ctr,
 	.generator = crypt_iv_eboiv_gen
 };
 
@@ -2739,6 +2705,15 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 		cipher_api = buf;
 	}
 
+	if (*ivmode && (!strcmp(*ivmode, "eboiv") || !strcmp(*ivmode, "elephant"))) {
+		ret = snprintf(buf, CRYPTO_MAX_ALG_NAME, "eboiv(%s)", cipher_api);
+		if (ret < 0 || ret >= CRYPTO_MAX_ALG_NAME) {
+			ti->error = "Cannot allocate cipher string";
+			return -ENOMEM;
+		}
+		cipher_api = buf;
+	}
+
 	cc->key_parts = cc->tfms_count;
 
 	/* Allocate cipher */
@@ -2817,6 +2792,8 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 		}
 		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
 			       "essiv(%s(%s),%s)", chainmode, cipher, *ivopts);
+	} else if (*ivmode && (!strcmp(*ivmode, "eboiv") || !strcmp(*ivmode, "elephant"))) {
+		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME, "eboiv(%s(%s))", chainmode, cipher);
 	} else {
 		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
 			       "%s(%s)", chainmode, cipher);
-- 
2.28.0

