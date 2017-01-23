From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: arm/aes-neonbs - fix issue with v2.22 and older
 assembler
Date: Mon, 23 Jan 2017 22:59:39 +0800
Message-ID: <20170123145939.GE20806@gondor.apana.org.au>
References: <1484828612-18956-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, arnd@arndb.de,
        paul.gortmaker@windriver.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37581 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751083AbdAWO7w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:59:52 -0500
Content-Disposition: inline
In-Reply-To: <1484828612-18956-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 19, 2017 at 12:23:32PM +0000, Ard Biesheuvel wrote:
> The GNU assembler for ARM version 2.22 or older fails to infer the
> element size from the vmov instructions, and aborts the build in
> the following way;
> 
> .../aes-neonbs-core.S: Assembler messages:
> .../aes-neonbs-core.S:817: Error: bad type for scalar -- `vmov q1h[1],r10'
> .../aes-neonbs-core.S:817: Error: bad type for scalar -- `vmov q1h[0],r9'
> .../aes-neonbs-core.S:817: Error: bad type for scalar -- `vmov q1l[1],r8'
> .../aes-neonbs-core.S:817: Error: bad type for scalar -- `vmov q1l[0],r7'
> .../aes-neonbs-core.S:818: Error: bad type for scalar -- `vmov q2h[1],r10'
> .../aes-neonbs-core.S:818: Error: bad type for scalar -- `vmov q2h[0],r9'
> .../aes-neonbs-core.S:818: Error: bad type for scalar -- `vmov q2l[1],r8'
> .../aes-neonbs-core.S:818: Error: bad type for scalar -- `vmov q2l[0],r7'
> 
> Fix this by setting the element size explicitly, by replacing vmov with
> vmov.32.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
