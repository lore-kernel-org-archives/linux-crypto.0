From: Dave Watson <davejwatson@fb.com>
Subject: Re: Deadlock when using crypto API for block devices
Date: Fri, 24 Aug 2018 09:02:55 -0700
Message-ID: <20180824160255.rg7lgt2tcbwjc5xn@mmilisic-mbp.dhcp.thefacebook.com>
References: <alpine.LRH.2.02.1808231621220.8560@file01.intranet.prod.int.rdu2.redhat.com>
 <20180824021010.hfar7gasp34ddrib@gondor.apana.org.au>
 <alpine.LRH.2.02.1808240659320.27014@file01.intranet.prod.int.rdu2.redhat.com>
 <20180824112435.ggizlqrymuibm6oo@gondor.apana.org.au>
 <alpine.LRH.2.02.1808240837120.11243@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1808240854010.15479@file01.intranet.prod.int.rdu2.redhat.com>
 <20180824132145.2zsnqwbih3iygeeq@gondor.apana.org.au>
 <20180824132231.t3narmsfcykseeee@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, Mike Snitzer <msnitzer@redhat.com>,
        <dm-devel@redhat.com>, <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180824132231.t3narmsfcykseeee@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 08/24/18 09:22 PM, Herbert Xu wrote:
> > > BTW. gcmaes_crypt_by_sg also contains GFP_ATOMIC and -ENOMEM, behind a 
> > > pretty complex condition. Do you mean that this condition is part of the 
> > > contract that the crypto API provides?
> > 
> > This is an implementation defect.  I think for this case we should
> > fall back to software GCM if the accelerated version fails.
> > 
> > > Should "req->src->offset + req->src->length < PAGE_SIZE" use "<=" instead? 
> > > Because if the data ends up at page boundary, it will use the atomic 
> > > allocation that can fail.
> > 
> > This condition does look strange.  It's introduced by the commit
> > e845520707f85c539ce04bb73c6070e9441480be.   Dave, what exactly is
> > it meant to do?

The aesni routines still require linear AAD data, the condition checks
that the AAD data is linear, and if not, kmallocs and copies it to a
linear buffer.

Yes, the condition looks like it could be <= PAGE_SIZE, similar to the
one in gcmaes_encrypt.

Yes, we should fall back to software gcm if kmalloc fails, although
AAD data is usually small, and it is probably worth having a small
stack buffer before attempting to kmalloc.
