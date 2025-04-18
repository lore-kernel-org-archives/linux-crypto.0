Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B99268697
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945241; cv=none; b=AUJJfHt4njgpXH+K0r4quGruXyMRfw1dAcie5e3H5NGMsRWTxaGc0QEnOnyymQ7/sPelu3y9OOtqjRGvuAyGaxH9aNh8XBA3H+gMOkdjGli72A6iJ7x2iXf4gZhVcg+m2IC33LOYh4dvfYfmjm59EAELjEcJ+ZKtArYdyb4SXwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945241; c=relaxed/simple;
	bh=+nm6oBLtK9KTa19ZC357kSbxAdJRorpdW2RTTZl5eFs=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=XPg34LEOeaDSWDN4+mvO7+zcJ4/W7GEXQISR0OGpkIMGZDtYc9wtEmrpsY4bmeisoPWKlMprNZa+30WGexEBMWSqMXjO3TIchDs66acUamDRblkVfFgqtkXlK7FPiKJ8r6dBGKFhAAf8aKoX/ArHyAEkFYNf3NVyniA2QVUqwXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GPYlsPvQ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GPYlsPvQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WY5zy24TEtLq2l8zVmtrG97fmxvINEeXSpCEdWBb/H0=; b=GPYlsPvQn1Eo6PknLteYUuejwh
	eEGUQFFTicXW5VQ9N+GGyZ7yZTjUhiQlQ+ifQc4AnntirbGCN79s/A+NZQJ0cprV+dK71SQqTHRhV
	czqtJ25nyuBapIJVt2y8ayC/FAtLiC4VxCMo13AKEnfJDKqQC4I9zAqgoyc3HML8D4XZ+Fpg+GS/H
	wlYQpJYRlwpaRpy0mLQZfiinxcgoz5D7PQvSFvc/Vni5DaZFjCUTz3Gb7UNOjv8NGx2Z+5yJlktbW
	wUc1nm4dBRRm0ZohbFcUNzSRGfLWv+Kd4NoRT87NTdPtb52Gg1whU3osH9frXk5XgEtHEP6thUt2K
	+Hd/0XPA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5by0-00GeFh-1f;
	Fri, 18 Apr 2025 11:00:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:36 +0800
Date: Fri, 18 Apr 2025 11:00:36 +0800
Message-Id: <46c0d73e58156f8e2e8a8c14b8712039a4c5c7ca.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 51/67] crypto: arm/sha512 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/sha512-glue.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/crypto/sha512-glue.c b/arch/arm64/crypto/sha512-glue.c
index f789deabefc0..ab2e1c13dfad 100644
--- a/arch/arm64/crypto/sha512-glue.c
+++ b/arch/arm64/crypto/sha512-glue.c
@@ -6,10 +6,10 @@
  */
 
 #include <crypto/internal/hash.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <crypto/sha2.h>
 #include <crypto/sha512_base.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 MODULE_DESCRIPTION("SHA-384/SHA-512 secure hash for arm64");
 MODULE_AUTHOR("Andy Polyakov <appro@openssl.org>");
@@ -20,7 +20,6 @@ MODULE_ALIAS_CRYPTO("sha512");
 
 asmlinkage void sha512_block_data_order(u64 *digest, const void *data,
 					unsigned int num_blks);
-EXPORT_SYMBOL(sha512_block_data_order);
 
 static void sha512_arm64_transform(struct sha512_state *sst, u8 const *src,
 				   int blocks)
@@ -31,46 +30,41 @@ static void sha512_arm64_transform(struct sha512_state *sst, u8 const *src,
 static int sha512_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
 {
-	return sha512_base_do_update(desc, data, len, sha512_arm64_transform);
+	return sha512_base_do_update_blocks(desc, data, len,
+					    sha512_arm64_transform);
 }
 
 static int sha512_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
-	if (len)
-		sha512_base_do_update(desc, data, len, sha512_arm64_transform);
-	sha512_base_do_finalize(desc, sha512_arm64_transform);
-
+	sha512_base_do_finup(desc, data, len, sha512_arm64_transform);
 	return sha512_base_finish(desc, out);
 }
 
-static int sha512_final(struct shash_desc *desc, u8 *out)
-{
-	return sha512_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg algs[] = { {
 	.digestsize		= SHA512_DIGEST_SIZE,
 	.init			= sha512_base_init,
 	.update			= sha512_update,
-	.final			= sha512_final,
 	.finup			= sha512_finup,
-	.descsize		= sizeof(struct sha512_state),
+	.descsize		= SHA512_STATE_SIZE,
 	.base.cra_name		= "sha512",
 	.base.cra_driver_name	= "sha512-arm64",
 	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SHA512_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 }, {
 	.digestsize		= SHA384_DIGEST_SIZE,
 	.init			= sha384_base_init,
 	.update			= sha512_update,
-	.final			= sha512_final,
 	.finup			= sha512_finup,
-	.descsize		= sizeof(struct sha512_state),
+	.descsize		= SHA512_STATE_SIZE,
 	.base.cra_name		= "sha384",
 	.base.cra_driver_name	= "sha384-arm64",
 	.base.cra_priority	= 150,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SHA384_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 } };
-- 
2.39.5

