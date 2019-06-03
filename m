Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D04C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B46D27739
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559540760;
	bh=uIgFIySqBY2+hXBL3fX7uSdcRh4/a/PAY2vsQY86zzs=;
	h=From:To:Subject:Date:List-ID:From;
	b=cZ92IYy3FyhQ4Swf17bfearAq7pTFIIGz30vEsmKPSRCN9y95OZBQ0TxAiAZrcE/t
	 EulO4fpbZLD87TcWyXaSnAB/1OjpBbf5hXrsOWm9bwoCMq3Orkz/q+vLxsPpURDcjO
	 8HVLYEkigmnH6azQycHqeCvp77wqyPj7HRShGlGQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFCFp7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 01:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfFCFp7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 01:45:59 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C21927739
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 05:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559540758;
        bh=uIgFIySqBY2+hXBL3fX7uSdcRh4/a/PAY2vsQY86zzs=;
        h=From:To:Subject:Date:From;
        b=fgUxB7SjnAEfvRQlXkXHdg3o7J+AZtaExDFV+moNtF1z469ZfVALzzJBm6rLvBOo/
         cwCzc8OpSLHKp9j8NGhfOqL9uriEOPNsUIOZzmx1uJQejX+LS4rRZ3mAr6e8T1rRqP
         4LE3xTS6udq+Rle3fKe+lv1HCdw/XkpqGyMxzN+U=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: skcipher - un-inline encrypt and decrypt functions
Date:   Sun,  2 Jun 2019 22:45:51 -0700
Message-Id: <20190603054551.6182-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

crypto_skcipher_encrypt() and crypto_skcipher_decrypt() have grown to be
more than a single indirect function call.  They now also check whether
a key has been set, and with CONFIG_CRYPTO_STATS=y they also update the
crypto statistics.  That can add up to a lot of bloat at every call
site.  Moreover, these always involve a function call anyway, which
greatly limits the benefits of inlining.

So change them to be non-inline.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c         | 34 ++++++++++++++++++++++++++++++++++
 include/crypto/skcipher.h | 32 ++------------------------------
 2 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 2e66f312e2c4f..2828e27d7fbc0 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -842,6 +842,40 @@ static int skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return 0;
 }
 
+int crypto_skcipher_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int cryptlen = req->cryptlen;
+	int ret;
+
+	crypto_stats_get(alg);
+	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		ret = -ENOKEY;
+	else
+		ret = tfm->encrypt(req);
+	crypto_stats_skcipher_encrypt(cryptlen, ret, alg);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_skcipher_encrypt);
+
+int crypto_skcipher_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_alg *alg = tfm->base.__crt_alg;
+	unsigned int cryptlen = req->cryptlen;
+	int ret;
+
+	crypto_stats_get(alg);
+	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		ret = -ENOKEY;
+	else
+		ret = tfm->decrypt(req);
+	crypto_stats_skcipher_decrypt(cryptlen, ret, alg);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_skcipher_decrypt);
+
 static void crypto_skcipher_exit_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_skcipher *skcipher = __crypto_skcipher_cast(tfm);
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index e555294ed77fe..98547d1f18c53 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -484,21 +484,7 @@ static inline struct crypto_sync_skcipher *crypto_sync_skcipher_reqtfm(
  *
  * Return: 0 if the cipher operation was successful; < 0 if an error occurred
  */
-static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	unsigned int cryptlen = req->cryptlen;
-	int ret;
-
-	crypto_stats_get(alg);
-	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		ret = -ENOKEY;
-	else
-		ret = tfm->encrypt(req);
-	crypto_stats_skcipher_encrypt(cryptlen, ret, alg);
-	return ret;
-}
+int crypto_skcipher_encrypt(struct skcipher_request *req);
 
 /**
  * crypto_skcipher_decrypt() - decrypt ciphertext
@@ -511,21 +497,7 @@ static inline int crypto_skcipher_encrypt(struct skcipher_request *req)
  *
  * Return: 0 if the cipher operation was successful; < 0 if an error occurred
  */
-static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
-{
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_alg *alg = tfm->base.__crt_alg;
-	unsigned int cryptlen = req->cryptlen;
-	int ret;
-
-	crypto_stats_get(alg);
-	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		ret = -ENOKEY;
-	else
-		ret = tfm->decrypt(req);
-	crypto_stats_skcipher_decrypt(cryptlen, ret, alg);
-	return ret;
-}
+int crypto_skcipher_decrypt(struct skcipher_request *req);
 
 /**
  * DOC: Symmetric Key Cipher Request Handle
-- 
2.21.0

