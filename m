From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: don't raise alarm for no ctr(aes*) tests in
	fips mode
Date: Wed, 29 Apr 2009 06:50:35 -0400
Message-ID: <20090429105035.GC7227@hmsreliant.think-freely.org>
References: <200904282118.22823.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45122 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZD2Kus (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2009 06:50:48 -0400
Content-Disposition: inline
In-Reply-To: <200904282118.22823.jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 28, 2009 at 09:18:22PM -0400, Jarod Wilson wrote:
> Per the NIST AESAVS document, Appendix A[1], it isn't possible to
> have automated self-tests for counter-mode AES, but people are
> misled to believe something is wrong by the message that says there
> is no test for ctr(aes). Simply suppress all 'no test for ctr(aes*'
> messages if fips_enabled is set to avoid confusion.
> 
> Dependent on earlier patch 'crypto: catch base cipher self-test
> failures in fips mode', which adds the test_done label.
> 
> [1] http://csrc.nist.gov/groups/STM/cavp/documents/aes/AESAVS.pdf
> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> ---
>  crypto/testmgr.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 5a50416..39ffa69 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -2134,6 +2134,17 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
>  				      type, mask);
>  	goto test_done;
>  notest:
> +	/*
> +	 * Per NIST AESAVS[1], it isn't possible to have automated self-tests
> +	 * for counter mode aes vectors, they have to be covered by ecb mode
> +	 * and code inspection. The ecb mode tests are trigger above in the
> +	 * CRYPTO_ALG_TYPE_CIPHER section. Suppress warnings about missing
> +	 * ctr tests if we're in fips mode to avoid confusion.
> +	 *
> +	 * [1] http://csrc.nist.gov/groups/STM/cavp/documents/aes/AESAVS.pdf
> +	 */
> +	if (fips_enabled && !strncmp(alg, "ctr(aes", 7))
> +		goto test_done;
>  	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);
>  test_done:
>  	if (fips_enabled && rc)
> 
>From the way I read the document, anything operating in a counter mode will have
an unpredictable output (given the counter operation isn't specified).  While
the above works, I'm not sure that it fully covers the various ccm modes
available (ccm_base and rfc4309).  Perhaps instead it would be better to add a
TFM mask flag indicating that the selected transform included a unpredictable
component or counter input (marking the alg as being unsuitable for automatic
testing without knoweldge of the inner workings of that counter.  Then you could
just test for that flag?

Neil

> -- 
> Jarod Wilson
> jarod@redhat.com
> 
