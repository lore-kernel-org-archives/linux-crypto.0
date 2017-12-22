From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto] crypto: aesni - add wrapper for generic gcm(aes)
Date: Fri, 22 Dec 2017 20:10:53 +1100
Message-ID: <20171222091053.GI32542@gondor.apana.org.au>
References: <0a60d233428e2e9bca747a29712688b6e66b59ac.1513172421.git.sd@queasysnail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sbrivio@redhat.com, ilyal@mellanox.com
To: Sabrina Dubroca <sd@queasysnail.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0a60d233428e2e9bca747a29712688b6e66b59ac.1513172421.git.sd@queasysnail.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 13, 2017 at 02:54:36PM +0100, Sabrina Dubroca wrote:
> When I added generic-gcm-aes I didn't add a wrapper like the one
> provided for rfc4106(gcm(aes)). We need to add a cryptd wrapper to fall
> back on in case the FPU is not available, otherwise we might corrupt the
> FPU state.
> 
> Fixes: cce2ea8d90fe ("crypto: aesni - add generic gcm(aes)")
> Reported-by: Ilya Lesokhin <ilyal@mellanox.com>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
