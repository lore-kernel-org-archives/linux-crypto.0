Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F395F360EF0;
	Mon, 10 Aug 2026 08:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786349432; cv=none; b=dpusXaOUTqshZQkzZhIRAeR21KYARtXbi/4WPwI3NZIyRAXB+D9UXZRaX+towJAiAjw57ZWdpFzz+hs+VSAb9/8H2qAggOaAUHBrkVVHIah9/0UV16L4fgz4yvbmBgvvydz5Jamy3Do+O/wot+D+/7ADlQlmgww9/oMupNymvk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786349432; c=relaxed/simple;
	bh=3IwBHSpT4E3u3eW97XB3arpoqPPxXkJIfhX8Zv8duYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgksF46OpsYF8udikRz1BtlALQEX6WUuU6w1OF+OBqU59el3qYKqpfd42rrayy0Dd8HCoSNuyhbxdRVZvgBZ0E8Cecob/KbaehfGTZ854VwrdmYOOEqsZxRaKTnHLmJYRwhkao8flUnGlth5EkK/dP1xg80pMDXa82FbeZW2Ws8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qxXhgsWF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qxXhgsWF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=I8g03HLjrI6MmppUhp5T17EUkXkbiNDiEyX0pw+P4cs=; 
	b=qxXhgsWFsn0u8rWf9gKs3rkCJL/SzmiJgzpqyxN0tnc1VrkPoowV7ISlbOJnUqSPhxRR50fdJdN
	GvCVj4dHuNI7OdNHBAt9LnItM8ZrEwwZaRdn0agt2cNurQMwv4UQOlLx2QIV/TvbgDZbOLD3rwfso
	OxwW/vZbuqhkCm4s/9ioSSNAXEDOyNcJFUDPG3IBmgRlpEdw/sbCjgXF10Aqf0fdTddiOOSm9wwA/
	jYxVGSKm9orfSeMrPgK5YWBQNIqFqE/wvQ64f195AFBn12LQs9Wi1QSQjRaKz6TwqEE19dJMvyC9n
	14OWbjzrIJ5XWM4jhrpISqYkJCO7mxntWwQA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtL5V-00000003WMA-2ulx;
	Mon, 10 Aug 2026 16:10:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:10:25 +1000
Date: Mon, 10 Aug 2026 18:10:25 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam/jr: fix use-after-free in interrupt handler
 teardown
Message-ID: <anmHccSuAF5apZr2@gondor.apana.org.au>
References: <20260730231603.1169539-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730231603.1169539-1-rosenp@gmail.com>

On Thu, Jul 30, 2026 at 04:16:03PM -0700, Rosen Penev wrote:
> caam_jr_shutdown() currently calls tasklet_kill() without freeing the
> IRQ first, creating a window where the interrupt handler can fire and
> schedule the tasklet after it has been killed.  Move from
> devm_request_irq() to request_irq()/free_irq() so that the IRQ is
> explicitly freed in caam_jr_shutdown() before the tasklet is killed.
> 
> As part of this change, pass jrp directly as the dev_id cookie to
> request_irq() instead of the device pointer.  This lets the interrupt
> handler obtain jrp directly from the cookie, eliminating the
> dev_get_drvdata() call in the hot path.
> 
> Two related fixes:
> - Use jrp->dev instead of the now-undefined dev local in the handler's
>   error path.
> - Set jrpriv->dev before calling caam_jr_init() so that jrp->dev is
>   valid before the IRQ is registered and the handler can run.
> 
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/caam/jr.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

I think we should fix the general problem of hardware removal
in the middle of a crypto operation first before attempting these
fixes.

The driver needs to be modified so that it can fail gracefully
if the hardware is forcefully unbound while a crypto op is ongoing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
