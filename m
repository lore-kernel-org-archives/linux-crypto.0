Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88882C432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DE7921736
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575051860;
	bh=wnGlrnRO1XwwvM23eS/gneOt/0pRyRbkbOO0Mn4v4Eo=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kM988JS8PkIdDx7zRoKwx30EkRqjuzvPc6jgIZj4N+pXM25GLCBA+CkN564MkXuNb
	 o2FEQd9YB0OMyigJ5zjK6paScduUWzZPTowLCukDFv3zF7i0KxzsgO7X9A1mSB16xO
	 1NtoBarDXSrWHtpFNnlDBj6rt8pEg2gLwSkVwJdg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfK2SYT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 13:24:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbfK2SYS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 13:24:18 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CA8821771
        for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2019 18:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575051857;
        bh=wnGlrnRO1XwwvM23eS/gneOt/0pRyRbkbOO0Mn4v4Eo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=vzbJmuzpwORXO8nhU8Pj7acOJa494+YTUhpBHrBQB4Qh2xPj4EDFbJCBxjNmBYDAo
         aDRS2Yw1KqlHNa2wYNZwSM7sTnoJDBHt8+kySCLitkugB/9k2TAjbH9vZ/Snu24srA
         yBAyyOFxbj9YrA5TeFTm89ItXnmzdfhKvjcOfkns=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/6] crypto: skcipher - remove crypto_skcipher::keysize
Date:   Fri, 29 Nov 2019 10:23:04 -0800
Message-Id: <20191129182308.53961-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191129182308.53961-1-ebiggers@kernel.org>
References: <20191129182308.53961-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Due to the removal of the blkcipher and ablkcipher algorithm types,
crypto_skcipher::keysize is now redundant since it always equals
crypto_skcipher_alg(tfm)->max_keysize.

Remove it and update crypto_skcipher_default_keysize() accordingly.

Also rename crypto_skcipher_default_keysize() to
crypto_skcipher_max_keysize() to clarify that it specifically returns
the maximum key size, not some unspecified "default".

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c         |  3 +--
 crypto/testmgr.c          | 10 ++++++----
 fs/ecryptfs/crypto.c      |  2 +-
 fs/ecryptfs/keystore.c    |  4 ++--
 include/crypto/skcipher.h |  5 ++---
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 7d2e722e82af..6cfafd80c7e6 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -585,7 +585,7 @@ static unsigned int crypto_skcipher_extsize(struct crypto_alg *alg)
 
 static void skcipher_set_needkey(struct crypto_skcipher *tfm)
 {
-	if (tfm->keysize)
+	if (crypto_skcipher_max_keysize(tfm) != 0)
 		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
 }
 
@@ -686,7 +686,6 @@ static int crypto_skcipher_init_tfm(struct crypto_tfm *tfm)
 	skcipher->setkey = skcipher_setkey;
 	skcipher->encrypt = alg->encrypt;
 	skcipher->decrypt = alg->decrypt;
-	skcipher->keysize = alg->max_keysize;
 
 	skcipher_set_needkey(skcipher);
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 82513b6b0abd..85d720a57bb0 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2647,7 +2647,7 @@ static void generate_random_cipher_testvec(struct skcipher_request *req,
 					   char *name, size_t max_namelen)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	const unsigned int maxkeysize = tfm->keysize;
+	const unsigned int maxkeysize = crypto_skcipher_max_keysize(tfm);
 	const unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct scatterlist src, dst;
 	u8 iv[MAX_IVLEN];
@@ -2693,6 +2693,7 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 					 struct cipher_test_sglists *tsgls)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const unsigned int maxkeysize = crypto_skcipher_max_keysize(tfm);
 	const unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	const unsigned int blocksize = crypto_skcipher_blocksize(tfm);
 	const unsigned int maxdatasize = (2 * PAGE_SIZE) - TESTMGR_POISON_LEN;
@@ -2751,9 +2752,10 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 
 	/* Check the algorithm properties for consistency. */
 
-	if (tfm->keysize != generic_tfm->keysize) {
+	if (maxkeysize != crypto_skcipher_max_keysize(generic_tfm)) {
 		pr_err("alg: skcipher: max keysize for %s (%u) doesn't match generic impl (%u)\n",
-		       driver, tfm->keysize, generic_tfm->keysize);
+		       driver, maxkeysize,
+		       crypto_skcipher_max_keysize(generic_tfm));
 		err = -EINVAL;
 		goto out;
 	}
@@ -2778,7 +2780,7 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 	 * the other implementation against them.
 	 */
 
-	vec.key = kmalloc(tfm->keysize, GFP_KERNEL);
+	vec.key = kmalloc(maxkeysize, GFP_KERNEL);
 	vec.iv = kmalloc(ivsize, GFP_KERNEL);
 	vec.ptext = kmalloc(maxdatasize, GFP_KERNEL);
 	vec.ctext = kmalloc(maxdatasize, GFP_KERNEL);
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index f91db24bbf3b..db1ef144c63a 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1586,7 +1586,7 @@ ecryptfs_process_key_cipher(struct crypto_skcipher **key_tfm,
 	}
 	crypto_skcipher_set_flags(*key_tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	if (*key_size == 0)
-		*key_size = crypto_skcipher_default_keysize(*key_tfm);
+		*key_size = crypto_skcipher_max_keysize(*key_tfm);
 	get_random_bytes(dummy_key, *key_size);
 	rc = crypto_skcipher_setkey(*key_tfm, dummy_key, *key_size);
 	if (rc) {
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 216fbe6a4837..7d326aa0308e 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -2204,9 +2204,9 @@ write_tag_3_packet(char *dest, size_t *remaining_bytes,
 	if (mount_crypt_stat->global_default_cipher_key_size == 0) {
 		printk(KERN_WARNING "No key size specified at mount; "
 		       "defaulting to [%d]\n",
-		       crypto_skcipher_default_keysize(tfm));
+		       crypto_skcipher_max_keysize(tfm));
 		mount_crypt_stat->global_default_cipher_key_size =
-			crypto_skcipher_default_keysize(tfm);
+			crypto_skcipher_max_keysize(tfm);
 	}
 	if (crypt_stat->key_size == 0)
 		crypt_stat->key_size =
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index bf656a97cb65..d8c28c8186a4 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -41,7 +41,6 @@ struct crypto_skcipher {
 	int (*decrypt)(struct skcipher_request *req);
 
 	unsigned int reqsize;
-	unsigned int keysize;
 
 	struct crypto_tfm base;
 };
@@ -377,10 +376,10 @@ static inline int crypto_sync_skcipher_setkey(struct crypto_sync_skcipher *tfm,
 	return crypto_skcipher_setkey(&tfm->base, key, keylen);
 }
 
-static inline unsigned int crypto_skcipher_default_keysize(
+static inline unsigned int crypto_skcipher_max_keysize(
 	struct crypto_skcipher *tfm)
 {
-	return tfm->keysize;
+	return crypto_skcipher_alg(tfm)->max_keysize;
 }
 
 /**
-- 
2.24.0

