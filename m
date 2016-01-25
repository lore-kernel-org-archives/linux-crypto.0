From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4] crypto: sunxi - don't print uninitialized data
Date: Mon, 25 Jan 2016 17:56:40 +0100
Message-ID: <5143347.j0XTtrAXzs@wuerfel>
References: <1453740845-1980433-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:53849 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbcAYQ5F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 11:57:05 -0500
In-Reply-To: <1453740845-1980433-1-git-send-email-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday 25 January 2016 17:53:48 Arnd Bergmann wrote:
> gcc correctly warns that the printk output contains a variable that
> is not initialized in some cases:
> 
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c: In function 'sun4i_ss_cipher_poll':
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:254:76: warning: 'todo' may be used uninitialized in this function [-Wmaybe-uninitialized]
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:144:15: note: 'todo' was declared here
> 
> This adds an explicit initialization to zero in the exact case where it
> was missing, to avoid leaking stack data to the console and to shut up
> that warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 


Sorry for the broken ordering and missing cover letter. 
I just submitted three crypto patches:

[PATCH 1/4] crypto: sunxi - don't print uninitialized data
[PATCH] crypto: hash - select CRYPTO_HASH where needed
[PATCH 1/2] crypto: jitterentropy - always select CRYPTO_RNG

These address independent build issues, and there is no ordering between
them. None of them are important, so please queue them up for 4.6.

	Arnd
