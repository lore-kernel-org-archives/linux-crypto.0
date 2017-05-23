From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86/aes - Don't use %rbp as temporary register
Date: Tue, 23 May 2017 13:01:27 +0800
Message-ID: <20170523050127.GD17569@gondor.apana.org.au>
References: <20170517040308.406-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:47990 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757491AbdEWFBr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2017 01:01:47 -0400
Content-Disposition: inline
In-Reply-To: <20170517040308.406-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 16, 2017 at 09:03:08PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When using the "aes-asm" implementation of AES (*not* the AES-NI
> implementation) on an x86_64, v4.12-rc1 kernel with lockdep enabled, the
> following warning was reported, along with a long unwinder dump:
> 
> 	WARNING: kernel stack regs at ffffc90000643558 in kworker/u4:2:155 has bad 'bp' value 000000000000001c
> 
> The problem is that aes_enc_block() and aes_dec_block() use %rbp as a
> temporary register, which breaks stack traces if an interrupt occurs.
> 
> Fix this by replacing %rbp with %r9, which was being used to hold the
> saved value of %rbp.  This required rearranging the AES round macro
> slightly since %r9d cannot be used as the target of a move from %ah-%dh.
> 
> Performance is essentially unchanged --- actually about 0.2% faster than
> before.  Interestingly, I also measured aes-generic as being nearly 7%
> faster than aes-asm, so perhaps aes-asm has outlived its usefulness...
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
