From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/3] crypto: arm64/chacha20 - implement NEON version
 based on SSE3 code
Date: Tue, 27 Dec 2016 17:00:01 +0800
Message-ID: <20161227090001.GB10121@gondor.apana.org.au>
References: <1481294033-23508-1-git-send-email-ard.biesheuvel@linaro.org>
 <1481294033-23508-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59987 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751900AbcL0JAL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 04:00:11 -0500
Content-Disposition: inline
In-Reply-To: <1481294033-23508-3-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 09, 2016 at 02:33:52PM +0000, Ard Biesheuvel wrote:
>
> +	.chunksize		= 4 * CHACHA20_BLOCK_SIZE,

This should use a new attribute specific to the walk interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
