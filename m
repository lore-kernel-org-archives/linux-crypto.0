Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9864230264
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744020183; cv=none; b=KDIX2Sw9sjrxtMBcCEweiMK1U2NTFlHxRCtKYo+tOp5FjL3C1cHKOIPZTAdWY4tr1Fpd0it+Udohit9mVs8jpftCnQkznWcYOn7XpHSTmN9myVn/t25qhdI6vO9Z9vGPQ673ZyC1MF8Ego0fc+f1Kv5UO7KNoE2Yc1GKA0A+sDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744020183; c=relaxed/simple;
	bh=5KukUFNVNN17WlnXRH82/A9WZg1uSDsooNWatTsiuyg=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=OdLda0qG6LsUBPh8jEuq/NQOOFQoxnDhwNot+Pt3vQKCTO6aXw6bCK31CqBeO6Jv+llR95mU/WkcmH5a8piFLEMad+e6YMYuwKsDgfXVX3/qw0vMP29BIcSHGzAY4WSxakzpL49YsDan25Tg2rPnna/kT/Y0AkzgNUtaYhRedpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XG6jzAZ1; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XG6jzAZ1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=N/kV/3akXRd58FogHn86jKF/OX5hcoPGbXayJwTkJqI=; b=XG6jzAZ1FnKDPjeKXr+71wxvcV
	uPaOB/awuKivEwilwSo8Ln/vKITvuq+xMfCUo5AL+VrnvCUyKi+hWtaV6Hk+A4hJpl+bGGuAn/N1i
	W1ssWpT2d6+EuRrN+JcKFbPFgXYttlS5eGwps8R0kRIlKj1BsxrMMGLkdg2Q3YE4fGY4BES8Vo2PA
	qqoH/Oyn536KRwoCk8Fe5k6VKFjon4KE5YTyNquGI0MkJk4x+Pi8M4Bmmw/P3tIKWyEFQ7Ose+Ydg
	PzZrI0UYCZp1rJv5K6dKQBv/G3jFcEw1bk/N6COFY5LnjWMd9kzwz2AAGoajskoPROo7SJxkIXiag
	zFqOKCew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jJi-00DTHo-0M;
	Mon, 07 Apr 2025 18:02:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:02:58 +0800
Date: Mon, 07 Apr 2025 18:02:58 +0800
Message-Id: <5e73c54a230c711c581238979936dc72543c7f02.1744019630.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744019630.git.herbert@gondor.apana.org.au>
References: <cover.1744019630.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/7] crypto: iaa - Switch to ACOMP_FBREQ_ON_STACK
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Rather than copying the request by hand, use the ACOMP_FBREQ_ON_STACK
helper to do it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index aa63df16f20b..b4f15e738cee 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -999,12 +999,9 @@ static inline int check_completion(struct device *dev,
 
 static int deflate_generic_decompress(struct acomp_req *req)
 {
-	ACOMP_REQUEST_ON_STACK(fbreq, crypto_acomp_reqtfm(req));
+	ACOMP_FBREQ_ON_STACK(fbreq, req);
 	int ret;
 
-	acomp_request_set_callback(fbreq, 0, NULL, NULL);
-	acomp_request_set_params(fbreq, req->src, req->dst, req->slen,
-				 req->dlen);
 	ret = crypto_acomp_decompress(fbreq);
 	req->dlen = fbreq->dlen;
 
-- 
2.39.5

