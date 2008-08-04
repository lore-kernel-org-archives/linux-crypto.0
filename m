From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
Date: Mon, 04 Aug 2008 11:12:05 +0100
Message-ID: <1217844725.3454.580.camel@pmac.infradead.org>
References: <1217842507.20845.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Austin Zhang <austin_zhang@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbYHDKMV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 06:12:21 -0400
In-Reply-To: <1217842507.20845.18.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2008-08-04 at 05:35 -0400, Austin Zhang wrote:
> +u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, size_t
> len)
> +{
> +       unsigned int iquotient = len / SCALE_F;
> +       unsigned int iremainder = len % SCALE_F;
> +#ifdef CONFIG_X86_64
> +       u64 *ptmp = (u64 *)p;
> +#else
> +       u32 *ptmp = (u32 *)p;
> +#endif

You could perhaps just use 'unsigned long' here, to avoid the ifdef.

And it would be nice if we could make libcrc32c use this too, rather
than just the 'crypto' users.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



