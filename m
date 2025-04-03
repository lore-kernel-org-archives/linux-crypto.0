Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D7C24BC00;
	Thu,  3 Apr 2025 11:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743678684; cv=none; b=gnpbUrsFzz8QftkoXNrc5p3OoMO1yxpI6CN1cCykpcBHXlwURodLOaO0bHdyZ9K5syBbmglDj96cSI9wv0HQn2A2QMGlWRNbkJlMkHWRlrQSQjaBuPebA+YsqygUysjErhrxPgAHO3QCjZV5f5U8ha8c+rR/vuC1wOcFVFU1j8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743678684; c=relaxed/simple;
	bh=dDl5YLB8fWtodZLXtUrO0jZ7f1/8RsDRp5b/qyAhCPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZpO4JPnbBTLYoOMAzjFOnQWfYw3hYeyfTgFY8eLAr8WKF9btLx1p1ZHmH53sA+kCIPIa5qr2bHqqLC4wLyn1SGh7mM3P9zdtFlMrkPmveQ1uMtIhLkUw8ynk1+udHiB1F6b+Gd8ml6kXWi+ZZTPxZi52OYLgg7N3RCEXL2CROdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fpjm8wpL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fpjm8wpL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NUfddGO7yDhykOwJEI8UwCQ5Z0JTQ3F8HI60e3ORxAQ=; b=fpjm8wpLs/hPWMeHyqVFt7gcIl
	PulxTSpl8DYOseNmo0pWTXlCgEIP+a5Lhw0MF2/RcMJs8IUDMz4BYqUFqBhXTcEXyy5ieTQ/iGKvI
	dOZ8kvwR7ms83meDWx4wqypc7dIiSiid+vwTFrHqjSZJYCvP8kThgrpHcbbjmbEahMdcm0i4zFv9i
	F24GAFutjhHe80Yqq5KkKp7PVtbrTAdp/fDb7fE0+dqHaBmjlA+qwNtJ3FXd+ixQZ5E49OEayAtlU
	e9/i2o4PzNlOpdeU8i1sun/qphOvxuxIjyToTRQog+3ziTbnwMUUvXdjVk5/PO7RlRDWoltkvEKSs
	Wxc9OAlw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0ITU-00CSUK-2S;
	Thu, 03 Apr 2025 19:11:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 03 Apr 2025 19:11:08 +0800
Date: Thu, 3 Apr 2025 19:11:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: inside-secure/eip93 - acquire lock on
 eip93_put_descriptor hash
Message-ID: <Z-5szPllytn7hQ03@gondor.apana.org.au>
References: <20250401115735.11726-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401115735.11726-1-ansuelsmth@gmail.com>

On Tue, Apr 01, 2025 at 01:57:30PM +0200, Christian Marangi wrote:
> In the EIP93 HASH functions, the eip93_put_descriptor is called without
> acquiring lock. This is problematic when multiple thread execute hash
> operations.
> 
> Correctly acquire ring write lock on calling eip93_put_descriptor to
> prevent concurrent access and mess with the ring pointers.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/crypto/inside-secure/eip93/eip93-hash.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
