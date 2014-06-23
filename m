From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: sha512_ssse3: fix byte count to bit count
 conversion
Date: Mon, 23 Jun 2014 09:58:55 -0700
Message-ID: <1403542735.2970.604.camel@schen9-DESK>
References: <20140623164105.13319.42220.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38844 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbaFWQ7V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Jun 2014 12:59:21 -0400
In-Reply-To: <20140623164105.13319.42220.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks for catching this.

Should propagate this patch to stable kernels 3.14, 3.12 and 3.10 too.

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>

On Mon, 2014-06-23 at 19:41 +0300, Jussi Kivilinna wrote:
> Byte-to-bit-count computation is only partly converted to big-endian and is
> mixing in CPU-endian values. Problem was noticed by sparce with warning:
> 
>   CHECK   arch/x86/crypto/sha512_ssse3_glue.c
> arch/x86/crypto/sha512_ssse3_glue.c:144:19: warning: restricted __be64 degrades to integer
> arch/x86/crypto/sha512_ssse3_glue.c:144:17: warning: incorrect type in assignment (different base types)
> arch/x86/crypto/sha512_ssse3_glue.c:144:17:    expected restricted __be64 <noident>
> arch/x86/crypto/sha512_ssse3_glue.c:144:17:    got unsigned long long
> 
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> ---
>  arch/x86/crypto/sha512_ssse3_glue.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
> index f30cd10..8626b03 100644
> --- a/arch/x86/crypto/sha512_ssse3_glue.c
> +++ b/arch/x86/crypto/sha512_ssse3_glue.c
> @@ -141,7 +141,7 @@ static int sha512_ssse3_final(struct shash_desc *desc, u8 *out)
>  
>  	/* save number of bits */
>  	bits[1] = cpu_to_be64(sctx->count[0] << 3);
> -	bits[0] = cpu_to_be64(sctx->count[1] << 3) | sctx->count[0] >> 61;
> +	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
>  
>  	/* Pad out to 112 mod 128 and append length */
>  	index = sctx->count[0] & 0x7f;
> 
