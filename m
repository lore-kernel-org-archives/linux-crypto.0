From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: skcipher - set walk.iv for zero-length inputs
Date: Mon, 11 Dec 2017 22:45:13 +1100
Message-ID: <20171211114513.GD12014@gondor.apana.org.au>
References: <20171129091857.6877-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:43910 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752484AbdLKLpf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:45:35 -0500
Content-Disposition: inline
In-Reply-To: <20171129091857.6877-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 29, 2017 at 01:18:57AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> All the ChaCha20 algorithms as well as the ARM bit-sliced AES-XTS
> algorithms call skcipher_walk_virt(), then access the IV (walk.iv)
> before checking whether any bytes need to be processed (walk.nbytes).
> 
> But if the input is empty, then skcipher_walk_virt() doesn't set the IV,
> and the algorithms crash trying to use the uninitialized IV pointer.
> 
> Fix it by setting the IV earlier in skcipher_walk_virt().  Also fix it
> for the AEAD walk functions.
> 
> This isn't a perfect solution because we can't actually align the IV to
> ->cra_alignmask unless there are bytes to process, for one because the
> temporary buffer for the aligned IV is freed by skcipher_walk_done(),
> which is only called when there are bytes to process.  Thus, algorithms
> that require aligned IVs will still need to avoid accessing the IV when
> walk.nbytes == 0.  Still, many algorithms/architectures are fine with
> IVs having any alignment, and even for those that aren't, a misaligned
> pointer bug is much less severe than an uninitialized pointer bug.
> 
> This change also matches the behavior of the older blkcipher_walk API.
> 
> Fixes: 0cabf2af6f5a ("crypto: skcipher - Fix crash on zero-length input")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: <stable@vger.kernel.org> # v4.14+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
