Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA05F3515F7;
	Mon, 10 Aug 2026 08:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350707; cv=none; b=rmNgyY+K4umgHowNwIiG7pkGWMW0ehe7183TNOWOt/Y7golIHUEMN/9kpsmGK374KPXAv9+Wm+KGbTorUQ7ntBYumnJ0X0YMPUubhz8W/MI7pE+PX3JwBQHIw4ObO1Y6Moek6FxdJX0/kZgHc6K83Ob+bYdhCWbkKflcz7z+YmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350707; c=relaxed/simple;
	bh=UAbQWb2TIgdC3YbUhFgZZT33NUHE0AyMPAhemcgPKEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GrPJgwD2yxLGMocNxX2E8oRwGuFAQgIEecldDJrgpzDEL6ETf6dqj+Yz/6OBgClo4Zt9qZn+nEC80kg54n9Gz3OKwReRcIMnIJgoENmFOd+SLCQ4vhbeXsX0wIg6uOWGPSDqgMQ5ueIl7n1vskoRGE+a6tZDb5+2rkBz/MBR8ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=BLVExA0X; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="BLVExA0X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4gbpYdJdO3yNCSwfVumu/OlXSxLrtHvBDXadccplKbg=; 
	b=BLVExA0XLSxdzk0HCuqyU1AUU3324/8FAjCGTVzk6sBeGT2x/PZHUwTumLL6GAtQhXWb8Z62hEX
	IV6GNTr4o3wLbO+e/I861yxRRzrQqfnyCvLklTtkMiHgeOaNESHLFOailzBNYOVzOmISRvDub3BCh
	UpM7+lQW3lUQZpx6yjFvZ8pDrSVcsF3x55yjdbF8TK0mR2ekBp8/bHZZ96oAA+t8lgekFHehMPEWa
	IeyFFWsKO1/3h/TBbNebNqI3fn1PJIF+T6eGtp4EzftyMyZ3fumBzdlFnKQ85dMvq+xOVnvqHesm/
	0OVLGJFbz5E5kEu2M3uA/F2++ERdXs93JXsw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLQ6-00000003WlC-000a;
	Mon, 10 Aug 2026 16:31:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:31:41 +1000
Date: Mon, 10 Aug 2026 18:31:41 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: amcc - fix racy teardown with devm_request_irq
Message-ID: <anmMbYIYQmkruYSv@gondor.apana.org.au>
References: <20260730191420.1043871-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730191420.1043871-1-rosenp@gmail.com>

On Thu, Jul 30, 2026 at 12:14:20PM -0700, Rosen Penev wrote:
> The driver uses devm_request_irq() for the IRQ, but cleans up the
> tasklet and DMA rings inside the remove function.  Since devres frees
> the IRQ only after the remove function returns, a window exists where a
> pending hardware interrupt can reschedule the tasklet after it has been
> killed, leading to use-after-free of the descriptor rings.
> 
> Fix by switching to plain request_irq() and adding the corresponding
> free_irq() calls in the remove function and the probe error path before
> tasklet_kill(), ensuring the IRQ is fully torn down before the tasklet
> is killed.
> 
> Rename goto error path to err_tasklet as that's more descriptive.
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
