From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 2/3] crypto: Fix potential leak in test_aead_speed() if
 crypto_alloc_aead() fails
Date: Wed, 23 Apr 2014 10:20:58 -0700
Message-ID: <1398273658.2970.54.camel@schen9-DESK>
References: <20140421204439.7999f1c6@spike>  <20140421204640.76380365@spike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christian Engelmayer <cengelma@gmx.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28222 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaDWRV3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Apr 2014 13:21:29 -0400
In-Reply-To: <20140421204640.76380365@spike>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2014-04-21 at 20:46 +0200, Christian Engelmayer wrote:
> Fix a potential memory leak in the error handling of test_aead_speed(). In case
> crypto_alloc_aead() fails, the function returns without going through the
> centralized cleanup path. Reported by Coverity - CID 1163870.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Acked.

Tim

> ---
>  crypto/tcrypt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index 1856d7f..1849155 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -313,7 +313,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int sec,
>  	if (IS_ERR(tfm)) {
>  		pr_err("alg: aead: Failed to load transform for %s: %ld\n", algo,
>  		       PTR_ERR(tfm));
> -		return;
> +		goto out_notfm;
>  	}
>  
>  	req = aead_request_alloc(tfm, GFP_KERNEL);
> @@ -391,6 +391,7 @@ static void test_aead_speed(const char *algo, int enc, unsigned int sec,
>  
>  out:
>  	crypto_free_aead(tfm);
> +out_notfm:
>  	kfree(sg);
>  out_nosg:
>  	testmgr_free_buf(xoutbuf);
