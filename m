Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B388F3EDAA0;
	Fri,  2 Oct 2026 08:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790928625; cv=none; b=jd42V7XGA4bbd3pW0mCnKLXQ5egHeYsE5HLUsvazGi/Wh+Smj8oJzpeyekw1UKta2iUHYD4L/1sShnjuFg27FAKwshQB95juop72p3K6nOAmDQ3dbKEjYWl0n0Emj/M+FZhcWMzcLOzA7/VjIhSuk9xNLWyjITMPecVSAXY3PFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790928625; c=relaxed/simple;
	bh=P5qDOBB+maHprqRSEG339lxLmlV9DddAz8WOH1gvDok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DaPTflFWujPZC1QZS/+SZJ0GL7Vq9GekB1jOncX3QMn27TK+Bo2sim1xiLD95dVcfM5/Gy4ei2WM1jb32T5GcaUk31OWJ9wFILasWWci5rBEW5YtbECu+L2FbkfWhfNQzjzf1msoY3JumR+gjdHB26EfsdUEzdDNgFt86C3hLp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gO8ybHJ4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gO8ybHJ4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=zohR+31d4S/MlhZOaky7vMucJvC+3R4Cb2NEvA3Oaik=; 
	b=gO8ybHJ4gzoqwES9fnJ4kniFTDWAf8X2+O/MNR41AVVY2eTrr3HOtU7UBUQ3aCV1yv6TfvV0OGL
	S55B4lPC/gOae5HXw9kXTEpuBwtuUU5GBCxQv4N+Uz9YtRQ/2yUQARPlsbgNR0ERuS+j78hIqi+JO
	gb/+JFxKahtMDQQ/wtQ4DSBDn0RCMpjrNyhc1NksQBrY3ra3UJoXzidOjQIjN9SGzIQ69cnJTu+Rn
	LWizFgdg1TxEqqk1/SvQmz1IYCY7VIkL6sAP5jKCAUTYoE6K1nEqrNX3Dj+JlsGr7I6ruiraeh8U0
	mCmGK0uSWgNP73nK32NW4od6ToaJqJ/xDwjg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYLM-00000002mIm-3uZM;
	Fri, 02 Oct 2026 16:10:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:10:12 +1000
Date: Fri, 2 Oct 2026 18:10:12 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] crypto: cesa: complete pending requests on device
 remove
Message-ID: <ar9m5Bn_QFzjL6MW@gondor.apana.org.au>
References: <20260927212315.113966-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927212315.113966-1-rosenp@gmail.com>

On Sun, Sep 27, 2026 at 02:23:15PM -0700, Rosen Penev wrote:
> mv_cesa_remove() unregisters the algorithms but never drains the engine
> queues, so waiters of requests that were in flight, queued or already
> processed block forever once the device is unbound.
> 
> Quiesce the IRQ with disable_irq(), mark the engine aborted so no rearm
> or new submission can restart it, stop it and wait for it to go idle.
> Drain engine->req and engine->queue with -ENODEV, the error
> mv_cesa_queue_req() now returns to new submissions, and report
> engine->complete_queue as successful because ctx->ops->complete() has
> already copied their result out. All of them go through
> mv_cesa_complete_req(), so ctx->ops->cleanup() still releases their DMA
> mappings and descriptors. cesa_dev is cleared last, as those callbacks
> unmap through it.
> 
> mv_cesa_dma_cleanup() now stops at dreq->chain.last. mv_cesa_tdma_chain()
> links requests queued back to back and only mv_cesa_tdma_process() severs
> the link, so a request that never ran still points at its successor and
> would otherwise free its tdma_desc_pool and op_pool objects twice.
> 
> Assisted-by: LLM
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v3: fix more errors
>  v2: fix a bunch of sashiko errors
>  drivers/crypto/marvell/cesa/cesa.c | 120 ++++++++++++++++++++++++++++-
>  drivers/crypto/marvell/cesa/cesa.h |   4 +
>  drivers/crypto/marvell/cesa/tdma.c |   9 ++-
>  3 files changed, 131 insertions(+), 2 deletions(-)

Please review

https://sashiko.dev/#/patchset/20260927212315.113966-1-rosenp%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
