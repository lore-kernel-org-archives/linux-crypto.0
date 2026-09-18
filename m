Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AD44B0CBD;
	Fri, 18 Sep 2026 08:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721540; cv=none; b=dLG7VhfrTbUNSQyd4KHtWrD9HZat8HI4b/mEHhTPHn7YzXXgsTzpfQi2INrLb7szIQD8dgpqOp4dfX8+iOfXJyUo1l7jPSzIqbYuZiYXMWyFcdPCfvUduHmT5TK+yuWmS7dwNynbhsb9NXtGMqsVjDTQGGRaOnymC8MJqKglX3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721540; c=relaxed/simple;
	bh=oGSwTCGLU0lDyVnVluF/I13nX51dTEK+ToseuDxh2K4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sqit6MzpCXm6zLnNHyENyTkbbhOgunaUyyDB5sLFmEjhJdy6S3faQQP0BWoNebEx2EWijcPwA85Xo7pg2k9HMNzxPWHOPC6PzJhu7eE1DjVNR1Smp2mduawxtaTRqDFSIaWWDPnbyW62SAn/oANEFlcXfbpP1rQj8WaVPefUtCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=rXjMkOHs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="rXjMkOHs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=jZLW6WJFVhU+LLcc0daYjVscse94JVPYOxGjDJR0vBY=; 
	b=rXjMkOHsvMByvr71y5p+y0r71KilPSIYOu8eNXw4WC11O8yYs1nKEia7AM4+cPvShrLMqUt47Q0
	sJa7OEkh787LVVtCyhijiuxdIwOQeh8O0hVjbVKxIXQ2dm69mDKnkR+ARJBt1342sfRUfT9ZO59iT
	24+C/ghYXwyoFhtEhtgYrX1CqN89hUlOxKK4yznXp4/2eGCh1qO/9vNZcm0AufNs8x+c8dq4c2Au+
	7bTxnzb5LskhfBBGYPcZ1fq9XHORGFwA1EAZEaJBK1LRYQ0yoGeM7Vdy4rnGR0IvzZxnYyxUtpv1E
	eJfVXsCJg8gmkGo69Oexa/aZDUYaV2R9pTNg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7UKD-0000000FKg2-0EvH;
	Fri, 18 Sep 2026 16:52:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 18:52:05 +1000
Date: Fri, 18 Sep 2026 18:52:05 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: clabbe@baylibre.com, davem@davemloft.net, skhan@linuxfoundation.org,
	me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: amlogic: Fix IRQ handler return value and
 fallthrough logic
Message-ID: <aqz7tT10SEMCrwV4@gondor.apana.org.au>
References: <20260908160120.4805-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908160120.4805-1-raizudeen.kerneldev@gmail.com>

On Tue, Sep 08, 2026 at 09:31:20PM +0530, Mohamad Raizudeen wrote:
> In irqreturn_t_meson_irq_handler(), when an interrupt matches a flow
> but the status register is empty, the driver prints an error but
> doesn't return. It falls through the loop and incorrectly prints an
> `unknown irq` message.
> 
> Fix this by returning IRQ_HANDLED immediately after the error print.
> 
> Additionally, the handler returns IRQ_HANDLED for genuinely unknown
> interrupts. This masks false interrupts and prevents the kernel from
> detecting interrupts. Return IRQ_NONE instead for unhandled
> interrupts.
> 
> Cc: stable@vger.kernel.org
> Fixes: 48fe583fe5417 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Please check

https://sashiko.dev/#/patchset/20260908160120.4805-1-raizudeen.kerneldev%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
