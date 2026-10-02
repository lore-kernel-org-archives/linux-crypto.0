Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD2934F24E;
	Fri,  2 Oct 2026 07:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790927749; cv=none; b=FU+e/GJ3nIOH/gCDXtc9DTJAKUpY9NQm9A0HBTX5xV8pLIQ1GSd7Skav3mmlM8dmE33tpKURIiozNCIjV/HDcKCUYCoStiJkSAeaI9eaqNT3geh0k53yZm9Q7DYuWJGvFrLkmw6lt74NU47N+F7HaHHRYg+8+7F6d7GBFssTuhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790927749; c=relaxed/simple;
	bh=FMPbCZkDohbMH1ilSpGh1oB+EV4WDprAkdAnFaaMO0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=st9VXVPnoREmWVMuOBfCn2C4mAOQlBOZ5pO4l9J1pfXv0c2FUg/JX3PRwwqE0INyHex7mSJirrHyyVJ/Nfq1N+h6Xw/AOWXGAevDdWnBsB7hpWaORx/75M8kElgqbX/dedZuLon5+/ws+cbpScnZhb3sr05oTm9kIkOob4uKz3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iHLlfZY4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iHLlfZY4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Sa2n4mUQDXdRZHzBFPcaMMv0stwwLkzEYvfnu1Cc3/E=; 
	b=iHLlfZY40xMfnZ18XIw5ZrH+PFjT0mUtuWpTULcGYq1QKXnu67+ZBWcUo1paJFGjEy3u9wHfT3O
	xdREruzCOVY5eCHiu9R8MvRH303/uVQGLVb0nBpatDIw9hKk63vXrd9y/l94LN19U3I/IUZpHZJUk
	oR2YSeBZlbGkitlKOEoNpmcU8yseEo5QLd7UYcPeQ0vzvi9SAJ1xRf9faLn3OaKJttLO/N3pqLnBQ
	pb7qeRJjk//Gqvb5EL4xwsN7mWelbPMCyuBnhKWi0kV+cWSRnmeWibl6FWKRUw0f+AEYyY3iyi3En
	5IjVr842hPLaR72+L73I88Je1h/OZNR4wuLg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCY7K-00000002m7Q-0pC6;
	Fri, 02 Oct 2026 15:55:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 17:55:42 +1000
Date: Fri, 2 Oct 2026 17:55:42 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] crypto: talitos: fix probe IRQ ordering
Message-ID: <ar9jfjxGNrFr0e49@gondor.apana.org.au>
References: <20260924235119.141323-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924235119.141323-1-rosenp@gmail.com>

On Thu, Sep 24, 2026 at 04:51:19PM -0700, Rosen Penev wrote:
> The talitos interrupt handlers schedule priv->done_task[] via
> tasklet_schedule().  In probe(), talitos_probe_irq() ran before
> tasklet_init(), so an interrupt arriving during that window (a shared
> IRQ, or a completion pending from an earlier transmission) would
> schedule an uninitialized tasklet.
> 
> Resolve the IRQ numbers before the tasklet_init() calls so the
> done_task[] selection can see the secondary IRQ, and only request the
> IRQs after the channel fifos are allocated and the device is
> initialized.  Every structure the handlers touch is then fully set up
> before interrupts are enabled.  This matches remove(), which frees the
> IRQs before killing the tasklets.
> 
> Assisted-by: LLM
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v2: reshuffle code to avoid NULL derefs
>  drivers/crypto/talitos.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)

Please check

https://sashiko.dev/#/patchset/20260924235119.141323-1-rosenp%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
