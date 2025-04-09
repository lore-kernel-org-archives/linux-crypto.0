Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A30AA1D6DBB;
	Wed,  9 Apr 2025 12:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744202179; cv=none; b=ZfAdjiNXl5YGNvtlIIPWOpyDyS49IYHAaaf63W0W0W7CX+NH91hGFf28AImGvlyqqTlyEBuZgH9e47eQMK9tHG8bEcma/D0KX19M2RpEywchan8GU1xK/D0bEAPh6cOwU9jfpkmS7IhvgCN5TXsQ4SXZTUedfEXOP2HaYqamo9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744202179; c=relaxed/simple;
	bh=vsq2H4wbKekMe2rcYLkaDpskemfC+TPVC8LbUtF7AS8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SeT7Ur450BvsZqxqN4nkQSWHXWeElKal2ljZvFgAlKssHsa/dYFSIjZ1WChB4FwLbpYV7KBGhVCpwOM5ETodPUu1jJ1eRutHh99Fc5PiVEuOx9vEmDT+zTdAxpKoLCquUZlVMAhSE5m3eifXZ8RdomsxTZAQAkXVSUH6tGO1rYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F11715A1;
	Wed,  9 Apr 2025 05:36:16 -0700 (PDT)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B53D63F59E;
	Wed,  9 Apr 2025 05:36:13 -0700 (PDT)
Date: Wed, 9 Apr 2025 13:36:10 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: linux-sunxi@lists.linux.dev, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Chen-Yu Tsai <wens@csie.org>,
 Corentin Labbe <clabbe.montjoie@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Jernej
 Skrabec <jernej.skrabec@gmail.com>, Ovidiu Panait
 <ovidiu.panait.oss@gmail.com>, Samuel Holland <samuel@sholland.org>, LKML
 <linux-kernel@vger.kernel.org>, Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH] crypto: sun8i-ce-hash - Refine exception handling in
 sun8i_ce_hash_run()
Message-ID: <20250409133610.59d42bec@donnerap.manchester.arm.com>
In-Reply-To: <3727de04-7993-4b81-80c0-adb40b847307@web.de>
References: <3727de04-7993-4b81-80c0-adb40b847307@web.de>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 9 Apr 2025 13:43:39 +0200
Markus Elfring <Markus.Elfring@web.de> wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 9 Apr 2025 13:26:55 +0200
> 
> Two if branches contained duplicate source code.
> Thus avoid the specification of repeated error code assignments by using
> additional labels instead.

Is that really useful? I think the current code reads easier, with the
usual pattern of setting the error code and the goto'ing out.
Now there is one rather opaque label it goes to, so a reader doesn't see
the error code immediately. And it really just saves one line per case
here. Plus the added danger that future changes might break this again.

And then there is the oddity that it jumps *into* an "if" branch, which
looks odd, I think typically we goto the end of the function, outside of
any other statements.

Cheers,
Andre

> This issue was transformed by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> index ba13fb75c05d..7d31e190bb6a 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> @@ -399,14 +399,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
>  	}
>  	if (len > 0) {
>  		dev_err(ce->dev, "remaining len %d\n", len);
> -		err = -EINVAL;
> -		goto err_unmap_src;
> +		goto e_inval_src;
>  	}
>  	addr_res = dma_map_single(ce->dev, result, digestsize, DMA_FROM_DEVICE);
>  	cet->t_dst[0].addr = desc_addr_val_le32(ce, addr_res);
>  	cet->t_dst[0].len = cpu_to_le32(digestsize / 4);
>  	if (dma_mapping_error(ce->dev, addr_res)) {
>  		dev_err(ce->dev, "DMA map dest\n");
> +e_inval_src:
>  		err = -EINVAL;
>  		goto err_unmap_src;
>  	}
> @@ -428,16 +428,15 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
>  		j = hash_pad(bf, 2 * bs, j, byte_count, false, bs);
>  		break;
>  	}
> -	if (!j) {
> -		err = -EINVAL;
> -		goto err_unmap_result;
> -	}
> +	if (!j)
> +		goto e_inval_result;
> 
>  	addr_pad = dma_map_single(ce->dev, buf, j * 4, DMA_TO_DEVICE);
>  	cet->t_src[i].addr = desc_addr_val_le32(ce, addr_pad);
>  	cet->t_src[i].len = cpu_to_le32(j);
>  	if (dma_mapping_error(ce->dev, addr_pad)) {
>  		dev_err(ce->dev, "DMA error on padding SG\n");
> +e_inval_result:
>  		err = -EINVAL;
>  		goto err_unmap_result;
>  	}
> --
> 2.49.0
> 

