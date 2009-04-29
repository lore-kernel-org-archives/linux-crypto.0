From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: print self-test pass notices in fips mode
Date: Wed, 29 Apr 2009 21:18:17 +0800
Message-ID: <20090429131817.GB17254@gondor.apana.org.au>
References: <200904282121.35300.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761346AbZD2NTu@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200904282121.35300.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 28, 2009 at 09:21:35PM -0400, Jarod Wilson wrote:
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

What is this strncmp crap for?
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
