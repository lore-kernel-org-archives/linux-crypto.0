From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/mcryptd: Check mcryptd algorithm compatibility
Date: Wed, 7 Dec 2016 19:49:43 +0800
Message-ID: <20161207114942.GA20525@gondor.apana.org.au>
References: <6825659d1f6a96d4ab2327aa0dcf357f6252e915.1480967128.git.tim.c.chen@linux.intel.com>
 <alpine.LRH.2.02.1612061604480.942@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>, megha.dey@linux.intel.com,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Milan Broz <mbroz@redhat.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1612061604480.942@file01.intranet.prod.int.rdu2.redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 06, 2016 at 04:07:46PM -0500, Mikulas Patocka wrote:
> I think a proper fix would be to find the reason why mcryptd crashes and 
> fix that reason (i.e. make it fail in mcryptd_create_hash rather than 
> crash).
> 
> Testing flags could fix the bug for now but it could backfire later when 
> more algorithms are added.

I agree that a better solution is needed for the next merge window.
The problem here is that mcryptd is only meant to be used on specific
algorithms, so it shouldn't have been a template in the first place.

It should instead switch over to the simd model of creating new
algorithms.  So I'd like to see patch for the next merge window
that converted mcryptd and its users to something similar to what
we do in crypto/simd.c.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
