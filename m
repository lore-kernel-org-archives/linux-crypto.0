From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: print self-test pass notices in fips mode
Date: Wed, 29 Apr 2009 06:52:16 -0400
Message-ID: <20090429105216.GD7227@hmsreliant.think-freely.org>
References: <200904282121.35300.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45128 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbZD2KwY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2009 06:52:24 -0400
Content-Disposition: inline
In-Reply-To: <200904282121.35300.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2009 at 09:21:35PM -0400, Jarod Wilson wrote:
> According to our FIPS CAVS testing lab guru, when we're in fips mode,
> we *must* print out notices of successful self-test completion for
> every alg to be compliant.
> 
> Dependent on patch 'crypto: catch base cipher self-test failures in
> fips mode', which adds the test_done label.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> ---
>  crypto/testmgr.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 39ffa69..d0cc85c 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2149,6 +2149,10 @@ notest:
>  test_done:
>  	if (fips_enabled && rc)
>  		panic("%s: %s alg self test failed in fips mode!\n", driver, alg);
> +	/* fips mode requires we print out self-test success notices */
> +	if (fips_enabled && !rc && strncmp(alg, "ctr(aes", 7))
> +		printk(KERN_INFO "alg: self-tests for %s (%s) passed\n",
> +		       driver, alg);
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(alg_test);
> 
> -- 
> Jarod Wilson
> jarod@redhat.com
> 

Acked-by: Neil Horman <nhorman@tuxdriver.com>
