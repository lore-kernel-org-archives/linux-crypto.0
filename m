From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Documentation: crypto: Fixed bugs, added example usage
 of calc_hash().
Date: Mon, 19 Jun 2017 14:40:44 +0800
Message-ID: <20170619064044.GB13800@gondor.apana.org.au>
References: <CGME20170512153803eucas1p1d3029703e8edee069e4aa3c578885d00@eucas1p1.samsung.com>
 <98b6249c-cd31-10cb-1527-9d95ac26f10e@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <98b6249c-cd31-10cb-1527-9d95ac26f10e@partner.samsung.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 12, 2017 at 05:38:02PM +0200, Kamil Konieczny wrote:
> - Fixed bugs in example for shash and rng (added missing "*" and " *").
> - Corrected pr_info() in calc_hash().
> - Added example usage of calc_hash().
> - No need for negate PTR_ERR to get error code, as crypto_alloc_rng
>   already returns negative values like ERR_PTR(-ENOMEM). Fixed.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
