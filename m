Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED013D4101;
	Thu,  8 Oct 2026 08:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791447176; cv=none; b=ZyUj4EqgE5FM5Ech+xi5ZcGUVOTnvkZiVeBGhtCzTKhM+qlPlT8CHpdecpXDkkscQBI0fXDIleB6oDUuZ2XHl6x96L+HikwigcHd0WL+xRq6UWjjTNvL9DjEI3ZvwWgmuMX192qojuPRQ3TVHG3wYaHSqug/2JZVzqR3NfqaeNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791447176; c=relaxed/simple;
	bh=TCIte7MDbqlGpnlVAvbYVUXLOdukV4uvMPq14vwQquQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbnkpWFfoAg81238u1H519gQbp0OMwsM11R632pDtdJ+dhogwRyYYpRIvFZ4oOj03dzoGloKMvys1T1+Mf4kiqNSvVTMqkbJLNt0h/t3Gf9jn0psvsGqGlzsB4aCm1BXgtDT+t239ni9Vf6sk47Qf3BM/fDjORbVHaTtxdfDetc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=swGk4w6o; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="swGk4w6o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/NpMgLXRRZpW3DmO3Yv4qNoVqFNxjzsb/RxwbkWUJzA=; 
	b=swGk4w6oDojPgsqXTg9Vq5Jz+crDgkW+bLXi8NDHgFYzvoVpxZY+01tHWr1id6jJGZ1nChSgB9g
	cp6JnVVxscTNWzaOHRq65KboHqhvWhJApXtuD5xjrxu6/3WuoRwG9+gI+3PUh8ooyPQrbcMOlHdBs
	E5czUzSr1n0NNjhJOt+Rj2M9ICTQ/j6KXnxyvaMAyvHJQ3aa1Cbq4klXWTweIFpaRevw1ax2S7doM
	7epj8pZcDe7KVH5lA01gJEs+2nZ7S4xVgfL7z83kiedXI+kVTwND+BYoi0/TgIzSHuFgy62MIn6pI
	iH0fxRvwy7wCxJ85gnbL5EOUJbZsAmy4ve2g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjFA-00000001nXu-0w6g;
	Thu, 08 Oct 2026 16:12:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:12:48 +1100
Date: Thu, 8 Oct 2026 19:12:48 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: vjardin@free.fr
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Sahil Malhotra <sahil.malhotra@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: caam/qi2 - reset the DPSECI at probe only when
 enabled
Message-ID: <asdQgEO3fZ0H3zfm@gondor.apana.org.au>
References: <20260928-for-upstream-caam-qi2-dpseci-reset-v1-1-042be6c05472@free.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-for-upstream-caam-qi2-dpseci-reset-v1-1-042be6c05472@free.fr>

On Mon, Sep 28, 2026 at 04:06:56PM +0200, Vincent Jardin via B4 Relay wrote:
> From: Vincent Jardin <vjardin@free.fr>
> 
> Since the commit
>   060ce5037d5f ("crypto: caam/qi2 - add support for dpseci_reset()")
> probe resets every DPSECI.
> 
> On a DPSECI the MC has just created from the DPL, never enabled,
> MC 10.40.x then logs for each of its queues:
> 
>   [E, qbman_rec_isr:396, QBMAN]  QBMAN recoverable event 0x1000000
>   [E, dpmng_dump_rerr_fqid:1335, QBMAN]  REL_FQ (FQ[0]) has 1 messages, dumping up to 16:
>   [W, DPSECI]  DPSECI ID[0]: Flush on queue 43 not confirmed
> 
> That is 16 error lines for an 8-queue DPSECI, at every boot, although
> there is nothing to flush: a disabled DPSECI has no request in flight.
> 
> The reset at remove is unchanged.
> 
> Signed-off-by: Vincent Jardin <vjardin@free.fr>
> ---
>  drivers/crypto/caam/caamalg_qi2.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
