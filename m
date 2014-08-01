From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] DRBG: fix failure of generating multiple of 2**16 bytes
Date: Fri, 1 Aug 2014 22:41:00 +0800
Message-ID: <20140801144100.GG15005@gondor.apana.org.au>
References: <7159935.MYAcUzQ1Ny@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7159935.MYAcUzQ1Ny@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 31, 2014 at 09:47:33PM +0200, Stephan Mueller wrote:
> The function drbg_generate_long slices the request into 2**16 byte
> or smaller chunks. However, the loop, however invokes the random number
> generation function with zero bytes when the request size is a multiple
> of 2**16 bytes. The fix prevents zero bytes requests.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
