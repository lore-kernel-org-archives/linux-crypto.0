From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] drivers/crypto/nx: saves chaining value from
 co-processor
Date: Fri, 9 Aug 2013 16:43:37 +1000
Message-ID: <20130809064337.GC23834@gondor.apana.org.au>
References: <1375917350.16050.14.camel@what-is-leg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, mhcerri@linux.vnet.ibm.com
To: Fionnuala Gunter <fin@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375917350.16050.14.camel@what-is-leg>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 07, 2013 at 06:15:50PM -0500, Fionnuala Gunter wrote:
> This patch fixes a bug that is triggered when cts(cbc(aes)) is used with
> nx-crypto driver on input larger than 32 bytes.
> 
> The chaining value from co-processor was not being saved. This value is
> needed because it is used as the IV by cts(cbc(aes)).
> 
> Signed-off-by: Fionnuala Gunter <fin@linux.vnet.ibm.com>
> Reviewed-by: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>
> ---
> v2. changed signed-off-by to reviewed-by and added more details to
> description
> 
> This bug appeared in the original submission (v3.5)

Patch applied.  However your patch was totally white-space damaged.
I've fixed it this time, but please fix this in your future
submissions.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
