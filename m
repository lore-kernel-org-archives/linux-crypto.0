From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: sunxi - don't print uninitialized data
Date: Tue, 26 Jan 2016 18:44:27 +0800
Message-ID: <20160126104427.GA19583@gondor.apana.org.au>
References: <1453740845-1980433-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	LABBE Corentin <clabbe.montjoie@gmail.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43771 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701AbcAZKpD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 05:45:03 -0500
Content-Disposition: inline
In-Reply-To: <1453740845-1980433-1-git-send-email-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 25, 2016 at 05:53:48PM +0100, Arnd Bergmann wrote:
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

This is actually a bogus warning because todo is always initialised
but gcc can't see that because it's behind multiple conditionals.

It would be great if we can restructure the code so that gcc can see
this while at the same time also improving the readability of the
loop.

Otherwise just initialise it at the top or use uninitialised_var.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
