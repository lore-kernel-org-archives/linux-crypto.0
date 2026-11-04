Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793798639;
	b=5hIPm3J9WPO1kQKM0oEffmMqSxZCFiiK+I/kP6BqUBNKoxrN3ir6A9O3EROg040IwvtX
	 5W1qXcvBt2Vjlj1K3rtwul85k/pUVbn9qHgX+ObpzkfzYJkDZNvAoQsNAaTqk6ZM/Ehnd
	 zgWNV2evD1Fylq9cp3KtOz39orLm3ZYCaXuEZ2sdDKjaBToft+1B7PKyPP3KjWA/whAmJ
	 a0rZFICMXlxjorVvQoUhgEn/bmME6t9jVjn4ngfMqHT2kT9RAn6tS2ajbpiiWw6hB+PsH
	 eABTRKwseqDD1gtpReH7E1CBxMSmJc+GzNq1HKzcvTxF9RfMEvxo9mpdQl6P4uubjpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793798639;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=koGhw/zQkpB3+l8oGWVfjInvNvaPcvPO52t7yk4yfHM=;
	b=MkseGyVwPRG58Frnmc9AtQ/8JyPgFeQqSLh+efUx9X7y/jZQqSIqm9/Q+Xvv8JFMltVR
	 4sD7f4CZVz/mt2n+uir9TTS+XVanQK4DZg+FUH6BlZXhNH5sK7Q/11UuWuhvwKuKYBuGq
	 xeuhi3MwcT9jJZzpWJ7ftvjVggHgl0qqqAP3PVlAXGsWLLLPapbiDUh0F2I9OzE+lpv1J
	 J1BNs7o5qblPk9qlw12Domemm4FUVRWRaEbuiAgoCOl6gy2EQtL4Gk4alp+9MJNhCqQkK
	 GP1A5lRNdYFBjStdsxbmjoPBszkm2zYIEH8UQDoxsqZkulr2rJlHyQgQ7xJQiB8QnlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fHj+ep8x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ECD606A32E;
	Wed,  4 Nov 2026 13:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fHj+ep8x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42441F000C1;
	Wed,  4 Nov 2026 13:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793798639;
	bh=koGhw/zQkpB3+l8oGWVfjInvNvaPcvPO52t7yk4yfHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fHj+ep8x3yly6WmyIDK2JcRVgHVPEfVW9dXsFN8/Z0zmMyMquAKVVLEt5r4Zbaz4o
	 uRgjDJimqS+NN2BNXzMVtwauA6MqR0inhTnNHfDU3VMQwSnP5AlvLp6EVgB4ADGcyw
	 oxzWDr7H4cd6AHmRRYrlKrsJNliogCy1eZy9APbtbHmkkfmURuJRbtxcCmPSOeLGdB
	 aM7wpa+ZPrSH1Men7SSQvVyTiQuVtYXBrwYM986yfTyo/AMpVWC7zmtHaERVKT7zH/
	 8Y5nkLwdC47edx9o5vs3HAYjsPR8qNeAblD1SonFEz3Gbai7248COv0ZdmoVZJphwU
	 0sCrXBzHz3pXA==
Date: Wed, 4 Nov 2026 14:23:54 +0100
From: Thorsten Blum <blum@kernel.org>
To: "Chawdhry, Manorit" <m-chawdhry@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: sa2ul - avoid rollback in sa_init_ctx_info()
Message-ID: <ausx6tcVMminhyQ7@kernel.org>
References: <20261104082056.47165-2-blum@kernel.org>
 <727fd6fb-844b-4229-86e5-f34a8b518413@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <727fd6fb-844b-4229-86e5-f34a8b518413@ti.com>

Hi Manorit,

On Wed, Nov 04, 2026 at 01:06:15PM +0000, Chawdhry, Manorit wrote:
> Hi Thorsten,
> 
> On 11/4/2026 1:50 PM, Thorsten Blum wrote:
> > Allocate the security context before reserving a security context ID to
> > avoid the rollback on allocation failure. Remove the now-unused local
> > error variable.
> >
> > Signed-off-by: Thorsten Blum <blum@kernel.org>
> > ---
> >   drivers/crypto/sa2ul.c | 22 ++++++----------------
> >   1 file changed, 6 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> > index e026fc14a411..964ddadaa211 100644
> > --- a/drivers/crypto/sa2ul.c
> > +++ b/drivers/crypto/sa2ul.c
> > @@ -748,7 +748,12 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
> >   			    struct sa_crypto_data *data)
> >   {
> >   	unsigned long bn;
> > -	int err;
> > +
> > +	ctx->sc = dma_pool_alloc(data->sc_pool, GFP_KERNEL, &ctx->sc_phys);
> > +	if (!ctx->sc) {
> > +		dev_err(&data->pdev->dev, "Failed to allocate SC memory\n");
> > +		return -ENOMEM;
> > +	}
> 
> I have been working on a cleanup and the following patch [0] would 
> actually defeat
> the purpose of the patch you've posted, with the addition of the check, 
> we'd have to
> rollback this dma alloc'ed pool instead which just reverses the order of 
> rollback and
> nothing else.
> 
> Are you okay if we drop this patch ( given am not seeing any criticality 
> ) or do you see
> it still helping after the context of the patch I shared?

You would need to call dma_pool_free() with my patch, but it's probably
better to not allocate any memory at all. So yes, feel free to drop it.

Thanks,
Thorsten
