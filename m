From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH] crypto: AF_ALG - limit mask and type
Date: Tue, 12 Dec 2017 00:57:37 -0800
Message-ID: <20171212085737.GA1865@zzz.localdomain>
References: <001a1141c43ad30ccf055efb76ed@google.com>
 <4450500.tGvsruIfR8@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: syzbot
        <bot+b6e703f648ebbbf57a4528d4314e0c2a5c893dc2@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:41856 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdLLI5m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Dec 2017 03:57:42 -0500
Content-Disposition: inline
In-Reply-To: <4450500.tGvsruIfR8@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On Tue, Dec 12, 2017 at 07:09:08AM +0100, Stephan Müller wrote:
> Hi Herbert,
> 
> you see the reported problem by simply using
> 
> sa.salg_mask = 0xffffffff;
> 
> Note, I am not fully sure about whether CRYPTO_AF_ALG_ALLOWED_MASK and
> CRYPTO_AF_ALG_ALLOWED_TYPE have the correct value. But I think that all
> that user space should reach is potentially the ASYNC flag and the
> cipher types flags.
> 
> ---8<---
> 
> The user space interface allows specifying the type and the mask field
> used to allocate the cipher. Only a subset of the type and mask is
> considered relevant to be set by user space if needed at all.
> 
> This fixes a bug where user space is able to cause one cipher to be
> registered multiple times potentially exhausting kernel memory.
> 
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

The syzkaller reproducer triggered a crash in crypto_remove_spawns().  Is it
possible the bug is still there somewhere, while this patch just makes it
inaccessible through AF_ALG?

Anyway, we definitely should expose as few algorithm flags to AF_ALG as
possible.  There are just way too many things that can go wrong with exposing
arbitrary flags.

However, why do the check in every af_alg_type.bind() method instead of just
once in alg_bind()?

If it can be done without breaking users, it also would be nice if we would
actually validate the flags and return -EINVAL if unknown flags are specified.
Otherwise users cannot test for whether specific flags are supported.

Also, note that even after this fix there are still ways to register an
arbitrarily large number of algorithms.  There are two classes of problems.

First, it can happen that a template gets instantiated for a request but the
resulting algorithm does not exactly match the original request, so making the
same request again will instantiate the template again.  This could happen by
specifically requesting an untested algorithm (type=0, mask=CRYPTO_ALG_TESTED),
which your patch fixes.  However this can also happen in cases where neither the
final ->cra_name nor the final ->cra_driver_name matches what was requested.
For example asking for "cryptd(sha1)" results in .cra_name = "sha1" and
.cra_driver_name = "cryptd(sha1-avx2)", or asking for "xts(ecb(aes))" results in
.cra_name = "xts(aes)" and .cra_driver_name = "xts(ecb-aes-aesni)".

Probably the crypto API needs to be taught how to find the instantiated
templates correctly.

Second, you can just keep choosing different combinations of algorithms when
instantiating templates, taking advantage of the fact that templates can be
nested and some take multiple parameters, so the number of possible combinations
grows exponentially.  I don't know how to easily solve this.  Perhaps
crypto_free_skcipher(), crypto_free_ahash(), etc. should unregister the
algorithm if it was created from a template and nothing else is using it; then
the number of algorithms someone could instantiate via AF_ALG at a given time
would be limited by their number of file descriptors.

Eric
