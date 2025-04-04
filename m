Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3516B199E94;
	Fri,  4 Apr 2025 10:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743762206; cv=none; b=CZlHcUG2s0Is6OMUsKVukuGkYaIpv+ogaomTRHKpNowEo+2YnDkrLlr/m/H+eYRbNDDaS7RD/UW35Ql33Vynslj2ilh+7Xj6afLY+jF4ZAGGsehZSAKsgQ4Hmv7DoMJ0w++Z6ziTSxKH2whm3Xby3RsouDaOS2jS4gGoNu4Lup4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743762206; c=relaxed/simple;
	bh=ObDq0f0fnEV2FcPcgfHxsun1r3xampKKYsEcxwPovlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLecYLHnF9VnNb/g2L2lveT2MSJBGRCxZ24SGMtpkq+vQFqSXQn9UrfzJyfMCvNdgKMHntv+nwotP09r5/k5Qt/EDDkUtQiMJm8SM22lJErcxGVBBE8Ccf2KWDQDpK4s+mF4WOZtd9T2ctrq0XKA+6p/Z6/mvgtGvcFyWbg2rLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=eRdCq+RU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="eRdCq+RU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=G96ySguWZDT5PuQlhv00ND/PaMp9dHjJuHlVlO5QZcU=; b=eRdCq+RU394xvdBjAXSci2QWG5
	3mvcE6Ll3fdnpb9IWyGzdH1X5RohtIxG8XB4wO4izgdL2bcu74VAfQ9exHKo+KLS/gh6fg2sT7hQz
	Y7i8rHS9WOOuWsYhRIfacxl5pPv68rJoGXtkZAw/dOm5rdlh86XZ/EYteXrzyTgOM46GMDnXFjhZj
	nJGSHeyMMSScNBqlLwHzyUQojqvHQfRODBEH4SR2sz54sJyE0iltb6S7qQapHsq0zN7x+tsexAunn
	i4+K7Mx9yb2fUTziKKwktni1Z2q7OEJJv7TzE8PcVqu01fmTCTzaePd7rQK3TuHB3pR8EaO3Ie40h
	fVgn8ykg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u0eCi-00Cncz-0V;
	Fri, 04 Apr 2025 18:23:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Apr 2025 18:23:16 +0800
Date: Fri, 4 Apr 2025 18:23:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512
 in DTHE V2 driver
Message-ID: <Z--zFB8Rm007AMzP@gondor.apana.org.au>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
 <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
 <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
 <104cdd15-8763-49fc-9f4b-9b21020bd6a1@ti.com>
 <Z-5IaY0JoTYcx1JW@gondor.apana.org.au>
 <8aa65022-8adc-4c4a-a812-11bfd64e628c@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aa65022-8adc-4c4a-a812-11bfd64e628c@ti.com>

On Fri, Apr 04, 2025 at 03:45:22PM +0530, T Pratham wrote:
>
> Although, I was not able to quite understand what you meant to imply
> from this snippet. And I was not able to find any references for
> HASH_FBREQ_ON_STACK as well. Overall, it was not clear why such a fbreq
> is required and where it is being used. Hence I omitted this part
> completely, and still passing all tests. Would love to know if you have
> any good reason to what you suggested.

The HASH_FBREQ_ON_STACK is part of the revamped ahash interface
that I'm working on right now.  I think you should wait for that
to be merged before reposting your driver as it would make your
job a lot easier.

> Another thing, the buflen variable ranges from 0 to BLOCK_SIZE, not
> (BLOCK_SIZE - 1). This is being used to handle certain quirks of the
> hardware together with linux crypto framework, which I am happy to
> elaborate further if required. Cutting the digression short, I have to
> find a workaround to comply with your import/export changes:

Yes that's a common problem with crypto hash drivers that can't
deal with a zero-length final update.  The best solution is to
use a fallback for the final update if it turns out to be zero-length
rather than retaining an extra block.  Hashing a single block for
finalisation is simply not worth the overhead of setting up DMA and
what not.

The other option is to use the fallback to hash the extra block in
the export function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
