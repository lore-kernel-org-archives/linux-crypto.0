From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: 4.10 aesni-intel no longer having lrw/ablk_helper dependencies?
Date: Sun, 29 Jan 2017 15:46:32 -0800
Message-ID: <20170129234632.GA5253@zzz>
References: <201701292231.59656.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: arekm@maven.pl
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33653 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750888AbdA2Xqf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Jan 2017 18:46:35 -0500
Received: by mail-pg0-f65.google.com with SMTP id 194so30008141pgd.0
        for <linux-crypto@vger.kernel.org>; Sun, 29 Jan 2017 15:46:35 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <201701292231.59656.a.miskiewicz@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 29, 2017 at 10:31:59PM +0100, Arkadiusz Miskiewicz wrote:
> Hi.
> 
> [arekm@xps ~]$ modinfo --set-version 4.9.6 aesni-intel | grep depends
> depends:        glue_helper,aes-x86_64,lrw,cryptd,ablk_helper
> 
> [arekm@xps ~]$ modinfo --set-version  4.10.0-rc5-00161-gfd694aaa46c7 aesni-
> intel |grep depends
> depends:        glue_helper,aes-x86_64,crypto_simd,cryptd
> 
> With 4.10.0 lrw and ablk_helper are no longer in dependencies while
> aesni-intel seem to still need these. My luks encrypted rootfs fails to 
> unlock. Initrd generation script only installs modules based on dependencies 
> and that seems to be a reason for luks unlock failure with 4.10rc - some 
> missing modules.
> 
> Failure looks like that:
> $ insmod path/to/aesni-intel.ko
> dmesg gets logged:
> "AVX2 version of gcm_enc/dec engaged
> AES CTR mode by8 optimization enabled."
> and insmod reports that it cannot insert aesni-intel because of unresolved 
> symbol or unknown option but nothing more is logged in dmesg.
> 
> 4.9.x works fine.
> 
> What did change/how to figure out deps now?
> 
> Both modules exist:

Hi Arkadiusz,

First, aesni-intel no longer includes an LRW implementation itself.  Instead,
the generic LRW module must be selected.  Internally it will use the aesni-intel
accelerated ECB algorithm if available.  So you need to make sure that the "lrw"
module is included in the initrd if it's not already.

But I think the bigger problem is that aesni-intel couldn't be insmod'ed at all,
which shouldn't happen.  The problem might actually be related to the "pcbc"
algorithm.  Upon initialization, aesni-intel now tries to wrap
"pcbc(__aes-aesni)" with the "fpu" template.  This will fail if the "pcbc"
module hasn't been inserted.  I think this wasn't a problem before because the
old code using ablk_helper instead of crypto_simd didn't try to find "pcbc"
until someone asked for it, while now aesni-intel will try to find it
immediately.  And since aesni-intel has no direct dependency on pcbc, I'm
guessing what happened is that pcbc didn't end up in your initrd even though it
may have been built.  (You can verify this by adding pcbc to your initrd and
seeing if that works around the problem.)

Herbert, would it make any sense to solve this by creating a real dependency of
aesni-intel on pcbc, by making aesni-intel reference an exported symbol in pcbc
if IS_ENABLED(CONFIG_PCBC)?  Or do you / did you have something else in mind?

I also think it's kind of weird that aesni-intel has to do anything with pcbc at
all since it doesn't actually implement pcbc specifically; it's just wrapping it
in the "fpu" template to avoid so many calls to kernel_fpu_begin/kernel_fpu_end.
I wonder if there is a better solution to this, maybe even optimizing
kernel_fpu_begin/kernel_fpu_end so that the wrapping isn't needed.

Eric
