From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] HIFN 795x driver.
Date: Tue, 2 Oct 2007 14:54:31 +0400
Message-ID: <20071002105431.GA28803@2ka.mipt.ru>
References: <20071001124822.GA16017@2ka.mipt.ru> <20071001202214.GA15421@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56141 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbXJBKyv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Oct 2007 06:54:51 -0400
Content-Disposition: inline
In-Reply-To: <20071001202214.GA15421@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi.

On Mon, Oct 01, 2007 at 10:22:14PM +0200, Sebastian Siewior (linux-crypto@ml.breakpoint.cc) wrote:
> >optimisations. It also refuses to register 'ecb(des)' with min and max
> >keylen set to the same number, so right now des and 3des are removed.
> I don't know if I understood you correctly but keep this in mind:
> min and max key size is only important for the output in /proc/crypto.
> If you register an algorithm like AES which is specified for 128, 192
> and 256 bit keys you have to provide all three sizes within one
> algorithm. If you post some code that is not working I could take a
> look.
> 
> After a quick look I can tell:
> - CBC is not working because when you call hifn_setup_session() from
>   hifn_setup_crypto() you don't use the IV supplied by the crypto API
>   (tcrypt) but set the IV to NULL and its length to zero. You should use
>   something like req->base.data, 16 :)

Yep :)
iv sits in req->info, but its size can not be obtained via
crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req)) for tcrypt at
least, so I added a check if req->info is not NULL and mode is not ecb,
in that case I set ivsize according to algorithm, but that can lead to
undetectible errors - if caller has a bug and iv is not set correctly,
so ivsize will be zero, but code will use some garbage as iv.

> - The code looks like you are going to remove
>   hifn_encrypt_aes_ecb_{16,24,32} and set the appropriate

Yes, I've removed that.

>   ACRYPTO_TYPE_AES_??? depending on ctx->current_key_len. Good.
> - You need a software queue in case your HW queue is full and you receive
>   a requests which you may not drop. Currently you don't consider
>   CRYPTO_TFM_REQ_MAY_BACKLOG (it is fine if you can process all requests
>   no mater what).

That is what I do not like, but will implement.

> - You may want to call 
>   crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
>   in hifn_setkey() if the key size is wrong (you may want to move the
>   check for 16/24/32 from hifn_setup_session() to hifn_setkey()).

Done.

> Anyway, it looks fine from what I can say :)

Thanks for review, Sebastian, I will release new version soon with fixed
issues.

-- 
	Evgeniy Polyakov
