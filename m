Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72EB1ACEAF
	for <linux-crypto@vger.kernel.org>; Fri, 13 Jun 2025 09:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807321; cv=none; b=myRD8qf9kTj5yw8ruYeUsmPELX1iiRxobD2euXodAsnhwRWKO1G4fQpMr2YoDGO8Q14u/c73e9QpUxROGcFBbQWMaUR4hCdqbK/avACHVC0JHvUsoEgE+V1bJFi6KP38HHSclthmZYd8zj52fvgu0eiMl/kYnkTMX3iWUdZmvd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807321; c=relaxed/simple;
	bh=oNHIlHZDldVJaBMZWS1wSmA6jq5g/WDieFvH3hVyP8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uo8VxZNZ2DCxeqbxdg45IG7fbDKfK6JW1A7ZxPq1+vt6y8tVXFMmbNY85IuAsgSETFVlwQgb7fagxriIfi4rhXTPuu8kRDhFdGRS/Agpjl0MGzFb+CwTRFpvoLdl01HbJf9f/ahex7qbeZ1fVzIf7EAObCmmMVcFMO5vYX9BgZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=juTqBgNU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="juTqBgNU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EgctgdAdqiu5uywiAFml0zFVgi0yC5WGqOpRj7RJc1U=; b=juTqBgNUv9GftLknVC/A0lcZn3
	SRoDHqE5ZRpzOZR6wXUmCKxr+sSJfctGhEfP4sNL/+tbBR+5D+7EAkiLACzN6OHsNBvrUSKYz6mBz
	UZg3mD1/4QlpMDvi6IlPk3m9u7RHPzrcT5Bt7J+sUjdR3sKkGPijA3BNYgoZbrjgp6AN+BmhSkKFD
	6KKmQX/JXr7qpIpavjg42ORJpRKe9lyUTB06pCo/6MV4Wxwp9cA6mZCahufmXF20VkUCWUi2PRs9A
	dqDlFxmHZg1fcIgGxR96gpP4FsMYVTcUbXfmRtDZ9F9PxmdMEkWJZSz+nQhkdtQ+v3ubZGSj63Q1X
	8o8AfuHg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uQ0oa-00CsxN-24;
	Fri, 13 Jun 2025 17:35:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Jun 2025 17:35:12 +0800
Date: Fri, 13 Jun 2025 17:35:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Marcus Meissner <meissner@suse.de>, Jarod Wilson <jarod@redhat.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH] crypto/testmgr.c: desupport SHA-1 for FIPS 140
Message-ID: <aEvw0NdpevOL3UA0@gondor.apana.org.au>
References: <20250521125519.2839581-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250521125519.2839581-1-vegard.nossum@oracle.com>

On Wed, May 21, 2025 at 02:55:19PM +0200, Vegard Nossum wrote:
> The sunset period of SHA-1 is approaching [1] and FIPS 140 certificates
> have a validity of 5 years. Any distros starting FIPS certification for
> their kernels now would therefore most likely end up on the NIST
> Cryptographic Module Validation Program "historical" list before their
> certification expires.
> 
> While SHA-1 is technically still allowed until Dec. 31, 2030, it is
> heavily discouraged by NIST and it makes sense to set .fips_allowed to
> 0 now for any crypto algorithms that reference it in order to avoid any
> costly surprises down the line.
> 
> [1]: https://www.nist.gov/news-events/news/2022/12/nist-retires-sha-1-cryptographic-algorithm
> 
> Acked-by: Stephan Mueller <smueller@chronox.de>
> Cc: Marcus Meissner <meissner@suse.de>
> Cc: Jarod Wilson <jarod@redhat.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: John Haxby <john.haxby@oracle.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  crypto/testmgr.c | 5 -----
>  1 file changed, 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
