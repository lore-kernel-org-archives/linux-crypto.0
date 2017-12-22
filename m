From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH crypto] crypto: aesni - fix typo in generic_gcmaes_decrypt
Date: Fri, 22 Dec 2017 20:10:46 +1100
Message-ID: <20171222091045.GH32542@gondor.apana.org.au>
References: <750b6e05579d7c186557be03acb1b6937a3f4498.1513172423.git.sd@queasysnail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sbrivio@redhat.com
To: Sabrina Dubroca <sd@queasysnail.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <750b6e05579d7c186557be03acb1b6937a3f4498.1513172423.git.sd@queasysnail.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Dec 13, 2017 at 02:53:43PM +0100, Sabrina Dubroca wrote:
> generic_gcmaes_decrypt needs to use generic_gcmaes_ctx, not
> aesni_rfc4106_gcm_ctx. This is actually harmless because the fields in
> struct generic_gcmaes_ctx share the layout of the same fields in
> aesni_rfc4106_gcm_ctx.
> 
> Fixes: cce2ea8d90fe ("crypto: aesni - add generic gcm(aes)")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
