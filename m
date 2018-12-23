Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38996 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729640AbeLWEDV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:03:21 -0500
Date: Sun, 23 Dec 2018 12:03:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/chacha - avoid sleeping under
 kernel_fpu_begin()
Message-ID: <20181223040312.twgpjgmfs3wybnmb@gondor.apana.org.au>
References: <000000000000fb268d057d13ea55@google.com>
 <20181215204017.7880-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181215204017.7880-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 15, 2018 at 12:40:17PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Passing atomic=true to skcipher_walk_virt() only makes the later
> skcipher_walk_done() calls use atomic memory allocations, not
> skcipher_walk_virt() itself.  Thus, we have to move it outside of the
> preemption-disabled region (kernel_fpu_begin()/kernel_fpu_end()).
> 
> (skcipher_walk_virt() only allocates memory for certain layouts of the
> input scatterlist, hence why I didn't notice this earlier...)
> 
> Reported-by: syzbot+9bf843c33f782d73ae7d@syzkaller.appspotmail.com
> Fixes: 4af78261870a ("crypto: x86/chacha20 - add XChaCha20 support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/x86/crypto/chacha_glue.c | 33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
