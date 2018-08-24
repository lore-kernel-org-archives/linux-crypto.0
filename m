From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Deadlock when using crypto API for block devices
Date: Fri, 24 Aug 2018 19:24:35 +0800
Message-ID: <20180824112435.ggizlqrymuibm6oo@gondor.apana.org.au>
References: <alpine.LRH.2.02.1808231621220.8560@file01.intranet.prod.int.rdu2.redhat.com>
 <20180824021010.hfar7gasp34ddrib@gondor.apana.org.au>
 <alpine.LRH.2.02.1808240659320.27014@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1808240659320.27014@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 24, 2018 at 07:06:32AM -0400, Mikulas Patocka wrote:
>
> A quick search through the crypto code shows that ahash_save_req and 
> seqiv_aead_encrypt return -ENOMEM.
> 
> Will you fix them?

These only trigger for unaligned buffers.  It would be much better
if dm-crypt can ensure that the input/output is properly unaligned
and if otherwise do the allocation in dm-crypt.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
