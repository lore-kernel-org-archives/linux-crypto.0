From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: public_key: select CRYPTO_AKCIPHER2
Date: Wed, 18 May 2016 16:56:32 +0200
Message-ID: <4277264.YmbM8GybfZ@wuerfel>
References: <1463580776-930850-1-git-send-email-arnd@arndb.de> <20160518145031.GA12712@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:49889 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbcERO5F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 10:57:05 -0400
In-Reply-To: <20160518145031.GA12712@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 18 May 2016 22:50:31 Herbert Xu wrote:
> On Wed, May 18, 2016 at 04:12:44PM +0200, Arnd Bergmann wrote:
> > In some rare randconfig builds, we can end up with
> > ASYMMETRIC_PUBLIC_KEY_SUBTYPE enabled but CRYPTO_AKCIPHER2 disabled,
> > which fails to link because of the reference to crypto_alloc_akcipher:
> 
> This symbol is not meant to be selected by crypto users.  Please
> select CRYPTO_AKCIPHER instead.
> 

Ok, sent a v2 now.

	Arnd
