From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aead - move aead_request_cast helper to aead.h
Date: Tue, 2 Feb 2016 00:20:39 +0800
Message-ID: <20160201162039.GA12748@gondor.apana.org.au>
References: <20160127220916.12466.99501.stgit@tstruk-mobl1>
 <20160201094633.GA6299@gondor.apana.org.au>
 <56AF7DF3.1010305@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AF7DF3.1010305@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 01, 2016 at 07:46:59AM -0800, Tadeusz Struk wrote:
>
> Yes, I though about it, but I followed skcipher. The skcipher_request_cast()
> helper is in crypto/skcipher.h not in crypto/internal/skcipher.h
> Shouldn't this be consistent?

Yes it should be moved into internal as well.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
