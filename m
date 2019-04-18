Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21EE0C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 21:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6AAD217F9
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 21:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555623895;
	bh=iBDUW+B83dPAnn3BG1+dIDS8eyYKJkgWTtvYYntRtZ0=;
	h=From:To:Subject:Date:List-ID:From;
	b=k4VgQAxWGNuqMihDTFg3GTtD0+Gnqq8feDybC4RndkHcSOQ73o+h0sqDHMLQQoiKR
	 7+qnpfd4kRxplDs+UvsR+nBDimlnObhkPkQsvWsGiETPJ/GOZQU6NAgoXXb8lFPRGC
	 rs0DY4brIpjYOlv0KbqffsGy0I994bQXuf5OGgmU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfDRVoy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 17:44:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfDRVoy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 17:44:54 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEF94217D7;
        Thu, 18 Apr 2019 21:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555623892;
        bh=iBDUW+B83dPAnn3BG1+dIDS8eyYKJkgWTtvYYntRtZ0=;
        h=From:To:Subject:Date:From;
        b=P5z24gxiriD11Wb636XoObxUpZTT0Yigdp2DqHf7ChCh79Y10JvU937nBZFT4yInb
         cI8xNBMCF7o6NtdoGi6ezEHi4BRmf3HfX7XDD28QyqlkjvhfYD4riIq55bIn8u10fF
         i1GDHyLn05XZByKfhL9r2NBb2BW5ZG5lvpK7oI3o=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v3] crypto: ccm - fix incompatibility between "ccm" and "ccm_base"
Date:   Thu, 18 Apr 2019 14:44:27 -0700
Message-Id: <20190418214427.137933-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.392.gf8f6787159e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

CCM instances can be created by either the "ccm" template, which only
allows choosing the block cipher, e.g. "ccm(aes)"; or by "ccm_base",
which allows choosing the ctr and cbcmac implementations, e.g.
"ccm_base(ctr(aes-generic),cbcmac(aes-generic))".

However, a "ccm_base" instance prevents a "ccm" instance from being
registered using the same implementations.  Nor will the instance be
found by lookups of "ccm".  This can be used as a denial of service.
Moreover, "ccm_base" instances are never tested by the crypto
self-tests, even if there are compatible "ccm" tests.

The root cause of these problems is that instances of the two templates
use different cra_names.  Therefore, fix these problems by making
"ccm_base" instances set the same cra_name as "ccm" instances, e.g.
"ccm(aes)" instead of "ccm_base(ctr(aes-generic),cbcmac(aes-generic))".

This requires extracting the block cipher name from the name of the ctr
and cbcmac algorithms.  It also requires starting to verify that the
algorithms are really ctr and cbcmac using the same block cipher, not
something else entirely.  But it would be bizarre if anyone were
actually using non-ccm-compatible algorithms with ccm_base, so this
shouldn't break anyone in practice.

Fixes: 4a49b499dfa0 ("[CRYPTO] ccm: Added CCM mode")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Changed since v2:
	- Leave check for ctr cra_blocksize == 1.

Changed since v1:
	- Verify that cbcmac is really cbcmac (based on name).
	- Improved commit message.

 crypto/ccm.c | 44 ++++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 3d036df0f4d4a..c1ef9d0b4271a 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -458,7 +458,6 @@ static void crypto_ccm_free(struct aead_instance *inst)
 
 static int crypto_ccm_create_common(struct crypto_template *tmpl,
 				    struct rtattr **tb,
-				    const char *full_name,
 				    const char *ctr_name,
 				    const char *mac_name)
 {
@@ -486,7 +485,8 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 
 	mac = __crypto_hash_alg_common(mac_alg);
 	err = -EINVAL;
-	if (mac->digestsize != 16)
+	if (strncmp(mac->base.cra_name, "cbcmac(", 7) != 0 ||
+	    mac->digestsize != 16)
 		goto out_put_mac;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
@@ -509,23 +509,27 @@ static int crypto_ccm_create_common(struct crypto_template *tmpl,
 
 	ctr = crypto_spawn_skcipher_alg(&ictx->ctr);
 
-	/* Not a stream cipher? */
+	/* The skcipher algorithm must be CTR mode, using 16-byte blocks. */
 	err = -EINVAL;
-	if (ctr->base.cra_blocksize != 1)
+	if (strncmp(ctr->base.cra_name, "ctr(", 4) != 0 ||
+	    crypto_skcipher_alg_ivsize(ctr) != 16 ||
+	    ctr->base.cra_blocksize != 1)
 		goto err_drop_ctr;
 
-	/* We want the real thing! */
-	if (crypto_skcipher_alg_ivsize(ctr) != 16)
+	/* ctr and cbcmac must use the same underlying block cipher. */
+	if (strcmp(ctr->base.cra_name + 4, mac->base.cra_name + 7) != 0)
 		goto err_drop_ctr;
 
 	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "ccm(%s", ctr->base.cra_name + 4) >= CRYPTO_MAX_ALG_NAME)
+		goto err_drop_ctr;
+
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "ccm_base(%s,%s)", ctr->base.cra_driver_name,
 		     mac->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_ctr;
 
-	memcpy(inst->alg.base.cra_name, full_name, CRYPTO_MAX_ALG_NAME);
-
 	inst->alg.base.cra_flags = ctr->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = (mac->base.cra_priority +
 				       ctr->base.cra_priority) / 2;
@@ -567,7 +571,6 @@ static int crypto_ccm_create(struct crypto_template *tmpl, struct rtattr **tb)
 	const char *cipher_name;
 	char ctr_name[CRYPTO_MAX_ALG_NAME];
 	char mac_name[CRYPTO_MAX_ALG_NAME];
-	char full_name[CRYPTO_MAX_ALG_NAME];
 
 	cipher_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(cipher_name))
@@ -581,35 +584,24 @@ static int crypto_ccm_create(struct crypto_template *tmpl, struct rtattr **tb)
 		     cipher_name) >= CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
 
-	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "ccm(%s)", cipher_name) >=
-	    CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
-
-	return crypto_ccm_create_common(tmpl, tb, full_name, ctr_name,
-					mac_name);
+	return crypto_ccm_create_common(tmpl, tb, ctr_name, mac_name);
 }
 
 static int crypto_ccm_base_create(struct crypto_template *tmpl,
 				  struct rtattr **tb)
 {
 	const char *ctr_name;
-	const char *cipher_name;
-	char full_name[CRYPTO_MAX_ALG_NAME];
+	const char *mac_name;
 
 	ctr_name = crypto_attr_alg_name(tb[1]);
 	if (IS_ERR(ctr_name))
 		return PTR_ERR(ctr_name);
 
-	cipher_name = crypto_attr_alg_name(tb[2]);
-	if (IS_ERR(cipher_name))
-		return PTR_ERR(cipher_name);
-
-	if (snprintf(full_name, CRYPTO_MAX_ALG_NAME, "ccm_base(%s,%s)",
-		     ctr_name, cipher_name) >= CRYPTO_MAX_ALG_NAME)
-		return -ENAMETOOLONG;
+	mac_name = crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(mac_name))
+		return PTR_ERR(mac_name);
 
-	return crypto_ccm_create_common(tmpl, tb, full_name, ctr_name,
-					cipher_name);
+	return crypto_ccm_create_common(tmpl, tb, ctr_name, mac_name);
 }
 
 static int crypto_rfc4309_setkey(struct crypto_aead *parent, const u8 *key,
-- 
2.21.0.392.gf8f6787159e-goog

