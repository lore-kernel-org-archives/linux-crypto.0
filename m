From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: hash.h: Prevent use of req->result in ahash
 update
Date: Fri, 16 Mar 2018 23:56:10 +0800
Message-ID: <20180316155610.GG7095@gondor.apana.org.au>
References: <CGME20180307104934eucas1p18af0e65a519299997b5d2f7fb78cd39f@eucas1p1.samsung.com>
 <7850c31c-8703-51fb-0710-3b4920935bfc@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7850c31c-8703-51fb-0710-3b4920935bfc@partner.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 07, 2018 at 11:49:33AM +0100, Kamil Konieczny wrote:
> Prevent improper use of req->result field in ahash update, init, export and
> import functions in drivers code. A driver should use ahash request context
> if it needs to save internal state.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
