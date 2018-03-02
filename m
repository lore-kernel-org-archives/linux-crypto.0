From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: ccp - return an actual key size from RSA
 max_size callback
Date: Sat, 3 Mar 2018 00:44:51 +0800
Message-ID: <20180302164451.GJ21579@gondor.apana.org.au>
References: <51c265e4-6153-3e5e-316a-ebef059ac36a@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51c265e4-6153-3e5e-316a-ebef059ac36a@maciej.szmigiero.name>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Feb 24, 2018 at 05:03:21PM +0100, Maciej S. Szmigiero wrote:
> rsa-pkcs1pad uses a value returned from a RSA implementation max_size
> callback as a size of an input buffer passed to the RSA implementation for
> encrypt and sign operations.
> 
> CCP RSA implementation uses a hardware input buffer which size depends only
> on the current RSA key length, so it should return this key length in
> the max_size callback, too.
> This also matches what the kernel software RSA implementation does.
> 
> Previously, the value returned from this callback was always the maximum
> RSA key size the CCP hardware supports.
> This resulted in this huge buffer being passed by rsa-pkcs1pad to CCP even
> for smaller key sizes and then in a buffer overflow when ccp_run_rsa_cmd()
> tried to copy this large input buffer into a RSA key length-sized hardware
> input buffer.
> 
> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> Fixes: ceeec0afd684 ("crypto: ccp - Add support for RSA on the CCP")
> Cc: stable@vger.kernel.org

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
