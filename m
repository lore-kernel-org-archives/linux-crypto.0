From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Thu, 23 Nov 2017 10:32:12 +0100
Message-ID: <CACT4Y+bUBdDoshbfP9OfdQ4yjz04OTRyA-wReOZL5H8gCzEjkA@mail.gmail.com>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com>
 <20171121204628.GA56006@google.com> <CACT4Y+bX-apiqnObwXJ2YsYDsW9vN0zUAzMRp+yZNwy=v9L6fw@mail.gmail.com>
 <1691937.ipLsOujZNS@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:40017 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbdKWJce (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Nov 2017 04:32:34 -0500
Received: by mail-pg0-f43.google.com with SMTP id u3so13783647pgn.7
        for <linux-crypto@vger.kernel.org>; Thu, 23 Nov 2017 01:32:34 -0800 (PST)
In-Reply-To: <1691937.ipLsOujZNS@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 22, 2017 at 6:08 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Mittwoch, 22. November 2017, 11:44:51 CET schrieb Dmitry Vyukov:
>
> Hi Dmitry,
>
>>
>> Thanks! I think we can incorporate this into syzkaller.
>>
>> One question: what's the relation between alg names and type ("aead",
>> "hash", "rng", "skcipher")?
>
> If you refer to AF_ALG, then the following applies:
>
> AF_ALG type of aead -> kernel crypto API: crypto_aead_*, aead_request_*
>
> AF_ALG type of skcipher -> kernel crypto API: crypto_skcipher_*,
> skcipher_request_*
>
> AF_ALG type of hash -> kernel crypto API: crypto_ahash_*, ahash_request_*
>
> AF_ALG type of rng -> kernel crypto API: crypto_rng_*
>
>
>> I remember I already looked at it before
>> and could not figure it out. Are all algorithms and templates
>> partitioned between types? Or they are orthogonal?
>
> If you refer to the cipher names, there are two types: templates and cipher
> implementations. See [1] for details. [2] gives you some ideas of the
> interrelationships between the templates and the ciphers.
>
> The relationship between the names and the AF_ALG names mentioned above is
> defined with the .cra_flags in the cipher specification of each cipher
> implementation. See [3] for details.
>
> Note, I started some fuzzing work in my libkcapi test application. See [4] for
> the implementation.
>
> [1] http://www.chronox.de/crypto-API/crypto/architecture.html#crypto-api-cipher-references-and-priority
>
> [2] http://www.chronox.de/crypto-API/crypto/architecture.html#internal-structure-of-kernel-crypto-api
>
> [3] http://www.chronox.de/crypto-API/crypto/architecture.html#cipher-allocation-type-and-masks
>
> [4] https://github.com/smuellerDD/libkcapi/blob/master/test/kcapi-main.c line
> 522


I've read the links and starring at the code, but still can't get it.
The question is about textual type names in sockaddr.
.cra_flags does not specify textual names.
[3] again talks about int flags rather than textual names.

I see they are used here:
http://www.chronox.de/crypto-API/crypto/userspace-if.html#aead-cipher-api

but it merely says:

    .salg_type = "aead", /* this selects the symmetric cipher */
    .salg_name = "gcm(aes)" /* this is the cipher name */

and does not explain why it is must be "aead" for  "gcm(aes)", nor why
would "skcipher" fail for  "gcm(aes)" (would it?).

These integer flags in sockaddr_alg.feat/mask seem to be better always
be 0 (because they can only fail an otherwise passing bind, right?).
But the textual type seems to matter, because bind first looks at type
and then everything else happens as callbacks on type.

I've found these guys:

tatic const struct crypto_type crypto_skcipher_type2 = {
.extsize = crypto_skcipher_extsize,
.init_tfm = crypto_skcipher_init_tfm,
.free = crypto_skcipher_free_instance,
#ifdef CONFIG_PROC_FS
.show = crypto_skcipher_show,
#endif
.report = crypto_skcipher_report,
.maskclear = ~CRYPTO_ALG_TYPE_MASK,
.maskset = CRYPTO_ALG_TYPE_BLKCIPHER_MASK,
.type = CRYPTO_ALG_TYPE_SKCIPHER,
.tfmsize = offsetof(struct crypto_skcipher, base),
};

But it still does not make sense to me.
 CRYPTO_ALG_TYPE_SKCIPHER const is not mentioned in any actual algorithms.
and CRYPTO_ALG_TYPE_BLKCIPHER_MASK is 0xc, which selects
CRYPTO_ALG_TYPE_BLKCIPHER, CRYPTO_ALG_TYPE_KPP and
CRYPTO_ALG_TYPE_RNG. And it looks like a random subset of
constants....
