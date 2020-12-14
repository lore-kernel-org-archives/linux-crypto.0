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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BC6C2BB9A
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 17:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6869622509
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 17:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440511AbgLNRzA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 12:55:00 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:35798 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732436AbgLNRyt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 12:54:49 -0500
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2020 12:54:46 EST
Received: from [10.136.13.65] (lbrmn-lnxub113.ric.broadcom.net [10.136.13.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id 09ADC80E3;
        Mon, 14 Dec 2020 09:45:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 09ADC80E3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1607967938;
        bh=AmNcKbdMqhqlJWgOqKFduLFh2nSR2MZaSlc8ErgP3rQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=FUIQlo47TnNfZAsYW1U83C/bnAdy06uCY7OVJwD8zVddfyMO5BydpZ04kxxCTyOQO
         OdfvVBvKA9pIXDu545hub0tUoUXGJks/V4yHBto71SLj5d291j7Ht/Oq2Di0SC8YJ4
         KCKy+1sxnC9EJ4zyrToonCGQRIMtWakUdJXsNezA=
Subject: Re: [PATCH 1/2] hwrng: iproc-rng200: Fix disable of the block.
To:     matthias.bgg@kernel.org, mpm@selenic.com,
        herbert@gondor.apana.org.au, rjui@broadcom.com,
        sbranden@broadcom.com, f.fainelli@gmail.com
Cc:     linux-kernel@vger.kernel.org, Julia.Lawall@inria.fr,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, nsaenzjulienne@suse.de,
        linux-crypto@vger.kernel.org, Matthias Brugger <mbrugger@suse.com>
References: <20201214160454.22769-1-matthias.bgg@kernel.org>
From:   Scott Branden <scott.branden@broadcom.com>
Message-ID: <24e22e5a-7371-02b4-1636-2e03def420e3@broadcom.com>
Date:   Mon, 14 Dec 2020 09:45:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214160454.22769-1-matthias.bgg@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-CA
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020-12-14 8:04 a.m., matthias.bgg@kernel.org wrote:
> From: Matthias Brugger <mbrugger@suse.com>
>
> When trying to disable the block we bitwise or the control
> register with value zero. This will leave the block always turned on.
> Fix this by setting the corresponding bit to zero.
>
> Fixes: c83d45d5685f ("hwrng: iproc-rng200 - Add Broadcom IPROC RNG driver")
Commit message needs to be re-written.
I don't think this is an actual fix as the ~RNG_CTL_RNG_RBGEN_MASK already zeros the bit.  This is just a code change, which is fine because it makes things clearer
> Signed-off-by: Matthias Brugger <mbrugger@suse.com>
> ---
>
>  drivers/char/hw_random/iproc-rng200.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
> index 01583faf9893..e106ce3c0146 100644
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
> @@ -61,7 +60,7 @@ static void iproc_rng200_restart(void __iomem *rng_base)
>  	/* Disable RBG */
>  	val = ioread32(rng_base + RNG_CTRL_OFFSET);
>  	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
This mask will already zero the enable bit.
> -	val |= RNG_CTRL_RNG_RBGEN_DISABLE;
> +	val &= ~RNG_CTRL_RNG_RBGEN_ENABLE;
>  	iowrite32(val, rng_base + RNG_CTRL_OFFSET);
>  
>  	/* Clear all interrupt status */
> @@ -174,7 +173,7 @@ static void iproc_rng200_cleanup(struct hwrng *rng)
>  	/* Disable RNG hardware */
>  	val = ioread32(priv->base + RNG_CTRL_OFFSET);
>  	val &= ~RNG_CTRL_RNG_RBGEN_MASK;
> -	val |= RNG_CTRL_RNG_RBGEN_DISABLE;
> +	val &= ~RNG_CTRL_RNG_RBGEN_ENABLE;
>  	iowrite32(val, priv->base + RNG_CTRL_OFFSET);
>  }
>  

