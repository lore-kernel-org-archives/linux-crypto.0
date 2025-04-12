Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4B238385
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 05:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744436225; cv=none; b=PrjseTnnIE1eXs3RqqZJn94uFdU7vxWzHcRFXl5zBu8ghOlYT17V1EPtHMXmy3baIZQNCkJRJRo40lz02Zp41c3hXZawDxNughvYzmyopOU8i2e10U3nvlUQ3UlxfYecyvSLakZGOrF8St+hswE9PACHhjbGb76i3DzyjVGAJCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744436225; c=relaxed/simple;
	bh=WUxOZvadLtgkPIz6Xp2EtMpEfbERQGn8icbPPFy7830=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=u0bxnRz5jNEsfA5dN0Vn1WGkZvLMEqoDWWzH61Wbj6bfqCrve1t9IdemDDCjd5/cPJRhI5HUjkTAaXIrS2ZZYBuz3rEhJWil20ngW/WuOyoHKZp4/cAsFprPDud9gGatKvrn3dLuv2dOqer8cuS0LYQVmSTx6huv5EtkCDRcjig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JbDamAzi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JbDamAzi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tQon+Yp20tZZlVMJBlYpZznZt+FTgcyNGSbHVn2edS0=; b=JbDamAzips5duqRD1X9CTwEFvN
	t+wL3VRwe1Kzd7v6OVtoLJ5ts2dv3voznjhs+ySJnssJGfInjOsUJEfuY4zDa1yQel/TgQ+hGVqzC
	iMA0RnZxLnsoDo2E5BwQlYETNmBHWi6arGb4jzGsVxISuhyZnoSsZskAbSkcnBvMyQAV7PCOiLOVE
	WOOSHLzw1FYYcJKyFdCGeJFlZrjSZseQMgIQ59ezeYSKZ7Vp5A13T7O7A4X5tC+Vjv/48IZn9hvJJ
	M6ZQdSmZoaYTXvBZZ9jqSWvdPs6TbyGA8jJsp1FOhJzbJW1lNBi6fTydhInUReC7PCt1Q0q8+AM5i
	lh/DnK+g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3TXx-00F2sV-1P;
	Sat, 12 Apr 2025 13:36:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 13:36:53 +0800
Date: Sat, 12 Apr 2025 13:36:53 +0800
Message-Id: <4cbb22b06c551e2af97b6ae914ce12678c59b7a2.1744436095.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744436095.git.herbert@gondor.apana.org.au>
References: <cover.1744436095.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 2/5] crypto: deflate - Remove request chaining
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Remove request chaining support from deflate.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/deflate.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index bc76c343a0cf..57d7af4dfdfb 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -111,7 +111,6 @@ static int deflate_compress(struct acomp_req *req)
 {
 	struct crypto_acomp_stream *s;
 	struct deflate_stream *ds;
-	struct acomp_req *r2;
 	int err;
 
 	s = crypto_acomp_lock_stream_bh(&deflate_streams);
@@ -126,12 +125,6 @@ static int deflate_compress(struct acomp_req *req)
 	}
 
 	err = deflate_compress_one(req, ds);
-	req->base.err = err;
-
-	list_for_each_entry(r2, &req->base.list, base.list) {
-		zlib_deflateReset(&ds->stream);
-		r2->base.err = deflate_compress_one(r2, ds);
-	}
 
 out:
 	crypto_acomp_unlock_stream_bh(s);
@@ -199,7 +192,6 @@ static int deflate_decompress(struct acomp_req *req)
 {
 	struct crypto_acomp_stream *s;
 	struct deflate_stream *ds;
-	struct acomp_req *r2;
 	int err;
 
 	s = crypto_acomp_lock_stream_bh(&deflate_streams);
@@ -212,12 +204,6 @@ static int deflate_decompress(struct acomp_req *req)
 	}
 
 	err = deflate_decompress_one(req, ds);
-	req->base.err = err;
-
-	list_for_each_entry(r2, &req->base.list, base.list) {
-		zlib_inflateReset(&ds->stream);
-		r2->base.err = deflate_decompress_one(r2, ds);
-	}
 
 out:
 	crypto_acomp_unlock_stream_bh(s);
-- 
2.39.5

