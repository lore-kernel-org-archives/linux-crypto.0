Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB60268FE0
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945173; cv=none; b=tScGQfSOSNecTvHgUUx59BSzXuFBGNJmREIEqiMuq1hSxhbj9z5XjJjFtx+rnBwr9Tnp6ZoKG5lCRJtYBruH5hTy5e0Y3TfC9hmsF5iRZ4TGEuMUwFGnEN4C4SM6iSXcKtKSjVpFpX9MytNFjXi6dEsJfxyKzcqoOm1yI0CZOqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945173; c=relaxed/simple;
	bh=/mSz73HuakR51Z8LglwAxOmrMKZEXleSH0gJV1TQIuU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=ZITOaha8ShtUph1JsJC2wxb4TuxHVOBlIhEGwL7HDvUXkNnt/yg1LnQAowlQV5BjFQgDSnjkJKBlIotFD91+l3sNM2dun0YGs5rGGATIvoOuj7cllq95x2CzZCeGh24nAzLm+lrODEkomdod9rf7VGJXrq1tNYjUivkVPH+ivms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZujrTVfs; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZujrTVfs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uemlKlx69YhqcHyUHEFXG5pTt9Dw+NjUbcqJlJ+jVC0=; b=ZujrTVfsbYi/rNvVyf6WWWfwCa
	WQegHKA2Y1nkpi7XqAf4lMz9Bfw2/USS8EONePABMjEyt4SPVJjwRoj98IeeMawa7LqY/AsCXHW8z
	3+dCoiwoBnjxR5M5OPlzXXkzH1OT9B87IH2hN6sZoAPsqbtKriK7jT4nXhik660Wv4CyhE2qDmELj
	hVHd5JR6L7REH964zQl+N7YcWG6MaZiYrdg3wDmjB1qNoNpGiWNScf/XDvRPoWI7rE+/nelQR/+dN
	SZKOd8ESfRo+gph5gnLu8BYRB5C1oiLd9FReACa7gR61+aITrXMypUKlplqzXmQYvTokcoUcbAT5L
	7BKlv/Vw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwt-00Ge70-16;
	Fri, 18 Apr 2025 10:59:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:27 +0800
Date: Fri, 18 Apr 2025 10:59:27 +0800
Message-Id: <02d105d913b518722dca5105eafccf05a2e39b05.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 21/67] crypto: arm/sha1-asm - Use API partial block
 handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/sha1.h      | 14 --------------
 arch/arm/crypto/sha1_glue.c | 33 +++++++++++----------------------
 2 files changed, 11 insertions(+), 36 deletions(-)
 delete mode 100644 arch/arm/crypto/sha1.h

diff --git a/arch/arm/crypto/sha1.h b/arch/arm/crypto/sha1.h
deleted file mode 100644
index b1b7e21da2c3..000000000000
--- a/arch/arm/crypto/sha1.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef ASM_ARM_CRYPTO_SHA1_H
-#define ASM_ARM_CRYPTO_SHA1_H
-
-#include <linux/crypto.h>
-#include <crypto/sha1.h>
-
-extern int sha1_update_arm(struct shash_desc *desc, const u8 *data,
-			   unsigned int len);
-
-extern int sha1_finup_arm(struct shash_desc *desc, const u8 *data,
-			   unsigned int len, u8 *out);
-
-#endif
diff --git a/arch/arm/crypto/sha1_glue.c b/arch/arm/crypto/sha1_glue.c
index 95a727bcd664..255da00c7d98 100644
--- a/arch/arm/crypto/sha1_glue.c
+++ b/arch/arm/crypto/sha1_glue.c
@@ -12,53 +12,42 @@
  */
 
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/types.h>
 #include <crypto/sha1.h>
 #include <crypto/sha1_base.h>
-#include <asm/byteorder.h>
-
-#include "sha1.h"
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 asmlinkage void sha1_block_data_order(struct sha1_state *digest,
 		const u8 *data, int rounds);
 
-int sha1_update_arm(struct shash_desc *desc, const u8 *data,
-		    unsigned int len)
+static int sha1_update_arm(struct shash_desc *desc, const u8 *data,
+			   unsigned int len)
 {
 	/* make sure signature matches sha1_block_fn() */
 	BUILD_BUG_ON(offsetof(struct sha1_state, state) != 0);
 
-	return sha1_base_do_update(desc, data, len, sha1_block_data_order);
+	return sha1_base_do_update_blocks(desc, data, len,
+					  sha1_block_data_order);
 }
-EXPORT_SYMBOL_GPL(sha1_update_arm);
 
-static int sha1_final(struct shash_desc *desc, u8 *out)
+static int sha1_finup_arm(struct shash_desc *desc, const u8 *data,
+			  unsigned int len, u8 *out)
 {
-	sha1_base_do_finalize(desc, sha1_block_data_order);
+	sha1_base_do_finup(desc, data, len, sha1_block_data_order);
 	return sha1_base_finish(desc, out);
 }
 
-int sha1_finup_arm(struct shash_desc *desc, const u8 *data,
-		   unsigned int len, u8 *out)
-{
-	sha1_base_do_update(desc, data, len, sha1_block_data_order);
-	return sha1_final(desc, out);
-}
-EXPORT_SYMBOL_GPL(sha1_finup_arm);
-
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	sha1_base_init,
 	.update		=	sha1_update_arm,
-	.final		=	sha1_final,
 	.finup		=	sha1_finup_arm,
-	.descsize	=	sizeof(struct sha1_state),
+	.descsize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"sha1-asm",
 		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

