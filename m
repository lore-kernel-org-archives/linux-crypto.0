Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD92C4646B
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 04:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA2C52086D
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 04:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561522318;
	bh=TaN+8d3Gw4d0lsqEYeKUloheJDpnR2XoiYv0FKk3LjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=x4DvGtgVaxzy3MO8X4H8ShcFfify5e+l/kQAnWcAVml0Kso0TGhnj/Ey6xHIBONdF
	 3xvVq0h6DRMek5iTFcsTxHjKL4Mmwu2VS5n2he0EFXahvPJop2cz2/kK/Y0hcR+Lge
	 LiHgV4pNXhih31s6CabEfHgNtg0xAB2fjiMlETe0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbfFZEL5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jun 2019 00:11:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfFZEL5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jun 2019 00:11:57 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AF6020645;
        Wed, 26 Jun 2019 04:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561522316;
        bh=TaN+8d3Gw4d0lsqEYeKUloheJDpnR2XoiYv0FKk3LjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S/FlPSa6ao0p9tJloXWj0+82MSH0aUpBRpY3U5+qHHRM9w4lY4rI0Z37/e3DZeVcp
         hpGNbXunoGNeT/HeZFWenkqpFYTInH5iBKM2sW5yl2VyOizzygD0eLyBANCwRT032e
         3OY7dmbyyyNI3DbIb17JYdtAIJxISqWvjkDYZ8mE=
Date:   Tue, 25 Jun 2019 21:11:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH v2 00/26]crypto: AES cleanup
Message-ID: <20190626041155.GC745@sol.localdomain>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 22, 2019 at 09:34:01PM +0200, Ard Biesheuvel wrote:
> This started out as an attempt to provide synchronous SIMD based GCM
> on 32-bit ARM, but along the way, I ended up changing and cleaning up
> so many things that it is more of a general AES cleanup now rather than
> anything else.
> 
> Changes since v1/RFC:
> - rename x86 AES-NI and padlock routines as well, in order to avoid clashes (#2)
> - move irq en/disabling out of the AES library into the callers (aes-ti
>   and the skcipher helper for sync ctr(aes) added in #17)
> - align 32-bit ARM CE key schedule endianness with other AES drivers, to
>   avoid problems on BE systems when using the synchronous ctr fallback (#18)
> - replace some occurrences where a "aes" or "aes-generic" cipher was allocated
>   explicitly, and use library calls instead.
> - use a generic helper in crypto/ctr.h instead of adding a CTR helper to the
>   AES library for providing the synchronous CTR fallback code.
> 
> Some users of the AES cipher are being switched to other algorithms (i.e.,
> SipHash for TCP fastopen and CCM or cbcmac for wusb and lib80211). These
> have been posted separately, since they have no build time interdependencies.
> 
> ----- Original blurb below ------
> 
> On 32-bit ARM, asynchronous GCM can be provided by the following drivers:
> 
>                                               |  cycles per byte on low end Si
>   gcm_base(ctr(aes-generic),ghash-generic)    |            65.3
>   gcm_base(ctr-aes-neonbs,ghash-ce) [*]       |            27.7
>   gcm_base(ctr-aes-ce,ghash-ce) [**]          |             3.7
> 
>   [*]  ghash-ce using vmull.p8 instructions
>   [**] ghash-ce using optional vmull.p64 instructions
> 
> The third and fastest option is actually only available on 32-bit cores that
> implement the v8 Crypto Extensions, which are rare, but the NEON based runner
> up is obviously a huge improvement over the generic code, not only in terms of
> performance, but also because it is time invariant (generic AES and generic
> GHASH are both implemented using lookup tables, which are susceptible to
> cache timing attacks)
> 
> However, when allocating the gcm(aes) skcipher in synchronous mode, we end up
> with the generic code, due to the fact that the NEON code has no handling for
> invocations that occur from a context where the NEON cannot be used, and so
> it defers the processing to a kthread, which is only permitted for asynchronous
> ciphers.
> 
> So let's implement this fallback handling, by reusing some of the logic that
> has already been implemented for arm64. Note that these fallbacks are rarely
> called in practice, but the API requires the functionality to be there.
> This is implemented in patches 16-22.
> 
> All the patches leading up to that are cleanups for the AES code, to reduce
> the dependency on the generic table based AES code, or in some cases, hardcoded
> dependencies on the scalar arm64 asm code which suffers from the same problem.
> It also removes redundant key expansion routines, and gets rid of the x86
> scalar asm code, which is a maintenance burden and is not actually faster than
> the generic code built with a modern compiler.
> 
> Ard Biesheuvel (26):
>   crypto: arm/aes-ce - cosmetic/whitespace cleanup
>   crypto: aes - rename local routines to prevent future clashes
>   crypto: aes/fixed-time - align key schedule with other implementations
>   crypto: aes - create AES library based on the fixed time AES code
>   crypto: x86/aes-ni - switch to generic for fallback and key routines
>   crypto: x86/aes - drop scalar assembler implementations
>   crypto: padlock/aes - switch to library version of key expansion
>     routine
>   crypto: cesa/aes - switch to library version of key expansion routine
>   crypto: safexcel/aes - switch to library version of key expansion
>     routine
>   crypto: arm64/ghash - switch to AES library
>   crypto: arm/aes-neonbs - switch to library version of key expansion
>     routine
>   crypto: arm64/aes-ccm - switch to AES library
>   crypto: arm64/aes-neonbs - switch to library version of key expansion
>     routine
>   crypto: arm64/aes-ce - switch to library version of key expansion
>     routine
>   crypto: generic/aes - drop key expansion routine in favor of library
>     version
>   crypto: ctr - add helper for performing a CTR encryption walk
>   crypto: aes - move sync ctr(aes) to AES library and generic helper
>   crypto: arm64/aes-ce-cipher - use AES library as fallback
>   crypto: aes/arm - use native endiannes for key schedule
>   crypto: arm/aes-ce - provide a synchronous version of ctr(aes)
>   crypto: arm/aes-neonbs - provide a synchronous version of ctr(aes)
>   crypto: arm/ghash - provide a synchronous version
>   bluetooth: switch to AES library
>   crypto: amcc/aes - switch to AES library for GCM key derivation
>   crypto: ccp - move to AES library for CMAC key derivation
>   crypto: chelsio/aes - replace AES cipher calls with library calls
> 

I'm seeing the following self-tests failures with this patchset applied:

On arm32:

[   20.956118] alg: skcipher: ctr-aes-ce-sync encryption test failed (wrong result) on test vector 0, cfg="random: inplace use_digest nosimd src_divs=[100.0%@+3650] iv_offset=9"
[   28.344185] alg: skcipher: ctr-aes-neonbs-sync encryption test failed (wrong result) on test vector 0, cfg="random: inplace use_final nosimd src_divs=[16.88%@+3, <flush>39.11%@+1898, <reimport>44.1%@+5] iv_offset=13"

On arm64:

[   15.528433] alg: skcipher: ctr-aes-ce encryption test failed (wrong result) on test vector 0, cfg="random: use_digest nosimd src_divs=[100.0%@+4078]"
[   20.080914] alg: skcipher: ctr-aes-neon encryption test failed (wrong result) on test vector 0, cfg="random: inplace use_final nosimd src_divs=[50.90%@+255, <flush,nosimd>49.10%@+25]"

Maybe a bug in crypto_ctr_encrypt_walk()?

- Eric
