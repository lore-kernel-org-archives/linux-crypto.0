From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Deadlock when using crypto API for block devices
Date: Fri, 24 Aug 2018 21:22:31 +0800
Message-ID: <20180824132231.t3narmsfcykseeee@gondor.apana.org.au>
References: <alpine.LRH.2.02.1808231621220.8560@file01.intranet.prod.int.rdu2.redhat.com>
 <20180824021010.hfar7gasp34ddrib@gondor.apana.org.au>
 <alpine.LRH.2.02.1808240659320.27014@file01.intranet.prod.int.rdu2.redhat.com>
 <20180824112435.ggizlqrymuibm6oo@gondor.apana.org.au>
 <alpine.LRH.2.02.1808240837120.11243@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1808240854010.15479@file01.intranet.prod.int.rdu2.redhat.com>
 <20180824132145.2zsnqwbih3iygeeq@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Dave Watson <davejwatson@fb.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180824132145.2zsnqwbih3iygeeq@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 24, 2018 at 09:21:45PM +0800, Herbert Xu wrote:
> On Fri, Aug 24, 2018 at 09:00:00AM -0400, Mikulas Patocka wrote:
> >
> > BTW. gcmaes_crypt_by_sg also contains GFP_ATOMIC and -ENOMEM, behind a 
> > pretty complex condition. Do you mean that this condition is part of the 
> > contract that the crypto API provides?
> 
> This is an implementation defect.  I think for this case we should
> fall back to software GCM if the accelerated version fails.
> 
> > Should "req->src->offset + req->src->length < PAGE_SIZE" use "<=" instead? 
> > Because if the data ends up at page boundary, it will use the atomic 
> > allocation that can fail.
> 
> This condition does look strange.  It's introduced by the commit
> e845520707f85c539ce04bb73c6070e9441480be.   Dave, what exactly is
> it meant to do?

I forgot to Cc Dave Watson.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
