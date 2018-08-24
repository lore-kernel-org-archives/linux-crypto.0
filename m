From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Deadlock when using crypto API for block devices
Date: Fri, 24 Aug 2018 07:22:19 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1808240711380.28952@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1808231621220.8560@file01.intranet.prod.int.rdu2.redhat.com> <20180824021010.hfar7gasp34ddrib@gondor.apana.org.au> <alpine.LRH.2.02.1808240659320.27014@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1808240659320.27014@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Fri, 24 Aug 2018, Mikulas Patocka wrote:

> 
> 
> On Fri, 24 Aug 2018, Herbert Xu wrote:
> 
> > On Thu, Aug 23, 2018 at 04:39:23PM -0400, Mikulas Patocka wrote:
> > >
> > > 1. don't set CRYPTO_TFM_REQ_MAY_SLEEP in dm-crypt
> > > =================================================
> > > If we don't set it, dm-crypt will use GFP_ATOMIC and GFP_ATOMIC may fail. 
> > > The function init_crypt in xts.c handles the failure gracefully - but the 
> > > question is - does the whole crypto code handle allocation failures 
> > > gracefully? If not and if it returns -ENOMEM somewhere, it would result in 
> > > I/O errors and data corruption.
> > 
> > It is safe to use GFP_ATOMIC.  First of the allocation is really
> > small (less than a page) so it will only fail when the system is
> > almost completely out of memory.
> 
> GFP_ATOMIC is used by networking code. If the system is in a situation 
> when packets arrive faster than the swapper is able to swap, it will 
> happen. It does happen during netwoking surge and corrupting the 
> filesystem in tris situation is not acceptable.
> 
> > Even when it does fail the crypto
> > operation will still succeed, albeit it will process things at a
> > smaller granularity so the performance will degrade.
> 
> A quick search through the crypto code shows that ahash_save_req and 
> seqiv_aead_encrypt return -ENOMEM.
> 
> Will you fix them?

And also ablkcipher_next_slow, ablkcipher_copy_iv, skcipher_next_slow, 
skcipher_next_copy, skcipher_copy_iv, blkcipher_next_slow, 
blkcipher_copy_iv.

So, I think that dropping CRYPTO_TFM_REQ_MAY_SLEEP is not possible.

Mikulas
