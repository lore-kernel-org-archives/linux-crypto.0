Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795711638;
	b=QEieMOa7+ofKo9LcSBEux4AMzlW3aoj1xExYLA0NbvpgvkVI2ieSOUGDjxWChYXFdUeM
	 RtMDGPIuV66rCphMhylPgUxeXV3hfDGJkBR0QcRgv1AFjxZ6EsuVdMJynRyMOcatZN7Bo
	 JEKx6SFzLOGbodFEMQUVQJXOK4SMjfA4gNhm6t9/JPmQ3Pz2LCOzBRYrlJaKbwk/Eo57F
	 sWLlUocqPaqeFXFcKwXrulGykizjdv6F1vDjxkGmRlu+fva7YHI2fmKE54TAEUhYkj66I
	 EJFOqAzblnzu6cNYBB1YPqYPmWPaylmcrdVyCaHgqsfMmYwpg45UaPisCIAL7OK3vTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795711638;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=nspLTlqYznDj+NK1vwMnwBPDLnuWDzwWNa7MDsNX3bc=;
	b=ddVLIZQUdWIh74Tpo6KtAUnEcQnJCEl9m68CDw6q7FsAUWyIjdr68TGVNo9hvofpt21I
	 HMfT0AWlpQ0cXawNF2tebWcKCta61qj0ldIOQKHqOHpZVngMDQGn2IoTRicl4IFg8c7AW
	 ZnHvFbzaOh6p+VJzfhfGAWiwfolDDu/msDGt1zlHVMAiXNAEnKxZtzoKR/5Qra+128kV2
	 kCKLdy93Z6Uii+VOPueSGw5HE0g/xuC3rALveA0VthALJZkxDIJu5xLVGrfi8ifB17LFM
	 8i9FbPOnJpfnU5VD3RXIp/BUNb/unpbsLU91auPrZvtsukjsGuLLh4Jbe8DhsRzwIcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NZ5UQVAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC398606A31E;
	Thu, 26 Nov 2026 16:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NZ5UQVAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E843D1F000C4;
	Thu, 26 Nov 2026 16:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795711638;
	bh=nspLTlqYznDj+NK1vwMnwBPDLnuWDzwWNa7MDsNX3bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NZ5UQVAWWsNtA5Sv9oWjKKwRobLdw2OWTU06+iS11rI6gTTa7qtkBQgecET6/MLo6
	 kgDUtqK+r4/f+gSiNCciIW4rVvpcwx6Chd+Sp8BK6BJ+5nx7uu8kvwMl/qDWnlIwFn
	 D3NHM78LKoW2PbEP0ZKrEhC02JeT0BLA7AACkpm3d9k+SdRfoOW7dirL/Z8vwGRsGe
	 4V1dDlGsMclWcPYpMl+b54gEhBEWy7M5sZZsjtrgN0pqW4h/H3QfyPiyiRSsRIGUbG
	 fgfWZLk44eCzbSPZl7gzEYISuA4UajBNPsJmS6pvbB7fK9DjJCX2M4mZsoI0U4brPo
	 03rGpwPw/9cPQ==
Date: Thu, 26 Nov 2026 17:47:15 +0100
From: Antoine Tenart <atenart@kernel.org>
To: Lee Jones <lee@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Aleksander Jan Bajkowski <olek2@wp.pl>, 
	Pascal van Leeuwen <pvanleeuwen@insidesecure.com>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 07/10] crypto: safexcel - Check scatterlist errors before
 max() for in-place
Message-ID: <awhiMq5yUzdssptB@toolbx>
References: <20261123151055.2533735-1-lee@kernel.org>
 <20261123151055.2533735-8-lee@kernel.org>
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
In-Reply-To: <20261123151055.2533735-8-lee@kernel.org>

On Mon, Nov 23, 2026 at 03:09:58PM +0000, Lee Jones wrote:
> In safexcel_send_req(), sg_nents_for_len() returns -EINVAL when a
> scatterlist is shorter than the required payload length.  For in-place
> requests (src == dst), the driver combines sreq->nr_src and
> sreq->nr_dst using max() before checking for errors.
> 
> When an in-place AEAD encryption request provides a scatterlist large
> enough for totlen_src (sreq->nr_src > 0) but too short for the
> appended authentication tag in totlen_dst (sreq->nr_dst == -EINVAL),
> max() selects the positive sreq->nr_src and discards -EINVAL.  The
> driver then maps only the undersized buffer while programming the
> engine token to emit totlen_dst bytes.
> 
> Check both sreq->nr_src and sreq->nr_dst for negative error values
> before combining them with max().
> 
> Fixes: 19b347b32bb1 ("crypto: inside-secure - fix scatter/gather list to descriptor conversion")
> Closes: https://sashiko.dev/#/bug/linux-78f87af5-af5e-439c-bb52-de4c8c53fdee
> Cc: stable@vger.kernel.org
> Signed-off-by: Lee Jones <lee@kernel.org>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

> ---
>  drivers/crypto/inside-secure/safexcel_cipher.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
> index b031cb9652ec..e7816f6ddeaa 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -736,14 +736,13 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
>  	queued = totlen_src;
>  
>  	if (src == dst) {
> -		sreq->nr_src = max(sreq->nr_src, sreq->nr_dst);
> -		sreq->nr_dst = sreq->nr_src;
> -		if (unlikely((totlen_src || totlen_dst) &&
> -		    (sreq->nr_src <= 0))) {
> +		if (unlikely(sreq->nr_src < 0 || sreq->nr_dst < 0)) {
>  			dev_err(priv->dev, "In-place buffer not large enough (need %d bytes)!",
>  				max(totlen_src, totlen_dst));
>  			return -EINVAL;
>  		}
> +		sreq->nr_src = max(sreq->nr_src, sreq->nr_dst);
> +		sreq->nr_dst = sreq->nr_src;
>  		if (sreq->nr_src > 0 &&
>  		    !dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONAL))
>  			return -EIO;
> -- 
> 2.56.1.750.gf70dc682cf-goog
> 
