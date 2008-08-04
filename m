From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
Date: Mon, 4 Aug 2008 12:25:57 +0200
Message-ID: <20080804102557.GA21265@Chamillionaire.breakpoint.cc>
References: <1217842507.20845.18.camel@localhost.localdomain> <1217844725.3454.580.camel@pmac.infradead.org>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Austin Zhang <austin_zhang@linux.intel.com>,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:41312 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbYHDK0L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 06:26:11 -0400
Content-Disposition: inline
In-Reply-To: <1217844725.3454.580.camel@pmac.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* David Woodhouse | 2008-08-04 11:12:05 [+0100]:

>On Mon, 2008-08-04 at 05:35 -0400, Austin Zhang wrote:
>> +u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, size_t
>> len)
>> +{
>> +       unsigned int iquotient = len / SCALE_F;
>> +       unsigned int iremainder = len % SCALE_F;
>> +#ifdef CONFIG_X86_64
>> +       u64 *ptmp = (u64 *)p;
>> +#else
>> +       u32 *ptmp = (u32 *)p;
>> +#endif
>
>You could perhaps just use 'unsigned long' here, to avoid the ifdef.
>
>And it would be nice if we could make libcrc32c use this too, rather
>than just the 'crypto' users.

I'm not sure if I remeber correctly but I thing Herbert was planning to
convert all users over to the crypto API to avoid compile time
dependency.

Sebastian
