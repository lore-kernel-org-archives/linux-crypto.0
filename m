From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr: Allow different compression results
Date: Thu, 19 Apr 2018 11:42:11 +0800
Message-ID: <20180419034210.nsmzuf3f6lmn7suc@gondor.apana.org.au>
References: <20180411182832.27761-1-jglauber@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mahipal Challa <mchalla@cavium.com>,
        Balakrishna Bhamidipati <bbhamidipati@cavium.com>
To: Jan Glauber <jglauber@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180411182832.27761-1-jglauber@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 11, 2018 at 08:28:32PM +0200, Jan Glauber wrote:
>
> @@ -1362,7 +1373,17 @@ static int test_comp(struct crypto_comp *tfm,
>  			goto out;
>  		}
>  
> -		if (dlen != ctemplate[i].outlen) {
> +		ilen = dlen;
> +		dlen = COMP_BUF_SIZE;
> +		ret = crypto_comp_decompress(tfm, output,
> +					     ilen, decomp_output, &dlen);
> +		if (ret) {
> +			pr_err("alg: comp: compression failed: decompress: on test %d for %s failed: ret=%d\n",
> +			       i + 1, algo, -ret);
> +			goto out;
> +		}
> +
> +		if (dlen != ctemplate[i].inlen) {
>  			printk(KERN_ERR "alg: comp: Compression test %d "
>  			       "failed for %s: output len = %d\n", i + 1, algo,
>  			       dlen);

Your patch is fine as it is.

But I just thought I'd mention that if anyone wants to we should
really change this to use a different tfm, e.g., always use the
generic algorithm to perform the decompression.  This way if there
were multiple implementations we can at least test them against
the generic one.

Otherwise you could end up with a buggy implementation that works
against itself but still generates incorrect output.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
