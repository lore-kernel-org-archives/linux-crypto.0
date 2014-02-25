From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] arm64: add support for AES in CCM mode using Crypto
 Extensions
Date: Tue, 25 Feb 2014 15:02:52 +0800
Message-ID: <20140225070252.GB9934@gondor.apana.org.au>
References: <1392106905-28709-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	will.deacon@arm.com, nico@linaro.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:47055 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaBYHDA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 02:03:00 -0500
Content-Disposition: inline
In-Reply-To: <1392106905-28709-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 11, 2014 at 09:21:45AM +0100, Ard Biesheuvel wrote:
> This adds support for a synchronous implementation of AES in CCM mode
> using ARMv8 Crypto Extensions, using NEON registers q0 - q5.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> Hi all,
> 
> I am posting this for review/RFC. The main topic for feedback is the way
> I have used an inner blkcipher instance to process the encrypted + authenticated
> data.
> 
> The point of having a dedicated module for synchronous ccm(aes) is the fact that
> mac80211 uses it for WPA2 CCMP en-/decryption, where it runs entirely in soft
> IRQ context. In this case, the performance improvement offered by dedicated AES
> instructions is likely wasted on stacking and unstacking the NEON register file,
> as the generic CCM operates on a single AES block at a time.
> 
> Instead, this implementation interleaves the CTR and CBC modes at the round
> level, eliminating 50% of both the input and round key loads and (hopefully)
> eliminating pipeline stalls by operating on two AES blocks at a time.
> 
> Tested with tcrypt, no performance numbers yet.

I think your idea definitely make sense, since we do the same
thing in aesni-intel.

It'll be interesting to see some numbers, especially if we could
compare this against the generic version that we talked about
earlier.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
