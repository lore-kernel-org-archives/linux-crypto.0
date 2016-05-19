From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: public_key: select CRYPTO_AKCIPHER
Date: Thu, 19 May 2016 18:01:04 +0800
Message-ID: <20160519100104.GA25981@gondor.apana.org.au>
References: <1463583366-1689248-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59166 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908AbcESKBg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 May 2016 06:01:36 -0400
Content-Disposition: inline
In-Reply-To: <1463583366-1689248-1-git-send-email-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 18, 2016 at 04:55:56PM +0200, Arnd Bergmann wrote:
> In some rare randconfig builds, we can end up with
> ASYMMETRIC_PUBLIC_KEY_SUBTYPE enabled but CRYPTO_AKCIPHER disabled,
> which fails to link because of the reference to crypto_alloc_akcipher:
> 
> crypto/built-in.o: In function `public_key_verify_signature':
> :(.text+0x110e4): undefined reference to `crypto_alloc_akcipher'
> 
> This adds a Kconfig 'select' statement to ensure the dependency
> is always there.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
