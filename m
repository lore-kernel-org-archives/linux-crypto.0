Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C735CA9EBC
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F142921D81
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572032726;
	bh=Uz30zkD8i+4maJkolb49XrN1RYHmbyvgQ1ee7eQO1/4=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vAmIOpusZkwj41g+a4RobvqCX5Omj88lNiUfFwWa2JzbFR1t7MOhLNEzGlhbPmac7
	 BfMoc/JSMUCuh151kVa6XpyFsOrP6FNeWr/A9QV8h9AXLC4heg6Mc5+B06rla889gQ
	 abtOLzPPp3apVIa+n/rsaOSCbLD1GSwVoPzV1/KY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfJYTpZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 15:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727545AbfJYTpZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 15:45:25 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E67B721D82
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 19:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572032724;
        bh=Uz30zkD8i+4maJkolb49XrN1RYHmbyvgQ1ee7eQO1/4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=PkqQs0m2JfSbxoxUORRyjy2kjtUJiuLsmIDzyqzl9iuA4wnCYdmsJkTmHoVy/1n7p
         hivTvuksH0Egyv3ww6e2DWFfOdt22CCLr4IKFrWr5+JKe7fJklyA5LDfc66aFqqJLD
         79mEr2gsR7rFri3Gp91Mo8DzZCogYmVK7u8e+5kU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/5] crypto: remove crypto_has_ablkcipher()
Date:   Fri, 25 Oct 2019 12:41:10 -0700
Message-Id: <20191025194113.217451-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191025194113.217451-1-ebiggers@kernel.org>
References: <20191025194113.217451-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

crypto_has_ablkcipher() has no users, and it does the same thing as
crypto_has_skcipher() anyway.  So remove it.  This also removes the last
user of crypto_skcipher_type() and crypto_skcipher_mask(), so remove
those too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/crypto/api-skcipher.rst |  2 +-
 include/linux/crypto.h                | 31 ---------------------------
 2 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
index 20ba08dddf2e..55e0851f6fed 100644
--- a/Documentation/crypto/api-skcipher.rst
+++ b/Documentation/crypto/api-skcipher.rst
@@ -41,7 +41,7 @@ Asynchronous Block Cipher API - Deprecated
    :doc: Asynchronous Block Cipher API
 
 .. kernel-doc:: include/linux/crypto.h
-   :functions: crypto_free_ablkcipher crypto_has_ablkcipher crypto_ablkcipher_ivsize crypto_ablkcipher_blocksize crypto_ablkcipher_setkey crypto_ablkcipher_reqtfm crypto_ablkcipher_encrypt crypto_ablkcipher_decrypt
+   :functions: crypto_free_ablkcipher crypto_ablkcipher_ivsize crypto_ablkcipher_blocksize crypto_ablkcipher_setkey crypto_ablkcipher_reqtfm crypto_ablkcipher_encrypt crypto_ablkcipher_decrypt
 
 Asynchronous Cipher Request Handle - Deprecated
 -----------------------------------------------
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 19ea3a371d7b..b7855743f7e3 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -900,20 +900,6 @@ static inline struct crypto_ablkcipher *__crypto_ablkcipher_cast(
 	return (struct crypto_ablkcipher *)tfm;
 }
 
-static inline u32 crypto_skcipher_type(u32 type)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_BLKCIPHER;
-	return type;
-}
-
-static inline u32 crypto_skcipher_mask(u32 mask)
-{
-	mask &= ~CRYPTO_ALG_TYPE_MASK;
-	mask |= CRYPTO_ALG_TYPE_BLKCIPHER_MASK;
-	return mask;
-}
-
 /**
  * DOC: Asynchronous Block Cipher API
  *
@@ -959,23 +945,6 @@ static inline void crypto_free_ablkcipher(struct crypto_ablkcipher *tfm)
 	crypto_free_tfm(crypto_ablkcipher_tfm(tfm));
 }
 
-/**
- * crypto_has_ablkcipher() - Search for the availability of an ablkcipher.
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	      ablkcipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Return: true when the ablkcipher is known to the kernel crypto API; false
- *	   otherwise
- */
-static inline int crypto_has_ablkcipher(const char *alg_name, u32 type,
-					u32 mask)
-{
-	return crypto_has_alg(alg_name, crypto_skcipher_type(type),
-			      crypto_skcipher_mask(mask));
-}
-
 static inline struct ablkcipher_tfm *crypto_ablkcipher_crt(
 	struct crypto_ablkcipher *tfm)
 {
-- 
2.23.0

