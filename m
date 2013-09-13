From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha256_ssse3 - use correct module alias for
 sha224
Date: Fri, 13 Sep 2013 22:22:47 +1000
Message-ID: <20130913122246.GA8579@gondor.apana.org.au>
References: <20130903132649.6239.4068.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:42297 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751513Ab3IMMWv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Sep 2013 08:22:51 -0400
Content-Disposition: inline
In-Reply-To: <20130903132649.6239.4068.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 03, 2013 at 04:26:49PM +0300, Jussi Kivilinna wrote:
> Commit a710f761f (crypto: sha256_ssse3 - add sha224 support) attempted to add
> MODULE_ALIAS for SHA-224, but it ended up being "sha384", probably because
> mix-up with previous commit 340991e30 (crypto: sha512_ssse3 - add sha384
> support). Patch corrects module alias to "sha224".
> 
> Reported-by: Pierre-Mayeul Badaire <pierre-mayeul.badaire@m4x.org>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
