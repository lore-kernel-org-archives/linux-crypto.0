Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D48C449B11;
	Thu,  8 Oct 2026 08:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448650; cv=none; b=tMlUbd7+KCwdHqQoOsO7l3CUiGYXnVgz+l4knS/djo0skBdKxCQRG+6yU7r/oT2buYmiK14s3Ej0VcIvnFJGhemoGNNlFF8x09TUCWFTEFMnaE5DsQglWRhvgadQHtmXinLl5I8lxXr0LkRbZ1WjKoG9gfL4fk9gLRg2Y2KdTNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448650; c=relaxed/simple;
	bh=I5zpVEXZpQKVXkdlUVmsf+FUfYzS+iueSknawtKzoP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=saIzmjvJSivWg90D6mfySbWEBPXiX+KyxQVEtY1yb8ESomCy++QZQ4YJotTdr42p9Kgu/9xWPWRXOgpClde/vMBNasaVrbMiQ+9KOtgPVCXlAKNm/NxFb/DsK2957GLiUvw26jzciwa8WsT05NFOq21lB3O8ofWUkgrX+RGrsg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NJFMsQ83; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NJFMsQ83"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=2ZxIvsNO5f5PUT0bP/KTPDZ1byTpKd3FQBMRNeE2iiA=; 
	b=NJFMsQ83iKCe1uxEeMCnja128jqGK7n3w3ZLmf11H8KDa4Sdn7dWRvdAGuJscZv6X2crXBUE77p
	4ue1BBe2HZGrdBzdKST+8Kh6o6Xl6GQpve3HmHUD3/6GE4t7ZjSQ0VOeE8n4tvPgJvH3vxOKhRHFv
	4XazY3vMq7Uz4Hz77QnHGhJmcziMQLfQ6Ag0Itd1ak+Mur8ppaDrdjk9FWklLUGpMdP46sLfpyuTe
	DAuHpljqzBRKBl+g/vipdFqVvJ1Zn7uNzzzl4nEIc5o0JEt3qPGuobHxnlnf6QvJFaz9C+AV7lKzj
	qsk7FAMtKiZRIZL2OD6cJgPW/0NZI03DPA8Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjcx-00000001oAp-2B9O;
	Thu, 08 Oct 2026 16:37:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:37:23 +1100
Date: Thu, 8 Oct 2026 19:37:23 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] crypto: talitos: init tasklets before requesting IRQs
Message-ID: <asdWQ-GqFnF-QSwK@gondor.apana.org.au>
References: <20261004215042.383358-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004215042.383358-1-rosenp@gmail.com>

On Sun, Oct 04, 2026 at 02:50:42PM -0700, Rosen Penev wrote:
> The talitos interrupt handlers schedule priv->done_task[] via
> tasklet_schedule(). Since the second IRQ support, probe has requested
> the IRQs before calling tasklet_init(), so an interrupt already pending
> when a line is requested, e.g. engine state left by the bootloader or
> a kexec'd kernel, would schedule a tasklet with a NULL callback.
> 
> Look up the IRQ numbers and map the registers up front, so that
> -EPROBE_DEFER returns before anything is allocated and the done_task[]
> selection and reset_device() can see the secondary IRQ. Only request
> the IRQs once the channel fifos are allocated and init_device() has
> reset the engine. This matches remove(), which frees the IRQs before
> killing the tasklets.
> 
> remove() frees every IRQ number that is > 0, so make sure that only
> requested lines are set when it runs from the probe error path: clear
> both numbers when probe fails before the request, and clear any line
> talitos_probe_irq() did not request. Previously a failed primary
> request in the two-IRQ case freed the never-requested secondary line.
> 
> Fixes: c3e337f88a5b ("crypto: talitos - support for channel remap and 2nd IRQ")
> Assisted-by: LLM
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v4: actually fix IRQs this time. Add a Fixes: tag.
>  v3: reshuffle again to fix IRQs.
>  v2: reshuffle code to avoid NULL derefs
>  drivers/crypto/talitos.c | 54 ++++++++++++++++++++++++----------------
>  1 file changed, 33 insertions(+), 21 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
