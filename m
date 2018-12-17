Return-Path: <SRS0=ECh6=O2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbeLQDMs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Dec 2018 22:12:48 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: remove struct cipher_desc
Date: Sun, 16 Dec 2018 19:12:18 -0800
Message-Id: <20181217031218.18995-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

'struct cipher_desc' is unused.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/crypto.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index c2f5baed522cc..21153515db515 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -188,14 +188,6 @@ struct blkcipher_desc {
 	u32 flags;
 };
 
-struct cipher_desc {
-	struct crypto_tfm *tfm;
-	void (*crfn)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
-	unsigned int (*prfn)(const struct cipher_desc *desc, u8 *dst,
-			     const u8 *src, unsigned int nbytes);
-	void *info;
-};
-
 /**
  * DOC: Block Cipher Algorithm Definitions
  *
-- 
2.19.2
