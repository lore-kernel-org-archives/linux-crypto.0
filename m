Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79EF14A4D6
	for <linux-crypto@vger.kernel.org>; Sat, 10 Aug 2024 06:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723271102; cv=none; b=TQ9pNwgMsXmuHzeTntsSEHeEdymhgmZiwg9tK/0HORtDYzR6phFfEd3VpIeI9qqQNOFxyNwQm2KRXmcGlmQd3QjRJajbho2fHu50P3+5T4H7FL3boXeVtYF61psE2Zo7z7mkzBAbZA5kKbHUpAx2lTB9cWVBAPkYbfDAH6rG4mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723271102; c=relaxed/simple;
	bh=soMgFvGIAT4yetF6iiQPdwr0nBni+q1EJk37z2FFPhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aEv9nH3Fi8J5PncZpWqebzrlBv7LHdAjIdZeYiyFK+wCYrAnnK3E+/zWiaYTG4CkLNyI+a2QvZlPZA0JtNN+zIurS0CvcWKGAYH6fif1aG3BugvJchi7xI0t7PiJmGvTMNp2FvijpN3Lf/VeV9XyZv54pCqTy43pgueLuMQuyyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scfOH-003irK-0R;
	Sat, 10 Aug 2024 14:24:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Aug 2024 14:24:34 +0800
Date: Sat, 10 Aug 2024 14:24:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: olivia@selenic.com, florian.fainelli@broadcom.com,
	bcm-kernel-feedback-list@broadcom.com, rjui@broadcom.com,
	sbranden@broadcom.com, hadar.gat@arm.com, alex@shruggie.ro,
	aboutphysycs@gmail.com, wahrenst@gmx.net, robh@kernel.org,
	linux-crypto@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH -next 0/2] Add missing clk_disable_unprepare
Message-ID: <ZrcHoqtXWQ1s3aYl@gondor.apana.org.au>
References: <20240803064923.337696-1-cuigaosheng1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240803064923.337696-1-cuigaosheng1@huawei.com>

On Sat, Aug 03, 2024 at 02:49:21PM +0800, Gaosheng Cui wrote:
> Add missing clk_disable_unprepare, thanks!
> 
> Gaosheng Cui (2):
>   hwrng: bcm2835 - Add missing clk_disable_unprepare in bcm2835_rng_init
>   hwrng: cctrng - Add missing clk_disable_unprepare in cctrng_resume
> 
>  drivers/char/hw_random/bcm2835-rng.c | 4 +++-
>  drivers/char/hw_random/cctrng.c      | 1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
