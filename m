From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - use calculated count for number of
 test vectors
Date: Fri, 13 Jan 2017 22:32:03 +0800
Message-ID: <20170113143203.GA25945@gondor.apana.org.au>
References: <1484228439-28373-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54323 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751482AbdAMOcJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 09:32:09 -0500
Content-Disposition: inline
In-Reply-To: <1484228439-28373-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 12, 2017 at 01:40:39PM +0000, Ard Biesheuvel wrote:
> When working on AES in CCM mode for ARM, my code passed the internal
> tcrypt test before I had even bothered to implement the AES-192 and
> AES-256 code paths, which is strange because the tcrypt does contain
> AES-192 and AES-256 test vectors for CCM.
> 
> As it turned out, the define AES_CCM_ENC_TEST_VECTORS was out of sync
> with the actual number of test vectors, causing only the AES-128 ones
> to be executed.
> 
> So get rid of the defines, and wrap the test vector references in a
> macro that calculates the number of vectors automatically.
> 
> The following test vector counts were out of sync with the respective
> defines:
> 
>     BF_CTR_ENC_TEST_VECTORS          2 ->  3
>     BF_CTR_DEC_TEST_VECTORS          2 ->  3
>     TF_CTR_ENC_TEST_VECTORS          2 ->  3
>     TF_CTR_DEC_TEST_VECTORS          2 ->  3
>     SERPENT_CTR_ENC_TEST_VECTORS     2 ->  3
>     SERPENT_CTR_DEC_TEST_VECTORS     2 ->  3
>     AES_CCM_ENC_TEST_VECTORS         8 -> 14
>     AES_CCM_DEC_TEST_VECTORS         7 -> 17
>     AES_CCM_4309_ENC_TEST_VECTORS    7 -> 23
>     AES_CCM_4309_DEC_TEST_VECTORS   10 -> 23
>     CAMELLIA_CTR_ENC_TEST_VECTORS    2 ->  3
>     CAMELLIA_CTR_DEC_TEST_VECTORS    2 ->  3
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
