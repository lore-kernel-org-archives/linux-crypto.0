Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998E22874F5;
	Thu, 22 May 2025 11:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747912393; cv=none; b=Qu+Np8Fsrbp27VAeFMkC6RJO2jbx+bWuD/PnxsplRMhRdzO+HQdtJVd/guDkgXiqyYSmcP2sapKkCCYmwCV3Zkh/H+K8TJ+9g98nwcscIsH3t81sTbXyblNwafbfsBfFZQGDFRjiWnUX5r74b/AYBTQJJDflPRVlyEsGftIZRo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747912393; c=relaxed/simple;
	bh=9WNUn200Zhm7LY+Bv/Jeb7Hod+CbFvsfj8rQ52Cnu8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=foqH2oE8DU1R4akbe8pYl0ZazC/wseHpURQ/gfTnyTGwpbt/mU6FEfSa2WQGjXBAlw0N5sVxkd5ipKSODfOGgyodr3d4u1XMIyQ4by7uSl8fjM0c3kFcA59IckmZH2sFJ+7EBowPzSNpJd26RuLdJlkX43mJ/DsEe3TowsDtlBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jeCCMYFx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jeCCMYFx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KH74wmGLc54o0i5rjNjmqUs5fM3qKFnqrHsxffM9KDo=; b=jeCCMYFxLDpYdZD6fyoctsww45
	fPrz5Sv+jhpWhYMGu53J0tUYQq5q4tgPeVWp3aMvZ23A9r3kJ5VZ0cbOCLFcZl56F/kUO5dgkgXDS
	UvL44BHCbziAil+UHZIVGNBniUFFhSnXrm6n3UB2Gx1GTL6tHHwZdTsCSrSYCOPcbwXI2RchYpw1a
	J2Yw5A2d6/qNcr9Ctn9wyKn52M7M/OT1zGrCu+eOFWAM7s3F+BrQ7f2VDJvSCCxp/v+qzItOCMh57
	pyTnN6YfRIT7fDwHUCPWJ3ZTcqcITLmIqwzli6vspCLqprWnTg+Cv1x+k/HjeLpfCXlZcdqyW9t6w
	00PBX16g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uI3rD-0084SL-3B;
	Thu, 22 May 2025 19:13:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 May 2025 19:13:03 +0800
Date: Thu, 22 May 2025 19:13:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Klaus Kudielka <klaus.kudielka@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@bootlin.com>,
	Christoph Hellwig <hch@infradead.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: crypto: marvell/cesa - dma_alloc_coherent broken but kmalloc +
 dma_map_single works
Message-ID: <aC8Gv5HT_bflcEbo@gondor.apana.org.au>
References: <aCcyXkeBvHQYvf2d@Red>
 <aCczV6MF6xk5rRA3@gondor.apana.org.au>
 <aChx_ODF_hYKL8XO@Red>
 <aCmTQoJw6XG1CkuZ@gondor.apana.org.au>
 <aC1fY6IP-8MzVIbx@gondor.apana.org.au>
 <aC2aAvX07Aaho08d@gondor.apana.org.au>
 <aC2uvvzlR89iVFGW@Red>
 <aC2xTI1ZuXoZjgjX@gondor.apana.org.au>
 <aC3cF0-bWb-Jiz4i@Red>
 <aC6TkPM6mOuFwvkD@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC6TkPM6mOuFwvkD@gondor.apana.org.au>

On Thu, May 22, 2025 at 11:01:36AM +0800, Herbert Xu wrote:
>
> I think we've made progress.  All the simple hashes have passed
> and now we're only failing on hmac.  So it looks it was the
> coherent memory being incoherent.

I've analysed the hmac errors and the good news is that they
all appear to be caused by a genuine bug in the driver.  When
the final update is zero-length which the hardware can't handle,
the driver fallback code is broken for hmac.

I'm working on a fix.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
