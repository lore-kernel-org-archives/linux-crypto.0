Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E14330651;
	Thu, 26 Mar 2026 08:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774513660; cv=none; b=XXcVokC/nPdmXvtohm9+7sylb+onkXhM5aAryTya3iTw5pF/7GPOaq3/xagNEL9vU1EyKgAuWH73pqyQ7op4V93rVZY2d+1gxFV1f3t49Aji4cT3MOcpnUVTqnFVmSHC5EugMCsYpUxnt40yzb4Q4O/TyMvTH40dCWddGTg1CIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774513660; c=relaxed/simple;
	bh=wTVEv8T+Dn3sJDZL4R+of8cpiiiK7ZWIgBCBhfMXpZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agKQbjfPrr4GN/IKAhKvgXI2mbQ+H7WMcyc5mSnbKIIZGc72Mqb5i6uzfU8opx55s1usV+rdrWUOBhaaMGNZNUo7mFhs78uZNM1lcReiYT+iA5KWcxE9qWPUad9VxuB3o6dqtHO5GkiSFOZi1aFuNke3+He3EOucQAzNg+5aCMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kjuSG+2I; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kjuSG+2I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PWyb1zeeOXETmO3QFKFYUGHiFYZfZaGPiLKzkzKbi5Y=; 
	b=kjuSG+2IF/i0I7T8mjvboIn/wujrKb6wrgZ67tB2YgQ86bUTTqII59iFjj3qSiBQ0LjytyhENy8
	ynbiJeSVu93NnGdEtHRJM6YyyKnipVMVoPYkaXAbzzclnV1MtBfj+qTXHf14uF4Yp5COLBqm8ITk2
	034C0kQiOCRH66RZQLoMc57Q1Om51EP7b5KoYeiCCRK3Nsdp1qXXT7NiRiHqfrGDzQoNeMO/C9/0V
	iZ4Y/TRW6cOoHuDzR9ac1+zuQS88yPrHZOQd7awDr63LAagYk8qGanKO3OaWeeD9OXFLpr9KSe9Pd
	hn0/K2NqqHwLWk9bEPsjsfRB1mg/rtgM18QA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5feO-001F1X-0A;
	Thu, 26 Mar 2026 16:27:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2026 17:27:26 +0900
Date: Thu, 26 Mar 2026 17:27:26 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Paul Louvel <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Need some clarification about CRYPTO_AHASH_ALG_BLOCK_ONLY
Message-ID: <acTt7q5nXMBsDcxv@gondor.apana.org.au>
References: <4f93481a-a0e5-4a9f-8aae-00d3189ccc58@bootlin.com>
 <b53feadd-8246-43cf-a768-740cb73d2553@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b53feadd-8246-43cf-a768-740cb73d2553@bootlin.com>

> On 3/20/26 10:42 AM, Paul Louvel wrote:
> > Hello,
> > 
> > I have stumbled across a flag defined in include/crypto/internal/hash.h
> > : CRYPTO_AHASH_ALG_BLOCK_ONLY.
> > To get more information about what exact behavior this flag do, I read
> > the crypto_ahash_update function.
> > From the looks of it, it seems that the API will call the tfm update if
> > there is enough bytes (and by enough I mean at least a block size), from
> > the internal buffer and the incoming ahash_request.
> > In this case, I find the BLOCK_ONLY naming a bit of a misnomer, since it
> > only guarantee you than req->nbytes will be at least a block size.
> > I initially though that the API would only give a request that are a
> > multiple of the block size.
> > 
> > This flag, among others, are relatively recent.
> > I think adding documentation about these flags would be a great idea.

This flag is meant to be temporary in nature.

Historically, crypto API hash drivers processed partial blocks at the
end directly and the API played no role in it.

This has resulted in complexities in the drivers and associated bugs.

The API is now able to handle partial blocks for the drivers and
the flag is an indication of the driver's preference for it.

For a reference, see the aspeed driver which has been converted
to the new way of handling partial block data.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
