From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: lib: sw842: select crc32
Date: Mon, 18 Jan 2016 23:24:57 +0800
Message-ID: <20160118152457.GD717@gondor.apana.org.au>
References: <4168537.6I1FVkp3DA@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Streetman <ddstreet@ieee.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38453 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbcARPZI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 10:25:08 -0500
Content-Disposition: inline
In-Reply-To: <4168537.6I1FVkp3DA@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 13, 2016 at 11:24:02PM +0100, Arnd Bergmann wrote:
> The sw842 library code was merged in linux-4.1 and causes a very rare randconfig
> failure when CONFIG_CRC32 is not set:
>     
>     lib/built-in.o: In function `sw842_compress':
>     oid_registry.c:(.text+0x12ddc): undefined reference to `crc32_be'
>     lib/built-in.o: In function `sw842_decompress':
>     oid_registry.c:(.text+0x137e4): undefined reference to `crc32_be'
> 
> This adds an explict 'select CRC32' statement, similar to what the other users
> of the crc32 code have. In practice, CRC32 is always enabled anyway because
> over 100 other symbols select it.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
