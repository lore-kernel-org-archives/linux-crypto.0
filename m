From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Deadlock when using crypto API for block devices
Date: Fri, 24 Aug 2018 08:37:52 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1808240837120.11243@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1808231621220.8560@file01.intranet.prod.int.rdu2.redhat.com> <20180824021010.hfar7gasp34ddrib@gondor.apana.org.au> <alpine.LRH.2.02.1808240659320.27014@file01.intranet.prod.int.rdu2.redhat.com>
 <20180824112435.ggizlqrymuibm6oo@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180824112435.ggizlqrymuibm6oo@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Fri, 24 Aug 2018, Herbert Xu wrote:

> On Fri, Aug 24, 2018 at 07:06:32AM -0400, Mikulas Patocka wrote:
> >
> > A quick search through the crypto code shows that ahash_save_req and 
> > seqiv_aead_encrypt return -ENOMEM.
> > 
> > Will you fix them?
> 
> These only trigger for unaligned buffers.  It would be much better
> if dm-crypt can ensure that the input/output is properly unaligned
> and if otherwise do the allocation in dm-crypt.

But we are relying here on an implementation detail and not on contract.

Mikulas
