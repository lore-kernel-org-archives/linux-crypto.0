From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] crypto: aes - add generic time invariant AES cipher
Date: Sat, 11 Feb 2017 18:52:33 +0800
Message-ID: <20170211105233.GD855@gondor.apana.org.au>
References: <1486053460-7526-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ebiggers3@gmail.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36097 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750994AbdBKTAB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2017 14:00:01 -0500
Content-Disposition: inline
In-Reply-To: <1486053460-7526-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 02, 2017 at 04:37:40PM +0000, Ard Biesheuvel wrote:
> Lookup table based AES is sensitive to timing attacks, which is due to
> the fact that such table lookups are data dependent, and the fact that
> 8 KB worth of tables covers a significant number of cachelines on any
> architecture, resulting in an exploitable correlation between the key
> and the processing time for known plaintexts.
> 
> For network facing algorithms such as CTR, CCM or GCM, this presents a
> security risk, which is why arch specific AES ports are typically time
> invariant, either through the use of special instructions, or by using
> SIMD algorithms that don't rely on table lookups.
> 
> For generic code, this is difficult to achieve without losing too much
> performance, but we can improve the situation significantly by switching
> to an implementation that only needs 256 bytes of table data (the actual
> S-box itself), which can be prefetched at the start of each block to
> eliminate data dependent latencies.
> 
> This code encrypts at ~25 cycles per byte on ARM Cortex-A57 (while the
> ordinary generic AES driver manages 18 cycles per byte on this
> hardware). Decryption is substantially slower.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
