From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: vmx - Use skcipher for cbc fallback
Date: Thu, 23 Feb 2017 19:21:56 +0800
Message-ID: <20170223112156.GA14038@gondor.apana.org.au>
References: <20170222221700.GA19026@gallifrey>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Marcelo Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59639 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751191AbdBWLWF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2017 06:22:05 -0500
Content-Disposition: inline
In-Reply-To: <20170222221700.GA19026@gallifrey>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Marcelo Cerri <marcelo.cerri@canonical.com> wrote:
>
> I noticed you used a similar approach in arch/s390/crypto/aes_s390.c
> (commit 64e2680).
> 
> How do you ensure the skcipher operation will not be asynchronous? 

You need to set the bit CRYPTO_ALG_ASYNC in the mask field when
allocating the algorithm to ensure that it's synchronous.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
