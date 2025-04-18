Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AFC268C6C
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945258; cv=none; b=fP/u0xS3AvCZZWOcTMDGm0ULQCYJL8tPRoU77cAVTBMIvlKPMBNUCdayoRTObAFW7QnQw0baVxqwry8WJBsq+FWmB5uTlsr6X9USgp1qPtxsS9EEmEFb2XImpWFzSMg/r9D1s7KjksHWwEDQLkRfIRvJ2TGp1JDiJLaeZlRBT/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945258; c=relaxed/simple;
	bh=s+n0rZWN9OHNb9jSxTXJswwTYy3YvIl9k49PjkssynY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=RbXc/wLF6vB55S6F/EEQgF6EWFvhj10XR0tBiFGmjVGVQmD/KSPl9t5SAB6RnRiOMegV4kbKn7RMe6pSnrCoE4N0y+qEzDYLmmNTPDA1cRYzCv/+gjGybb5GYraBgxdiZ8Sa+VPIg2EBxihBSsTbj6OwqZcrMa6UvR5P8VpLyFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JXVSeSgI; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JXVSeSgI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mKtFmevMOThjVA+5PEADUD4DtOovsjOOmURMwNvdZzk=; b=JXVSeSgITzwg4rdNd8QnHLtMoo
	dmiBhBUIisCrfEZK8bGjBbHzxyKtQn2Ps8DwFK5w0uVt5o1YOT/j3OijDP/S79HBrPyE3MxJfCcy9
	MECyxv1ptru+yaZRxEU5XnZRGat6KdkyofzZ/lwdXyF7s1mKIIICmA4WRAQWBD3SxVuIp31G4vWYc
	EkEvtl3Zyr5zumQrBTb6sreC0o5SaXpo1x/WQalsAg3+CNteBofV2xo/hpV1XHMEx8aL0/TGG8/z/
	LFGWQsb+hpzWyiHapGiGXCK0JL6/x80jYqGpBBkDabjXqV2XdYhDUPC2XIfG2qaBiXJUtRBmIeI1l
	/iROGycg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5byG-00GeHh-2l;
	Fri, 18 Apr 2025 11:00:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:52 +0800
Date: Fri, 18 Apr 2025 11:00:52 +0800
Message-Id: <2910de5908583104db29cf03ed9f6d407f894025.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 58/67] crypto: riscv/sm3 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/riscv/crypto/sm3-riscv64-glue.c | 49 ++++++++++------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/arch/riscv/crypto/sm3-riscv64-glue.c b/arch/riscv/crypto/sm3-riscv64-glue.c
index e1737a970c7c..abdfe4a63a27 100644
--- a/arch/riscv/crypto/sm3-riscv64-glue.c
+++ b/arch/riscv/crypto/sm3-riscv64-glue.c
@@ -13,8 +13,9 @@
 #include <asm/vector.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
+#include <crypto/sm3.h>
 #include <crypto/sm3_base.h>
-#include <linux/linkage.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 
 /*
@@ -24,8 +25,8 @@
 asmlinkage void sm3_transform_zvksh_zvkb(
 	struct sm3_state *state, const u8 *data, int num_blocks);
 
-static int riscv64_sm3_update(struct shash_desc *desc, const u8 *data,
-			      unsigned int len)
+static void sm3_block(struct sm3_state *state, const u8 *data,
+		      int num_blocks)
 {
 	/*
 	 * Ensure struct sm3_state begins directly with the SM3
@@ -35,52 +36,36 @@ static int riscv64_sm3_update(struct shash_desc *desc, const u8 *data,
 
 	if (crypto_simd_usable()) {
 		kernel_vector_begin();
-		sm3_base_do_update(desc, data, len, sm3_transform_zvksh_zvkb);
+		sm3_transform_zvksh_zvkb(state, data, num_blocks);
 		kernel_vector_end();
 	} else {
-		sm3_update(shash_desc_ctx(desc), data, len);
+		sm3_block_generic(state, data, num_blocks);
 	}
-	return 0;
+}
+
+static int riscv64_sm3_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len)
+{
+	return sm3_base_do_update_blocks(desc, data, len, sm3_block);
 }
 
 static int riscv64_sm3_finup(struct shash_desc *desc, const u8 *data,
 			     unsigned int len, u8 *out)
 {
-	struct sm3_state *ctx;
-
-	if (crypto_simd_usable()) {
-		kernel_vector_begin();
-		if (len)
-			sm3_base_do_update(desc, data, len,
-					   sm3_transform_zvksh_zvkb);
-		sm3_base_do_finalize(desc, sm3_transform_zvksh_zvkb);
-		kernel_vector_end();
-
-		return sm3_base_finish(desc, out);
-	}
-
-	ctx = shash_desc_ctx(desc);
-	if (len)
-		sm3_update(ctx, data, len);
-	sm3_final(ctx, out);
-
-	return 0;
-}
-
-static int riscv64_sm3_final(struct shash_desc *desc, u8 *out)
-{
-	return riscv64_sm3_finup(desc, NULL, 0, out);
+	sm3_base_do_finup(desc, data, len, sm3_block);
+	return sm3_base_finish(desc, out);
 }
 
 static struct shash_alg riscv64_sm3_alg = {
 	.init = sm3_base_init,
 	.update = riscv64_sm3_update,
-	.final = riscv64_sm3_final,
 	.finup = riscv64_sm3_finup,
-	.descsize = sizeof(struct sm3_state),
+	.descsize = SM3_STATE_SIZE,
 	.digestsize = SM3_DIGEST_SIZE,
 	.base = {
 		.cra_blocksize = SM3_BLOCK_SIZE,
+		.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY |
+			     CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_priority = 300,
 		.cra_name = "sm3",
 		.cra_driver_name = "sm3-riscv64-zvksh-zvkb",
-- 
2.39.5

