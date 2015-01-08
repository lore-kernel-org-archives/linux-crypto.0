From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: AEAD: add check for presence of auth tag
Date: Thu, 8 Jan 2015 21:48:52 +1100
Message-ID: <20150108104852.GB8374@gondor.apana.org.au>
References: <2529951.NL2CVhi6xs@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2529951.NL2CVhi6xs@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jan 05, 2015 at 12:21:45PM +0100, Stephan Mueller wrote:
> The AEAD decryption operation requires the authentication tag to be
> present as part of the cipher text buffer. The added check verifies that
> the caller provides a cipher text with at least the authentication tag.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
