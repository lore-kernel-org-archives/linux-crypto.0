From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH] crypto: x86/aes - Don't use %rbp as temporary register
Date: Wed, 17 May 2017 15:44:27 -0500
Message-ID: <20170517204427.lwvzonoa26paoitk@treble>
References: <20170517040308.406-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49804 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbdEQUo3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 16:44:29 -0400
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

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
