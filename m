From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: handle ccm dec test vectors expected to
	fail verification
Date: Mon, 20 Apr 2009 14:25:43 +0800
Message-ID: <20090420062543.GA1135@gondor.apana.org.au>
References: <200904091434.59639.jarod@redhat.com> <200904150835.38818.jarod@redhat.com> <200904150935.15947.jarod@redhat.com> <200904150936.43919.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33643 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751300AbZDTGZq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2009 02:25:46 -0400
Content-Disposition: inline
In-Reply-To: <200904150936.43919.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 15, 2009 at 09:36:43AM -0400, Jarod Wilson wrote:
> Add infrastructure to tcrypt to support handling ccm decryption test
> vectors that are expected to fail verification.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> ---
>  crypto/testmgr.c |   32 ++++++++++++++++++++++++++++++++
>  crypto/testmgr.h |    1 +
>  2 files changed, 33 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index a8bdcb3..92f4df0 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -373,6 +373,16 @@ static int test_aead(struct crypto_aead *tfm, int enc,
>  
>  			switch (ret) {
>  			case 0:
> +				if (template[i].novrfy) {
> +					/* verification was supposed to fail */
> +					printk(KERN_ERR "alg: aead: %s failed "
> +					       "on test %d for %s: ret was 0, "
> +					       "expected -EBADMSG\n",
> +					       e, j, algo);
> +					/* so really, we got a bad message */
> +					ret = -EBADMSG;
> +					goto out;
> +				}
>  				break;
>  			case -EINPROGRESS:
>  			case -EBUSY:
> @@ -382,6 +392,10 @@ static int test_aead(struct crypto_aead *tfm, int enc,
>  					INIT_COMPLETION(result.completion);
>  					break;
>  				}
> +			case -EBADMSG:
> +				if (template[i].novrfy)
> +					/* verification failure was expected */
> +					goto next_aead_vector;
>  				/* fall through */

How about just doing continue instead of having this goto?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
