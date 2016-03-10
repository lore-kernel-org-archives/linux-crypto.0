From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/2] crypto: af_alg - add async support to algif_aead
Date: Thu, 10 Mar 2016 18:53:58 +0800
Message-ID: <20160310105358.GA13907@gondor.apana.org.au>
References: <20160201191730.21093.458.stgit@tstruk-mobl1>
 <20160201191735.21093.36524.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55584 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935302AbcCJKyP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Mar 2016 05:54:15 -0500
Content-Disposition: inline
In-Reply-To: <20160201191735.21093.36524.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 01, 2016 at 11:17:35AM -0800, Tadeusz Struk wrote:
>
> @@ -240,6 +255,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
>  		if (!aead_writable(sk)) {
>  			/* user space sent too much data */
>  			aead_put_sgl(sk);
> +			aead_reset_ctx(ctx);

It seems that every call to aead_put_sgl is followed by a call to
aead_reset_ctx.  So how about calling the latter from aead_put_sgl
directly?

> +	while (atomic_read(&sk->sk_refcnt) != 0 && ctr++ < 10)
> +		msleep(100);
>  
> +	WARN_ON(atomic_read(&sk->sk_refcnt) != 0);

The whole point of using sock_hold is to get rid of the wait so
why is this still needed?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
