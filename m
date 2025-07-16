Received: from abb.hmeau.com (unknown [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AE921421E;
	Wed, 16 Jul 2025 22:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752706633; cv=none; b=StF2btz63agGy3J1ZCAn5y0MS8yddemY5tc2989K2TizjqJi17/IbU6U8xoKsxt6DC7fdhtodd1usfQ9TS5f06kn2CT2Dhh9xT38GaMGXKkly8BXMFs0jQVvMu3wzIHprqZ3JQAPvylDrDEC5BuA0rjh0JUJEy/NEukRPwkNSt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752706633; c=relaxed/simple;
	bh=bfwtNLp5rri6UcyOSN5k7Puad1C6ABbv6kQt5HDC5/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HigJ2Vvi2d4YjEIlB+dW7Q3BPWrlkvGUuPK0nw+/eq00yOM9WCMa1woABf3D4WMy1artwtnpkChjIDyoPYg6aplm+TXelk1ESFpBfwxZTZetZgnamHE+6Psiz2wadvQ7gMzfrkMz13GuByzLXYDhXNb1YSCxHHyPqiHStIGS9q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dB+kWm+O; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dB+kWm+O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uZhUZJT3jmv5S3FDIUNtwbnHtugp9v+/3Itp8z/2hRA=; b=dB+kWm+OR2FLpOB3RgYbWwD+W4
	0pdtKjURKJQPW4glHCmsoj5mQPVQy0vFaHlTflzitR7tvHOAvj8X6qtBRHamOyclMKP4jEXiKbEGM
	AL7KQM8YhF0mvHUR7ct9Ls+0cu/sB/NQhrTEn8J6rALHrA3ISmlzQVkFJug3SBjBOpxUs56QTcnnB
	nDXeLMPQIx55KQ7xpi7jCM08cOlPpFhdWgn+YVthcWpl0BquyBZqr0S30aFQty9zJb+eEiN3P0P3i
	2TkHWcbM5jI8Jh/jQNWNTfl9MO12D3+d8unAdeVndcVVLwmPPPDFEYMCGVPViLf7a8Sr1FKvENkUZ
	q/xC4yJQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ucAMY-007a3S-0X;
	Thu, 17 Jul 2025 06:28:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 17 Jul 2025 08:28:26 +1000
Date: Thu, 17 Jul 2025 08:28:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"Botcha, Mounika" <Mounika.Botcha@amd.com>,
	"Savitala, Sarat Chand" <sarat.chand.savitala@amd.com>,
	"Dhanawade, Mohan" <mohan.dhanawade@amd.com>,
	"Simek, Michal" <michal.simek@amd.com>,
	Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 3/3] crypto: drbg: Export CTR DRBG DF functions
Message-ID: <aHgnilxOJxEddVr6@gondor.apana.org.au>
References: <20250612052542.2591773-1-h.jain@amd.com>
 <20250612052542.2591773-4-h.jain@amd.com>
 <aGs8N675Fe9svGTD@gondor.apana.org.au>
 <DS0PR12MB9345C8F5A728830DD9ABB1E19754A@DS0PR12MB9345.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR12MB9345C8F5A728830DD9ABB1E19754A@DS0PR12MB9345.namprd12.prod.outlook.com>

On Mon, Jul 14, 2025 at 06:05:29AM +0000, Jain, Harsh (AECG-SSW) wrote:
>
> There is hkdf.c and kdf_sp800108.c module, Both implements different NIST Specifications and DRBG derivative function represents different NIST Specification.
> Moving it to hkdf.c may not be a best fit. How about adding new module for " crypto_drbg_ctr_df ()"?

A new module is fine.

> > You should also keep the drbg changes to a minimum.
> 
> drbg_ctr_df() needs tfm, blocklen, statelen which is currently derived from struct drbg_state.
> If I updated structure drbg_state, It needs code changes in HMAC as well.
> To keep code changes minimum, I added required inputs as function arguments.
> Do you have any other idea in mind?

The existing drbg_ctr_df should become a wrapper around the new
df function and all changes should be localised to it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
