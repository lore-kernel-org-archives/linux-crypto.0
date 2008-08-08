From: "Ulrich Drepper" <drepper@gmail.com>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API -V3.
Date: Thu, 7 Aug 2008 20:38:35 -0700
Message-ID: <a36005b50808072038w3e88658p6769e1e3779b6cab@mail.gmail.com>
References: <1218000211.4231.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, bunk@kernel.org, dwmw2@infradead.org,
	davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: "Austin Zhang" <austin_zhang@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from po-out-1718.google.com ([72.14.252.152]:25757 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYHHDig (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Aug 2008 23:38:36 -0400
Received: by po-out-1718.google.com with SMTP id c31so1151837poi.1
        for <linux-crypto@vger.kernel.org>; Thu, 07 Aug 2008 20:38:35 -0700 (PDT)
In-Reply-To: <1218000211.4231.23.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 5, 2008 at 10:23 PM, Austin Zhang
<austin_zhang@linux.intel.com> wrote:
> +#ifdef CONFIG_X86_64
> +#define REX_PRE "0x48, "
> +#define SCALE_F 8
> +#else
> +#define REX_PRE
> +#define SCALE_F 4
> +#endif
[...]
> +static u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, size_t len)
> +{
> +       unsigned int iquotient = len / SCALE_F;
> +       unsigned int iremainder = len % SCALE_F;
> +       unsigned long *ptmp = (unsigned long *)p;
> +
> +       while (iquotient--) {
> +               __asm__ __volatile__(
> +                       ".byte 0xf2, " REX_PRE "0xf, 0x38, 0xf1, 0xf1;"
> +                       :"=S"(crc)
> +                       :"0"(crc), "c"(*ptmp)
> +               );
> +               ptmp++;

I think you want to use

  #define SCALE_F sizeof(unsigned long)

Since the loop iteration count etc depends on

   ptmp++

which depends on the type being unsigned long.
