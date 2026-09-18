Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0477148CD55;
	Fri, 18 Sep 2026 08:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721711; cv=none; b=J84nj1sV343rXMF65UEwRWNaTvkIBuyZiCAZ6OggFkiPeMGRHW9y0odDUCJupTzgzXji3fYkmAW+4Mm0KwGNXkRHxwaKLH5V9P42rZXTR9oHMul0C9bQnb5pb2aL/sbN5KsMHEpN6dNIt2B8yECKkI6MBxkcLzk4uD+jUtkRP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721711; c=relaxed/simple;
	bh=1DqkGGWtxVO4fBhFc4dVGbne2HBuB4a+8tindyfsV4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cgai/kg6Na1OLvz/Vi1vohUnja1BPeuH7tCOKQ37u92doyvoHPivi916po1lhGkVudn0l7RHEluWmz5i8QLlNAj6r3QF45xcpMP15oeFxUtOJxfD5PRrXcPiV8Olhy9cyXznCXlNU83ZXwExq8PT6gy3KxdQ3tDcEWl952vcPjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Kv4KgHQl; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Kv4KgHQl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=wk8nHi1+NwmKfpvcYn7tzR5HA+W4QGvJwyefOT68wII=; 
	b=Kv4KgHQltkVEtjJVeQaNwgRtEO5M2pwHEr/wYqfvLGxznDvvR2pxUZ2i5Rwq7SEGR0iiKRZDrFQ
	rXOANJLW5TrbwnpuNsFpbJ+pLayh8RC2t/h/8W+6fuxQ8HbAC9yZ7eB5RYYat9lTkAdUQ8UBnWDbo
	iJ2GYImYq8eFpBU8tQxcVirQZhrRyhmNGKgUYQZsy1HdGT9IqKRuxudqyd6PGPnLptmo467u7C5CO
	XWtVntPwXB1HoRR+SUv/cNbe27pqhi92cJGBR/m3eXbvnMOMNqKiRk1hTcloKRH8Fasptsz059dP3
	V/IsQ+lAldoWv0e9dePcIRoPjStaXdILCoWQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7UN5-0000000FKht-3piT;
	Fri, 18 Sep 2026 16:55:05 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 18:55:03 +1000
Date: Fri, 18 Sep 2026 18:55:03 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: eip93: fix IRQ teardown ordering in remove path
Message-ID: <aqz8Z1qQob43ISM5@gondor.apana.org.au>
References: <20260909211218.15388-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909211218.15388-1-rosenp@gmail.com>

On Wed, Sep 09, 2026 at 02:12:18PM -0700, Rosen Penev wrote:
> Switch from devm_request_threaded_irq() to request_threaded_irq() so
> that free_irq() can be called at the correct position in the remove
> path.  Move the IRQ registration after tasklet_init() in probe to
> ensure the tasklet is ready before the handler can fire.
> 
> Reorder eip93_cleanup() to:
>   1. disable device interrupts (HW)
>   2. free_irq() - synchronizes and removes the handler
>   3. tasklet_kill() - safe, no new IRQs can arrive
> 
> The previous order (tasklet_kill before interrupt disable) could race:
> an IRQ arriving after tasklet_kill() would schedule the already-killed
> tasklet.  With devm_request_threaded_irq(), free_irq() ran after the
> remove callback returned, leaving the handler registered while device
> state was being torn down.
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  .../crypto/inside-secure/eip93/eip93-main.c   | 27 ++++++++++++-------
>  1 file changed, 18 insertions(+), 9 deletions(-)

Please check

https://sashiko.dev/#/patchset/20260909211218.15388-1-rosenp%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
