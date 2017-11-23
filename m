From: Stephan Mueller <smueller@chronox.de>
Subject: Re: x509 parsing bug + fuzzing crypto in the userspace
Date: Thu, 23 Nov 2017 12:10:36 +0100
Message-ID: <1824692.QiU0QWCXD7@tauon.chronox.de>
References: <CAG_fn=XJZG_MJXXgos5jZmOThKho=uSvwgfhkMSYONZ04PKKaw@mail.gmail.com> <CACT4Y+b9DGu5YPG-+-AJGt0sAEJr5r+gObHza5EBy9c12rQrzw@mail.gmail.com> <CACT4Y+a78eXZQn9gyrWdYi0Jm11FWcxZ=qW1B1-ZvtPpk_9dcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers@google.com>,
        Alexander Potapenko <glider@google.com>,
        linux-crypto@vger.kernel.org, Kostya Serebryany <kcc@google.com>,
        keyrings@vger.kernel.org, Andrey Konovalov <andreyknvl@google.com>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42412 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752571AbdKWLKj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Nov 2017 06:10:39 -0500
In-Reply-To: <CACT4Y+a78eXZQn9gyrWdYi0Jm11FWcxZ=qW1B1-ZvtPpk_9dcA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. November 2017, 10:37:35 CET schrieb Dmitry Vyukov:

Hi Dmitry,

> >> I've read the links and starring at the code, but still can't get it.
> >> The question is about textual type names in sockaddr.
> >> .cra_flags does not specify textual names.
> >> [3] again talks about int flags rather than textual names.
> >> 
> >> I see they are used here:
> >> http://www.chronox.de/crypto-API/crypto/userspace-if.html#aead-cipher-api
> >> 
> >> but it merely says:
> >>     .salg_type = "aead", /* this selects the symmetric cipher */
> >>     .salg_name = "gcm(aes)" /* this is the cipher name */
> >> 
> >> and does not explain why it is must be "aead" for  "gcm(aes)", nor why
> >> would "skcipher" fail for  "gcm(aes)" (would it?).
> >> 
> >> These integer flags in sockaddr_alg.feat/mask seem to be better always
> >> be 0 (because they can only fail an otherwise passing bind, right?).
> >> But the textual type seems to matter, because bind first looks at type
> >> and then everything else happens as callbacks on type.
> >> 
> >> I've found these guys:
> >> 
> >> tatic const struct crypto_type crypto_skcipher_type2 = {
> >> .extsize = crypto_skcipher_extsize,
> >> .init_tfm = crypto_skcipher_init_tfm,
> >> .free = crypto_skcipher_free_instance,
> >> #ifdef CONFIG_PROC_FS
> >> .show = crypto_skcipher_show,
> >> #endif
> >> .report = crypto_skcipher_report,
> >> .maskclear = ~CRYPTO_ALG_TYPE_MASK,
> >> .maskset = CRYPTO_ALG_TYPE_BLKCIPHER_MASK,
> >> .type = CRYPTO_ALG_TYPE_SKCIPHER,
> >> .tfmsize = offsetof(struct crypto_skcipher, base),
> >> };
> >> 
> >> But it still does not make sense to me.
> >> 
> >>  CRYPTO_ALG_TYPE_SKCIPHER const is not mentioned in any actual
> >>  algorithms.
> >> 
> >> and CRYPTO_ALG_TYPE_BLKCIPHER_MASK is 0xc, which selects
> >> CRYPTO_ALG_TYPE_BLKCIPHER, CRYPTO_ALG_TYPE_KPP and
> >> CRYPTO_ALG_TYPE_RNG. And it looks like a random subset of
> >> constants....
> > 
> > Also, there seems to be only 4 types ("aead", "hash", "rng",
> > "skcipher"), but more algorithm types. For example, how do I get
> > access to ACOMPRESS/SCOMPRESS?
> 
> Looking at /proc/crypto confuses me even more:
> 
> $ cat /proc/crypto  | grep type | sort | uniq
> type         : ablkcipher
> type         : aead
> type         : ahash
> type         : akcipher
> type         : blkcipher
> type         : cipher
> type         : compression
> type         : givcipher
> type         : rng
> type         : shash
> 
> Now, there are 10 types. They partially intersect with the other
> textual types (e.g. "aead"). But, say "skcipher" is not present in
> /proc/crypto at all.

The types that a cipher can implement is given in include/linux/crypto.h:

/*
 * Algorithm masks and types.
 */
#define CRYPTO_ALG_TYPE_MASK            0x0000000f
#define CRYPTO_ALG_TYPE_CIPHER          0x00000001
...

These types are resolved when the various crypto_alloc_* functions are 
invoked. For example

static const struct crypto_type crypto_skcipher_type2 = {
...
        .type = CRYPTO_ALG_TYPE_SKCIPHER,
...
};

struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
                                              u32 type, u32 mask)
{
        return crypto_alloc_tfm(alg_name, &crypto_skcipher_type2, type, mask);
}

Thus, when you use crypto_alloc_skcipher, it will only "find" cipher 
implementations that are of type SKCIPHER (or ABLKCIPHER as both values are 
identical). I.e. even when you try to call crypto_alloc_skcipher("sha256"), 
the lookup code will not find it as the sha256 implementation is of type AHASH 
(or SHASH) and not SKCIPHER.

The name you see in /proc/crypto are given with the respective report function 
call (e.g. crypto_skcipher_report for the aforementioned example). These names 
are just informative and not relevant at all for anything.


When you come to the AF_ALG interface, the used names of "skcipher" or "aead" 
are *not* related to the names you see in /proc/crypto. They are simply 
identifiers referring to the different AF_ALG handler callbacks. For example, 
crypto/algif_skcipher.c:

static const struct af_alg_type algif_type_skcipher = {
...
        .name           =       "skcipher",
...
};

This name is used to find the right AF_ALG handler in alg_bind:

        type = alg_get_type(sa->salg_type);
        if (IS_ERR(type) && PTR_ERR(type) == -ENOENT) {
                request_module("algif-%s", sa->salg_type);
                type = alg_get_type(sa->salg_type);
        }

Thus, if you use "skcipher" during bind it is resolved to algif_skcipher.c. If 
you use some unknown name, alg_bind will error out.

Now, algif_skcipher only uses crypto_alloc_skcipher() which as shown above can 
only allocate ciphers marked as SKCIPHER or ABLKCIPHER.
 
These names are to be pointed to by the sockaddr type value:

Here my libkcapi code in _kcapi_allocated_handle_init:

        memset(&sa, 0, sizeof(sa));
        sa.salg_family = AF_ALG;
        snprintf((char *)sa.salg_type, sizeof(sa.salg_type),"%s", type);
        snprintf((char *)sa.salg_name, sizeof(sa.salg_name),"%s", ciphername);

===> type contains the name to resolve the right AF_ALG handler.

===> ciphername contains the actual cipher name (like "gcm(aes)") to be used 
in the crypto_alloc_* functions implemented by AF_ALG.

Now, assume user space is nasty. When you use the type "aead" resolving to 
algif_aead.c and the cipher of, say, "sha256", the algif_aead.c will do an 
crypto_alloc_aead("sha256") which will cause an error because the allocation 
function will never match a cipher name of "sha256" and the type of AEAD.

Ciao
Stephan
