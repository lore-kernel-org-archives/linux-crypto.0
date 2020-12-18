Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568E2C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 17:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F1C623B54
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 17:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgLRRnt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 12:43:49 -0500
Received: from saphodev.broadcom.com ([192.19.232.172]:42844 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728246AbgLRRnt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 12:43:49 -0500
Received: from [10.136.13.65] (lbrmn-lnxub113.ric.broadcom.net [10.136.13.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 7B9FB80DF;
        Fri, 18 Dec 2020 09:32:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 7B9FB80DF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1608312731;
        bh=h5hEddcP3Sei2BEVtxNVjlgWNGIa0QHdTFP0mGxVgPg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=JY6mDCu4kdtoBCdx0RP4p0Uesc3xo1WE8L1XSYnCKDwjAMLBBdA9VwgRBFSAL/K1n
         X8d24QLKvqP3KM6WZ/yP0x6GOjkM63T18wz4OnLgiybgsSvYsdvoZ48mTHpFxj6lL4
         HvHocDSMu5BtgwpcdImX0OtzjNcQEobKqvMjY7GQ=
Subject: Re: [PATCH v2 2/2] hwrng: iproc-rng200: Move enable/disable in
 separate function
To:     matthias.bgg@kernel.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, rjui@broadcom.com,
        sbranden@broadcom.com, f.fainelli@gmail.com
Cc:     linux-kernel@vger.kernel.org, Julia.Lawall@inria.fr,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, nsaenzjulienne@suse.de,
        linux-crypto@vger.kernel.org, Matthias Brugger <mbrugger@suse.com>
References: <20201218105708.28480-1-matthias.bgg@kernel.org>
 <20201218105708.28480-2-matthias.bgg@kernel.org>
From:   Scott Branden <scott.branden@broadcom.com>
Message-ID: <fe0bd5cf-b48b-d7e6-c20c-6f8d0ae7aeb5@broadcom.com>
Date:   Fri, 18 Dec 2020 09:32:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201218105708.28480-2-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-CA
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020-12-18 2:57 a.m., matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
>
> We are calling the same code for enable and disable the block in various
> parts of the driver. Put that code into a new function to reduce code
> duplication.
>
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Scott Branden <scott.branden@broadcom.com>
>
> ---
>
> Changes in v2:
> - rename function to iproc_rng200_enable_set()
> - use u32 value instead of uint32_t
>
>  drivers/char/hw_random/iproc-rng200.c | 35 ++++++++++++---------------
>  1 file changed, 16 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
> index 70cd818a0f31..a43743887db1 100644
> --- a/drivers/char/hw_random/iproc-rng200.c
> +++ b/drivers/char/hw_random/iproc-rng200.c
> @@ -53,14 +53,24 @@ struct iproc_rng200_dev {
>  
>  #define to_rng_priv(rng)	container_of(rng, struct iproc_rng200_dev, rng)
>  
> -static void iproc_rng200_restart(void __iomem *rng_base)
> +static void iproc_rng200_enable_set(void __iomem *rng_base, bool enable)
>  {
> -	uint32_t val;
> +	u32 val;
>  
> -	/* Disable RBG */
>  	val = ioread32(rng_base + RNG_CTRL_OFFSET);
>  	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
> +
> +	if (enable)
> +		val |= RNG_CTRL_RNG_RBGEN_ENABLE;
> +
>  	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
> +}
> +
> +static void iproc_rng200_restart(void __iomem *rng_base)
> +{
> +	uint32_t val;
> +
> +	iproc_rng200_enable_set(rng_base, false);
>  
>  	/* Clear all interrupt status */
>  	iowrite32(0xFFFFFFFFUL, rng_base + RNG_INT_STATUS_OFFSET);
> @@ -82,11 +92,7 @@ static void iproc_rng200_restart(void __iomem *rng_base)
>  	val &= ~RBG_SOFT_RESET;
>  	iowrite32(val, rng_base + RBG_SOFT_RESET_OFFSET);
>  
> -	/* Enable RBG */
> -	val = ioread32(rng_base + RNG_CTRL_OFFSET);
> -	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
> -	val |= RNG_CTRL_RNG_RBGEN_ENABLE;
> -	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
> +	iproc_rng200_enable_set(rng_base, true);
>  }
>  
>  static int iproc_rng200_read(struct hwrng *rng, void *buf, size_t max,
> @@ -153,13 +159,8 @@ static int iproc_rng200_read(struct hwrng *rng, void *buf, size_t max,
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
> +	iproc_rng200_enable_set(priv->base, true);
>  
>  	return 0;
>  }
> @@ -167,12 +168,8 @@ static int iproc_rng200_init(struct hwrng *rng)
>  static void iproc_rng200_cleanup(struct hwrng *rng)
>  {
>  	struct iproc_rng200_dev *priv = to_rng_priv(rng);
> -	uint32_t val;
>  
> -	/* Disable RNG hardware */
> -	val = ioread32(priv->base + RNG_CTRL_OFFSET);
> -	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
> -	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
> +	iproc_rng200_enable_set(priv->base, false);
>  }
>  
>  static int iproc_rng200_probe(struct platform_device *pdev)

