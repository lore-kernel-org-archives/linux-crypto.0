From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Wed, 02 Apr 2008 14:03:54 +0800
Message-ID: <E1Jgw4g-0008Uc-00@gondolin.me.apana.org.au>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc>
Cc: stefan@the2masters.de, linux-crypto@vger.kernel.org
To: linux-crypto@ml.breakpoint.cc (Sebastian Siewior)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44536 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751253AbYDBGED (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2008 02:04:03 -0400
In-Reply-To: <20080328223333.GB24018@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior <linux-crypto@ml.breakpoint.cc> wrote:
>
> @@ -205,14 +208,22 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
> static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> {
>        struct aes_ctx *ctx = aes_ctx(tfm);
> -       padlock_reset_key();
> +
> +       if (last_key != ctx) {
> +               last_key = ctx;
> +               padlock_reset_key();
> +       }

What if user-space invokes the padlock when xts is preempted?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
