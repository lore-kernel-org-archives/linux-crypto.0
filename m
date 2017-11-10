From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AF_ALG - remove locking in async callback
Date: Fri, 10 Nov 2017 22:10:58 +1100
Message-ID: <20171110111058.GA25914@gondor.apana.org.au>
References: <CAGkQfmNKbSwue13zPh2K1F_kLkpm1_AhsAHK4spRFA0xMvU5PA@mail.gmail.com>
 <4677171.2qOLUIFS1s@positron.chronox.de>
 <20171107063212.GA25491@gondor.apana.org.au>
 <2510520.gYBNS8MAsP@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Romain Izard <romain.izard.pro@gmail.com>,
        linux-crypto@vger.kernel.org,
        Cyrille Pitchen <cyrille.pitchen@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:35754 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbdKJLLR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 06:11:17 -0500
Content-Disposition: inline
In-Reply-To: <2510520.gYBNS8MAsP@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 07, 2017 at 10:05:48AM +0100, Stephan Müller wrote:
>  
>  	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
>  		/* AIO operation */
> +		sock_hold(sk);
>  		areq->iocb = msg->msg_iocb;
>  		aead_request_set_callback(&areq->cra_u.aead_req,
>  					  CRYPTO_TFM_REQ_MAY_BACKLOG,
>  					  af_alg_async_cb, areq);
>  		err = ctx->enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
>  				 crypto_aead_decrypt(&areq->cra_u.aead_req);
> +
> +		/* AIO operation in progress */
> +		if (err == -EINPROGRESS) {
> +			/* Remember output size that will be generated. */
> +			areq->outlen = outlen;
> +
> +			return -EIOCBQUEUED;
> +		}

Since we're allowing backlogs, what about EBUSY?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
