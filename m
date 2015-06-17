From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v7 0/3] crypto: Introduce Public Key Encryption API
Date: Wed, 17 Jun 2015 17:14:53 +0800
Message-ID: <20150617091453.GB11190@gondor.apana.org.au>
References: <20150616173050.1248.21847.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34666 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbbFQJPQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 05:15:16 -0400
Content-Disposition: inline
In-Reply-To: <20150616173050.1248.21847.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 16, 2015 at 10:30:50AM -0700, Tadeusz Struk wrote:
> This patch set introduces a Public Key Encryption API.
> What is proposed is a new crypto type called crypto_akcipher_type,
> plus new struct akcipher_alg and struct crypto_akcipher, together with number
> of helper functions to register akcipher type algorithms and allocate
> tfm instances. This is to make it similar to how the existing crypto
> API works for the ablkcipher, ahash, and aead types.
> The operations the new interface will allow to provide are:
> 
> 	int (*sign)(struct akcipher_request *req);
> 	int (*verify)(struct akcipher_request *req);
> 	int (*encrypt)(struct akcipher_request *req);
> 	int (*decrypt)(struct akcipher_request *req);

All applied with two minor changes.  First of all I made AKCIPHER
invisible to the user like the other type config options.  I also
added a missing select on ASN1 that broke my build.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
