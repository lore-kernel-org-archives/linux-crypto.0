From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] crypto: Add AES-NI accelerated CTR mode
Date: Thu, 11 Mar 2010 12:15:10 -0800
Message-ID: <20100311121510.80a16ec4.akpm@linux-foundation.org>
References: <1267424076.1640.82.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758120Ab0CKUQQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Mar 2010 15:16:16 -0500
In-Reply-To: <1267424076.1640.82.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 01 Mar 2010 14:14:36 +0800
Huang Ying <ying.huang@intel.com> wrote:

> To take advantage of the hardware pipeline implementation of AES-NI
> instructions. CTR mode cryption is implemented in ASM to schedule
> multiple AES-NI instructions one after another. This way, some latency
> of AES-NI instruction can be eliminated.
> 
> Performance testing based on dm-crypt should 50% reduction of
> ecryption/decryption time.
> 
> ...
>
> +/*
> + * _aesni_inc_init:	internal ABI
> + *	setup registers used by _aesni_inc
> + * input:
> + *	IV
> + * output:
> + *	CTR:	== IV, in little endian
> + *	TCTR_LOW: == lower qword of CTR
> + *	INC:	== 1, in little endian
> + *	BSWAP_MASK == endian swapping mask
> + */
> +_aesni_inc_init:
> +	movaps .Lbswap_mask, BSWAP_MASK
> +	movaps IV, CTR
> +	PSHUFB_XMM BSWAP_MASK CTR
> +	mov $1, TCTR_LOW
> +	movq TCTR_LOW, INC
> +	movq CTR, TCTR_LOW

^^ these two lines don't assemble with gas 2.16.1:

arch/x86/crypto/aesni-intel_asm.S: Assembler messages:
arch/x86/crypto/aesni-intel_asm.S:752: Error: suffix or operands invalid for `movq'
arch/x86/crypto/aesni-intel_asm.S:753: Error: suffix or operands invalid for `movq'

> +	ret

