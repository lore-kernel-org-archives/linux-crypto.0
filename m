From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: add infra to skip disallowed algs in fips
	mode
Date: Fri, 8 May 2009 10:12:33 +0800
Message-ID: <20090508021233.GA20388@gondor.apana.org.au>
References: <200905071441.27093.jarod@redhat.com> <200905071527.59809.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43231 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753385AbZEHCMh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 May 2009 22:12:37 -0400
Content-Disposition: inline
In-Reply-To: <200905071527.59809.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 07, 2009 at 03:27:59PM -0400, Jarod Wilson wrote:
> Because all fips-allowed algorithms must be self-tested before they
> can be used, they will all have entries in testmgr.c's alg_test_descs[].
> If we add and set an additional flag for the allowed algorithms, we can
> key off of it to prevent use of any algs that aren't allowed.
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> ---
>  crypto/testmgr.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index f4cc178..232f043 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -94,6 +94,7 @@ struct alg_test_desc {
>  	const char *alg;
>  	int (*test)(const struct alg_test_desc *desc, const char *driver,
>  		    u32 type, u32 mask);
> +	int fips_allowed;	/* set if alg is allowed in fips mode */
>  
>  	union {
>  		struct aead_test_suite aead;

Please merge this chunk with the second patch into one and have
it as the first patch.  We want this to be bisectable.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
