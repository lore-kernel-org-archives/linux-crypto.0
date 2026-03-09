Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A850258EFF
	for <linux-crypto@vger.kernel.org>; Mon,  9 Mar 2026 09:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773047672; cv=none; b=mDd26YiVYZKEhjCeKvStYcQqxn02rsUjdBk4ucWIAjlsqIavspYVLRp/MZeoc4rr8T9il8rWm28RhFdakaZwdwz95r779ClBUsgQvnyO2PHhAFTJ4BS84x36iHq3opbhz6OnNjzv9ZA2O3Qvu7nBpZx28yJxklojAB74HUMDHGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773047672; c=relaxed/simple;
	bh=R7P12giqx+U/gfuTcAglxHb1DpggorWv0epkaojrzi4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Osqi+M9/oCHp2PwLpTgfOGxYTuupNVKCj+EleEFOBG04pMHtuWJW7oAZQfg2qkxHoDArT65di9tbFE8WWqPk9CmCkWDekb+5fSLQ8Y3k0Z6kjc5QbH3jS1XvmdTDfRjWshaENlrbFmuypgoTslfbJgcc5u1bBt6Mk7NXgbOwH6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Ms6XTPky; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Ms6XTPky"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	Cc:To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=ozmK29io6AOONATMljQSj1PGII/jB4BUzp8asV30Smg=; b=Ms6XT
	PkygTkY9Xe843KuZtSB9CB/Ol5J6iM0taEm/L/xuZp4uxxTgYcucQ3ecjizEw8pDYVBbefiaH7m4q
	YZ/WPssciMsv1pSbjv3BlzR20xa5Nfkmaoxry0BncyjCMAfZW0r8eLE05OkpLCLKKYJjVgPgIuX93
	qrHL3QALs8qQssHZDNIXWrXUDXmTgdm8+e2LYITg7ZVJlKIvaK2snDktGn2jvwN7I2zSdgECLbrL4
	Wu5enPx+dv0fP9uVFmNkDd5g+QI97oDGlHISMCnprOdJknxs+ca6Ll00VbyMppVWH3AFW2IzrLm0E
	o3A7P+njiDHW7tRw/bFwaysJgIelA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vzWgs-00CkII-0D;
	Mon, 09 Mar 2026 17:14:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 09 Mar 2026 18:14:18 +0900
Date: Mon, 9 Mar 2026 18:14:18 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>
Cc: Paul Bunyan <pbunyan@redhat.com>
Subject: [PATCH] crypto: caam - Fix DMA corruption on long hmac keys
Message-ID: <aa6PaoYiz_BY1eZI@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When a key longer than block size is supplied, it is copied and then
hashed into the real key.  The memory allocated for the copy needs to
be rounded to DMA cache alignment, as otherwise the hashed key may
corrupt neighbouring memory.

The rounding was performed, but never actually used for the allocation.
Fix this by using the rounded value when calling kmemdup.

Fixes: 199354d7fb6e ("crypto: caam - Remove GFP_DMA and add DMA alignment padding")
Reported-by: Paul Bunyan <pbunyan@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index e0a23c55c10e..aded03c8601c 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -441,7 +441,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 		if (aligned_len < keylen)
 			return -EOVERFLOW;
 
-		hashed_key = kmemdup(key, keylen, GFP_KERNEL);
+		hashed_key = kmemdup(key, aligned_len, GFP_KERNEL);
 		if (!hashed_key)
 			return -ENOMEM;
 		ret = hash_digest_key(ctx, &keylen, hashed_key, digestsize);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
