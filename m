Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493CE383C93;
	Thu, 30 Jul 2026 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397827; cv=none; b=NDMEKxx0dvikkAGZDunizskTjSngDQKJMrBuoMoH9ceZOBWIAmbpELZ3DGWnp1QwEKhSBZO8mDGnnmsFwDHZ1WF33HkPhwbcwh9XoJrOvCHpcv6gLnHZyy1wSgPhFlJJLXmUPFdA9WPPuJ9kMlVIDj2n0bqMS5k/XFK1Xv0yMlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397827; c=relaxed/simple;
	bh=aV3BZhOhUuvYbbsSpJZuZAx1/IS0y+XhQGufcQtrXeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2dqWygdO4Rzgzn9N5raUoGnlRkCxDIK/9l2fKspBV4XXjn7FkZ2o3IArZ3A0n9QCKuwDYOk+Jqoknwiw54H+vH+hyxh4KWYhSpN4Pit5gO8srL3zJupCYj5fKQx291KoWo6510DB5iTNQZ0709w7tmntlOtcrIgX/Yge7QBI6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nWlos8TZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nWlos8TZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=F3NxMm6jClV9wt9jjilUoB6NrEDfRxCIFjZ4/Dno+Vk=; 
	b=nWlos8TZ+CIwnbALgMaODMcQa7wXGj1w7SriRnHiptCPilOjpOYx54FAv26E8/xINddUHYS/Ovk
	uX4LOivHtFLwDYa3LFdUM+wqztxyuolANquAto9uRwXKFKFl09BiSTMkEI8+h1ljekB0RtjCiUrVh
	djsl51hnI/jwXDYa2Uqj9rIzXrfyctvKozxeF9KkNkeqrQH4YPtanVuBdLwhUBd/c/ziHoDptvtXF
	wm1YeomxNg2v5ZTG9Q2qWB3sL/4caEITcXbjs3J6JCClfgecfITauBPvgB4M4JKZFBxAxSs57zqSJ
	PyaXCdDyT2WUWRhDBZe5q4LXqbCjuckx60yQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpLX3-00000000S7I-1ktu;
	Thu, 30 Jul 2026 15:50:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:50:21 +1000
Date: Thu, 30 Jul 2026 17:50:21 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Richard Weinberger <richard@sigma-star.at>
Cc: Richard Weinberger <richard@nod.at>, upstream@sigma-star.at,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	demiobenour@gmail.com, davem@davemloft.net, ebiggers@kernel.org,
	upstream+linux@sigma-star.at
Subject: Re: [PATCH] crypto: af_alg: Allow cbc(paes)
Message-ID: <amsCPXNkPr4dYd6F@gondor.apana.org.au>
References: <20260726192716.2351505-1-richard@nod.at>
 <amr_LZMjwUCl_QpH@gondor.apana.org.au>
 <5372653.jyWNHgNrjM@nailgun>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5372653.jyWNHgNrjM@nailgun>

On Thu, Jul 30, 2026 at 09:39:24AM +0200, Richard Weinberger wrote:
> On Donnerstag, 30. Juli 2026 09:37 'Herbert Xu' via upstream wrote:
> > This does not apply against cryptodev.
> 
> This is not material for next/7.3, this is for the current release cycle.

So what am I supposed to do for next? Allow cbc(paes) or deny it?

Because it's not in the white list.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
