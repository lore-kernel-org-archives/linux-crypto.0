From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr: Allow different compression results
Date: Sat, 21 Apr 2018 00:52:27 +0800
Message-ID: <20180420165227.wb2hsckedgkauxz4@gondor.apana.org.au>
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
> From: Mahipal Challa <mchalla@cavium.com>
> 
> The following error is triggered by the ThunderX ZIP driver
> if the testmanager is enabled:
> 
> [  199.069437] ThunderX-ZIP 0000:03:00.0: Found ZIP device 0 177d:a01a on Node 0
> [  199.073573] alg: comp: Compression test 1 failed for deflate-generic: output len = 37
> 
> The reason for this error is the verification of the compression
> results. Verifying the compression result only works if all
> algorithm parameters are identical, in this case to the software
> implementation.
> 
> Different compression engines like the ThunderX ZIP coprocessor
> might yield different compression results by tuning the
> algorithm parameters. In our case the compressed result is
> shorter than the test vector.
> 
> We should not forbid different compression results but only
> check that compression -> decompression yields the same
> result. This is done already in the acomp test. Do something
> similar for test_comp().
> 
> Signed-off-by: Mahipal Challa <mchalla@cavium.com>
> Signed-off-by: Balakrishna Bhamidipati <bbhamidipati@cavium.com>
> [jglauber@cavium.com: removed unrelated printk changes, rewrote commit msg,
>  fixed whitespace and unneeded initialization]
> Signed-off-by: Jan Glauber <jglauber@cavium.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
