Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF58418B46C
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744454869; cv=none; b=d0pWuXGm2hXImQJ+uqi7CePnLzRIk5A+Jv1PHkvylJtSugSQGxj7S4uRl9EuxEjPU3wLBjeMm7YKY/CeJzArTq+bsDFGu4wK7PKrD4aeEeA3HRsUZaeF9/nIuDP1rPQjPFnMiuWbuI5dWcQQfVEtsedNQFl9yOsKr4S0ofcjZhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744454869; c=relaxed/simple;
	bh=Oic9AtyKm+fTVJK97SHmF2CeA+KmZDgJaEp5wSGK+DQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=p3KFnJS3/eVlLAA9He8LBO2eZ2wKxuBieNX0HBTzOTmTUDlxXQbA94aSn21u5C6F/1jUkEtfVY8vFezrI1BAWImMU7g93v04U9FikqON/FwJvyopiG/vpgoBSbXQ1K97mjhvaVAoOZsHfOwI/pt+0AdkkRKkJ87zmuGsJH6ztF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YtTHupO3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YtTHupO3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XIMEU82CXaTecQBLG692Eyt/sj/Ly3LM2J+J08JBDZk=; b=YtTHupO3v6dHQvjKngvxY5SSha
	gkuBdG+f5kkdqkjTex5G3IqCpiCx7hRU2RzxRMmDCpM42R8OsjvxAOog4cbexnys4967eJPN0j/rh
	Z3/peSZYUVn0OQZACp84j5ULETYfEsdwtBValDzjrLrBhrDK+ya3oh85yByaYST21q82d/vhSYoJ+
	q+apvTCcE77WkfePecMxK8Uk93kK8hTxZ5fcHZCvaJ/2eTqQ6URBRImc3gA03fP2uZUjUbXnae3Jl
	jvoTcb7Z9tbIxBCfqxr+jsdSYteplD3NN5NuzPts0jbGauUW4+jAjgihcm73/BbPICWSP82hlCDOy
	3e+W86Xg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YOk-00F5Dx-2O;
	Sat, 12 Apr 2025 18:47:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:47:42 +0800
Date: Sat, 12 Apr 2025 18:47:42 +0800
Message-Id: <9df87c9d53d8bbed751d28c2091dd0fb1705717f.1744454589.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744454589.git.herbert@gondor.apana.org.au>
References: <cover.1744454589.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/4] crypto: zynqmp-sha - Make descsize an algorithm attribute
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Rather than setting descsize in init_tfm, set it statically and
double-check it in init_tfm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 580649f9bff8..f66e0a4c1169 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -60,8 +60,14 @@ static int zynqmp_sha_init_tfm(struct crypto_shash *hash)
 	if (IS_ERR(fallback_tfm))
 		return PTR_ERR(fallback_tfm);
 
+	if (crypto_shash_descsize(hash) <
+	    sizeof(struct zynqmp_sha_desc_ctx) +
+	    crypto_shash_descsize(tfm_ctx->fbk_tfm)) {
+		crypto_free_shash(fallback_tfm);
+		return -EINVAL;
+	}
+
 	tfm_ctx->fbk_tfm = fallback_tfm;
-	hash->descsize += crypto_shash_descsize(tfm_ctx->fbk_tfm);
 
 	return 0;
 }
@@ -170,7 +176,8 @@ static struct zynqmp_sha_drv_ctx sha3_drv_ctx = {
 		.import = zynqmp_sha_import,
 		.init_tfm = zynqmp_sha_init_tfm,
 		.exit_tfm = zynqmp_sha_exit_tfm,
-		.descsize = sizeof(struct zynqmp_sha_desc_ctx),
+		.descsize = sizeof(struct zynqmp_sha_desc_ctx) +
+			    sizeof(struct sha3_state),
 		.statesize = sizeof(struct sha3_state),
 		.digestsize = SHA3_384_DIGEST_SIZE,
 		.base = {
-- 
2.39.5

