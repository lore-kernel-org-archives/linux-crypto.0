From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86 - build AVX block cipher implementations
 only if assembler supports AVX instructions
Date: Wed, 3 Apr 2013 09:52:50 +0800
Message-ID: <20130403015250.GB20205@gondor.apana.org.au>
References: <20130324133407.2632.1596.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33035 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760645Ab3DCBwz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Apr 2013 21:52:55 -0400
Content-Disposition: inline
In-Reply-To: <20130324133407.2632.1596.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Mar 24, 2013 at 03:34:07PM +0200, Jussi Kivilinna wrote:
> These modules require AVX support in assembler, so add new check to Makefile
> for this.
> 
> Other option would be to use CONFIG_AS_AVX inside source files, but that would
> result dummy/empty/no-fuctionality modules being created.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
