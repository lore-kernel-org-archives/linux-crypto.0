From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: public_key: select CRYPTO_AKCIPHER2
Date: Wed, 18 May 2016 22:50:31 +0800
Message-ID: <20160518145031.GA12712@gondor.apana.org.au>
References: <1463580776-930850-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51555 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbcEROuq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 10:50:46 -0400
Content-Disposition: inline
In-Reply-To: <1463580776-930850-1-git-send-email-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 18, 2016 at 04:12:44PM +0200, Arnd Bergmann wrote:
> In some rare randconfig builds, we can end up with
> ASYMMETRIC_PUBLIC_KEY_SUBTYPE enabled but CRYPTO_AKCIPHER2 disabled,
> which fails to link because of the reference to crypto_alloc_akcipher:

This symbol is not meant to be selected by crypto users.  Please
select CRYPTO_AKCIPHER instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
