Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735F61714D8
	for <linux-crypto@vger.kernel.org>; Sat, 24 Aug 2024 13:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724507296; cv=none; b=ho2e3rUpm8Bnyo7XL4NmucoEH7KfjUn7pGp4BpJjULZnaPCRyhoWUuL5RPyCbUCaP2rAsNkdml0b7mokDaw7zWeED1WMnEGVXW6TdiCEpmJvkHTUcq+AXbvX2fJUS0iWOF2JwcfFpJcoonm/QUC8475EFvajSSC+wSCcDGulokY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724507296; c=relaxed/simple;
	bh=8p08OLilLkMW0bOR6RNHYhe5O7w1DMTbODUzDRwDGls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MfBPyRoTkqJ8imnfSoTZm3mMHMAgHTuk251V/Nn9cbmECKobJFYBhB+Ok60B4u6P1FhOAs4sqDgrwC98WZWE7zSQBHeMFgXad2B23xbnqJ9KM/TjaJ5u4ZlMv9r5hfG+/kBxazImR5Fd2jbnpUrtoggjxkcJA7If1saTzJLtu/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1shqzC-0071z4-2M;
	Sat, 24 Aug 2024 21:48:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Aug 2024 21:48:07 +0800
Date: Sat, 24 Aug 2024 21:48:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan Mueller <smueller@chronox.de>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Jeff Barnes <jeffbarnes@microsoft.com>,
	Vladis Dronov <vdronov@redhat.com>,
	"marcelo.cerri@canonical.com" <marcelo.cerri@canonical.com>,
	Tyler Hicks <Tyler.Hicks@microsoft.com>,
	Shyam Saini <shyamsaini@microsoft.com>
Subject: Re: [PATCH] crypto: JENT - set default OSR to 3
Message-ID: <Zsnkl8l6igz__tew@gondor.apana.org.au>
References: <DM4PR21MB360932816FA7B848D7D8F7B0C7B82@DM4PR21MB3609.namprd21.prod.outlook.com>
 <2143341.7H5Lhh2ooS@tauon.atsec.com>
 <ZrRUzaPVqoDAcRLk@gondor.apana.org.au>
 <2185508.xKdoZgZVDs@tauon.atsec.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2185508.xKdoZgZVDs@tauon.atsec.com>

On Mon, Aug 12, 2024 at 08:25:42AM +0200, Stephan Mueller wrote:
> The user space Jitter RNG library uses the oversampling rate of 3 which
> implies that each time stamp is credited with 1/3 bit of entropy. To
> obtain 256 bits of entropy, 768 time stamps need to be sampled. The
> increase in OSR is applied based on a report where the Jitter RNG is
> used on a system exhibiting a challenging environment to collect
> entropy.
> 
> This OSR default value is now applied to the Linux kernel version of
> the Jitter RNG as well.
> 
> The increase in the OSR from 1 to 3 also implies that the Jitter RNG is
> now slower by default.
> 
> Reported-by: Jeff Barnes <jeffbarnes@microsoft.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.com>
> ---
>  crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
