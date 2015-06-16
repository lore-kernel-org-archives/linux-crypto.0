From: Jon Nettleton <jon.nettleton@gmail.com>
Subject: Re: [BUG?] crypto: caam: little/big endianness on ARM vs PPC
Date: Tue, 16 Jun 2015 10:11:09 +0200
Message-ID: <CALHpu35h7H30QbY3nrp-hXcwodYWjzMBQddz3KCTVOV4+Wcp5Q@mail.gmail.com>
References: <20150615155907.GC7947@pengutronix.de>
	<20150615220506.GA15134@gondor.apana.org.au>
	<BLUPR03MB391FCCC8B9AC019A0C8DA04E9A70@BLUPR03MB391.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Kim Phillips <kim.phillips@freescale.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Geanta Neag Horia <Horia.Geanta@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Victoria Milhoan <Vicki.Milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34103 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbbFPILK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 04:11:10 -0400
In-Reply-To: <BLUPR03MB391FCCC8B9AC019A0C8DA04E9A70@BLUPR03MB391.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Victoria,

I was hoping you would join the conversation.  I know you have a
series of patches in Freescale's 3.14 git repository.  Have you
updated those for mainline and published them for review and inclusion
in the upstream kernel?  If yes to any could you post a link?

-Jon

On Tue, Jun 16, 2015 at 5:27 AM, Victoria Milhoan
<Vicki.Milhoan@freescale.com> wrote:
> All,
>
> Freescale has been adding i.MX6 support to the CAAM driver and testing on both i.MX6 and QorIQ platforms. The patch series is now available for review. Your feedback for the provided patches is appreciated.
>
> Thanks,
> Victoria
>
> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
> Sent: Monday, June 15, 2015 3:05 PM
> To: Steffen Trumtrar
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-crypto@vger.kernel.org; Gupta Ruchika-R66431; kernel@pengutronix.de; Geanta Neag Horia Ioan-B05471; Kim Phillips
> Subject: Re: [BUG?] crypto: caam: little/big endianness on ARM vs PPC
>
> On Mon, Jun 15, 2015 at 05:59:07PM +0200, Steffen Trumtrar wrote:
>> Hi!
>>
>> I'm working on CAAM support for the ARM-based i.MX6 SoCs. The current
>> drivers/crypto/caam driver only works for PowerPC AFAIK.
>> Actually, there isn't that much to do, to get support for the i.MX6
>> but one patch breaks the driver severely:
>>
>>       commit ef94b1d834aace7101de77c3a7c2631b9ae9c5f6
>>       crypto: caam - Add definition of rd/wr_reg64 for little endian
>> platform
>>
>> This patch adds
>>
>> +#ifdef __LITTLE_ENDIAN
>> +static inline void wr_reg64(u64 __iomem *reg, u64 data) {
>> +     wr_reg32((u32 __iomem *)reg + 1, (data & 0xffffffff00000000ull) >> 32);
>> +     wr_reg32((u32 __iomem *)reg, data & 0x00000000ffffffffull); }
>>
>> The wr_reg64 function is only used in one place in the
>> drivers/crypto/caam/jr.c
>> driver: to write the dma_addr_t to the register. Without that patch
>> everything works fine on ARM (little endian, 32bit), with that patch
>> the driver will write 0's into the register that holds the DMA address (the numerically-higher) -> kernel hangs.
>> Also, from my understanding, the comment above the defines, stating
>> that you have to first write the numerically-lower and then the
>> numerically-higher address on 32bit systems doesn't match with the implementation.
>>
>> What I don't know/understand is if this makes any sense for any PowerPC implementation.
>>
>> So, the question is, how to fix this? I'd prefer to do it directly in
>> the jr driver instead of the ifdef-ery.
>>
>> Something like
>>       if (sizeof(dma_addr_t) == sizeof(u32))
>>               wr_reg32(&jrp->rregs->inpring_base + 1, inpbusaddr);
>>       else if (sizeof(dma_addr_t) == sizeof(u64))
>>               wr_reg64(...)
>>
>> or just go by DT compatible and then remove the inline function definitions.
>>
>> As far as I can tell, the compatible wouldn't be needed for anything
>> else in the jr driver, so maybe that is not optimal. On the other hand
>> the sizeof(..) solution would only catch little endian on 32bit and
>> not big endian (?!) I however don't know what combinations actually
>> *have* to be caught, as I don't know, which exist.
>>
>> So, what do you think people?
>
> I'm adding a couple of CCs.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
