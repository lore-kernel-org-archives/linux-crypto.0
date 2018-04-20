From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/ecc: Actually remove stack VLA usage
Date: Sat, 21 Apr 2018 00:50:18 +0800
Message-ID: <20180420165017.eqnez3jprvwawgsy@gondor.apana.org.au>
References: <20180330165544.GA13206@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180330165544.GA13206@beast>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 30, 2018 at 09:55:44AM -0700, Kees Cook wrote:
> On the quest to remove all VLAs from the kernel[1], this avoids VLAs
> by just using the maximum allocation size (4 bytes) for stack arrays.
> All the VLAs in ecc were either 3 or 4 bytes (or a multiple), so just
> make it 4 bytes all the time. Initialization routines are adjusted to
> check that ndigits does not end up larger than the arrays.
> 
> This includes a removal of the earlier attempt at this fix from
> commit a963834b4742 ("crypto/ecc: Remove stack VLA usage")
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
