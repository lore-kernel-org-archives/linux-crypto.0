From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/5] crypto: dh - input validation fixes
Date: Fri, 10 Nov 2017 22:36:59 +1100
Message-ID: <20171110113659.GB26163@gondor.apana.org.au>
References: <20171106023048.8067-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Stephan Mueller <smueller@chronox.de>, qat-linux@intel.com,
        keyrings@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:35786 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752713AbdKJLiU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 06:38:20 -0500
Content-Disposition: inline
In-Reply-To: <20171106023048.8067-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 05, 2017 at 06:30:43PM -0800, Eric Biggers wrote:
> This series fixes several corner cases in the Diffie-Hellman key
> exchange implementations:
> 
> 1. With the software DH implementation, using a large buffer for 'g'
>    caused a double free.
> 2. With CONFIG_DEBUG_SG=y and the software DH implementation, setting 'p'
>    to 0 caused a BUG_ON().
> 3. With the QAT DH implementation, setting 'key' or 'g' larger than 'p'
>    caused a buffer underflow.
> 
> Note that in kernels configured with CONFIG_KEY_DH_OPERATIONS=y, these
> bugs are reachable by unprivileged users via KEYCTL_DH_COMPUTE.
> 
> Patches 4 and 5 are cleanup only.
> 
> Eric Biggers (5):
>   crypto: dh - Fix double free of ctx->p
>   crypto: dh - Don't permit 'p' to be 0
>   crypto: dh - Don't permit 'key' or 'g' size longer than 'p'
>   crypto: qat - Clean up error handling in qat_dh_set_secret()
>   crypto: dh - Remove pointless checks for NULL 'p' and 'g'

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
