Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC240C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 907D527739
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559540735;
	bh=7TvPRfXl/nERyuF2efL4XbdZGnXdQZdhdBY1PHonRL8=;
	h=From:To:Subject:Date:List-ID:From;
	b=RVobM+4xcRThBHbM6yBPuOuiwKBVfAP4ZHaCiwj0Ql24KKjZM9sWnC1H+n6/4nZPs
	 1V3PYIlkzoa9kyWIU2RaZDdB8knOSs1QRQpdUn+TneyHVOadt6ifUV0+zJv2mS2cJZ
	 P/SA6TW8T4b/shoGnSGsdWC45HA9TqXi8r/VdHG0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfFCFpf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 01:45:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfFCFpf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 01:45:35 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2585F27739
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 05:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559540734;
        bh=7TvPRfXl/nERyuF2efL4XbdZGnXdQZdhdBY1PHonRL8=;
        h=From:To:Subject:Date:From;
        b=rMV+GPNkQLoPPXD2fYogKJ2WyNyGBW03P1SICNmCtRof3xl3+aZjDCTsQBFtPAXzc
         GV/YpAa6xlHgDwTUH5x4N14q/CaAGFDkX2QE/wh15QqOOGk/eUgh7tln/0YJ3tOxbT
         56uqgmoXzsaQzH97yHKCqBN0VLLPEh1tCh+8seZo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: aead - un-inline encrypt and decrypt functions
Date:   Sun,  2 Jun 2019 22:45:16 -0700
Message-Id: <20190603054516.6080-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

crypto_aead_encrypt() and crypto_aead_decrypt() have grown to be more
than a single indirect function call.  They now also check whether a key
has been set, the decryption side checks whether the input is at least
as long as the authentication tag length, and with CONFIG_CRYPTO_STATS=y
they also update the crypto statistics.  That can add up to a lot of
bloat at every call site.  Moreover, these always involve a function
call anyway, which greatly limits the benefits of inlining.

So change them to be non-inline.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/aead.c         | 36 ++++++++++++++++++++++++++++++++++++
 include/crypto/aead.h | 34 ++--------------------------------
 2 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 4908b5e846f0e..fc1d7ad8a487d 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -89,6 +89,42 @@ int crypto_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 }
 EXPORT_SYMBOL_GPL(crypto_aead_setauthsize);
 
+int crypto_aead_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_alg *alg = aead->base.__crt_alg;
+	unsigned int cryptlen = req->cryptlen;
+	int ret;
+
+	crypto_stats_get(alg);
+	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
+		ret = -ENOKEY;
+	else
+		ret = crypto_aead_alg(aead)->encrypt(req);
+	crypto_stats_aead_encrypt(cryptlen, alg, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_aead_encrypt);
+
+int crypto_aead_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_alg *alg = aead->base.__crt_alg;
+	unsigned int cryptlen = req->cryptlen;
+	int ret;
+
+	crypto_stats_get(alg);
+	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
+		ret = -ENOKEY;
+	else if (req->cryptlen < crypto_aead_authsize(aead))
+		ret = -EINVAL;
+	else
+		ret = crypto_aead_alg(aead)->decrypt(req);
+	crypto_stats_aead_decrypt(cryptlen, alg, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_aead_decrypt);
+
 static void crypto_aead_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_aead *aead = __crypto_aead_cast(tfm);
diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 9ad595f97c65a..020d581373abd 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -322,21 +322,7 @@ static inline struct crypto_aead *crypto_aead_reqtfm(struct aead_request *req)
  *
  * Return: 0 if the cipher operation was successful; < 0 if an error occurred
  */
-static inline int crypto_aead_encrypt(struct aead_request *req)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_alg *alg = aead->base.__crt_alg;
-	unsigned int cryptlen = req->cryptlen;
-	int ret;
-
-	crypto_stats_get(alg);
-	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
-		ret = -ENOKEY;
-	else
-		ret = crypto_aead_alg(aead)->encrypt(req);
-	crypto_stats_aead_encrypt(cryptlen, alg, ret);
-	return ret;
-}
+int crypto_aead_encrypt(struct aead_request *req);
 
 /**
  * crypto_aead_decrypt() - decrypt ciphertext
@@ -360,23 +346,7 @@ static inline int crypto_aead_encrypt(struct aead_request *req)
  *	   integrity of the ciphertext or the associated data was violated);
  *	   < 0 if an error occurred.
  */
-static inline int crypto_aead_decrypt(struct aead_request *req)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct crypto_alg *alg = aead->base.__crt_alg;
-	unsigned int cryptlen = req->cryptlen;
-	int ret;
-
-	crypto_stats_get(alg);
-	if (crypto_aead_get_flags(aead) & CRYPTO_TFM_NEED_KEY)
-		ret = -ENOKEY;
-	else if (req->cryptlen < crypto_aead_authsize(aead))
-		ret = -EINVAL;
-	else
-		ret = crypto_aead_alg(aead)->decrypt(req);
-	crypto_stats_aead_decrypt(cryptlen, alg, ret);
-	return ret;
-}
+int crypto_aead_decrypt(struct aead_request *req);
 
 /**
  * DOC: Asynchronous AEAD Request Handle
-- 
2.21.0

