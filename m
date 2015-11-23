From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: atmel: fix 64-bit warnings
Date: Mon, 23 Nov 2015 21:01:49 +0800
Message-ID: <20151123130149.GC7866@gondor.apana.org.au>
References: <4444008.DmhAgm3J77@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Leilei Zhao <leilei.zhao@atmel.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Nicolas Royer <nicolas@eukrea.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54108 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbbKWNCF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Nov 2015 08:02:05 -0500
Content-Disposition: inline
In-Reply-To: <4444008.DmhAgm3J77@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 17, 2015 at 10:22:06AM +0100, Arnd Bergmann wrote:
> The atmel AES driver assumes that 'int' and 'size_t' are the same
> type in multiple locations, which the compiler warns about when
> building it for 64-bit systems:
> 
> In file included from ../drivers/crypto/atmel-aes.c:17:0:
> drivers/crypto/atmel-aes.c: In function 'atmel_aes_sg_copy':
> include/linux/kernel.h:724:17: warning: comparison of distinct pointer types lacks a cast
> drivers/crypto/atmel-aes.c:448:11: note: in expansion of macro 'min'
> 
> drivers/crypto/atmel-aes.c: In function 'atmel_aes_crypt_dma_stop':
> include/linux/kern_levels.h:4:18: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'size_t {aka long unsigned int}' [-Wformat=]
> 
> This changes the format strings to use the %z modifier when printing
> a size_t, and makes sure that we use the correct size_t type where
> needed. In case of sg_dma_len(), the type of the result depends
> on CONFIG_NEED_SG_DMA_LENGTH, so we have to use min_t to get it to
> work in all configurations.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
