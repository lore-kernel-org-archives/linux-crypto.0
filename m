From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] crypto: chcr - Add AEAD algos.
Date: Tue, 24 Jan 2017 13:43:13 +0300
Message-ID: <20170124104313.GD4201@mwanda>
References: <20161201204858.GA10660@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: harsh@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32264 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdAXKnW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Jan 2017 05:43:22 -0500
Content-Disposition: inline
In-Reply-To: <20161201204858.GA10660@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ping?

regards,
dan carpenter

On Thu, Dec 01, 2016 at 11:48:58PM +0300, Dan Carpenter wrote:
> Hello Harsh Jain,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 2debd3325e55: "crypto: chcr - Add AEAD algos." from Nov 29, 
> 2016, leads to the following Smatch complaint:
> 
> 	drivers/crypto/chelsio/chcr_algo.c:2460 chcr_aead_op()
> 	warn: variable dereferenced before check 'ctx' (see line 2457)
> 
> 	drivers/crypto/chelsio/chcr_algo.c:2460 chcr_aead_op()
> 	warn: variable dereferenced before check 'ctx->dev' (see line 2457)
> 
> drivers/crypto/chelsio/chcr_algo.c
>   2456		struct chcr_context *ctx = crypto_aead_ctx(tfm);
>   2457		struct uld_ctx *u_ctx = ULD_CTX(ctx);
>                                         ^^^^^^^^^^^^
> Derefences both.
> 
>   2458		struct sk_buff *skb;
>   2459	
>   2460		if (ctx && !ctx->dev) {
>                     ^^^^^^^^^^^^^^^^
> Check is too late.
> 
>   2461			pr_err("chcr : %s : No crypto device.\n", __func__);
>   2462			return -ENXIO;
> 
> regards,
> dan carpenter
