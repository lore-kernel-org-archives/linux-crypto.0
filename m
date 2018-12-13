Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50496 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726886AbeLMKbu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 05:31:50 -0500
Date: Thu, 13 Dec 2018 18:31:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
        Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH v2 0/3] crypto: arm64/chacha - performance improvements
Message-ID: <20181213103147.goqqtdbps3hif4ic@gondor.apana.org.au>
References: <20181204131333.15046-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204131333.15046-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 04, 2018 at 02:13:30PM +0100, Ard Biesheuvel wrote:
> Improve the performance of NEON based ChaCha:
> 
> Patch #1 adds a block size of 1472 to the tcrypt test template so we have
> something that reflects the VPN case.
> 
> Patch #2 improves performance for arbitrary length inputs: on deep pipelines,
> throughput increases ~30% when running on inputs blocks whose size is drawn
> randomly from the interval [64, 1024)
> 
> Patch #3 adopts the OpenSSL approach to use the ALU in parallel with the
> SIMD unit to process a fifth block while the SIMD is operating on 4 blocks.
> 
> Performance on Cortex-A57:
> 
> BEFORE:
> =======
> testing speed of async chacha20 (chacha20-neon) encryption
> tcrypt: test 0 (256 bit key, 16 byte blocks): 2528223 operations in 1 seconds (40451568 bytes)
> tcrypt: test 1 (256 bit key, 64 byte blocks): 2518155 operations in 1 seconds (161161920 bytes)
> tcrypt: test 2 (256 bit key, 256 byte blocks): 1207948 operations in 1 seconds (309234688 bytes)
> tcrypt: test 3 (256 bit key, 1024 byte blocks): 332194 operations in 1 seconds (340166656 bytes)
> tcrypt: test 4 (256 bit key, 1472 byte blocks): 185659 operations in 1 seconds (273290048 bytes)
> tcrypt: test 5 (256 bit key, 8192 byte blocks): 41829 operations in 1 seconds (342663168 bytes)
> 
> AFTER:
> ======
> testing speed of async chacha20 (chacha20-neon) encryption
> tcrypt: test 0 (256 bit key, 16 byte blocks): 2530018 operations in 1 seconds (40480288 bytes)
> tcrypt: test 1 (256 bit key, 64 byte blocks): 2518270 operations in 1 seconds (161169280 bytes)
> tcrypt: test 2 (256 bit key, 256 byte blocks): 1187760 operations in 1 seconds (304066560 bytes)
> tcrypt: test 3 (256 bit key, 1024 byte blocks): 361652 operations in 1 seconds (370331648 bytes)
> tcrypt: test 4 (256 bit key, 1472 byte blocks): 280971 operations in 1 seconds (413589312 bytes)
> tcrypt: test 5 (256 bit key, 8192 byte blocks): 53654 operations in 1 seconds (439533568 bytes)
> 
> Zinc:
> =====
> testing speed of async chacha20 (chacha20-software) encryption
> tcrypt: test 0 (256 bit key, 16 byte blocks): 2510300 operations in 1 seconds (40164800 bytes)
> tcrypt: test 1 (256 bit key, 64 byte blocks): 2663794 operations in 1 seconds (170482816 bytes)
> tcrypt: test 2 (256 bit key, 256 byte blocks): 1237617 operations in 1 seconds (316829952 bytes)
> tcrypt: test 3 (256 bit key, 1024 byte blocks): 364645 operations in 1 seconds (373396480 bytes)
> tcrypt: test 4 (256 bit key, 1472 byte blocks): 251548 operations in 1 seconds (370278656 bytes)
> tcrypt: test 5 (256 bit key, 8192 byte blocks): 47650 operations in 1 seconds (390348800 bytes)
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Martin Willi <martin@strongswan.org>
> 
> Ard Biesheuvel (3):
>   crypto: tcrypt - add block size of 1472 to skcipher template
>   crypto: arm64/chacha - optimize for arbitrary length inputs
>   crypto: arm64/chacha - use combined SIMD/ALU routine for more speed
> 
>  arch/arm64/crypto/chacha-neon-core.S | 396 +++++++++++++++++++-
>  arch/arm64/crypto/chacha-neon-glue.c |  59 ++-
>  crypto/tcrypt.c                      |   2 +-
>  3 files changed, 404 insertions(+), 53 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
