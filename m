Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49FA2FF155
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 06:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774591471; cv=none; b=T86dycAdY4ydxVMZg8lueYMV5DeRpRts4zkZNrdZso4GvGcxZriBlhze6l+5UxZBqgwIiJGdk5mXGxMG+sLK83fXIvm/bndaBGWcyYdhtOeaR+B8SnnAukpmgytykWTNvY5sz3lNq5TZeLyUKZ+lhpKLR14paUpVSmukRrWwI5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774591471; c=relaxed/simple;
	bh=FoDw6VZynM90c0u76LrPiKidkWDGZfNUqbU18ZFsCu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNK8CSrmmNY8kfsoNLL9GQ+BsOcMHtPATQq6BH+wXhFAEHbDPmT7khhbzP1pQjvRWv4z55R/Z2oq03BfT9gdRmQt+7KzBBUrIVOSk+fJJUaB9XPYVv+nr018k6IhkJspxpw3Aqd9/waK7UG/snair8IwsU6kqq9/j1/IFbkwApw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=aYzqo4uE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="aYzqo4uE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=taS8vPaZDnhLAK4el+1/DQ5nLp6f6BWMnsF0JffABlE=; 
	b=aYzqo4uEm21QWNrg+Q4uhFT8NWCJ+o5j/mtr+zd0R5hF/kQGD8JSJ5M1386jr9zls9y1jPziMjh
	DGe9eZb6v9ulDQgwDJdqAPc14psXvU5mE+0x+8VXRM3nM1CNETSxisFeg19Cviae6Fct2niUKFPSY
	oZgGRAFeidallzwNj0xE+qIagvn6t7qFxMZo1I/OCxYoaMmmQBre+usPrZ763JSI42b/k0dQQmiRY
	2JPH2oSikLM3WhsnrYbH9PY6RJS+XL0PAIKNWfsb4NDIu4YN/LfqM6NtIQ6h4WWowKw7VJc02Otlu
	AqTcujjSuhmksNqZhJ7l3mIHS8/dqtjxR+9g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5ztO-001Y4B-0r;
	Fri, 27 Mar 2026 14:04:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 15:04:17 +0900
Date: Fri, 27 Mar 2026 15:04:17 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Taeyang Lee <0wn@theori.io>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
	Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>,
	Jungwon Lim <setuid0@theori.io>
Subject: [v2 PATCH] crypto: authencesn - Do not place hiseq at end of dst for
 out-of-place decryption
Message-ID: <acYd4c4CBbtvl7Mi@gondor.apana.org.au>
References: <acOpDrnN3cVfiASk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acOpDrnN3cVfiASk@gondor.apana.org.au>

On Wed, Mar 25, 2026 at 06:21:18PM +0900, Herbert Xu wrote:
> When decrypting data that is not in-place (src != dst), there is
> no need to save the high-order sequence bits in dst as it could
> simply be re-copied from the source.

This doesn't actually work because the high sequence number are
missing in the out-of-place case.  Here is an updated version to
handle that properly.  I will revise the follow-up patch to get
rid of scatterwalk_map_and_copy.

---8<---
When decrypting data that is not in-place (src != dst), there is
no need to save the high-order sequence bits in dst as it could
simply be re-copied from the source.

However, the data to be hashed need to be rearranged accordingly.

Reported-by: Taeyang Lee <0wn@theori.io>
Fixes: 104880a6b470 ("crypto: authencesn - Convert to new AEAD interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 542a978663b9..c0a01d738d9b 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -207,6 +207,7 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	u8 *ohash = areq_ctx->tail;
 	unsigned int cryptlen = req->cryptlen - authsize;
 	unsigned int assoclen = req->assoclen;
+	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
 	u32 tmp[2];
@@ -214,23 +215,27 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	if (!authsize)
 		goto decrypt;
 
-	/* Move high-order bits of sequence number back. */
-	scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
-	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
-	scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
+	if (src == dst) {
+		/* Move high-order bits of sequence number back. */
+		scatterwalk_map_and_copy(tmp, dst, 4, 4, 0);
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 0);
+		scatterwalk_map_and_copy(tmp, dst, 0, 8, 1);
+	} else
+		memcpy_sglist(dst, src, assoclen);
 
 	if (crypto_memneq(ihash, ohash, authsize))
 		return -EBADMSG;
 
 decrypt:
 
-	sg_init_table(areq_ctx->dst, 2);
+	if (src != dst)
+		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
 	dst = scatterwalk_ffwd(areq_ctx->dst, dst, assoclen);
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, flags,
 				      req->base.complete, req->base.data);
-	skcipher_request_set_crypt(skreq, dst, dst, cryptlen, req->iv);
+	skcipher_request_set_crypt(skreq, src, dst, cryptlen, req->iv);
 
 	return crypto_skcipher_decrypt(skreq);
 }
@@ -255,6 +260,7 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	unsigned int assoclen = req->assoclen;
 	unsigned int cryptlen = req->cryptlen;
 	u8 *ihash = ohash + crypto_ahash_digestsize(auth);
+	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
 	u32 tmp[2];
 	int err;
@@ -262,24 +268,28 @@ static int crypto_authenc_esn_decrypt(struct aead_request *req)
 	if (assoclen < 8)
 		return -EINVAL;
 
-	cryptlen -= authsize;
-
-	if (req->src != dst)
-		memcpy_sglist(dst, req->src, assoclen + cryptlen);
-
-	scatterwalk_map_and_copy(ihash, req->src, assoclen + cryptlen,
-				 authsize, 0);
-
 	if (!authsize)
 		goto tail;
 
-	/* Move high-order bits of sequence number to the end. */
-	scatterwalk_map_and_copy(tmp, dst, 0, 8, 0);
-	scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
-	scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
+	cryptlen -= authsize;
+	scatterwalk_map_and_copy(ihash, req->src, assoclen + cryptlen,
+				 authsize, 0);
 
-	sg_init_table(areq_ctx->dst, 2);
-	dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
+	/* Move high-order bits of sequence number to the end. */
+	scatterwalk_map_and_copy(tmp, src, 0, 8, 0);
+	if (src == dst) {
+		scatterwalk_map_and_copy(tmp, dst, 4, 4, 1);
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen, 4, 1);
+		dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
+	} else {
+		scatterwalk_map_and_copy(tmp, dst, 0, 4, 1);
+		scatterwalk_map_and_copy(tmp + 1, dst, assoclen + cryptlen - 4, 4, 1);
+
+		src = scatterwalk_ffwd(areq_ctx->src, src, 8);
+		dst = scatterwalk_ffwd(areq_ctx->dst, dst, 4);
+		memcpy_sglist(dst, src, assoclen + cryptlen - 8);
+		dst = req->dst;
+	}
 
 	ahash_request_set_tfm(ahreq, auth);
 	ahash_request_set_crypt(ahreq, dst, ohash, assoclen + cryptlen);

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
