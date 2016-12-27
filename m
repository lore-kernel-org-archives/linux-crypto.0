From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: arm64/ARM: NEON accelerated ChaCha20
Date: Tue, 27 Dec 2016 18:04:00 +0800
Message-ID: <20161227100400.GA10629@gondor.apana.org.au>
References: <1481207339-17332-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41733 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752502AbcL0KEJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2016 05:04:09 -0500
Content-Disposition: inline
In-Reply-To: <1481207339-17332-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 08, 2016 at 02:28:57PM +0000, Ard Biesheuvel wrote:
> Another port of existing x86 SSE code to NEON, again both for arm64 and ARM.
> 
> ChaCha20 is a stream cipher described in RFC 7539, and is intended to be
> an efficient software implementable 'standby cipher', in case AES cannot
> be used.
> 
> This NEON implementation is almost 2x as fast as the generic C code
> (measured on Cortex-A57 using the arm64 version)
> 
> I'm aware that blkciphers are deprecated in favor of skciphers, but this
> code (like the x86 version) uses the init and setkey routines of the generic
> version, so it is probably better to port all implementations at once.
> 
> Ard Biesheuvel (2):
>   crypto: arm64/chacha20 - implement NEON version based on SSE3 code
>   crypto: arm/chacha20 - implement NEON version based on SSE3 code

Both patches applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
