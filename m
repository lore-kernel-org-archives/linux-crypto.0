From: Jan Glauber <jan.glauber@caviumnetworks.com>
Subject: Re: [PATCH] crypto: testmgr: Allow different compression results
Date: Thu, 19 Apr 2018 13:58:40 +0200
Message-ID: <20180419115840.GA14706@hc>
References: <20180411182832.27761-1-jglauber@cavium.com>
 <20180419034210.nsmzuf3f6lmn7suc@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mahipal Challa <mchalla@cavium.com>,
        Balakrishna Bhamidipati <bbhamidipati@cavium.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180419034210.nsmzuf3f6lmn7suc@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 19, 2018 at 11:42:11AM +0800, Herbert Xu wrote:
> On Wed, Apr 11, 2018 at 08:28:32PM +0200, Jan Glauber wrote:
> >
> > @@ -1362,7 +1373,17 @@ static int test_comp(struct crypto_comp *tfm,
> >  			goto out;
> >  		}
> >  
> > -		if (dlen != ctemplate[i].outlen) {
> > +		ilen = dlen;
> > +		dlen = COMP_BUF_SIZE;
> > +		ret = crypto_comp_decompress(tfm, output,
> > +					     ilen, decomp_output, &dlen);
> > +		if (ret) {
> > +			pr_err("alg: comp: compression failed: decompress: on test %d for %s failed: ret=%d\n",
> > +			       i + 1, algo, -ret);
> > +			goto out;
> > +		}
> > +
> > +		if (dlen != ctemplate[i].inlen) {
> >  			printk(KERN_ERR "alg: comp: Compression test %d "
> >  			       "failed for %s: output len = %d\n", i + 1, algo,
> >  			       dlen);
> 
> Your patch is fine as it is.
> 
> But I just thought I'd mention that if anyone wants to we should
> really change this to use a different tfm, e.g., always use the
> generic algorithm to perform the decompression.  This way if there
> were multiple implementations we can at least test them against
> the generic one.
> 
> Otherwise you could end up with a buggy implementation that works
> against itself but still generates incorrect output.

Nice idea. Would a crypto_alloc_cipher("deflate", ...) pick the generic
implementation or how can we select it?

--Jan
