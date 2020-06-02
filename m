Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62DA9C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 11:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36A662068D
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 11:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgFBLcx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 07:32:53 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52871 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgFBLcx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 07:32:53 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 22B5EE0005;
        Tue,  2 Jun 2020 11:32:49 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200602092019.31878-1-piotr.stankiewicz@intel.com>
References: <20200602092019.31878-1-piotr.stankiewicz@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Subject: Re: [PATCH 05/15] crypto: inside-secure - use PCI_IRQ_MSI_TYPES where appropriate
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Message-ID: <159109756912.870467.7291427996953916910@kwain>
Date:   Tue, 02 Jun 2020 13:32:49 +0200
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Piotr,

Quoting Piotr Stankiewicz (2020-06-02 11:20:19)
> Seeing as there is shorthand available to use when asking for any type
> of interrupt, or any type of message signalled interrupt, leverage it.
> 
> Signed-off-by: Piotr Stankiewicz <piotr.stankiewicz@intel.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>

Reviewed-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks,
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index 2cb53fbae841..1b2faa2a6ab0 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1567,7 +1567,7 @@ static int safexcel_probe_generic(void *pdev,
>                 ret = pci_alloc_irq_vectors(pci_pdev,
>                                             priv->config.rings + 1,
>                                             priv->config.rings + 1,
> -                                           PCI_IRQ_MSI | PCI_IRQ_MSIX);
> +                                           PCI_IRQ_MSI_TYPES);
>                 if (ret < 0) {
>                         dev_err(dev, "Failed to allocate PCI MSI interrupts\n");
>                         return ret;
> -- 
> 2.17.2
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
