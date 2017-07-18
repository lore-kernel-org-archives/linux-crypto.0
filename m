From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/7] crypto: aes - allow generic AES to be omitted
Date: Tue, 18 Jul 2017 13:25:56 +0800
Message-ID: <20170718052556.GA4532@gondor.apana.org.au>
References: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, nico@linaro.org, ebiggers3@gmail.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:49442 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdGRF0X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 01:26:23 -0400
Content-Disposition: inline
In-Reply-To: <1497950940-24243-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 20, 2017 at 11:28:53AM +0200, Ard Biesheuvel wrote:
> The generic AES driver uses 16 lookup tables of 1 KB each, and has
> encryption and decryption routines that are fully unrolled. Given how
> the dependencies between this code and other drivers are declared in
> Kconfig files, this code is always pulled into the core kernel, even
> if it is usually superseded at runtime by accelerated drivers that
> exist for many architectures.

Why can't we simply replace aes-generic with aes-ti?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
