Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD262356BD
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785816; cv=none; b=qhp1gxFfeKFYasCr5WJFGZzAQnTKGqtsR1DB5uQ5AGQbeRMwmNNlrnDcFrK60KhF+UcvmTWXhRU9icbE2Nfp7hj2xnlyMDfsdl5wAuVKxEkoOxn9hwCE2eQ3NTXWsZ07sK9d27iU1uurO1auYVMatg0aAUfHcZ8cvaRQCvi8FwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785816; c=relaxed/simple;
	bh=/mSz73HuakR51Z8LglwAxOmrMKZEXleSH0gJV1TQIuU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=Glrd2YHII2r50BTc18ccSJ8k1u9mnWPgKUHkp9FOp923GNNTTKnaTZ9Xnc1xl2cYGtcFeNVzz3YE5qAJo/NjcM/Im3KbfdMSO8EDChRCo8pbkFByr/JhTMKRejzq/5hxBdmmz6OGBn2RjzDE4CtKUfpreDkLcxEb7vIFIW5Gprk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WFEzOOaW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WFEzOOaW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uemlKlx69YhqcHyUHEFXG5pTt9Dw+NjUbcqJlJ+jVC0=; b=WFEzOOaWWl56Mkv+IZDB7ux0Dj
	0uQJrs2jNEmkQN1KS51NwX5SXmD8HRo/NsBURiqtU9L99nVzDwcKHVcNgju3DG2/+rxhR3D3ZQHUf
	RAcmN1+6zhEP61fWiRc2rqatnarr8ORVmNgSV0JHxPEW5mo2ilbsopnz1cM/0Z3VCVAW/M1neVRgV
	OgizqbGh0oHrpr3QR9suUMW+vpLITVguP3QnGdfg07/3gZJQ8DSMtF4nvijeDp9gw/URO/m3ND0pG
	MITpOR+A081CVW4HL600ju2tykPMbr4NJ8BJG30sIxNx7iG3afsh8zfM3CPftneZPqCWmUQ3bx3EC
	j3VhC4RA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUd-00G6K3-0u;
	Wed, 16 Apr 2025 14:43:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:31 +0800
Date: Wed, 16 Apr 2025 14:43:31 +0800
Message-Id: <742cebb5bc08b3010c5e7283372ee920f3df944b.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 21/67] crypto: arm/sha1-asm - Use API partial block handling
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

