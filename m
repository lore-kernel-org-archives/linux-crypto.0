From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: KASAN: use-after-free Read in aead_recvmsg
Date: Wed, 29 Nov 2017 16:23:05 +1100
Message-ID: <20171129052305.GA19831@gondor.apana.org.au>
References: <001a113ebb5ece8a7a055efb7676@google.com>
 <2409323.isfI9bk5QC@positron.chronox.de>
 <20171127224308.GB8426@gmail.com>
 <5111191.QYDWLsXdp1@tauon.chronox.de>
 <20171128072944.GA23565@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
        syzbot
        <bot+6fbc13c3b1ed2105e7a2e516be43d6a0624a59c0@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40492 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750783AbdK2FXt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Nov 2017 00:23:49 -0500
Content-Disposition: inline
In-Reply-To: <20171128072944.GA23565@zzz.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 27, 2017 at 11:29:44PM -0800, Eric Biggers wrote:
>
> >From 453b54793e843c0d5b8fd2d5e33fcc5427ec038e Mon Sep 17 00:00:00 2001
> From: Eric Biggers <ebiggers@google.com>
> Date: Mon, 27 Nov 2017 23:23:05 -0800
> Subject: [PATCH] crypto: algif_aead - fix reference counting of null skcipher
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

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
