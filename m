From: Stephan Mueller <smueller@chronox.de>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Wed, 22 Nov 2017 18:15:55 +0100
Message-ID: <3689525.KZ9gHdGHIR@tauon.chronox.de>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com> <8790288.6NrG2qtxDg@tauon.chronox.de> <CACT4Y+YSZngVgt24DyQD1hrMyBF9uue=aGzKcWNA6CFDuCO=ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42404 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751458AbdKVRP5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 12:15:57 -0500
In-Reply-To: <CACT4Y+YSZngVgt24DyQD1hrMyBF9uue=aGzKcWNA6CFDuCO=ug@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 22. November 2017, 18:03:14 CET schrieb Dmitry Vyukov:

Hi Dmitry,

> On Wed, Nov 22, 2017 at 5:54 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > Am Dienstag, 21. November 2017, 21:46:28 CET schrieb Eric Biggers:
> > 
> > Hi Eric,
> > 
> >> (There is probably more to improve for AF_ALG besides the algorithm
> >> names;
> >> this is just what I happened to notice for now.)
> > 
> > Just grepping may not cover all possibilities. Attached is a script that I
> > use to invoke an array different tests for different cipher
> > implementations. For now, it only covers C, ASM and CPU-based cipher
> > implementations.
> 
> Hi Stephan,
> 
> I see it has lots of names hardcoded. Is it possible to extract
> up-to-date list from kernel? Maybe at runtime from running kernel?

Nope, this is currently not possible because the names where templates are 
used are "created" on the fly. I.e. the kernel parses the name up to a 
paranthesis and tries to allocate that name.

Thus, the content of /proc/crypto is NOT complete per definition as it only 
contains registered ciphers and allocated templates/cipher combos.
> 
> What's the max number of arguments for a template? I see there is at least
> 2: rfc4106(gcm_base(ctr(aes-aesni),ghash-clmulni))
> can there be more?

This is always defined by an implementation. For gcm_base, you see that as 
follows: crypto/gcm.c: see all invocations of crypto_gcm_create_common where 
the last but one argument is the CTR implementation and the last argument is 
the GHASH implementation.
> 
> Do you know answer to this question by any chance?
> what's the relation between alg names and type ("aead", "hash", "rng",
> "skcipher")? I remember I already looked at it before and could not
> figure it out. Are all algorithms and templates partitioned between
> types? Or they are orthogonal?

See other email.

> 
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe keyrings" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Ciao
Stephan
