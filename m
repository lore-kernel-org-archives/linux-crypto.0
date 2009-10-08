From: "Benjamin Gilbert" <bgilbert@cs.cmu.edu>
Subject: [PATCH 3/3] crypto: hash - Remove cra_u.{digest,hash}
Date: Thu,  8 Oct 2009 17:41:05 -0400
Message-ID: <1255038065-3113-4-git-send-email-bgilbert@cs.cmu.edu>
References: <1255038065-3113-1-git-send-email-bgilbert@cs.cmu.edu>
 <1255038065-3113-2-git-send-email-bgilbert@cs.cmu.edu>
 <1255038065-3113-3-git-send-email-bgilbert@cs.cmu.edu>
Cc: linux-crypto@vger.kernel.org,
	Benjamin Gilbert <bgilbert@cs.cmu.edu>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from SMTP03.SRV.CS.CMU.EDU ([128.2.217.198]:32782 "EHLO
	smtp03.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbZJHVsG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2009 17:48:06 -0400
In-Reply-To: <1255038065-3113-3-git-send-email-bgilbert@cs.cmu.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove unused digest_alg and hash_alg structs from crypto_alg union and
kill their definitions.  This also ensures that old-style digest/hash
algorithms maintained out of tree will break at build time rather than
oopsing at runtime.

Signed-off-by: Benjamin Gilbert <bgilbert@cs.cmu.edu>
---
 include/linux/crypto.h |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index fd92988..24d2e30 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -250,29 +250,6 @@ struct cipher_alg {
 	void (*cia_decrypt)(struct crypto_tfm *tfm, u8 *dst, const u8 *src);
 };
 
-struct digest_alg {
-	unsigned int dia_digestsize;
-	void (*dia_init)(struct crypto_tfm *tfm);
-	void (*dia_update)(struct crypto_tfm *tfm, const u8 *data,
-			   unsigned int len);
-	void (*dia_final)(struct crypto_tfm *tfm, u8 *out);
-	int (*dia_setkey)(struct crypto_tfm *tfm, const u8 *key,
-	                  unsigned int keylen);
-};
-
-struct hash_alg {
-	int (*init)(struct hash_desc *desc);
-	int (*update)(struct hash_desc *desc, struct scatterlist *sg,
-		      unsigned int nbytes);
-	int (*final)(struct hash_desc *desc, u8 *out);
-	int (*digest)(struct hash_desc *desc, struct scatterlist *sg,
-		      unsigned int nbytes, u8 *out);
-	int (*setkey)(struct crypto_hash *tfm, const u8 *key,
-		      unsigned int keylen);
-
-	unsigned int digestsize;
-};
