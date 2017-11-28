From: Stephan Mueller <smueller@chronox.de>
Subject: Re: KASAN: use-after-free Read in aead_recvmsg
Date: Tue, 28 Nov 2017 08:43:54 +0100
Message-ID: <1713831.MCFILKZksC@tauon.chronox.de>
References: <001a113ebb5ece8a7a055efb7676@google.com> <5111191.QYDWLsXdp1@tauon.chronox.de> <20171128072944.GA23565@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+6fbc13c3b1ed2105e7a2e516be43d6a0624a59c0@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171128072944.GA23565@zzz.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 28. November 2017, 08:29:44 CET schrieb Eric Biggers:

Hi Eric,

> 
> Sometimes you have to reboot to get the reproducer to work, because the bug
> has to do with referencing counting of the "null skcipher" which is a
> global resource.  Here's a patch that fixes it, it seems:
> 
> ---8<---
> 
> From 453b54793e843c0d5b8fd2d5e33fcc5427ec038e Mon Sep 17 00:00:00 2001
> From: Eric Biggers <ebiggers@google.com>
> Date: Mon, 27 Nov 2017 23:23:05 -0800
> Subject: [PATCH] crypto: algif_aead - fix reference counting of null
> skcipher
> 
> In the AEAD interface for AF_ALG, the reference to the "null skcipher"
> held by each tfm was being dropped in the wrong place -- when each
> af_alg_ctx was freed instead of when the aead_tfm was freed.  As
> discovered by syzkaller, a specially crafted program could use this to
> cause the null skcipher to be freed while it is still in use.
> 
> Fix it by dropping the reference in the right place.
> 
> Fixes: 72548b093ee3 ("crypto: algif_aead - copy AAD from src to dst")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: <stable@vger.kernel.org> # v4.14+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Yes, absolutely -- the null cipher is allocated together with the AEAD cipher 
and should be freed together with the AEAD cipher.

Thanks a lot.

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
