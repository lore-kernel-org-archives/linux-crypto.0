From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif - Mark sgl end at the end of data
Date: Mon, 1 Dec 2014 22:40:26 +0800
Message-ID: <20141201144026.GA18008@gondor.apana.org.au>
References: <20141128184036.11421.36028.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39612 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaLAOkc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Dec 2014 09:40:32 -0500
Content-Disposition: inline
In-Reply-To: <20141128184036.11421.36028.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 28, 2014 at 10:40:36AM -0800, Tadeusz Struk wrote:
>
> @@ -468,6 +470,9 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
>  			if (!used)
>  				goto free;
>  
> +			nents = sg_nents(ctx->rsgl.sg);
> +			sg_mark_end(&sg[nents - 1]);

Huh? You're getting nents from the RX side and using it to mark
the TX side? This makes no sense because RX may have no relationship
whatsoever with TX.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
