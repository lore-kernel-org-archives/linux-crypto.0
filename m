Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F55B23236A
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021270; cv=none; b=WnEvx61KHv+ajw2SZptfF0oUqjXtHrKYizgqyankrgc8IUGGfL/k8VR6qUQs557GEzkbMbJmB7j6kf4URcb2Y4zpSyYmOGyzX7//3oMJgqz1UcP0aaSaTLHj8/NZLwZwOre05LgYNIGh3exNBwKc8BzLd3uuvkNAESumpU3njtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021270; c=relaxed/simple;
	bh=Hjd8wdtuPmHUkPOyxJmRRSWXARpW415ZtYs3xhhdpQg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=EuAhuwfuk0c/FtG3roXDCcgil9X0NqELdG7Mp6iDZBt4kfL1yrn7R8C3b1tCVX/vablEGwGfhNbLgXNiKL0GJSFS8MiKeNF6wyIeJ/vpRX5qRh4FqPrfXqGFww+a1mEclthLGTdDdKICL6DBmgkO+ma6/sL1AFnBRKffFUUxoWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=IN0Pjpv/; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="IN0Pjpv/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2Kj+KwLDSvYLXE9C2srSfIA02wK6VcmcClWb9zIT178=; b=IN0Pjpv/C9S/AJ1/jy34wvpuHu
	QtVbNcgBJQqUf/pdcL0pL6YF4sboxqAY/HpdZ0ZLizkQXSlnCB6S9RmCUH6ghF4RjOFms1iCOXOJu
	aS26mvU5Jiii2rxBN/t+03l0HhjrZZIJniIBpoUqGQQsCGpoN6Q1H6zfswoM3qo18mEm2WRYyFchU
	DN5b31lZhQPhMFGv9sxgwMR2ftF40wgVAhhwz7eeeZOV736HlwqbgmLtcGdgq5xT5dgmOnyCwTFUf
	aImwF1OHXJBrDrxGHDdu5ek0SXiNDySNoYpXG+pGhX/0vkNShV4BjuSylSETk8h4cm8AhVbJIu65r
	BWyUa4yw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jbE-00DTZZ-1Q;
	Mon, 07 Apr 2025 18:21:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:21:04 +0800
Date: Mon, 07 Apr 2025 18:21:04 +0800
Message-Id: <9acaaa1dea3360c1979265b17bcbae8f2159d56c.1744021074.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744021074.git.herbert@gondor.apana.org.au>
References: <cover.1744021074.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/7] crypto: qat - Use cra_reqsize for acomp
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the common reqsize field for acomp algorithms.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/intel/qat/qat_common/qat_comp_algs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
index a6e02405d402..a0a29b97a749 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
@@ -241,13 +241,13 @@ static struct acomp_alg qat_acomp[] = { {
 		.cra_priority = 4001,
 		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,
 		.cra_ctxsize = sizeof(struct qat_compression_ctx),
+		.cra_reqsize = sizeof(struct qat_compression_req),
 		.cra_module = THIS_MODULE,
 	},
 	.init = qat_comp_alg_init_tfm,
 	.exit = qat_comp_alg_exit_tfm,
 	.compress = qat_comp_alg_compress,
 	.decompress = qat_comp_alg_decompress,
-	.reqsize = sizeof(struct qat_compression_req),
 }};
 
 int qat_comp_algs_register(void)
-- 
2.39.5

