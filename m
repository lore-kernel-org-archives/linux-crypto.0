From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 3/3] crypto: Fix leak of struct aead_request in
 test_aead_speed()
Date: Wed, 23 Apr 2014 10:26:06 -0700
Message-ID: <1398273966.2970.55.camel@schen9-DESK>
References: <20140421204439.7999f1c6@spike>  <20140421204705.07cb8278@spike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christian Engelmayer <cengelma@gmx.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3843 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbaDWR00 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Apr 2014 13:26:26 -0400
In-Reply-To: <20140421204705.07cb8278@spike>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2014-04-21 at 20:47 +0200, Christian Engelmayer wrote:
> Fix leakage of memory for struct aead_request that is allocated via
> aead_request_alloc() but not released via aead_request_free().
> Reported by Coverity - CID 1163869.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Acked.  Thanks for fixing the leak.

Tim

> ---
>  crypto/tcrypt.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 1849155..09c93ff2 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -320,7 +320,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int sec,
>  	if (!req) {
>  		pr_err("alg: aead: Failed to allocate request for %s\n",
>  		       algo);
> -		goto out;
> +		goto out_noreq;
>  	}
>  
>  	i = 0;
> @@ -390,6 +390,8 @@ static void test_aead_speed(const char *algo, int enc, unsigned int sec,
>  	} while (*keysize);
>  
>  out:
> +	aead_request_free(req);
> +out_noreq:
>  	crypto_free_aead(tfm);
>  out_notfm:
>  	kfree(sg);
