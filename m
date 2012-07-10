From: Timur Tabi <timur@freescale.com>
Subject: Re: [linuxppc-release] [PATCH 4/4] Talitos: fix the issue of dma
 memory leak
Date: Tue, 10 Jul 2012 16:25:53 -0500
Message-ID: <4FFC9DE1.5060502@freescale.com>
References: <1341900014-20915-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	<leoli@freescale.com>, "David S. Miller" <davem@davemloft.net>
To: Qiang Liu <qiang.liu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:22829
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab2GJVZ6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 17:25:58 -0400
In-Reply-To: <1341900014-20915-1-git-send-email-qiang.liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Qiang Liu wrote:
> An error will be happened when test with mass data:

Please don't use the phrase "fix the issue" in patch summaries.  It's
redundant.

This patch should be titled,

"drivers/crypto: fix memory leak in Talitos driver"

> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 81f8497..a7da48c 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -264,7 +264,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
>  			else
>  				status = error;
> 
> -		dma_unmap_single(dev, request->dma_desc,
> +		 dma_unmap_single(priv->dev, request->dma_desc,

You have an indentation problem here.

-- 
Timur Tabi
Linux kernel developer at Freescale
