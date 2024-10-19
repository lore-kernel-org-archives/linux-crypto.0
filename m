Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE8818FC65;
	Sat, 19 Oct 2024 11:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729339135; cv=none; b=ZBbxhmnJzcHs9T8Lee4DVM3eTTHGgkAktxGba9BeDw+/W2WmOVhLmZKvQ+S4htFSlVgX6XWZs4Rb1vyy6c2LG1tGAFsRlZmjlD1kW2Kb9YzWCap+cAXQakZfjKMMTAM2FvBjJc0dktLAA+qnJQYCDnd6ONaIv5S51B5l4q4dS7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729339135; c=relaxed/simple;
	bh=ep/2bM4TsoLItBtu/eFVNbOYo8sryixYnGhH4iAEp2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dkgKvy3YqdYcXH2F3lO2GNuI9ZuMXGLTKP9Tyz2jTgTHs0SG7kCmf76rgdJ+Cb/JX644+Lquwmah7X5XpgIh5wH/o7v1x8+eoyIHWq55s6spLDsdvqPm9/cE55AHziP69eR+eFc+qDwjH78CbNhYiMyt7aeDQWSmaMvdx7BTn/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=h0lCt83X; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="h0lCt83X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=T4yJCWxbDFtAHjLg6MHT5rCKne5rh2s2MF09kAjNh0w=; b=h0lCt83X7xJ+bAguOUsrqcLVmy
	w9AfnFyklQ+bLHIWUhegXcQMRdke1ff/bgyCQkh2FhBrx4WPGedUDVj7lBH7f5+ZxZ9Szq1AgLg4T
	gny5NZjdQ2YhsLowlPOfjGElo5CvIQfJ0jTNI4zhMikMYgBLIMhMkCIn5oq0ADnaOGLQ6nXcEuDzM
	sjx5a8K2mVivNndJgFLcnXyw3DbHsSdxsVSUjBqjYRMKjfzbHHz5vUtcqpD+J35uts2P5X1N5i0BS
	H1p+UrAH9yGIrWCMbYFquf26yf9S34ImtMB5ZqVPSJ/FvwBJxcsqP3ORMxx2AmQo9MUtlHPNzpKMc
	LUjT37jg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t286R-00AaP3-0e;
	Sat, 19 Oct 2024 19:58:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 19 Oct 2024 19:58:39 +0800
Date: Sat, 19 Oct 2024 19:58:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 0/5] cesa: small cleanups
Message-ID: <ZxOe795LvfypJkTL@gondor.apana.org.au>
References: <20241010194517.18635-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010194517.18635-1-rosenp@gmail.com>

On Thu, Oct 10, 2024 at 12:45:12PM -0700, Rosen Penev wrote:
> Mostly increased devm usage and added COMPILE_TEST.
> 
> v2: fix wrong returns in clk_get conversions
> 
> Rosen Penev (5):
>   crypto: cesa: add COMPILE_TEST
>   crypto: cesa: use enabled variants for clk_get
>   crypto: cesa: remove irq_set_affinity_hint
>   crypto: cesa: move loop to mv_cesa_put_sram
>   crypto: cesa: use devm_platform_get_and_ioremap_resource
> 
>  drivers/crypto/marvell/Kconfig     |  2 +-
>  drivers/crypto/marvell/cesa/cesa.c | 79 ++++++++++--------------------
>  2 files changed, 28 insertions(+), 53 deletions(-)
> 
> -- 
> 2.46.2

Patches 1-3,5 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
