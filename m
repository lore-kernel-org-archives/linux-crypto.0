Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E2AC433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 09:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8167C20665
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 09:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfG3JIO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 05:08:14 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:50081 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfG3JIO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 05:08:14 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id A50D51C0009;
        Tue, 30 Jul 2019 09:08:11 +0000 (UTC)
Date:   Tue, 30 Jul 2019 11:08:11 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Message-ID: <20190730090811.GF3108@kwain>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-3-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564145005-26731-3-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Fri, Jul 26, 2019 at 02:43:24PM +0200, Pascal van Leeuwen wrote:
> +	if (priv->version == EIP197D_MRVL) {

I see you renamed EIP197D to EIP197D_MRVL in the v2. Such a rename
should not be part of this patch, as it has nothing to do with the
engine you're adding support for.

Is there a reason to have this one linked to Marvell? Aren't there other
EIP197 (or EIP97) engines not on Marvell SoCs? (I'm pretty sure I know
at least one).

> -	switch (priv->version) {
> -	case EIP197B:
> -		dir = "eip197b";
> -		break;
> -	case EIP197D:
> -		dir = "eip197d";
> -		break;
> -	default:
> +	if (priv->version == EIP97IES_MRVL)
>  		/* No firmware is required */
>  		return 0;
> -	}
> +	else if (priv->version == EIP197D_MRVL)
> +		dir = "eip197d";
> +	else
> +		/* Default to minimum EIP197 config */
> +		dir = "eip197b";

You're moving the default choice from "no firmware" to being a specific
one.

> -			if (priv->version != EIP197B)
> +			if (!(priv->version == EIP197B_MRVL))

'!=' ?

> -			/* Fallback to the old firmware location for the
> +			/*
> +			 * Fallback to the old firmware location for the

This is actually the expected comment style in net/ and crypto/. (There
are other examples).

>  	/* For EIP197 set maximum number of TX commands to 2^5 = 32 */
> -	if (priv->version == EIP197B || priv->version == EIP197D)
> +	if (priv->version != EIP97IES_MRVL)

I would really prefer having explicit checks here. More engines will be
supported in the future and doing will help. (There are others).

> @@ -869,9 +898,6 @@ static int safexcel_register_algorithms(struct safexcel_crypto_priv *priv)
>  	for (i = 0; i < ARRAY_SIZE(safexcel_algs); i++) {
>  		safexcel_algs[i]->priv = priv;
>  
> -		if (!(safexcel_algs[i]->engines & priv->version))
> -			continue;

You should remove the 'engines' flag in a separate patch. I'm really not
sure about this. I don't think all the IS EIP engines support the same
sets of algorithms?

> @@ -925,22 +945,18 @@ static void safexcel_configure(struct safexcel_crypto_priv *priv)
>  	val = readl(EIP197_HIA_AIC_G(priv) + EIP197_HIA_OPTIONS);
>  
>  	/* Read number of PEs from the engine */
> -	switch (priv->version) {
> -	case EIP197B:
> -	case EIP197D:
> -		mask = EIP197_N_PES_MASK;
> -		break;
> -	default:
> +	if (priv->version == EIP97IES_MRVL)
>  		mask = EIP97_N_PES_MASK;
> -	}
> +	else
> +		mask = EIP197_N_PES_MASK;
> +

You also lose readability here.

> +	if (IS_ENABLED(CONFIG_PCI) && (priv->version == EIP197_DEVBRD)) {

You have extra parenthesis here.

> -	platform_set_drvdata(pdev, priv);

Side note: this is why you had to send the patch fixing rmmod.

>  static void safexcel_hw_reset_rings(struct safexcel_crypto_priv *priv)
> @@ -1160,6 +1139,78 @@ static void safexcel_hw_reset_rings(struct safexcel_crypto_priv *priv)
>  	}
>  }
>  
> +#if (IS_ENABLED(CONFIG_OF))

No need for the extra parenthesis here.

> +	if (priv->version == EIP197_DEVBRD) {

It seems to me this is mixing an engine version information and a board
were the engine is integrated. Are there differences in the engine
itself, or only in the way it's wired?

We had this discussion on the v1. Your point was that you wanted this
information to be in .data. One solution I proposed then was to use a
struct (with both a 'version' and a 'flag' variable inside) instead of
a single 'version' variable, so that we still can make checks on the
version itself and not on something too specific.

> +static int __init crypto_is_init(void)
> +{
> +	int rc;
> +
> +	#if (IS_ENABLED(CONFIG_OF))
> +		/* Register platform driver */
> +		platform_driver_register(&crypto_safexcel);
> +	#endif

When used in the code directly, you should use:

  if (IS_ENABLED(CONFIG_OF))

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
