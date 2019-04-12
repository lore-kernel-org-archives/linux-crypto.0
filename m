Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5795C282CE
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 848FB218D2
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 05:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555045253;
	bh=2VlVKPpU+gSALnP/UnRxZ2r8DgaIIpUp/bQOlEbg5tU=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0lpJEcKytdizzIkfd2O+PIJFTq/pnD3hOMA02vAxN4YresLjiRBap+bNHv18i5jx/
	 rWx/nsacVva2WIWj8KSHFLoJxE+GIoqCcMD5RZM5FBaMCgMp866DyrkDyqM+o8wEwF
	 WfohFa1OSfZTz2rEmf1GpkbCbxKZDckAYoBVT/A4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfDLFAw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Apr 2019 01:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726829AbfDLFAv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Apr 2019 01:00:51 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1E782186A;
        Fri, 12 Apr 2019 05:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555045249;
        bh=2VlVKPpU+gSALnP/UnRxZ2r8DgaIIpUp/bQOlEbg5tU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZGPVVnumstYM/Tb4wVql9XfeVRKs6MQf3u+GwGJhEp+2P79oLKCMUUIE7bJkVg1ER
         f2XjMB/q2oqPYw9pEo6OuDU/zR7JBVeVh9IA7z5K2byV4MTLbERi3QPLXxQDpcE/9Y
         30ZYwY/+hI4TqcIWVpf5GTafpINiflDviW1mo0sE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 1/7] crypto: testmgr - expand ability to test for errors
Date:   Thu, 11 Apr 2019 21:57:36 -0700
Message-Id: <20190412045742.1725-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190412045742.1725-1-ebiggers@kernel.org>
References: <20190412045742.1725-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Update testmgr to support testing for specific errors from setkey() and
digest() for hashes; setkey() and encrypt()/decrypt() for skciphers and
ciphers; and setkey(), setauthsize(), and encrypt()/decrypt() for AEADs.
This is useful because algorithms usually restrict the lengths or format
of the message, key, and/or authentication tag in some way.  And bad
inputs should be tested too, not just good inputs.

As part of this change, remove the ambiguously-named 'fail' flag and
replace it with 'setkey_error = -EINVAL' for the only test vector that
used it -- the DES weak key test vector.  Note that this tightens the
test to require -EINVAL rather than any error code, but AFAICS this
won't cause any test failure.

Other than that, these new fields aren't set on any test vectors yet.
Later patches will do so.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 134 +++++++++++++++++++++++++++++++----------------
 crypto/testmgr.h |  20 +++++--
 2 files changed, 104 insertions(+), 50 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0f6bfb6ce6a46..755f0725b5279 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -971,11 +971,18 @@ static int test_hash_vec_cfg(const char *driver,
 	if (vec->ksize) {
 		err = crypto_ahash_setkey(tfm, vec->key, vec->ksize);
 		if (err) {
-			pr_err("alg: hash: %s setkey failed with err %d on test vector %u; flags=%#x\n",
-			       driver, err, vec_num,
+			if (err == vec->setkey_error)
+				return 0;
+			pr_err("alg: hash: %s setkey failed on test vector %u; expected_error=%d, actual_error=%d, flags=%#x\n",
+			       driver, vec_num, vec->setkey_error, err,
 			       crypto_ahash_get_flags(tfm));
 			return err;
 		}
+		if (vec->setkey_error) {
+			pr_err("alg: hash: %s setkey unexpectedly succeeded on test vector %u; expected_error=%d\n",
+			       driver, vec_num, vec->setkey_error);
+			return -EINVAL;
+		}
 	}
 
 	/* Build the scatterlist for the source data */
@@ -995,17 +1002,26 @@ static int test_hash_vec_cfg(const char *driver,
 	testmgr_poison(req->__ctx, crypto_ahash_reqsize(tfm));
 	testmgr_poison(result, digestsize + TESTMGR_POISON_LEN);
 
-	if (cfg->finalization_type == FINALIZATION_TYPE_DIGEST) {
+	if (cfg->finalization_type == FINALIZATION_TYPE_DIGEST ||
+	    vec->digest_error) {
 		/* Just using digest() */
 		ahash_request_set_callback(req, req_flags, crypto_req_done,
 					   &wait);
 		ahash_request_set_crypt(req, tsgl->sgl, result, vec->psize);
 		err = do_ahash_op(crypto_ahash_digest, req, &wait, cfg->nosimd);
 		if (err) {
-			pr_err("alg: hash: %s digest() failed with err %d on test vector %u, cfg=\"%s\"\n",
-			       driver, err, vec_num, cfg->name);
+			if (err == vec->digest_error)
+				return 0;
+			pr_err("alg: hash: %s digest() failed on test vector %u; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
+			       driver, vec_num, vec->digest_error, err,
+			       cfg->name);
 			return err;
 		}
+		if (vec->digest_error) {
+			pr_err("alg: hash: %s digest() unexpectedly succeeded on test vector %u; expected_error=%d, cfg=\"%s\"\n",
+			       driver, vec_num, vec->digest_error, cfg->name);
+			return -EINVAL;
+		}
 		goto result_ready;
 	}
 
@@ -1262,6 +1278,7 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 		 cfg->iv_offset +
 		 (cfg->iv_offset_relative_to_alignmask ? alignmask : 0);
 	struct kvec input[2];
+	int expected_error;
 	int err;
 
 	/* Set the key */
@@ -1270,26 +1287,33 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 	else
 		crypto_aead_clear_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	err = crypto_aead_setkey(tfm, vec->key, vec->klen);
-	if (err) {
-		if (vec->fail) /* expectedly failed to set key? */
-			return 0;
-		pr_err("alg: aead: %s setkey failed with err %d on test vector %u; flags=%#x\n",
-		       driver, err, vec_num, crypto_aead_get_flags(tfm));
+	if (err && err != vec->setkey_error) {
+		pr_err("alg: aead: %s setkey failed on test vector %u; expected_error=%d, actual_error=%d, flags=%#x\n",
+		       driver, vec_num, vec->setkey_error, err,
+		       crypto_aead_get_flags(tfm));
 		return err;
 	}
-	if (vec->fail) {
-		pr_err("alg: aead: %s setkey unexpectedly succeeded on test vector %u\n",
-		       driver, vec_num);
+	if (!err && vec->setkey_error) {
+		pr_err("alg: aead: %s setkey unexpectedly succeeded on test vector %u; expected_error=%d\n",
+		       driver, vec_num, vec->setkey_error);
 		return -EINVAL;
 	}
 
 	/* Set the authentication tag size */
 	err = crypto_aead_setauthsize(tfm, authsize);
-	if (err) {
-		pr_err("alg: aead: %s setauthsize failed with err %d on test vector %u\n",
-		       driver, err, vec_num);
+	if (err && err != vec->setauthsize_error) {
+		pr_err("alg: aead: %s setauthsize failed on test vector %u; expected_error=%d, actual_error=%d\n",
+		       driver, vec_num, vec->setauthsize_error, err);
 		return err;
 	}
+	if (!err && vec->setauthsize_error) {
+		pr_err("alg: aead: %s setauthsize unexpectedly succeeded on test vector %u; expected_error=%d\n",
+		       driver, vec_num, vec->setauthsize_error);
+		return -EINVAL;
+	}
+
+	if (vec->setkey_error || vec->setauthsize_error)
+		return 0;
 
 	/* The IV must be copied to a buffer, as the algorithm may modify it */
 	if (WARN_ON(ivsize > MAX_IVLEN))
@@ -1328,18 +1352,6 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 	if (cfg->nosimd)
 		crypto_reenable_simd_for_test();
 	err = crypto_wait_req(err, &wait);
-	if (err) {
-		if (err == -EBADMSG && vec->novrfy)
-			return 0;
-		pr_err("alg: aead: %s %s failed with err %d on test vector %u, cfg=\"%s\"\n",
-		       driver, op, err, vec_num, cfg->name);
-		return err;
-	}
-	if (vec->novrfy) {
-		pr_err("alg: aead: %s %s unexpectedly succeeded on test vector %u, cfg=\"%s\"\n",
-		       driver, op, vec_num, cfg->name);
-		return -EINVAL;
-	}
 
 	/* Check that the algorithm didn't overwrite things it shouldn't have */
 	if (req->cryptlen != (enc ? vec->plen : vec->clen) ||
@@ -1385,6 +1397,21 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 		return -EINVAL;
 	}
 
+	/* Check for success or failure */
+	expected_error = vec->novrfy ? -EBADMSG : vec->crypt_error;
+	if (err) {
+		if (err == expected_error)
+			return 0;
+		pr_err("alg: aead: %s %s failed on test vector %u; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
+		       driver, op, vec_num, expected_error, err, cfg->name);
+		return err;
+	}
+	if (expected_error) {
+		pr_err("alg: aead: %s %s unexpectedly succeeded on test vector %u; expected_error=%d, cfg=\"%s\"\n",
+		       driver, op, vec_num, expected_error, cfg->name);
+		return -EINVAL;
+	}
+
 	/* Check for the correct output (ciphertext or plaintext) */
 	err = verify_correct_output(&tsgls->dst, enc ? vec->ctext : vec->ptext,
 				    enc ? vec->clen : vec->plen,
@@ -1550,13 +1577,20 @@ static int test_cipher(struct crypto_cipher *tfm, int enc,
 
 		ret = crypto_cipher_setkey(tfm, template[i].key,
 					   template[i].klen);
-		if (template[i].fail == !ret) {
-			printk(KERN_ERR "alg: cipher: setkey failed "
-			       "on test %d for %s: flags=%x\n", j,
-			       algo, crypto_cipher_get_flags(tfm));
+		if (ret) {
+			if (ret == template[i].setkey_error)
+				continue;
+			pr_err("alg: cipher: %s setkey failed on test vector %u; expected_error=%d, actual_error=%d, flags=%#x\n",
+			       algo, j, template[i].setkey_error, ret,
+			       crypto_cipher_get_flags(tfm));
 			goto out;
-		} else if (ret)
-			continue;
+		}
+		if (template[i].setkey_error) {
+			pr_err("alg: cipher: %s setkey unexpectedly succeeded on test vector %u; expected_error=%d\n",
+			       algo, j, template[i].setkey_error);
+			ret = -EINVAL;
+			goto out;
+		}
 
 		for (k = 0; k < template[i].len;
 		     k += crypto_cipher_blocksize(tfm)) {
@@ -1614,15 +1648,16 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 					    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	err = crypto_skcipher_setkey(tfm, vec->key, vec->klen);
 	if (err) {
-		if (vec->fail) /* expectedly failed to set key? */
+		if (err == vec->setkey_error)
 			return 0;
-		pr_err("alg: skcipher: %s setkey failed with err %d on test vector %u; flags=%#x\n",
-		       driver, err, vec_num, crypto_skcipher_get_flags(tfm));
+		pr_err("alg: skcipher: %s setkey failed on test vector %u; expected_error=%d, actual_error=%d, flags=%#x\n",
+		       driver, vec_num, vec->setkey_error, err,
+		       crypto_skcipher_get_flags(tfm));
 		return err;
 	}
-	if (vec->fail) {
-		pr_err("alg: skcipher: %s setkey unexpectedly succeeded on test vector %u\n",
-		       driver, vec_num);
+	if (vec->setkey_error) {
+		pr_err("alg: skcipher: %s setkey unexpectedly succeeded on test vector %u; expected_error=%d\n",
+		       driver, vec_num, vec->setkey_error);
 		return -EINVAL;
 	}
 
@@ -1667,11 +1702,6 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 	if (cfg->nosimd)
 		crypto_reenable_simd_for_test();
 	err = crypto_wait_req(err, &wait);
-	if (err) {
-		pr_err("alg: skcipher: %s %s failed with err %d on test vector %u, cfg=\"%s\"\n",
-		       driver, op, err, vec_num, cfg->name);
-		return err;
-	}
 
 	/* Check that the algorithm didn't overwrite things it shouldn't have */
 	if (req->cryptlen != vec->len ||
@@ -1714,6 +1744,20 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 		return -EINVAL;
 	}
 
+	/* Check for success or failure */
+	if (err) {
+		if (err == vec->crypt_error)
+			return 0;
+		pr_err("alg: skcipher: %s %s failed on test vector %u; expected_error=%d, actual_error=%d, cfg=\"%s\"\n",
+		       driver, op, vec_num, vec->crypt_error, err, cfg->name);
+		return err;
+	}
+	if (vec->crypt_error) {
+		pr_err("alg: skcipher: %s %s unexpectedly succeeded on test vector %u; expected_error=%d, cfg=\"%s\"\n",
+		       driver, op, vec_num, vec->crypt_error, cfg->name);
+		return -EINVAL;
+	}
+
 	/* Check for the correct output (ciphertext or plaintext) */
 	err = verify_correct_output(&tsgls->dst, enc ? vec->ctext : vec->ptext,
 				    vec->len, 0, true);
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index d18a37629f053..beb9bd79fe1fa 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -34,6 +34,8 @@
  * @digest:	Pointer to expected digest
  * @psize:	Length of source data in bytes
  * @ksize:	Length of @key in bytes (0 if no key)
+ * @setkey_error: Expected error from setkey()
+ * @digest_error: Expected error from digest()
  */
 struct hash_testvec {
 	const char *key;
@@ -41,6 +43,8 @@ struct hash_testvec {
 	const char *digest;
 	unsigned short psize;
 	unsigned short ksize;
+	int setkey_error;
+	int digest_error;
 };
 
 /*
@@ -52,12 +56,13 @@ struct hash_testvec {
  * @ptext:	Pointer to plaintext
  * @ctext:	Pointer to ciphertext
  * @len:	Length of @ptext and @ctext in bytes
- * @fail:	If set to one, the test need to fail
  * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
  * 		( e.g. test needs to fail due to a weak key )
  * @fips_skip:	Skip the test vector in FIPS mode
  * @generates_iv: Encryption should ignore the given IV, and output @iv_out.
  *		  Decryption takes @iv_out.  Needed for AES Keywrap ("kw(aes)").
+ * @setkey_error: Expected error from setkey()
+ * @crypt_error: Expected error from encrypt() and decrypt()
  */
 struct cipher_testvec {
 	const char *key;
@@ -65,12 +70,13 @@ struct cipher_testvec {
 	const char *iv_out;
 	const char *ptext;
 	const char *ctext;
-	bool fail;
 	unsigned char wk; /* weak key flag */
 	unsigned char klen;
 	unsigned short len;
 	bool fips_skip;
 	bool generates_iv;
+	int setkey_error;
+	int crypt_error;
 };
 
 /*
@@ -82,7 +88,6 @@ struct cipher_testvec {
  * @ctext:	Pointer to the full authenticated ciphertext.  For AEADs that
  *		produce a separate "ciphertext" and "authentication tag", these
  *		two parts are concatenated: ciphertext || tag.
- * @fail:	setkey() failure expected?
  * @novrfy:	Decryption verification failure expected?
  * @wk:		Does the test need CRYPTO_TFM_REQ_FORBID_WEAK_KEYS?
  *		(e.g. setkey() needs to fail due to a weak key)
@@ -90,6 +95,9 @@ struct cipher_testvec {
  * @plen:	Length of @ptext in bytes
  * @alen:	Length of @assoc in bytes
  * @clen:	Length of @ctext in bytes
+ * @setkey_error: Expected error from setkey()
+ * @setauthsize_error: Expected error from setauthsize()
+ * @crypt_error: Expected error from encrypt() and decrypt()
  */
 struct aead_testvec {
 	const char *key;
@@ -97,13 +105,15 @@ struct aead_testvec {
 	const char *ptext;
 	const char *assoc;
 	const char *ctext;
-	bool fail;
 	unsigned char novrfy;
 	unsigned char wk;
 	unsigned char klen;
 	unsigned short plen;
 	unsigned short clen;
 	unsigned short alen;
+	int setkey_error;
+	int setauthsize_error;
+	int crypt_error;
 };
 
 struct cprng_testvec {
@@ -7084,7 +7094,7 @@ static const struct cipher_testvec des_tv_template[] = {
 			  "\xb4\x99\x26\xf7\x1f\xe1\xd4\x90",
 		.len	= 24,
 	}, { /* Weak key */
-		.fail	= true,
+		.setkey_error = -EINVAL,
 		.wk	= 1,
 		.key	= "\x01\x01\x01\x01\x01\x01\x01\x01",
 		.klen	= 8,
-- 
2.21.0

