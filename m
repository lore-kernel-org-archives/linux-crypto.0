Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964434;
	b=D1dgzl2srz16IvcbtgNlkxTOahOeTV67CHHhWdhrak5mRSd0vx67459bQHHIAfd29R1a
	 MNFDzmPKfcQRYDR79VkhrOSAp52jbSgfVlseIev1HN6OeE08iSvK5WEM+HlW1BK6MBVeW
	 4FL6SKZbgp8Th+GiDEL8VqSpKFfSb5Ooi3sj23YN/iqrCY1eXgvqR68BGU220RmNeIchb
	 YxnTqOQVugOTVrE2kBOViRi2hbo49fL8zeaJdV4sHq9k73U7mEYJWqApO7zPiYl9TH/q8
	 idvLUuUGpm5s4bc8P2HTnCy9ULonudDDcM/hnxmX7Mj0YejC5HlpX/XCqYIFaO8o2/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964434;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=YgMLLMnWY6CqEsB44iYDdoBhbVPGgbnoyQzO/xsuBdQ=;
	b=T5zUcHMkVbtYStP0YMd5rlVsx2kGKl4PrD1KCDPza+Ztdi4LAQIhbJBvajwPm38pFGGz
	 w19ah9WSNSyYBrj8DeJjH5HEKa8ZfUy38TJ2k1OnqZRHfIJ03J8V3Cb7JMZ4JovSCIjv2
	 Xl+0JvtV4yTzxSwYeuXcOT7KHggkGtLreVEzqn/btuoqZmtL7zZcHVQ6sX1baI/VbsabC
	 DeX4k0uTkW731ldK/dciweWukD1u3K7fFpz4jdet9Huk6gf/xstTlIeCEXFhexCXV17cZ
	 csgdhwL7ECCoHZzKYgRSlDN6xpKADXmm9+JAhv7wlaREmb6KN1Szglc4zQLc3hwHdfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=f3+BZRUH;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5043606A33E;
	Fri,  6 Nov 2026 11:27:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5043606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=f3+BZRUH
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=YgMLLMnWY6CqEsB44iYDdoBhbVPGgbnoyQzO/xsuBdQ=; 
	b=f3+BZRUHdjWzU79WwYEhdCWnw0aNc0t6qnp/FTQGg3KGKYE2eyV2mIv8aiFBE+aK/ap8yBncWp9
	K6vRIwWVJLJo9ODeW3oNLcdx9c1IU9lpLDiCRe9ICPRNG5o9ryKdaMarwE5ViStTFarp/IMgsB25t
	ebTYn5/Ur7K1P7esEV29+fEPP4ksLr4RYHVuto0+IYP/cSslZWIUqtBFYFWhZPIk9uKhQTi+3w+3n
	H6raU6HN9sfNpj3UbqgO+k9laMCXlXb+oygStkK8Hwnl6wlcluKHzRd5COHRKZOL94hP9CcgBz0GZ
	rru9J9GECEyRBKw2mMvXGjR8kGntxpzfk9+A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPI65-0000000Br1c-189A;
	Fri, 06 Nov 2026 19:27:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:27:05 +0800
Date: Fri, 6 Nov 2026 19:27:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	"David S . Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: x509_loader: Use %pe to log error pointer
Message-ID: <au25ifwRKIxVO41v@gondor.apana.org.au>
References: <20261015124500.53228-1-ampr.mhd@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015124500.53228-1-ampr.mhd@gmail.com>

On Thu, Oct 15, 2026 at 04:15:00PM +0330, Muhammad Mahdi Amirpour wrote:
> The error path in x509_load_certificate_list() prints an error pointer
> with %ld and PTR_ERR(), which produces a raw errno value rather than
> the kernel's symbolic error name.
> 
> Use %pe on the error pointer directly so the log reads:
> 
>   Problem loading in-kernel X.509 certificate (EINVAL)
> 
> instead of:
> 
>   Problem loading in-kernel X.509 certificate (-22)
> 
> The new form is easier to read and matches the convention used
> elsewhere in the kernel.  Reported by Coccinelle's
> misc/ptr_err_to_pe.cocci semantic patch.
> 
> Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
> ---
>  crypto/asymmetric_keys/x509_loader.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
