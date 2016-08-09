From: Tapas Sarangi <TSarangi@trustwave.com>
Subject: Re: [PATCH] crypto: DRBG: do not call drbg_instantiate in healt test
Date: Tue, 9 Aug 2016 21:59:44 +0000
Message-ID: <D3CFBBE7.2B1D%tsarangi@trustwave.com>
References: <D3CF7065.28F3%tsarangi@trustwave.com>
 <D3CF7805.2937%tsarangi@trustwave.com>
 <2671088.6l5BeQPtPO@positron.chronox.de>
 <6079382.fWeFLzBGfE@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from seg-node-chi-01.trustwave.com ([204.13.200.29]:1593 "EHLO
	seg-node-chi-01.trustwave.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932398AbcHIV7t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 17:59:49 -0400
In-Reply-To: <6079382.fWeFLzBGfE@positron.chronox.de>
Content-Language: en-US
Content-ID: <5B962B8BC9B1D741BF8D7C85E9504A10@namprd07.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

Thanks. The patch that I applied have different line numbers than yours.
In any case, patch worked to get rid of Œdrbg¹ related error.

Now, fips mode is failing on self-test:

/boot/vmlinuz-4.7.0-1.tos2_5: OK
[    1.296714] alg: skcipher: setkey failed on test 1 for xts(aes-asm):
flags=100000
[    1.297665] Kernel panic - not syncing: xts(aes): xts(aes) alg self
test failed in fips mode!
[    1.297665]




Thanks
-Tapas



On 8/9/16, 2:02 PM, "Stephan Mueller" <smueller@chronox.de> wrote:

>Am Dienstag, 9. August 2016, 19:52:46 CEST schrieb Stephan Mueller:
>
>Hi Tapas,
>
>I think I found the issue. Can you please test the attached patch?
>
>---8<---
>
>When calling the DRBG health test in FIPS mode, the Jitter RNG is not
>yet present in the kernel crypto API which will cause the instantiation
>to fail and thus the health test to fail.
>
>As the health tests cover the enforcement of various thresholds, invoke
>the functions that are supposed to enforce the thresholds directly.
>
>This patch also saves precious seed.
>
>Reported-by: Tapas Sarangi <TSarangi@trustwave.com>
>Signed-off-by: Stephan Mueller <smueller@chronox.de>
>---
> crypto/drbg.c | 15 ++++-----------
> 1 file changed, 4 insertions(+), 11 deletions(-)
>
>diff --git a/crypto/drbg.c b/crypto/drbg.c
>index f752da3..edf3ce0 100644
>--- a/crypto/drbg.c
>+++ b/crypto/drbg.c
>@@ -1917,6 +1917,8 @@ static inline int __init
>drbg_healthcheck_sanity(void)
>               return -ENOMEM;
>
>       mutex_init(&drbg->drbg_mutex);
>+      drbg->core = &drbg_cores[coreref];
>+      drbg->reseed_threshold = drbg_max_requests(drbg);
>
>       /*
>        * if the following tests fail, it is likely that there is a buffer
>@@ -1926,12 +1928,6 @@ static inline int __init
>drbg_healthcheck_sanity(void)
>        * grave bug.
>        */
>
>-      /* get a valid instance of DRBG for following tests */
>-      ret = drbg_instantiate(drbg, NULL, coreref, pr);
>-      if (ret) {
>-              rc = ret;
>-              goto outbuf;
>-      }
>       max_addtllen = drbg_max_addtl(drbg);
>       max_request_bytes = drbg_max_request_bytes(drbg);
>       drbg_string_fill(&addtl, buf, max_addtllen + 1);
>@@ -1941,10 +1937,9 @@ static inline int __init
>drbg_healthcheck_sanity(void)
>       /* overflow max_bits */
>       len = drbg_generate(drbg, buf, (max_request_bytes + 1), NULL);
>       BUG_ON(0 < len);
>-      drbg_uninstantiate(drbg);
>
>       /* overflow max addtllen with personalization string */
>-      ret = drbg_instantiate(drbg, &addtl, coreref, pr);
>+      ret = drbg_seed(drbg, &addtl, false);
>       BUG_ON(0 == ret);
>       /* all tests passed */
>       rc = 0;
>@@ -1952,9 +1947,7 @@ static inline int __init
>drbg_healthcheck_sanity(void)
>       pr_devel("DRBG: Sanity tests for failure code paths successfully "
>                "completed\n");
>
>-      drbg_uninstantiate(drbg);
>-outbuf:
>-      kzfree(drbg);
>+      kfree(drbg);
>       return rc;
> }
>
>--
>2.7.4
>
>


________________________________

This transmission may contain information that is privileged, confidential, and/or exempt from disclosure under applicable law. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or use of the information contained herein (including any reliance thereon) is strictly prohibited. If you received this transmission in error, please immediately contact the sender and destroy the material in its entirety, whether in electronic or hard copy format.
