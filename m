From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/cryptod: use crypto_skcipher_type() for getting
 skcipher type
Date: Fri, 27 Nov 2015 21:26:23 +0800
Message-ID: <20151127132623.GC29720@gondor.apana.org.au>
References: <1448473708-9609-1-git-send-email-kuleshovmail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448473708-9609-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 25, 2015 at 11:48:28PM +0600, Alexander Kuleshov wrote:
> The <linux/crypto.h> provides inline function - crypto_skcipher_type().
> Let's use it in the cryptd_alloc_ablkcipher() instead of direct calculation.
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
