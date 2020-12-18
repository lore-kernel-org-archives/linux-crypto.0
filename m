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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE901C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 17:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81E4D23AFD
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 17:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgLRRi7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 12:38:59 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:42726 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728013AbgLRRi7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 12:38:59 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Dec 2020 12:38:58 EST
Received: from [10.136.13.65] (lbrmn-lnxub113.ric.broadcom.net [10.136.13.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id AD18380E2;
        Fri, 18 Dec 2020 09:31:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com AD18380E2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1608312662;
        bh=ASc3+eHClKI6umumcLf09VzAeUQYT7bLZu87KGeByM4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=kSV+/mkSOaWepR6vm/S+hVi0wHDKslY0xrBaLOW/MbqmnfjYeo3sNNAB7vSn/5p9J
         MMMIq0VqulmPS7TiwifhjfFcz8jrikCRE1bVDXqFM9H/TjE+pnOKWPUWHQJGS8mX9m
         nhLq1CIJI4oO4N+uZt7DzzB9muCi5F4pDGTFsNMo=
Subject: Re: [PATCH v2 1/2] hwrng: iproc-rng200: Fix disable of the block.
To:     matthias.bgg@kernel.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, rjui@broadcom.com,
        sbranden@broadcom.com, f.fainelli@gmail.com
Cc:     linux-kernel@vger.kernel.org, Julia.Lawall@inria.fr,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, nsaenzjulienne@suse.de,
        linux-crypto@vger.kernel.org, Matthias Brugger <mbrugger@suse.com>
References: <20201218105708.28480-1-matthias.bgg@kernel.org>
From:   Scott Branden <scott.branden@broadcom.com>
Message-ID: <c00991f0-c353-c273-de58-a6813ba1fa71@broadcom.com>
Date:   Fri, 18 Dec 2020 09:30:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201218105708.28480-1-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-CA
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020-12-18 2:57 a.m., matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
>
> When trying to disable the block we bitwise or the control
> register with value zero. This is confusing as using bitwise or with
> value zero doesn't have any effect at all. Drop this as we already set
> the enable bit to zero by appling inverted RNG_RBGEN_MASK.
>
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
Acked-by: Scott Branden <scott.branden@broadcom.com>
>
> ---
>
> Changes in v2:
> - fix commit message, dropping Fixes tag
> - drop inverted RNT_RBGEN_ENABLE in disable case
>
>  drivers/char/hw_random/iproc-rng200.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
> index 01583faf9893..70cd818a0f31 100644
> --- a/drivers/char/hw_random/iproc-rng200.c
> +++ b/drivers/char/hw_random/iproc-rng200.c
> @@ -28,7 +28,6 @@
>  #define RNG_CTRL_OFFSET					0x00
>  #define RNG_CTRL_RNG_RBGEN_MASK				0x00001FFF
>  #define RNG_CTRL_RNG_RBGEN_ENABLE			0x00000001
> -#define RNG_CTRL_RNG_RBGEN_DISABLE			0x00000000
>  
>  #define RNG_SOFT_RESET_OFFSET				0x04
>  #define RNG_SOFT_RESET					0x00000001
> @@ -61,7 +60,6 @@ static void iproc_rng200_restart(void __iomem *rng_base)
>  	/* Disable RBG */
>  	val = ioread32(rng_base + RNG_CTRL_OFFSET);
>  	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
> -	val |= RNG_CTRL_RNG_RBGEN_DISABLE;
>  	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
>  
>  	/* Clear all interrupt status */
> @@ -174,7 +172,6 @@ static void iproc_rng200_cleanup(struct hwrng *rng)
>  	/* Disable RNG hardware */
>  	val = ioread32(priv->base + RNG_CTRL_OFFSET);
>  	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
> -	val |= RNG_CTRL_RNG_RBGEN_DISABLE;
>  	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
>  }
>  

