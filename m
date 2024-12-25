Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9F52F56;
	Wed, 25 Dec 2024 05:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735105059; cv=none; b=OFR7cSaDjippLT4hWCcgWvaYwTH5MT7o8a+uyt/JxXpIejmoU3XyRvl3rEdY3d7o4Dr4ckcEmEd3KppvHTjU5d0x+MHDKKfsyo4x/LGtq7jFuVNiApouArl7cAGBfLkjjVXSv2LozuVi9n+PCdb7sFD51WL/JqzBIc7imS18+24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735105059; c=relaxed/simple;
	bh=Lj0ZGraSxRe2GmDaj1d7BSNPH5d/Tv0yzdI8IMThxZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BavhpAT2CccoHODfHd1Q9PvMTsi3QorNFDQ+u+4ugMH6uyF8NP0UsM80IwlK+FCge2DqFqGuPj7tFW0s3yCZv3o/4pmrU2dgCu6t0s6WpKQ99CAx+0xpljCVZZTfM45sAK+UdK68PuKvo+QXI35dgUpmW/xLnYUZBtkcyFvu6yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id A5E0A300002D0;
	Wed, 25 Dec 2024 06:37:25 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id 900EB4E551F; Wed, 25 Dec 2024 06:37:25 +0100 (CET)
Date: Wed, 25 Dec 2024 06:37:25 +0100
From: Lukas Wunner <lukas@wunner.de>
To: Kurt Borja <kuurtb@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION][BISECTED] Double energy consumption on idle
Message-ID: <Z2uaFYEdPZL449_M@wunner.de>
References: <aqhq6okzqa56w3x6hb6xvhajs3ce6suxfrycjcmojpbrbosvzt@65sxbbnksphj>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqhq6okzqa56w3x6hb6xvhajs3ce6suxfrycjcmojpbrbosvzt@65sxbbnksphj>

On Tue, Dec 24, 2024 at 07:42:49PM -0500, Kurt Borja wrote:
> When I first booted into v6.13 I noticed my laptop got instantly hotter
> and battery started draining fast. Today I bisected the kernel an ran
> powerstat [1]. It comes down to
> 
> Upstream commit: 6b34562f0cfe ("crypto: akcipher - Drop sign/verify operations")
> 
> These results are reproducible on my system 100% of the time, and the
> regression is still present on the latest upstream commit.
> 
> Please tell me if there is more info or test I should provide. I can
> test any patch candidates too.

The commit removes dead code and doesn't touch anything power-related.
So it's quite odd that it should cause a power regression.

Could you try reverting only this single commit and verify that the
issue goes away?  Just to double-check that this commit is really
the root cause.


> Before commit 6b34562f0cfe
> CPU:  24.94 Watts on average with standard deviation 0.21  
[...]
> After commit 6b34562f0cfe
> CPU:  57.64 Watts on average with standard deviation 0.88

That's a huge amount of extra power draw.  I'd suspect the Nvidia
discrete graphics to consume such an amount, so maybe it's not
powered down?  Have you enabled relevant Kconfig options such as
CONFIG_VGA_SWITCHEROO and CONFIG_DRM_NOUVEAU on the v6.13-rc kernel?

Thanks,

Lukas
