Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5090D216E24;
	Sat, 16 Aug 2025 09:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755336906; cv=none; b=Nl+M8NtJGm6BxFJJxmSIggEFqLUhTSXZ0UHSf5TFXTj6bTAt+DhbmGmIGpXYG0oRuO6RH/yvcjlvc9Pn7RNvoiR8foLh+D9lYdMsUiux8RyaaLZN1tVUdbQYkb7HEMrOa/xsvsqRxxkmhxPgM07xYjsSz6gRTzbo1RprF7A4hRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755336906; c=relaxed/simple;
	bh=oS4MMNV5cFzJkx9BPCUG2h1bgKPe6DzbBhakUDx13nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aRPtaa7cuVQP1CmAbiCvTCE106qqcRSw3+P0E4dTB9ki1vATuLyYPH8J5k7m6rP5oX2aOYH2KB1/IbOD4WeUwXaszmjcGNiFxS4XHyrTrWyKzH9tEIImhE1Qy9xkj32Lpq5NwZopyzkuI4IqnWSpjFlbVKt2anb+yiqzu1FSq90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YWgD05nM; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YWgD05nM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CVeQ1TAhbYB1Ry605kKypiNwSur4bCtDvJM68WwPFr8=; b=YWgD05nMAGbJxttgEb059Ya7ww
	x/LUqM2utqnadxCcZnNrDb06Ci6aJmvt6xRn+2OgXjQHJ3vaWKqomUtb4D4mN0ojk3NpSKeCjCLwm
	PjyejJzUIvePtS0OXiZWOHaUmLKQ/y6O5Oeq3YuWvKwsO5Bs/4FNt3jB6hmXG0IyoicwYJAcGMBqF
	05F4b+HZ+ge35Y5E4Fbn180H+GW1YzVJ0eJLNbv3QDjAbsb3ZCSY0UxSHaAtONbbbpoWIlOwuhog9
	1R8p1T0CdYGe1jXU7jfgE++zve6IOQZzKxr5GrN14e2NYpVPmlv0yfT9Iv8zz6evmqiZ0jhSMguIf
	OejewbhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unD40-00EmOr-1l;
	Sat, 16 Aug 2025 17:34:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:34:56 +0800
Date: Sat, 16 Aug 2025 17:34:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Xichao Zhao <zhao.xichao@vivo.com>
Cc: olivia@selenic.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: Use us_to_ktime() where appropriate
Message-ID: <aKBQwOsgTYiUxSgh@gondor.apana.org.au>
References: <20250731121727.136128-1-zhao.xichao@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731121727.136128-1-zhao.xichao@vivo.com>

On Thu, Jul 31, 2025 at 08:17:27PM +0800, Xichao Zhao wrote:
> It is better to replace ns_to_ktime() with us_to_ktime(),
> which can make the code clearer.
> 
> Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
> ---
>  drivers/char/hw_random/timeriomem-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
