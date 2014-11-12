From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: zeroization of buffers
Date: Wed, 12 Nov 2014 22:17:00 +0800
Message-ID: <20141112141700.GA28442@gondor.apana.org.au>
References: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Sandy Harris' <sandyinchina@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1503070.D5VR9iy8Cm@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 11, 2014 at 05:36:16AM +0100, Stephan Mueller wrote:
> Hi Herbert,
> 
> as discussed, these patches use the memzero_explicit function that is
> yet to be integrated into the cryptodev-2.6 tree.
> 
> Stephan Mueller (2):
>   crypto: AF_ALG - zeroize message digest buffer
>   crypto: AF_ALG - zeroize IV buffer
> 
>  crypto/algif_hash.c     | 2 ++
>  crypto/algif_skcipher.c | 1 +
>  2 files changed, 3 insertions(+)

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
