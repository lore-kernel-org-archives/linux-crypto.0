From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Deadlock when using crypto API for block devices
Date: Fri, 24 Aug 2018 10:10:10 +0800
Message-ID: <20180824021010.hfar7gasp34ddrib@gondor.apana.org.au>
References: <alpine.LRH.2.02.1808231621220.8560@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1808231621220.8560@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 23, 2018 at 04:39:23PM -0400, Mikulas Patocka wrote:
>
> 1. don't set CRYPTO_TFM_REQ_MAY_SLEEP in dm-crypt
> =================================================
> If we don't set it, dm-crypt will use GFP_ATOMIC and GFP_ATOMIC may fail. 
> The function init_crypt in xts.c handles the failure gracefully - but the 
> question is - does the whole crypto code handle allocation failures 
> gracefully? If not and if it returns -ENOMEM somewhere, it would result in 
> I/O errors and data corruption.

It is safe to use GFP_ATOMIC.  First of the allocation is really
small (less than a page) so it will only fail when the system is
almost completely out of memory.  Even when it does fail the crypto
operation will still succeed, albeit it will process things at a
smaller granularity so the performance will degrade.

The sleeping part of that flag is also not an issue because it
only kicks in once per page.  As this is going to be less than
or equal to a page it shouldn't matter.
 
> 3. introduce new flag CRYPTO_TFM_REQ_MAY_SLEEP_NOIO
> ===================================================
> Would you like to introduce it?

For now I don't think this is necessary given that this allocation
and similar ones in lrw and other places in the crypto API are just
performance enhancements and unlikely to fail except in very dire
situations.

But if new problems arise I'm certainly not opposed to this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
