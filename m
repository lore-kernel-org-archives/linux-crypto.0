From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] n2rng: Use devm_kcalloc() in n2rng_probe()
Date: Fri, 21 Apr 2017 21:16:13 +0800
Message-ID: <20170421131612.GE14803@gondor.apana.org.au>
References: <4d9fbb01-e12f-eb5c-7ecd-5a2a10fd5110@users.sourceforge.net>
 <38c41219-7e7f-3a3e-29dd-04ae2d57beaa@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <38c41219-7e7f-3a3e-29dd-04ae2d57beaa@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 19, 2017 at 11:10:07AM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 19 Apr 2017 10:30:47 +0200
> 
> * A multiplication for the size determination of a memory allocation
>   indicated that an array data structure should be processed.
>   Thus use the corresponding function "devm_kcalloc".
> 
> * Replace the specification of a data structure by a pointer dereference
>   to make the corresponding size determination a bit safer according to
>   the Linux coding style convention.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
