From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [1/1] HIFN 795x driver.
Date: Mon, 1 Oct 2007 22:22:14 +0200
Message-ID: <20071001202214.GA15421@Chamillionaire.breakpoint.cc>
References: <20071001124822.GA16017@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60783 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244AbXJAUWT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Oct 2007 16:22:19 -0400
Content-Disposition: inline
In-Reply-To: <20071001124822.GA16017@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Evgeniy Polyakov | 2007-10-01 16:48:22 [+0400]:

Hello Evgeniy,

>optimisations. It also refuses to register 'ecb(des)' with min and max
>keylen set to the same number, so right now des and 3des are removed.
I don't know if I understood you correctly but keep this in mind:
min and max key size is only important for the output in /proc/crypto.
If you register an algorithm like AES which is specified for 128, 192
and 256 bit keys you have to provide all three sizes within one
algorithm. If you post some code that is not working I could take a
look.

After a quick look I can tell:
- CBC is not working because when you call hifn_setup_session() from
  hifn_setup_crypto() you don't use the IV supplied by the crypto API
  (tcrypt) but set the IV to NULL and its length to zero. You should use
  something like req->base.data, 16 :)
- The code looks like you are going to remove
  hifn_encrypt_aes_ecb_{16,24,32} and set the appropriate
  ACRYPTO_TYPE_AES_??? depending on ctx->current_key_len. Good.
- You need a software queue in case your HW queue is full and you receive
  a requests which you may not drop. Currently you don't consider
  CRYPTO_TFM_REQ_MAY_BACKLOG (it is fine if you can process all requests
  no mater what).
- You may want to call 
  crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
  in hifn_setkey() if the key size is wrong (you may want to move the
  check for 16/24/32 from hifn_setup_session() to hifn_setkey()).

Anyway, it looks fine from what I can say :)

>	Evgeniy Polyakov

Sebastian
