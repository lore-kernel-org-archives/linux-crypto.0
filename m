From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ux500: do not build with -O0
Date: Tue, 28 Jun 2016 16:36:46 +0800
Message-ID: <20160628083646.GA15985@gondor.apana.org.au>
References: <20160627091809.1349621-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46020 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbcF1Ig6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 Jun 2016 04:36:58 -0400
Content-Disposition: inline
In-Reply-To: <20160627091809.1349621-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 27, 2016 at 11:17:40AM +0200, Arnd Bergmann wrote:
> The ARM allmodconfig build currently warngs because of the
> ux500 crypto driver not working well with the jump label
> implementation that we started using for dynamic debug, which
> breaks building with 'gcc -O0':
> 
> In file included from /git/arm-soc/include/linux/jump_label.h:105:0,
>                  from /git/arm-soc/include/linux/dynamic_debug.h:5,
>                  from /git/arm-soc/include/linux/printk.h:289,
>                  from /git/arm-soc/include/linux/kernel.h:13,
>                  from /git/arm-soc/include/linux/clk.h:16,
>                  from /git/arm-soc/drivers/crypto/ux500/hash/hash_core.c:16:
> /git/arm-soc/arch/arm/include/asm/jump_label.h: In function 'hash_set_dma_transfer':
> /git/arm-soc/arch/arm/include/asm/jump_label.h:13:7: error: asm operand 0 probably doesn't match constraints [-Werror]
>   asm_volatile_goto("1:\n\t"
> 
> Turning off compiler optimizations has never really been supported
> here, and it's only used when debugging the driver. I have not found
> a good reason for doing this here, other than a misguided attempt
> to produce more readable assembly output. Also, the driver is only
> used in obsolete hardware that almost certainly nobody will spend
> time debugging any more.
> 
> This just removes the -O0 flag from the compiler options.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
