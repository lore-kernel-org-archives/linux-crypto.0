From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH 1/7] asm-generic/io.h: add io{read,write}64 accessors
Date: Thu, 5 May 2016 16:35:08 +0530
Message-ID: <572B28E4.3090700@synopsys.com>
References: <1462382179-11889-1-git-send-email-horia.geanta@nxp.com>
 <16429831.u9JK7qO1GE@wuerfel>
 <C2D7FE5348E1B147BCA15975FBA23075F4EA07DD@us01wembx1.internal.synopsys.com>
 <4560398.4eHNWD6mu5@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	arcml <linux-snps-arc@lists.infradead.org>,
	Noam Camus <noamc@ezchip.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <4560398.4eHNWD6mu5@wuerfel>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 05 May 2016 04:26 PM, Arnd Bergmann wrote:
> On Thursday 05 May 2016 08:16:47 Vineet Gupta wrote:
>> > Thx for noticing this Arnd and the heads up. Does the patch below look ok to you ?
>> > 
>> > ----------->
>> > rom b7e719831c389ab4fa338b2e2e7c0d1ff90dabb0 Mon Sep 17 00:00:00 2001
>> > From: Vineet Gupta <vgupta@synopsys.com>
>> > Date: Thu, 5 May 2016 13:32:34 +0530
>> > Subject: [PATCH] ARC: Add missing io barriers to io{read,write}{16,32}be()
>> > 
>> > While reviewing a different change to asm-generic/io.h Arnd spotted that
>> > ARC ioread32 and ioread32be both of which come from asm-generic versions
>> > are not symmetrical in terms of calling the io barriers.
>> > 
>> > generic ioread32   -> ARC readl()                  [ has barriers]
>> > generic ioread32be -> __be32_to_cpu(__raw_readl()) [ lacks barriers]
>> > 
>> > While generic ioread32be is being remediated to call readl(), that involves
>> > a swab32(), causing double swaps on ioread32be() on Big Endian systems.
>> > 
>> > So provide our versions of big endian IO accessors to ensure io barrier
>> > calls while also keeping them optimal
>> > 
>> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
>> > Cc: stable@vger.kernel.org  [4.2+]
>> > Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>
> Yes, that looks correct. We probably want this regardless of the change
> I proposed for the generic file, to avoid the double swap.

Indeed so - I've queued this for 4.6 fixes !

> Acked-by: Arnd Bergmann <arnd@arndb.de>

Thx !
