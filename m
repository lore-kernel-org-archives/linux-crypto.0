From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [PATCH 4/4] ARM: add support for bit sliced AES using NEON instructions
Date: Sun, 22 Sep 2013 14:12:07 +0300
Message-ID: <523ED087.7050006@iki.fi>
References: <1379702811-8025-1-git-send-email-ard.biesheuvel@linaro.org> <1379702811-8025-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: nico@linaro.org, Andy Polyakov <appro@openssl.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59313 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab3IVLML (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 22 Sep 2013 07:12:11 -0400
In-Reply-To: <1379702811-8025-5-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 20.09.2013 21:46, Ard Biesheuvel wrote:
> This implementation of the AES algorithm gives around 45% speedup on Cortex-A15
> for CTR mode and for XTS in encryption mode. Both CBC and XTS in decryption mode
> are slightly faster (5 - 10% on Cortex-A15). [As CBC in encryption mode can only
> be performed sequentially, there is no speedup in this case.]
> 
> Unlike the core AES cipher (on which this module also depends), this algorithm
> uses bit slicing to process up to 8 blocks in parallel in constant time. This
> algorithm does not rely on any lookup tables so it is believed to be
> invulnerable to cache timing attacks.
> 
> The core code has been adopted from the OpenSSL project (in collaboration
> with the original author, on cc). For ease of maintenance, this version is
> identical to the upstream OpenSSL code, i.e., all modifications that were
> required to make it suitable for inclusion into the kernel have already been
> merged upstream.
> 
> Cc: Andy Polyakov <appro@openssl.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
[..snip..]
> +	bcc	.Ldec_done
> +	@ multiplication by 0x0e

Decryption can probably be made faster by implementing InvMixColumns slightly
differently. Instead of implementing inverse MixColumns matrix directly, use
preprocessing step, followed by MixColumns as described in section "4.1.3
Decryption" of "The Design of Rijndael: AES - The Advanced Encryption Standard"
(J. Daemen, V. Rijmen / 2002).

In short, the MixColumns and InvMixColumns matrixes have following relation:
 | 0e 0b 0d 09 |   | 02 03 01 01 |   | 05 00 04 00 |
 | 09 0e 0b 0d | = | 01 02 03 01 | x | 00 05 00 04 |
 | 0d 09 0e 0b |   | 01 01 02 03 |   | 04 00 05 00 |
 | 0b 0d 09 0e |   | 03 01 01 02 |   | 00 04 00 05 |

Bit-sliced implementation of the 05-00-04-00 matrix much shorter than 0e-0b-0d-09
matrix, so even when combined with MixColumns total instruction count for
InvMixColumns implemented this way should be nearly half of current.

Check [1] for implementation of this on AVX instruction set.

-Jussi

[1] https://github.com/jkivilin/supercop-blockciphers/blob/beyond_master/crypto_stream/aes128ctr/avx/aes_asm_bitslice_avx.S#L234
