From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/6] crypto: SHA1 multibuffer map scatter gather walk's
 buffer address directly for x86_64
Date: Wed, 14 May 2014 07:34:10 +0800
Message-ID: <20140513233410.GA28134@gondor.apana.org.au>
References: <cover.1399990803.git.tim.c.chen@linux.intel.com>
 <1400023182.2970.238.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:33762 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaEMXer (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 May 2014 19:34:47 -0400
Content-Disposition: inline
In-Reply-To: <1400023182.2970.238.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 13, 2014 at 04:19:42PM -0700, Tim Chen wrote:
> For x86_64, it is not necessary to incur the additional overhead in
> kmap_atomic to map the scatter gather buffer to a linear address.
> Mapping the address directly will allow in x86_64 allows multi-buffer
> crypto hash alogrithms to have several unfinished buffers with their
> address stored in job context before switching out of the crypto daemon.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  crypto/ahash.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index a92dc38..556f1fa 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -46,7 +46,11 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
>  	unsigned int nbytes = min(walk->entrylen,
>  				  ((unsigned int)(PAGE_SIZE)) - offset);
>  
> +#ifdef CONFIG_X86_64
> +	walk->data = page_address(walk->pg);
> +#else
>  	walk->data = kmap_atomic(walk->pg);
> +#endif

Why do we need this patch since kmap_atomic is equivalent to
page_address plus preempt_disable on x86-64?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
