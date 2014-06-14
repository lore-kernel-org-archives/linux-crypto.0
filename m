From: Marek Vasut <marex@denx.de>
Subject: Re: [patch] crypto: caam - remove duplicate FIFOST_CONT_MASK define
Date: Sat, 14 Jun 2014 05:45:54 +0200
Message-ID: <201406140545.54199.marex@denx.de>
References: <20140609151941.GN9600@mwanda>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Alex Porosanu <alexandru.porosanu@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:58833 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaFNDsT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Jun 2014 23:48:19 -0400
In-Reply-To: <20140609151941.GN9600@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, June 09, 2014 at 05:19:41 PM, Dan Carpenter wrote:
> The FIFOST_CONT_MASK define is cut and pasted twice so we can delete the
> second instance.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
> index 7e4500f..d397ff9 100644
> --- a/drivers/crypto/caam/desc.h
> +++ b/drivers/crypto/caam/desc.h
> @@ -321,7 +321,6 @@ struct sec4_sg_entry {
>  /* Continue - Not the last FIFO store to come */
>  #define FIFOST_CONT_SHIFT	23
>  #define FIFOST_CONT_MASK	(1 << FIFOST_CONT_SHIFT)
> -#define FIFOST_CONT_MASK	(1 << FIFOST_CONT_SHIFT)
> 
>  /*
>   * Extended Length - use 32-bit extended length that

Sigh, I'm surprised the compiler didn't choke about this.

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
