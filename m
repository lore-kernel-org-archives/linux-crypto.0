From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 00/10] crypto: x86_64 - Add SSE/AVX2 ChaCha20/Poly1305
 ciphers
Date: Fri, 17 Jul 2015 21:31:53 +0800
Message-ID: <20150717133153.GB23854@gondor.apana.org.au>
References: <1437066848-18048-1-git-send-email-martin@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, x86@kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54636 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003AbbGQNb5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jul 2015 09:31:57 -0400
Content-Disposition: inline
In-Reply-To: <1437066848-18048-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 16, 2015 at 07:13:58PM +0200, Martin Willi wrote:
> This patch series adds both ChaCha20 and Poly1305 specific ciphers for
> x86_64 using SSE2/SSSE3 and AVX2 instructions. The idea is to have a drop-in
> replacement for AESNI/CLMUL-accelerated AES-GCM providing at least somewhat
> comparable performance, refer to RFC7539 for details. It is based on cryptodev,
> including the ChaCha20/Poly1305 AEAD interface conversion patch.
> 
> The first patch adds some speed tests to tcrypt. The second patch exports
> some functionality from chacha20-generic to use it as fallback. Patch 3
> adds a single block SSSE3 driver for ChaCha20, while patch 4 and 5 extend it
> by an optimized four block SSSE3 and an eight block AVX2 variant. Patch 6
> adds an additional test vector for ChaCha20 to actually test the AVX2 eight
> block variant processing 512-bytes at once.
> 
> Patch 7 exports some poly1305-generic functionality to use it as fallback.
> Patch 8 introduces a single block SSE2 driver for Poly1305, while patch 9
> and 10 add an optimized two block SSE2 and a four block AVX2 variant.
> 
> Overall speedup for the ChaCha20/Poly1305 AEAD for typical IPsec payloads
> is ~50-150% with SSE2/SSSE3 and ~100-200% with AVX2, or even more for larger
> payloads:

All applied.  Thanks Martin!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
