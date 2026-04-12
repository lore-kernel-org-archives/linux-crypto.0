Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C9E258CD0;
	Sun, 12 Apr 2026 08:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775983867; cv=none; b=pGHa1JB6qAW+fTj6a8uNNwPDNW/d88XFW+nzLR1nL3juciKL1mF7/lBNt99ml6+9NsFO479xx3Zq5R2HYGOG4BVaxlB64NpwzfHOZDI7Rco8AZOdvBvH4DWQ0a17LG1it0lyWiAKjnxpAD3DnwQE3zAly51x8aGQnHJ1LH8BjKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775983867; c=relaxed/simple;
	bh=b2oMIp8+Lv5bvDbzX+/0cbsdAKUxj8fFl+2WRuazyxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5WpYW/rTNTBJEGr3tDYSctosmt8fPB385parydukfe+Q7EX9+kbCh2dyxwmUun4aMBPZ5MYx/jr9XRuP9qs5c9iPpk1Ib/1/ODg7DHSf82M+HkFZdy57zbBJBfd82JrgxU4T1TLmODDRat/RhLo8fVTSOqN/QnkSSxB6jIE1pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Z9XElzk0; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Z9XElzk0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vjto2NeWLy26meAKGLKW58pKYe1tm6+d2JsB2pBfgdg=; 
	b=Z9XElzk0t75iAXhzLeikyh8NKCaJ+IV4wfF6qPq0JpVjrokBjtfGqQRHSCdouig+hlGpiVM6xNw
	p0k4sX7FT+rlYc3XnKXR7dSFA58I1cBkRQCE9SdrrmCeKbbGdhKXYqSQoTajrkRX5jddlJjeAokX3
	+j2VeG+gkFy14xaphQeLDRzfNWb4/cfA8JAvDj19MjupSkZojyxgaUlKeQPNwtDy0HExjHT/zs5iT
	PL3DVZmd650O7Nivi1WrddfPYpbR9bK/n0qnRSaRhmkMV6G+RHsVhzjqGKJvutVdKkN9A/sCqLtmr
	s97zcfWPBJvL7AUoUedI+XP4wg2nrPsSx4ww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBq7U-005UFi-0y;
	Sun, 12 Apr 2026 16:51:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 16:50:59 +0800
Date: Sun, 12 Apr 2026 16:50:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Haixin Xu <jerryxucs@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, smueller@chronox.de, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, yuantan098@gmail.com, bird@lzu.edu.cn
Subject: Re: [PATCH 1/1] crypto: jitterentropy - replace long-held spinlock
 with mutex
Message-ID: <adtc86185G19rHgJ@gondor.apana.org.au>
References: <cover.1774854094.git.jerryxucs@gmail.com>
 <9a8ef1cbcc68b752a495acf0a23e7095eb0a7796.1774854094.git.jerryxucs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8ef1cbcc68b752a495acf0a23e7095eb0a7796.1774854094.git.jerryxucs@gmail.com>

On Mon, Mar 30, 2026 at 03:23:46PM +0800, Haixin Xu wrote:
> jent_kcapi_random() serializes the shared jitterentropy state, but it
> currently holds a spinlock across the jent_read_entropy() call. That
> path performs expensive jitter collection and SHA3 conditioning, so
> parallel readers can trigger stalls as contending waiters spin for
> the same lock.
> 
> To prevent non-preemptible lock hold, replace rng->jent_lock with a
> mutex so contended readers sleep instead of spinning on a shared lock
> held across expensive entropy generation.
> 
> Fixes: bb5530e40824 ("crypto: jitterentropy - add jitterentropy RNG")
> Reported-by: Yifan Wu <yifanwucs@gmail.com>
> Reported-by: Juefei Pu <tomapufckgml@gmail.com>
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Suggested-by: Xin Liu <bird@lzu.edu.cn>
> Signed-off-by: Haixin Xu <jerryxucs@gmail.com>
> ---
>  crypto/jitterentropy-kcapi.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
