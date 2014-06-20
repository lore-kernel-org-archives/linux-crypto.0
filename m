From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: skcipher: Don't use __crypto_dequeue_request()
Date: Sat, 21 Jun 2014 02:40:16 +0800
Message-ID: <20140620184016.GB3169@gondor.apana.org.au>
References: <1401123108-31700-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Pantelis Antoniou <panto@antoniou-consulting.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:56058 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966182AbaFTSkT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Jun 2014 14:40:19 -0400
Content-Disposition: inline
In-Reply-To: <1401123108-31700-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 26, 2014 at 06:51:48PM +0200, Marek Vasut wrote:
> Use skcipher_givcrypt_cast(crypto_dequeue_request(queue)) instead, which
> does the same thing in much cleaner way. The skcipher_givcrypt_cast()
> actually uses container_of() instead of messing around with offsetof()
> too.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Pantelis Antoniou <panto@antoniou-consulting.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
