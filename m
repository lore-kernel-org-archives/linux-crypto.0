Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B03CC2BB48
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 18:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BC6022509
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 18:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408201AbgLNR7s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 12:59:48 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:36328 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408014AbgLNR7m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 12:59:42 -0500
Received: from [10.136.13.65] (lbrmn-lnxub113.ric.broadcom.net [10.136.13.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 2703080F3;
        Mon, 14 Dec 2020 09:50:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 2703080F3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1607968225;
        bh=FiZzrokXj/Wcz9DvgJNMcsRGqr2Epz7xd7OEyplP+kI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=YhwbyxPDbVluUt0jw+MkgNcmo8BJzWqtLGGnZgKS8TIbpcS+9UhDOT+P3MrSA/jOi
         uJme6kd9L5o0Xeo2F5RdoAy4z4RST2ZeubkzBvXjvNqdaLfFXhIpwZ3oNKhJRBY7Cg
         oSWJZhyuJDKsnIQa0NlIs2z2uRNqeiP3BliYOna4=
Subject: Re: [PATCH 2/2] hwrng: iproc-rng200: Move enable/disable in separate
 function
To:     matthias.bgg@kernel.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, rjui@broadcom.com,
        sbranden@broadcom.com, f.fainelli@gmail.com
Cc:     linux-kernel@vger.kernel.org, Julia.Lawall@inria.fr,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, nsaenzjulienne@suse.de,
        linux-crypto@vger.kernel.org, Matthias Brugger <mbrugger@suse.com>
References: <20201214160454.22769-1-matthias.bgg@kernel.org>
 <20201214160454.22769-2-matthias.bgg@kernel.org>
From:   Scott Branden <scott.branden@broadcom.com>
Message-ID: <9f87ad0f-b281-33f4-b81d-e62a37d536fc@broadcom.com>
Date:   Mon, 14 Dec 2020 09:50:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214160454.22769-2-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-CA
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020-12-14 8:04 a.m., matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
>
> We are calling the same code for enable and disable the block in various
> parts of the driver. Put that code into a new function to reduce code
> duplication.
Patch needs to be regenerated after most of PATCH 1 dropped.
>
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
>
> ---
>
>  drivers/char/hw_random/iproc-rng200.c | 37 ++++++++++++---------------
>  1 file changed, 17 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
> index e106ce3c0146..3367b26085e8 100644
> --- a/drivers/char/hw_random/iproc-rng200.c
> +++ b/drivers/char/hw_random/iproc-rng200.c
> @@ -53,15 +53,26 @@ struct iproc_rng200_dev {
>  
>  #define to_rng_priv(rng)	container_of(rng, struct iproc_rng200_dev, rng)
>  
> -static void iproc_rng200_restart(void __iomem *rng_base)
> +static void iproc_rng200_enable(void __iomem *rng_base, bool enable)
>  {
>  	uint32_t val;
>  
> -	/* Disable RBG */
>  	val = ioread32(rng_base + RNG_CTRL_OFFSET);
>  	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
> -	val &= ~RNG_CTRL_RNG_RBGEN_ENABLE;
> +
> +	if (enable)
> +		val |= RNG_CTRL_RNG_RBGEN_ENABLE;
> +	else
> +		val &= ~RNG_CTRL_RNG_RBGEN_ENABLE;
> +
>  	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
> +}
> +
> +static void iproc_rng200_restart(void __iomem *rng_base)
> +{
> +	uint32_t val;
> +
> +	iproc_rng200_enable(rng_base, false);
>  
>  	/* Clear all interrupt status */
>  	iowrite32(0xFFFFFFFFUL, rng_base + RNG_INT_STATUS_OFFSET);
> @@ -83,11 +94,7 @@ static void iproc_rng200_restart(void __iomem *rng_base)
>  	val &= ~RBG_SOFT_RESET;
>  	iowrite32(val, rng_base + RBG_SOFT_RESET_OFFSET);
>  
> -	/* Enable RBG */
> -	val = ioread32(rng_base + RNG_CTRL_OFFSET);
> -	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
> -	val |= RNG_CTRL_RNG_RBGEN_ENABLE;
> -	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
> +	iproc_rng200_enable(rng_base, true);
>  }
>  
>  static int iproc_rng200_read(struct hwrng *rng, void *buf, size_t max,
> @@ -154,13 +161,8 @@ static int iproc_rng200_read(struct hwrng *rng, void *buf, size_t max,
>  static int iproc_rng200_init(struct hwrng *rng)
>  {
>  	struct iproc_rng200_dev *priv = to_rng_priv(rng);
> -	uint32_t val;
>  
> -	/* Setup RNG. */
> -	val = ioread32(priv->base + RNG_CTRL_OFFSET);
> -	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
> -	val |= RNG_CTRL_RNG_RBGEN_ENABLE;
> -	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
> +	iproc_rng200_enable(priv->base, true);
>  
>  	return 0;
>  }
> @@ -168,13 +170,8 @@ static int iproc_rng200_init(struct hwrng *rng)
>  static void iproc_rng200_cleanup(struct hwrng *rng)
>  {
>  	struct iproc_rng200_dev *priv = to_rng_priv(rng);
> -	uint32_t val;
>  
> -	/* Disable RNG hardware */
> -	val = ioread32(priv->base + RNG_CTRL_OFFSET);
> -	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
> -	val &= ~RNG_CTRL_RNG_RBGEN_ENABLE;
> -	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
> +	iproc_rng200_enable(priv->base, false);
>  }
>  
>  static int iproc_rng200_probe(struct platform_device *pdev)

