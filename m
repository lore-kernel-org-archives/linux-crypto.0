Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7CC242D6A;
	Fri, 21 Nov 2025 05:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763704469; cv=none; b=N230T+7yO1VhTuFG9TQSh8BkWxcHm9/t6gTHQJpBKxljQdjmGkGT8lKZ1AbnHXkSt2fLSG5Y6YkNMAYlieBgzHRGh7Tdb5jXHbCp8TAciN9Z2egkzRHSnkNCQ8sZ0JKcojczZqAlo4vB0nO7PRKFx0uaLWZ4Urp/L56ja9RlzBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763704469; c=relaxed/simple;
	bh=F0ECbPeJ507/VZWqnYbsgJ1xFvStoLMUOi7rDAk1QAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F83WYI2WM5GmEeXa0V8mcWiHeHDm0hgDJFiLGcj6/BZzPDpQvY0ASg/tSbl1X7bmgDvG0D786djbNEZBzmjAecY8yyUggGrR+rF+ZZeTW7QfQjpLTkOYPsIZZpZ1otf4+mcnQjiUclSwRQokQKUrx82EGfaxk7eJc5MVq1biiw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bfCBvd33; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bfCBvd33"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=q2KvzWrlL+bRDSFNzgnTtzTwRl6vwiEvv91AoCCCrvQ=; 
	b=bfCBvd33clCxhkqd3WG9UXPpux6shGU4sZW31dMGwV2qtTaBr+DuagCFMfuQgK+WujYIwPVd5xz
	APN8/9LFBhgpGbcO6QaReeVvpYI/HodYeIZFD7qw1ECA/K5y4zCVmSZ4xLgxdpGCjT8EsazYYBEls
	tC/wmof+P9l3NWHJ7LkAR6FjXZkpLfr20xyHoTPlVqaFzI6RdEC3dni72o347GagUDO/Z3E3T9m8v
	cmsgwdV4BFKsIo7yz8/FlERJ/Q+3PgXEiviorh9vTZHROn+7rv3H0eiJYhQdWZE7FcDg39oKgHCZE
	fxqCSY8P5RU5RDm8zppNjqNXVgZzB3JBS2JA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMK68-004rwz-2z;
	Fri, 21 Nov 2025 13:54:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Nov 2025 13:54:20 +0800
Date: Fri, 21 Nov 2025 13:54:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Manorit Chawdhry <m-chawdhry@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>
Subject: [PATCH] crypto: ahash - Zero positive err value in
 ahash_update_finish
Message-ID: <aR_-jEam8i1qelAT@gondor.apana.org.au>
References: <20251113140634.1559529-1-t-pratham@ti.com>
 <20251113140634.1559529-3-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113140634.1559529-3-t-pratham@ti.com>

On Thu, Nov 13, 2025 at 07:30:13PM +0530, T Pratham wrote:
> 
> Commit 9d7a0ab1c7536 ("crypto: ahash - Handle partial blocks in API")
> introduced partial block handling for ahashes in the crypto API layer itself.
> This enables ahash algorithms to return a positive integer from the update
> function to indicate the number of bytes in the input which are not processed
> and should be buffered for next update/finup/final call to process.

Thanks for the report!

This is a bug in the ahash API code, it should return zero instead
of the positive value.

---8<---
The partial block length returned by a block-only driver should
not be passed up to the caller since ahash itself deals with the
partial block data.

Set err to zero in ahash_update_finish if it was positive.

Reported-by: T Pratham <t-pratham@ti.com>
Fixes: 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in API")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index dfb4f5476428..e3d0736e9afe 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -423,7 +423,11 @@ static int ahash_update_finish(struct ahash_request *req, int err)
 
 	req->nbytes += nonzero - blen;
 
-	blen = err < 0 ? 0 : err + nonzero;
+	blen = 0;
+	if (err >= 0) {
+		blen = err + nonzero;
+		err = 0;
+	}
 	if (ahash_request_isvirt(req))
 		memcpy(buf, req->svirt + req->nbytes - blen, blen);
 	else
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
