Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4C030C632
	for <linux-crypto@vger.kernel.org>; Thu, 26 Mar 2026 06:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774507578; cv=none; b=g0Mw2hgv1LUTr+Hx1jdOQeWpiRNY84O5E4omlhd7VGHvx5pWDowqBKzhwnoYjhf1VhUVlKwGZcO+oVOL86zX7RMkKnnn4AKBp3pJ0mmStxqya+b4ySW4uG/NobkjHm8uSVElvn2iVZA93byTsXTRrWH8yfz8a8UTAkHdVTQsT18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774507578; c=relaxed/simple;
	bh=AYO4dat2f2ipiPd09eACXVqr7HDEIA3bzjOpHtK2fok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8XTKuxUL8LCJjhiA+B/5RyzkAbtfFEJfqi2HYNcfGiY8UUzCDMZIGUFQTBMmgQJN2WB73bGYfCyB/rc7EIDWRy07vAb7UiwI+gJqWBE6wN0RpkwHlaTyvFFhAGo1oewMAKiynVXJVAqnhNYnIHzL2wnTYlko8Lsvt8XTw//i3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=TLLaqHoS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="TLLaqHoS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xhMy9m6jINVftH0BykMwE8TYkwhYKMqyHFBFu/BT75Q=; 
	b=TLLaqHoSzQ6jh4f2agFOBSZB7YCN3IpwykHMfFpEBZojCyWZHNYhqaTDVmSqDATBf4kt5oJ3U3f
	CM05bF8g+HS/RG1jf9E1NbWg8UmopmXjFjD4Hbe39DA/EyS88C7z9lJgn4aBDsYjTZZOmNTQJVEfp
	GqizvUejy2XNKlPoojUT3JIjiqRjvRa78/qcWUlxYU/hiMQFfNcbt5Jqc1HA6URaWko9xjvVC/zzv
	XJ76VX3F7uTD+/yX4+PkvAjc7MRe8T50Xfcu+aNfEB9YB/LrL7riKYya0gkytXeudotZ9gjRJic6I
	QedDybQEMaopuQFycn3dJMVSfngO0aPfpFJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5e4P-001DTi-1r;
	Thu, 26 Mar 2026 14:46:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2026 15:46:12 +0900
Date: Thu, 26 Mar 2026 15:46:12 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, Taeyang Lee <0wn@theori.io>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
	Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>,
	Jungwon Lim <setuid0@theori.io>
Subject: [PATCH] crypto: authencesn - Use memcpy_from/to_sglist
Message-ID: <acTWNAs0eBc9F-d0@gondor.apana.org.au>
References: <acOpDrnN3cVfiASk@gondor.apana.org.au>
 <CAHk-=wiEzzo=LQ4TasUqFDkSYYAXa3VT6PvLx+AS8asOEA6hng@mail.gmail.com>
 <acSzWm2bzRXTkhVH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acSzWm2bzRXTkhVH@gondor.apana.org.au>

Convert scatterwalk_map_and_copy to memcpy_to/from_sglist as they
are more readable and less error-prone.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index fae8c1dbf495..1cb7133bfb14 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -94,11 +94,11 @@ static int crypto_authenc_esn_genicv_tail(struct aead_request *req,
 	u32 tmp[2];
 
 	/* Move high-order bits of sequence number back. */
-	scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
-	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
-	scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
+	memcpy_from_sglist(tmp, dst, 4, 4);
+	memcpy_from_sglist(tmp + 1, dst, assoclen + cryptlen, 4);
+	memcpy_to_sglist(dst, 0, tmp, 8);
 
-	scatterwalk_map_and_copy(hash, dst, assoclen + cryptlen, authsize, 1);
+	memcpy_to_sglist(dst, assoclen + cryptlen, hash, authsize);
 	return 0;
 }
 
@@ -129,9 +129,9 @@ static int crypto_authenc_esn_genicv(struct aead_request *req,
 		return 0;
 
 	/* Move high-order bits of sequence number to the end. */
-	scatterwalk_map_and_copy(tmp, dst, 0, 8, 0);
-	scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
-	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
+	memcpy_from_sglist(tmp, dst, 0, 8);
+	memcpy_to_sglist(dst, 4, tmp, 4);
+	memcpy_to_sglist(dst, assoclen + cryptlen, tmp + 1, 4);
 
 	sg_init_table(areq_ctx->dst, 2);
 	dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
@@ -216,9 +216,9 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 
 	/* Move high-order bits of sequence number back. */
 	if (req->src == dst) {
-		scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
-		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
-		scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
+		memcpy_from_sglist(tmp, dst, 4, 4);
+		memcpy_from_sglist(tmp + 1, dst, assoclen + cryptlen, 4);
+		memcpy_to_sglist(dst, 0, tmp, 8);
 	} else
 		memcpy_sglist(dst, req->src, 8);
 
@@ -270,17 +270,16 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	if (req->src != dst)
 		memcpy_sglist(dst, req->src, assoclen + cryptlen);
 
-	scatterwalk_map_and_copy(ihash, req->src, assoclen + cryptlen,
-				 authsize, 0);
+	memcpy_from_sglist(ihash, req->src, assoclen + cryptlen, authsize);
 
 	if (!authsize)
 		goto tail;
 
-	scatterwalk_map_and_copy(tmp, dst, 0, 8, 0);
-	scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
+	memcpy_from_sglist(tmp, dst, 0, 8);
+	memcpy_to_sglist(dst, 4, tmp, 4);
 	if (req->src == dst) {
 		/* Move high-order bits of sequence number to the end. */
-		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
+		memcpy_to_sglist(dst, assoclen + cryptlen, tmp + 1, 4);
 	}
 
 	sg_init_table(areq_ctx->dst, 2);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
