Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95C3C0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 08:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6BB520B1F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 08:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfHEIgF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 04:36:05 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:35327 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfHEIgF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 04:36:05 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id A4EB5200006;
        Mon,  5 Aug 2019 08:36:02 +0000 (UTC)
Date:   Mon, 5 Aug 2019 10:36:02 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCHv3 3/4] crypto: inside-secure - add support for PCI based
 FPGA development board
Message-ID: <20190805083602.GG14470@kwain>
References: <1564586959-9963-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564586959-9963-4-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564586959-9963-4-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Pascal,

The patch looks mostly good, just a few comments below.

On Wed, Jul 31, 2019 at 05:29:18PM +0200, Pascal van Leeuwen wrote:
> @@ -381,10 +383,11 @@ static int safexcel_hw_init(struct safexcel_crypto_priv *priv)
>  		       EIP197_HIA_DxE_CFG_MAX_DATA_SIZE(8);
>  		val |= EIP197_HIA_DxE_CFG_DATA_CACHE_CTRL(WR_CACHE_3BITS);
>  		val |= EIP197_HIA_DSE_CFG_ALWAYS_BUFFERABLE;
> -		/* FIXME: instability issues can occur for EIP97 but disabling it impact
> -		 * performances.
> +		/*
> +		 * FIXME: instability issues can occur for EIP97 but disabling
> +		 * it impacts performance.
>  		 */

No need to change the comment style here.

> @@ -514,7 +517,8 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
>  	struct safexcel_context *ctx;
>  	int ret, nreq = 0, cdesc = 0, rdesc = 0, commands, results;
> 
> -	/* If a request wasn't properly dequeued because of a lack of resources,
> +	/*
> +	 * If a request wasn't properly dequeued because of a lack of resources,
>  	 * proceeded it first,
>  	 */

Ditto.

> @@ -543,7 +547,8 @@ void safexcel_dequeue(struct safexcel_crypto_priv *priv, int ring)
> 
> -		/* In case the send() helper did not issue any command to push
> +		/*
> +		 * In case the send() helper did not issue any command to push

Ditto.

> -	/* Not enough resources to handle all the requests. Bail out and save
> +	/*
> +	 * Not enough resources to handle all the requests. Bail out and save

Ditto.

> @@ -731,7 +738,8 @@ static inline void safexcel_handle_result_descriptor(struct safexcel_crypto_priv
>  		       EIP197_xDR_PROC_xD_COUNT(tot_descs * priv->config.rd_offset),
>  		       EIP197_HIA_RDR(priv, ring) + EIP197_HIA_xDR_PROC_COUNT);
> 
> -	/* If the number of requests overflowed the counter, try to proceed more
> +	/*
> +	 * If the number of requests overflowed the counter, try to proceed more

Ditto.

> +#if IS_ENABLED(CONFIG_OF)
> +/*
> + * for Device Tree platform driver
> + */

Single line comment should be:

/* comment */

> +#if IS_ENABLED(CONFIG_PCI)
> +/*
> + * PCIE devices - i.e. Inside Secure development boards
> + */

Here as well.

> +static int crypto_is_pci_probe(struct pci_dev *pdev,
> +			       const struct pci_device_id *ent)

The whole driver uses the "safexcel_" prefix for functions. You should
use it here as well for consistency.

> +void crypto_is_pci_remove(struct pci_dev *pdev)

Here as well.

> +static const struct pci_device_id crypto_is_pci_ids[] = {

Here as well.

> +static struct pci_driver crypto_is_pci_driver = {

Here as well.

> +static int __init crypto_is_init(void)

Here as well.

> +static void __exit crypto_is_exit(void)

Here as well.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
