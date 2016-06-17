From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [patch] crypto: drbg - fix an error code in drbg_init_sym_kernel()
Date: Fri, 17 Jun 2016 11:19:58 +0200
Message-ID: <1774858.Ao0ox7E6zA@tauon.atsec.com>
References: <20160617091618.GC25609@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36706 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbcFQJUD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 05:20:03 -0400
In-Reply-To: <20160617091618.GC25609@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 17. Juni 2016, 12:16:19 schrieb Dan Carpenter:

Hi Dan,

> We accidentally return PTR_ERR(NULL) which is success but we should
> return -ENOMEM.
> 
> Fixes: 355912852115 ('crypto: drbg - use CTR AES instead of ECB AES')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Stephan Mueller <smueller@chronox.de>

That points to an error in the documentation of skcipher_request_alloc.

I will send a follow-up patch.
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index ded8638..6872d15 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1686,7 +1686,7 @@ static int drbg_init_sym_kernel(struct drbg_state
> *drbg) if (!req) {
>  		pr_info("DRBG: could not allocate request queue\n");
>  		drbg_fini_sym_kernel(drbg);
> -		return PTR_ERR(req);
> +		return -ENOMEM;
>  	}
>  	drbg->ctr_req = req;
>  	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,


Ciao
Stephan
