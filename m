From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v1 3/3] crypto: cavium - Register the CNN55XX supported crypto algorithms.
Date: Thu, 11 May 2017 14:22:30 +0200
Message-ID: <2489871.hhvjNBQWWt@tauon.chronox.de>
References: <20170510130640.5838-1-Jampala.Srikanth@cavium.com> <3575749.J6klBtBYWh@tauon.chronox.de> <685383f7-6ae2-31fe-f081-2ac739343137@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        George.Cherian@cavium.com, Nidadavolu.Murthy@cavium.com,
        Sreerama.Gadam@cavium.com, Ram.Kumar@cavium.com
To: srikanth jampala <jsrikanth@caviumnetworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59470 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754911AbdEKMWf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 May 2017 08:22:35 -0400
In-Reply-To: <685383f7-6ae2-31fe-f081-2ac739343137@caviumnetworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 11. Mai 2017, 14:18:34 CEST schrieb srikanth jampala:

Hi srikanth,

> Hi Stephan,
> 
> On Wednesday 10 May 2017 07:26 PM, Stephan Müller wrote:
> > Am Mittwoch, 10. Mai 2017, 15:06:40 CEST schrieb Srikanth Jampala:
> > 
> > Hi Srikanth,
> > 
> > In general: you are using the ablkcipher API. I think it is on its way out
> > and being replaced with skcipher.
> > 
> > Maybe it makes sense to replace it here too. It could be as simple as s/
> > ablkcipher/skcipher/g
> 
> Sure, I will do the changes accordingly.
> As per my understanding, I see the following changes,
> 1. CRYPTO_ALG_TYPE_ABLKCIPHER changed to CRYPTO_ALG_TYPE_SKCIPHER
> 2. nitrox_ablkcipher_foo() changed to nitrox_skcipher_foo()
> 
> Please let me know, any other changes I have to consider?

What about all crypto_ablkcipher* function calls / structs? Also all 
ablkcipher_request function calls/structs?
> 
> >> +static inline int nitrox_ablkcipher_setkey(struct crypto_ablkcipher
> >> *cipher,
> >> +                                          int aes_keylen, const u8 *key,
> >> +                                          unsigned int keylen)
> >> +{
> >> +       struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
> >> +       struct nitrox_crypto_instance *inst = crypto_tfm_ctx(tfm);
> >> +       struct flexi_crypto_context *fctx;
> >> +       enum flexi_cipher cipher_type;
> >> +       const char *name;
> >> +
> >> +       name = crypto_tfm_alg_name(tfm);
> >> +       cipher_type = flexi_cipher_type(name);
> >> +       if (cipher_type == CIPHER_INVALID) {
> >> +               pr_err("unsupported cipher: %s\n", name);
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       /* fill crypto context */
> >> +       fctx = inst->u.fctx;
> >> +       fctx->flags = 0;
> >> +       fctx->w0.cipher_type = cipher_type;
> >> +       fctx->w0.aes_keylen = aes_keylen;
> >> +       fctx->w0.iv_source = IV_FROM_DPTR;
> >> +       fctx->flags = cpu_to_be64(*(u64 *)&fctx->w0);
> >> +       /* copy the key to context */
> >> +       memcpy(fctx->crypto.u.key, key, keylen);
> > 
> > Could you help me finding the location where this memory is zeroized upon
> > release?
> 
> Currently, we are not zeroized the context in release.
> We are doing it at the time of allocation.

You store a key in a piece of heap memory. I guess you want to zeroize that 
key memory before releasing?


Ciao
Stephan
