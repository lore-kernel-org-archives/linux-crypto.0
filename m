From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Documentation: hw_random: Fix issue related to feeding
 entropy pool
Date: Fri, 22 Sep 2017 17:17:49 +0800
Message-ID: <20170922091749.GA15902@gondor.apana.org.au>
References: <20170822161544.24958-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: corbet@lwn.net, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, prasannatsmkumar@gmail.com
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170822161544.24958-1-prasannatsmkumar@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com> wrote:
> There is no need to use rng-tools for feeding random data into kernel
> entropy pool as hw_random core handles it. Documentation suggested that
> rng-tools is required which is incorrect. So remove it.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>

Hmm, the tool still exists and can still be used to feed /dev/random.

Feeding /dev/random directly from the kernel is just one way of
using hwrng.

So rather than removing it perhaps you can modify it to state that
the kernel can now feed /dev/random as an option.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
