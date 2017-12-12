From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG - limit mask and type
Date: Tue, 12 Dec 2017 10:22:51 +0100
Message-ID: <2161453.OgJ66DpyYL@tauon.chronox.de>
References: <001a1141c43ad30ccf055efb76ed@google.com> <4450500.tGvsruIfR8@positron.chronox.de> <20171212085737.GA1865@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44310 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750749AbdLLJWy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 04:22:54 -0500
In-Reply-To: <20171212085737.GA1865@zzz.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 12. Dezember 2017, 09:57:37 CET schrieb Eric Biggers:

Hi Eric,

> Hi Stephan,
> 
> On Tue, Dec 12, 2017 at 07:09:08AM +0100, Stephan Müller wrote:
> > Hi Herbert,
> > 
> > you see the reported problem by simply using
> > 
> > sa.salg_mask = 0xffffffff;
> > 
> > Note, I am not fully sure about whether CRYPTO_AF_ALG_ALLOWED_MASK and
> > CRYPTO_AF_ALG_ALLOWED_TYPE have the correct value. But I think that all
> > that user space should reach is potentially the ASYNC flag and the
> > cipher types flags.
> > 
> > ---8<---
> > 
> > The user space interface allows specifying the type and the mask field
> > used to allocate the cipher. Only a subset of the type and mask is
> > considered relevant to be set by user space if needed at all.
> > 
> > This fixes a bug where user space is able to cause one cipher to be
> > registered multiple times potentially exhausting kernel memory.
> > 
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> The syzkaller reproducer triggered a crash in crypto_remove_spawns().  Is it
> possible the bug is still there somewhere, while this patch just makes it
> inaccessible through AF_ALG?

I think the issue is that the syzkaller generates a vast amount of registered 
ciphers. At one point in time, I would think that some implied limit is 
overflown. But I cannot say for sure.

Yet, it is definitely a bug to have more than one instance of the same cipher 
implementation registered.

> 
> Anyway, we definitely should expose as few algorithm flags to AF_ALG as
> possible.  There are just way too many things that can go wrong with
> exposing arbitrary flags.

Absolutely, I would even say that we should not expose any mask/type at all. 
I.e. the patch I offered here should be changed to set the mask/type to zero 
in all cases.
> 
> However, why do the check in every af_alg_type.bind() method instead of just
> once in alg_bind()?

You are quite right, that is the right place to add this code as it contains 
already some verification there.
> 
> If it can be done without breaking users, it also would be nice if we would
> actually validate the flags and return -EINVAL if unknown flags are
> specified. Otherwise users cannot test for whether specific flags are
> supported.

If we (and we need to hear Herbert) conclude that these values should not be 
exposed in the first place, I think we should not return any error but simply 
set it to zero.

If Herbert concludes that some flags are necessary, we should build a white-
list and return an error for any flag that is not in the white list.
> 
> Also, note that even after this fix there are still ways to register an
> arbitrarily large number of algorithms.  There are two classes of problems.
> 
> First, it can happen that a template gets instantiated for a request but the
> resulting algorithm does not exactly match the original request, so making
> the same request again will instantiate the template again.  This could
> happen by specifically requesting an untested algorithm (type=0,
> mask=CRYPTO_ALG_TESTED), which your patch fixes. However this can also
> happen in cases where neither the final ->cra_name nor the final
> ->cra_driver_name matches what was requested. For example asking for
> "cryptd(sha1)" results in .cra_name = "sha1" and .cra_driver_name =
> "cryptd(sha1-avx2)", or asking for "xts(ecb(aes))" results in .cra_name =
> "xts(aes)" and .cra_driver_name = "xts(ecb-aes-aesni)".
> 
> Probably the crypto API needs to be taught how to find the instantiated
> templates correctly.

Maybe a name mangling should be removed. A template/cipher has only two names, 
period. Either you use exactly these names or you will not find a cipher.
> 
> Second, you can just keep choosing different combinations of algorithms when
> instantiating templates, taking advantage of the fact that templates can be
> nested and some take multiple parameters, so the number of possible
> combinations grows exponentially.  I don't know how to easily solve this. 
> Perhaps crypto_free_skcipher(), crypto_free_ahash(), etc. should unregister
> the algorithm if it was created from a template and nothing else is using
> it; then the number of algorithms someone could instantiate via AF_ALG at a
> given time would be limited by their number of file descriptors.

There could be a large set of permutations of ciphers, I agree. However, do 
you think that in case all of them are registered, we have an issue? The goal 
is that if one template/cipher combo is registered once, any subsequent 
allocation of that combo should reuse the registered instance.

PS: The cipher allocation function has another long-standing bug which could 
be viewed as a DoS via AF_ALG: Assume you do not yet have gcm(aes) allocated. 
Now, AF_ALG allocates gcm_base(ctr(aes), ghash), the registered cipher 
instance will have *both*, the name and the driver name to be set to 
gcm_base(ctr(aes), ghash). Any subsequent allocation of gcm(aes) (e.g. by 
IPSEC) will fail with -ENOENT even though the cipher is allocated. Note, 
gcm(aes) here is only an example -- this issue is a general problem.


Ciao
Stephan
