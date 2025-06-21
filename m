Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9128A55
	for <linux-crypto@vger.kernel.org>; Sat, 21 Jun 2025 03:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750475193; cv=none; b=gBkWkADwatit9GdRj0xDLMxg1eFGcXqc26xuup+UUpYPZf6QT08qPBfPxjlK0K+Sld0S3WKboGT0yyRWAy6Csd7rhgXysBCuz8V4xhRwnQLpIUrVDyk2MLtpuEi8I5Gv38g1PUi1h3YjCOZLq+dnU4Zxk2+WZGoXWhKOdRmRR9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750475193; c=relaxed/simple;
	bh=Psselha1JxEIkflTHbVH5KbUfreUZa3wDUNB9ru99iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GM0Kz3zPsrLXz1gWUbnaCzr0rpLFc5hx9uDILT5Mav7cF+9IP5oXFrYhndH53VuKugyg3R7huWQoxNm0QbV5Q4SIsz/l5r2LVvW8pPw+wIwBsJAv5gmK4I3gjXg0dRxYucCuDykpHWIiqqsWd4KWjG+cOEHa9fcvavw7ZA0Rr4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=I14NQhsy; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="I14NQhsy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xHwYxuzhQwk57j5oFPYywnM16U1ZIGy3Jsy5wAS21ww=; b=I14NQhsyLL/WrAILA4tWMSB34w
	5PSWUnLiunlvD63XZmKyqpZ7BsqJUlhw52lGCwH/lHUnutHRkqf8SE1x/P3n5tQFr2L3BkPZxRwAd
	tmIq+xomokD9QmiI9rrFIvNDQXADr8HX+6fdh9CYWy6HrG058c/ufsduZ34ptwjbIWt1wpe+oFzDp
	73G0o7W2RX7X5q/CX6ppZEkn+5RsOqhrVKZYVWVIas/w2r50g1cnYlVQaFRJoVyHmKtRycE0T887i
	torr+oH/z7uF3dQ4AHAC23Lbf6CqaubyTxQ5D9e0qXFwlWJ8mRWimuoWx3/c4VOEZDSgaR9NaHppd
	+KjlPQLQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uSoJQ-000iT0-2C;
	Sat, 21 Jun 2025 11:06:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 21 Jun 2025 11:06:24 +0800
Date: Sat, 21 Jun 2025 11:06:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Milan Broz <gmazyland@gmail.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH] crypto: wp512 - Use API partial block handling
Message-ID: <aFYhsDyQUFlJM92c@gondor.apana.org.au>
References: <8be28417-2733-4494-8a09-b4343a3bcf3d@gmail.com>
 <aFT2D0UeO0cQYV1C@gondor.apana.org.au>
 <fea81d0e-5b80-4247-8231-1e099be5bb1c@gmail.com>
 <aFUd1upBNhEM1KfG@gondor.apana.org.au>
 <953e81bc-edbc-456b-8276-536d313ab220@gmail.com>
 <aFVQx1iDdBnaJ9sa@gondor.apana.org.au>
 <6a5313ca-4b57-4688-81c1-692e49c689a7@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a5313ca-4b57-4688-81c1-692e49c689a7@gmail.com>

On Fri, Jun 20, 2025 at 03:22:57PM +0200, Milan Broz wrote:
>
> I guess this will go to the next crypto update pull request.

Yes I will be pushing this for 6.16.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
