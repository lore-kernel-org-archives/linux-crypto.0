From: Stephan Mueller <smueller@chronox.de>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Thu, 23 Nov 2017 13:32:13 +0100
Message-ID: <7916986.MeZVoJOkMR@tauon.chronox.de>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com> <1824692.QiU0QWCXD7@tauon.chronox.de> <CACT4Y+ZSUWEni6SdmM5K-CsZshq77CNGdZedC0tYhcv6p=7Qvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42416 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751497AbdKWMcQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Nov 2017 07:32:16 -0500
In-Reply-To: <CACT4Y+ZSUWEni6SdmM5K-CsZshq77CNGdZedC0tYhcv6p=7Qvg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. November 2017, 12:27:30 CET schrieb Dmitry Vyukov:

Hi Dmitry,

> Hi Stephan,
> 
> Thanks for the explanation! I am starting to digesting it.
> 
> You say that:
> > static const struct crypto_type crypto_skcipher_type2 = {
> > 
> >         .type = CRYPTO_ALG_TYPE_SKCIPHER,
> 
> will select implementations of types SKCIPHER or ABLKCIPHER.
> But there are no such implementations. I see only implementation of
> types CIPHER and BLKCIPHER:
> 
> .cra_flags = CRYPTO_ALG_TYPE_CIPHER,
> crypto/seed.c
> 
> .cra_flags          =   CRYPTO_ALG_TYPE_BLKCIPHER,
> crypto/salsa20_generic.c

The blkcipher (symmetric synchronous cipher) is made asynchronous (ABLKCIPHER) 
via cryptd() implemented in crypto/cryptd.c. When using the skcipher API 
without any specific flags, it will allocate cryptd(salsa20_generic) in your 
case above transparently and mark it as an ABLKCIPHER.

CIPHER is a block cipher without block chaining which is only capable of 
encrypting one block. You can only use it with the crypto_cipher* API.

As this API is not exported via AF_ALG, you cannot access those ciphers from 
user space directly (albeit they are accessible indirectly via templates 
implementing block chaining algos)
> 
> SKCIPHER=0x5. Does it mean that it selects implementations that has
> ((cra_flags&CRYPTO_ALG_TYPE_MASK)&SKCIPHER) != 0? I.e. CIPHER and
> BLKCIPHER would match that.
> 
> But then I am again confused, because CRYPTO_ALG_TYPE_AEAD is 0x3 so
> it would match CRYPTO_ALG_TYPE_COMPRESS and CRYPTO_ALG_TYPE_CIPHER
> again. Does not make sense to me...

COMPRESS / PCOMPRESS implementations are accessible via the crypto_compress_* 
APIs. There is (currently) no AF_ALG interface for this API.
> 
> 
> And to confirm, we can't reach compress from userspace because only
> these 4 types are exposed "aead", "hash", "rng", "skcipher". Is it
> correct?

Precisely. Look into algif_*.c which kernel crypto API calls are exported to 
user space.
> --
> To unsubscribe from this list: send the line "unsubscribe keyrings" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Ciao
Stephan
