Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0786C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 19:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 889A620869
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 19:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575056189;
	bh=23wt+adORmu1LXGWTyNdKLjs1groVQ/QeqHaiN2TPvU=;
	h=From:To:Subject:Date:List-ID:From;
	b=QpI4EjL1ON/lJ/DVgaAlqvlkcFVR3dEcGyyx5RoBn3JrWdWdvOw6HERunporbNBJf
	 DcimEVpl7nF2h3/4OXzG4MMFLWTTq0+A5mMRinQaHUWfBLzYwx6P+AeGRkWOnN5ATX
	 jVYq2VdvNAr9i5VbKu+CEGh5cqS6J/IiO3lQGoD8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfK2Tg2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 14:36:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbfK2Tg2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 14:36:28 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA93D20869
        for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2019 19:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575056187;
        bh=23wt+adORmu1LXGWTyNdKLjs1groVQ/QeqHaiN2TPvU=;
        h=From:To:Subject:Date:From;
        b=bqNRivGyqu16ikt7gb2zEBmVsQQx2w/YN4sxlpJeXNbjVmnSc+lOTnzR05oozYJ7k
         iprbp/D7biHF0tFDzMIivyRVkTi3pZm6P4DCJyaGZ/W4wEQveyjbObWoAFfVX06bkh
         Kgu5VdKXgQpPvb1NWIl9CNiLeSxRAjjrg/jkGyrs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: shash - allow essiv and hmac to use OPTIONAL_KEY algorithms
Date:   Fri, 29 Nov 2019 11:35:22 -0800
Message-Id: <20191129193522.52513-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The essiv and hmac templates refuse to use any hash algorithm that has a
->setkey() function, which includes not just algorithms that always need
a key, but also algorithms that optionally take a key.

Previously the only optionally-keyed hash algorithms in the crypto API
were non-cryptographic algorithms like crc32, so this didn't really
matter.  But that's changed with BLAKE2 support being added.  BLAKE2
should work with essiv and hmac, just like any other cryptographic hash.

Fix this by allowing the use of both algorithms without a ->setkey()
function and algorithms that have the OPTIONAL_KEY flag set.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/essiv.c                 | 2 +-
 crypto/hmac.c                  | 4 ++--
 crypto/shash.c                 | 3 +--
 include/crypto/internal/hash.h | 6 ++++++
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index 808f2b362106..e4b32c2ea7ec 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -442,7 +442,7 @@ static bool essiv_supported_algorithms(const char *essiv_cipher_name,
 	if (ivsize != alg->cra_blocksize)
 		goto out;
 
-	if (crypto_shash_alg_has_setkey(hash_alg))
+	if (crypto_shash_alg_needs_key(hash_alg))
 		goto out;
 
 	ret = true;
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8b2a212eb0ad..377f07733e2f 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -185,9 +185,9 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return PTR_ERR(salg);
 	alg = &salg->base;
 
-	/* The underlying hash algorithm must be unkeyed */
+	/* The underlying hash algorithm must not require a key */
 	err = -EINVAL;
-	if (crypto_shash_alg_has_setkey(salg))
+	if (crypto_shash_alg_needs_key(salg))
 		goto out_put_alg;
 
 	ds = salg->digestsize;
diff --git a/crypto/shash.c b/crypto/shash.c
index e83c5124f6eb..7989258a46b4 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -50,8 +50,7 @@ static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 
 static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *alg)
 {
-	if (crypto_shash_alg_has_setkey(alg) &&
-	    !(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY))
+	if (crypto_shash_alg_needs_key(alg))
 		crypto_shash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
 }
 
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index bfc9db7b100d..f68dab38f160 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -85,6 +85,12 @@ static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
 	return alg->setkey != shash_no_setkey;
 }
 
+static inline bool crypto_shash_alg_needs_key(struct shash_alg *alg)
+{
+	return crypto_shash_alg_has_setkey(alg) &&
+		!(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY);
+}
+
 bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
 
 int crypto_init_ahash_spawn(struct crypto_ahash_spawn *spawn,
-- 
2.24.0

