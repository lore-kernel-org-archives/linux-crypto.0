From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: serpent: improve __serpent_setkey with UBSAN
Date: Wed, 9 Aug 2017 21:56:53 +0800
Message-ID: <20170809135653.GC743@gondor.apana.org.au>
References: <20170731204407.1396336-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36804 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752671AbdHIN5H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Aug 2017 09:57:07 -0400
Content-Disposition: inline
In-Reply-To: <20170731204407.1396336-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 31, 2017 at 10:43:55PM +0200, Arnd Bergmann wrote:
> When UBSAN is enabled, we get a very large stack frame for
> __serpent_setkey, when the register allocator ends up using more registers
> than it has, and has to spill temporary values to the stack. The code
> was originally optimized for in-order x86-32 CPU implementations using
> older compilers, but it now runs into a highly suboptimal case on all
> CPU architectures, as seen by this warning:
> 
> crypto/serpent_generic.c: In function '__serpent_setkey':
> crypto/serpent_generic.c:436:1: error: the frame size of 2720 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
> 
> Disabling -fsanitize=alignment would avoid that warning, presumably the
> option turns off a optimization step that is required for getting the
> register allocation right, but there is no easy way to do that on gcc-7
> (gcc-8 introduces a function attribute for this).
> 
> I tried to figure out a way to modify the source code instead, and noticed
> that the two stages of the setkey() function (keyiter and sbox) each are
> fine by themselves, but not when combined into one function. Splitting
> out the entire sbox into a separate function also happens to work fine
> with all compilers I tried (arm, arm64 and x86).
> 
> The setkey function uses a strange way to handle offsets into the key
> array, using both negative and positive index values, as well as adjusting
> the array pointer back and forth. I have checked that this actually
> makes no difference to modern compilers, but I left that untouched
> to make the patch easier to review and to keep the code closer to
> the reference implementation.
> 
> Link: https://patchwork.kernel.org/patch/9189575/
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
