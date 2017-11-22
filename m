From: Stephan Mueller <smueller@chronox.de>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Wed, 22 Nov 2017 18:08:55 +0100
Message-ID: <1691937.ipLsOujZNS@tauon.chronox.de>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com> <20171121204628.GA56006@google.com> <CACT4Y+bX-apiqnObwXJ2YsYDsW9vN0zUAzMRp+yZNwy=v9L6fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42400 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751476AbdKVRI6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 12:08:58 -0500
In-Reply-To: <CACT4Y+bX-apiqnObwXJ2YsYDsW9vN0zUAzMRp+yZNwy=v9L6fw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 22. November 2017, 11:44:51 CET schrieb Dmitry Vyukov:

Hi Dmitry,

> 
> Thanks! I think we can incorporate this into syzkaller.
> 
> One question: what's the relation between alg names and type ("aead",
> "hash", "rng", "skcipher")?

If you refer to AF_ALG, then the following applies:

AF_ALG type of aead -> kernel crypto API: crypto_aead_*, aead_request_*

AF_ALG type of skcipher -> kernel crypto API: crypto_skcipher_*, 
skcipher_request_*

AF_ALG type of hash -> kernel crypto API: crypto_ahash_*, ahash_request_*

AF_ALG type of rng -> kernel crypto API: crypto_rng_*


> I remember I already looked at it before
> and could not figure it out. Are all algorithms and templates
> partitioned between types? Or they are orthogonal?

If you refer to the cipher names, there are two types: templates and cipher 
implementations. See [1] for details. [2] gives you some ideas of the 
interrelationships between the templates and the ciphers.

The relationship between the names and the AF_ALG names mentioned above is 
defined with the .cra_flags in the cipher specification of each cipher 
implementation. See [3] for details.

Note, I started some fuzzing work in my libkcapi test application. See [4] for 
the implementation.

[1] http://www.chronox.de/crypto-API/crypto/architecture.html#crypto-api-cipher-references-and-priority

[2] http://www.chronox.de/crypto-API/crypto/architecture.html#internal-structure-of-kernel-crypto-api

[3] http://www.chronox.de/crypto-API/crypto/architecture.html#cipher-allocation-type-and-masks

[4] https://github.com/smuellerDD/libkcapi/blob/master/test/kcapi-main.c line 
522

Ciao
Stephan
