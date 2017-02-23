From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: vmx - Use skcipher for cbc fallback
Date: Thu, 23 Feb 2017 19:20:53 +0800
Message-ID: <20170223112052.GA14019@gondor.apana.org.au>
References: <20170222180015.27573-1-pfsmorigo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, mpe@ellerman.id.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        pfsmorigo@linux.vnet.ibm.com
To: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39693 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751032AbdBWLWB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2017 06:22:01 -0500
Content-Disposition: inline
In-Reply-To: <20170222180015.27573-1-pfsmorigo@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com> wrote:
>
>        fallback =
> -           crypto_alloc_blkcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
> +           crypto_alloc_skcipher(alg, 0, CRYPTO_ALG_NEED_FALLBACK);

You need to add CRYPTO_ALG_ASYNC to the mask in order to ensure
that you get a sync algorithm.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
