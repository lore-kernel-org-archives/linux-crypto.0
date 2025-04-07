Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E1E233141
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021272; cv=none; b=HJyZKnr2g0mdyyIM8XjH+PzvbAUNAwJzqytNRpfGIcWFdHFQKMNbIbiWctooJaIay+Q+i7hc0iMWt4K8sHewpldoRvLVoyC8icWIOUbMZyzoLI71kEX/fPwC/5d9YdEHsCqyPro85jZfZrcnpBaVBxbd8RrVbfQN4lDsIQ0+A7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021272; c=relaxed/simple;
	bh=Qxr9t/ICN9WFczx0KLfgydphczWMFQ1hcThzBIKtcqo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=jDFQgK6O/xMUyzcYUdvxsN7efxFjqE/Qa1x8m4y6704bvGt077UxGK0X6hAVJShxpWtxcr4LiUWcdlbyaKEdDPMnVXAgDwEF+4a0LMmGm+KnI6QzAg8ur7xYao/b+eMGcILZ58F+NnYhMm13UMrHLS0w4ioP5/2ybfCEPVLZRrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jM9PGznY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jM9PGznY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pEO9ynBKKvBxMkt8uccvxJ5XPvb20evCHLt+lfxDM+4=; b=jM9PGznYCu8ai5av8Pc1452fER
	4xbLaJc7/rIrdMQm8MU0MK2g+uJNkUS7JXgZtACp0SnnszrQhgV9B/tRNzrmBXxlBhQLhmrjts0BX
	z1UxTrH9WbRyHAkRp7EqKnoYdk5PVzozwPfo9fVruvpDJkHn5cN+H5Xc1SppF3W4QktusDaiDJq5d
	h8RiTCcqc47U1SI5sKuZw1y3loLKylNRLCXuKNTlWGcKM/AWjgLyf0fiHi3PdRs0IwyvXXfLiOic2
	cDUamv7rZ/ZVUmTlj5s4o4NVGzf+AthVyN5stkH+oInPjDJvO3xmdSKgEetiEsMr5HzQb0Mmmx8ef
	WW9/324w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jbG-00DTZk-2R;
	Mon, 07 Apr 2025 18:21:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:21:06 +0800
Date: Mon, 07 Apr 2025 18:21:06 +0800
Message-Id: <2dbf80a5cca0dde5144d380148b6152dd82fd0fe.1744021074.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744021074.git.herbert@gondor.apana.org.au>
References: <cover.1744021074.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/7] crypto: iaa - Use cra_reqsize for acomp
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the common reqsize field for acomp algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index b4f15e738cee..be3b899c6977 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1685,12 +1685,12 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
 	.compress		= iaa_comp_acompress,
 	.decompress		= iaa_comp_adecompress,
-	.reqsize		= sizeof(u32),
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
 		.cra_flags		= CRYPTO_ALG_ASYNC,
 		.cra_ctxsize		= sizeof(struct iaa_compression_ctx),
+		.cra_reqsize		= sizeof(u32),
 		.cra_module		= THIS_MODULE,
 		.cra_priority		= IAA_ALG_PRIORITY,
 	}
-- 
2.39.5

