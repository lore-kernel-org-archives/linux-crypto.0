From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/2] crypto: sunxi - don't print confusing data
Date: Wed, 27 Jan 2016 22:17:26 +0800
Message-ID: <20160127141726.GB1601@gondor.apana.org.au>
References: <1453815902-3070323-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50752 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602AbcA0ORy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 09:17:54 -0500
Content-Disposition: inline
In-Reply-To: <1453815902-3070323-1-git-send-email-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 26, 2016 at 02:44:50PM +0100, Arnd Bergmann wrote:
> gcc correctly warns that the printk output contains a variable that
> it thinks is not initialized in some cases:
> 
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c: In function 'sun4i_ss_cipher_poll':
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:254:76: warning: 'todo' may be used uninitialized in this function [-Wmaybe-uninitialized]
> drivers/crypto/sunxi-ss/sun4i-ss-cipher.c:144:15: note: 'todo' was declared here
> 
> A closer look at the function reveals that the variable is always
> initialized at this point (ileft is guaranteed to be positive at the
> start), but its contents are not well-defined:
> Depending on some other variables, it might be either a count in
> words or bytes, and it could refer to either input or output.
> 
> The easiest solution apparently is to remove the confusing output
> and let the reader figure out the state from the other variables.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
