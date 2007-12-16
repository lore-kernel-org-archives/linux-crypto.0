From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH 2/2] Salsa20 stream cipher algorithm (x86-64 version)
Date: Sun, 16 Dec 2007 21:26:40 +0100
Message-ID: <20071216202640.GB29507@Chamillionaire.breakpoint.cc>
References: <fd3e431c0712161006mf162962je617794061c19398@mail.gmail.com>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51250 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755848AbXLPU0m (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 16 Dec 2007 15:26:42 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0712161006mf162962je617794061c19398@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Tan Swee Heng | 2007-12-17 02:06:15 [+0800]:

>Hi Herbert, as mentioned some time ago, I don't have an x86-64. So
>please help me test it. Thanks!

I tested it and it passed 5 of 5 tests :)

>diff --git a/crypto/Kconfig b/crypto/Kconfig
>index 221356b..b0481f7 100644
>--- a/crypto/Kconfig
>+++ b/crypto/Kconfig
>@@ -504,6 +504,21 @@ config CRYPTO_SALSA20_586
> 	  The Salsa20 stream cipher algorithm is designed by Daniel J.
> 	  Bernstein <djb@cr.yp.to>. See <http://cr.yp.to/snuffle.html>
> 
>+config CRYPTO_SALSA20_X86_64
>+	tristate "Salsa20 stream cipher algorithm (x86_64) (EXPERIMENTAL)"
>+	depends on (X86 || UML_X86) && 64BIT
>+	depends on EXPERIMENTAL
>+	select CRYPTO_BLKCIPHER
>+	select CRYPTO_SALSA20
>+	help

I why do you select CRYPTO_SALSA20 ? I was able to build & test it
without it.

Sebastian
