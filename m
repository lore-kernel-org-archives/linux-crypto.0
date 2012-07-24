From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH v1] crypto api: add crc32 pclmulqdq implementation and
 wrappers for table implementation
Date: Tue, 24 Jul 2012 23:40:07 +0300
Message-ID: <20120724234007.50311b69zskfiecg@www.81.fi>
References: <500EA8CA.6040705@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Alexander Boyko <alexander_boyko@xyratex.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:55627 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab2GXUkK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Jul 2012 16:40:10 -0400
In-Reply-To: <500EA8CA.6040705@xyratex.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Alexander Boyko <alexander_boyko@xyratex.com>:

> From: Alexander Boyko <alexander_boyko@xyratex.com>
>
> This patch adds crc32 algorithms to shash crypto api. One is wrapper  
> to generic crc32_le function. Second is crc32 pclmulqdq  
> implementation. It use hardware provided PCLMULQDQ instruction to  
> accelerate the CRC32
> disposal. This instruction present from Intel Westmere and AMD  
> Bulldozer CPUs.
>
> kernel 3.5rc7
>
> Signed-off-by: Alexander Boyko <alexander_boyko@xyratex.com>

<snip>

> +static u32 __attribute__((pure))
> +	crc32_pclmul_le(u32 crc, unsigned char const *p, size_t len)
> +{
> +	unsigned int iquotient;
> +	unsigned int iremainder;
> +	unsigned int prealign;
> +
> +	if (len < PCLMUL_MIN_LEN + SCALE_F_MASK)
> +		return crc32_le(crc, p, len);
> +
> +	if ((long)p & SCALE_F_MASK) {
> +		/* align p to 16 byte */
> +		prealign = SCALE_F - ((long)p & SCALE_F_MASK);
> +
> +		crc = crc32_le(crc, p, prealign);
> +		len -= prealign;
> +		p = (unsigned char *)(((unsigned long)p + SCALE_F_MASK) &
> +				     ~SCALE_F_MASK);
> +	}
> +	iquotient = len & (~SCALE_F_MASK);
> +	iremainder = len & SCALE_F_MASK;
> +
> +	kernel_fpu_begin();
> +	crc = crc32_pclmul_le_16(p, iquotient, crc);
> +	kernel_fpu_end();

You need to check if FPU is available to kernel with irq_fpu_usable()  
before kernel_fpu_begin()/kernel_fpu_end() block.

-Jussi
