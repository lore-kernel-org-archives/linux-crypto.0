Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D005258
	for <linux-crypto@vger.kernel.org>; Sun,  4 May 2025 13:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746365603; cv=none; b=cjF4n7Pd2uPeWqK/cArdnJVjjeQViEGuuYyF2cArvbd6WUu8rJiZhRj7MqTtpu5rtYtfMIG/PUjn0FxrNFk1+dMuW3ba9x/SvEBMw8+/V8ne+xote6Gr9iGpivv8Mi5smh8Qg3wL6S3tX/s8K9F+9LsG276QTU4tSXPiC+J6gbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746365603; c=relaxed/simple;
	bh=en3DEi/aKBieL14g79Y8TJelW6XI9U7A+Ws6i0KvwCo=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=VjWUZ5Ebu6MKqPqJTSOck92gilxAcEVfMosSmXjZagfPnsYyb4Qkbe2O60p5zUW7ALEhxeisJ6yGs+f8FwqcgHjzpZrm1MU9BSufnZOdjCQf2eCK+b1NNvgdjPg8SlvZsO/POvOMLqx2A6JwtXONgXIUBKft3llnaJ8fik0uzfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jJH+ji+t; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jJH+ji+t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cMvmYaUaZVtHzLwMxlNMTomOHOLyfsj7PZOjTF9uFEM=; b=jJH+ji+tvbQN0bm32VPMMyE6jV
	5BlgUY0tLMMohj2FnehwjImxO5b1IbFuD6Ol+hS4gVQnfDblNbduAFakl6q29IUj/jFNVoA4Z/ky0
	z2RiBXbL9BSTLkGGCmG9Tu/0jk5P77FXo/8UNJDwxosQehhsQZGgnt4SNcY5azKHcOtx0huqmkEkb
	sBby8lbLMJao92FjLn3vb31V9K5+HSFfx5QrTqdachfdQ3BGLRlH2eFlCVySlDtDcGT7lxMlygPVu
	pIu/cm1CGXdSLfWbBH8khSw0Iam/fjpZWxQ1/44y8BVmygW4BQVZq2b0Rlud9RjDd89gZx81/OrAP
	xI10MThQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBZT2-003EvM-1X;
	Sun, 04 May 2025 21:33:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 04 May 2025 21:33:16 +0800
Date: Sun, 04 May 2025 21:33:16 +0800
Message-Id: <643ea20fc76a882567cc627d682d6c07a563935d.1746365585.git.herbert@gondor.apana.org.au>
In-Reply-To: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
References: <40527d5a34051a880c06fdcead0f566cc0e5a0ce.1746365585.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 2/6] crypto: shash - Mark shash algorithms as REQ_VIRT
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Mark shash algorithms with the REQ_VIRT bit as they can handle
virtual addresses as is.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/shash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/shash.c b/crypto/shash.c
index 44a6df3132ad..dee391d47f51 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -450,6 +450,7 @@ static int shash_prepare_alg(struct shash_alg *alg)
 
 	base->cra_type = &crypto_shash_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SHASH;
+	base->cra_flags |= CRYPTO_ALG_REQ_VIRT;
 
 	/*
 	 * Handle missing optional functions.  For each one we can either
-- 
2.39.5

