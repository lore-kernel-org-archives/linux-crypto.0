Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0B517BA0;
	Sat, 14 Dec 2024 09:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734168565; cv=none; b=HKWRCxi1sZRInmKmCa+MB/ZayrVHfVWAdft9NPgrbwh9LLXFM+BeolctHYvuvg29v5xUli2fSEr3pY6WbpPSAFYtL2mnEWP4Sze49sO3Ia7KCsof+9UuYOQJHVqlQDmICG+QpzgdrY2KiQUinSzgWDJCyLfClcdMLUHTf3PZZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734168565; c=relaxed/simple;
	bh=pJJFw73Ty/uYmaje8F31mJHj+QiTD+9ZKhFX156F7u8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4qJqe4keGKMlYw1Fd+887OEeUmiahux6UmMs14g2a+2lHhSYXrQL4qnjr9zwHTWSJPt0qtuuyvxXBDr9lEQXRcPb4yDj/FVNOCGl0rXTiXjf4U05TXhYWX6uQ0XNw/hARqmWVw8wVIuYYWhviq8aykxvhI/u7QqQ1f2Gu5Pt4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=EwyCLv61; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="EwyCLv61"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NBsDreyWHMPzFjMAFMlgAuYzpHlG/OUvmaxFBEDFJHA=; b=EwyCLv614SX/15B6pvwoIfFnwX
	iTrIUwgY98MOj/EB3X4Jeyy3x2j8MoZtGo4Ow/A7WmIXxeyk7UmNe20t5DMKCGZs+JpX53YMXq7wL
	H/ZBztuueKmrMxbCQcwVnuppnBcdj7LaKfdr3Joh1MfIeKhzCLkan5vqhoRWVB70e03/Oef5E9U1I
	4tSDyW0IA7Im1D0TG+FEVmsrJnf2kSYXZoc8xhGfZaMDNcHiIVQUI1/pgueHcJkO4+pvCNItgYSLe
	jgACnF8bc/mqgmywYPi2PSSs/5kxIqHH3SeDzy+wwE1FRbz7gGEOdEgp49HesNNTfsfkzb+F1CU7x
	rs0Kd78w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tMOFd-001TLb-02;
	Sat, 14 Dec 2024 17:29:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Dec 2024 17:29:13 +0800
Date: Sat, 14 Dec 2024 17:29:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: remove physical address support in
 skcipher_walk
Message-ID: <Z11P6Z6wolDJQxAS@gondor.apana.org.au>
References: <20241207190503.53440-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241207190503.53440-1-ebiggers@kernel.org>

On Sat, Dec 07, 2024 at 11:05:01AM -0800, Eric Biggers wrote:
> This series removes the unnecessary physical address support in
> skcipher_walk and the single obsolete driver that was using it.
> 
> Eric Biggers (2):
>   crypto: drivers - remove Niagara2 SPU driver
>   crypto: skcipher - remove support for physical address walks
> 
>  crypto/skcipher.c                  |  187 +--
>  drivers/crypto/Kconfig             |   17 -
>  drivers/crypto/Makefile            |    2 -
>  drivers/crypto/n2_asm.S            |   96 --
>  drivers/crypto/n2_core.c           | 2168 ----------------------------
>  drivers/crypto/n2_core.h           |  232 ---
>  include/crypto/internal/skcipher.h |   12 -
>  7 files changed, 26 insertions(+), 2688 deletions(-)
>  delete mode 100644 drivers/crypto/n2_asm.S
>  delete mode 100644 drivers/crypto/n2_core.c
>  delete mode 100644 drivers/crypto/n2_core.h
> 
> 
> base-commit: b5f217084ab3ddd4bdd03cd437f8e3b7e2d1f5b6
> -- 
> 2.47.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
