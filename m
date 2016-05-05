From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH 1/7] asm-generic/io.h: add io{read,write}64 accessors
Date: Thu, 5 May 2016 08:16:47 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075F4EA07DD@us01wembx1.internal.synopsys.com>
References: <1462382179-11889-1-git-send-email-horia.geanta@nxp.com>
 <16429831.u9JK7qO1GE@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
To: Arnd Bergmann <arnd@arndb.de>,
	=?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:59933 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbcEEIQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 04:16:53 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 05 May 2016 04:06 AM, Arnd Bergmann wrote:
> On Wednesday 04 May 2016 20:16:19 Horia Geant=E3 wrote:
>> @@ -625,6 +645,16 @@ static inline u32 ioread32be(const volatile voi=
d __iomem *addr)
>>  }
>>  #endif
>> =20
>> +#ifdef CONFIG_64BIT
>> +#ifndef ioread64be
>> +#define ioread64be ioread64be
>> +static inline u64 ioread64be(const volatile void __iomem *addr)
>> +{
>> +       return __be64_to_cpu(__raw_readq(addr));
>> +}
>> +#endif
>> +#endif /* CONFIG_64BIT */
>> +
>>  #ifndef iowrite16be
>>  #define iowrite16be iowrite16be
>>  static inline void iowrite16be(u16 value, void volatile __iomem *ad=
dr)
>> @@ -641,6 +671,16 @@ static inline void iowrite32be(u32 value, volat=
ile void __iomem *addr)
>>  }
>>  #endif
>> =20
>> +#ifdef CONFIG_64BIT
>> +#ifndef iowrite64be
>> +#define iowrite64be iowrite64be
>> +static inline void iowrite64be(u64 value, volatile void __iomem *ad=
dr)
>> +{
>> +       __raw_writeq(__cpu_to_be64(value), addr);
>> +}
>> +#endif
>> +#endif /* CONFIG_64BIT */
>> +
>>
> I just noticed that these two are both a bit wrong, but they copy the
> mistake that already exists in the 16 and 32 bit versions: If an
> architecture overrides readq/writeq to have barriers but does not ove=
rride
> ioread64be/iowrite64be, this will lack the barriers and behave differ=
ently
> from the little-endian version. I think the only affected architectur=
e
> is ARC, since ARM and ARM64 both override the big-endian accessors to
> have the correct barriers, and all others don't use barriers at all.
>
> Maybe you can add a patch before this one to replace the 16/32-bit ac=
cessors
> with ones that do a
>
> static inline void iowrite32be(u32 value, volatile void __iomem *addr=
)
> {
> 	writel(swab32(value), addr);
> }
>
> This will lead to a double-swap on architectures that don't override =
it,
> but it will work correctly on all architectures without them having
> to override the big-endian accessors.

Thx for noticing this Arnd and the heads up. Does the patch below look =
ok to you ?

----------->
rom b7e719831c389ab4fa338b2e2e7c0d1ff90dabb0 Mon Sep 17 00:00:00 2001
=46rom: Vineet Gupta <vgupta@synopsys.com>
Date: Thu, 5 May 2016 13:32:34 +0530
Subject: [PATCH] ARC: Add missing io barriers to io{read,write}{16,32}b=
e()

While reviewing a different change to asm-generic/io.h Arnd spotted tha=
t
ARC ioread32 and ioread32be both of which come from asm-generic version=
s
are not symmetrical in terms of calling the io barriers.

generic ioread32   -> ARC readl()                  [ has barriers]
generic ioread32be -> __be32_to_cpu(__raw_readl()) [ lacks barriers]

While generic ioread32be is being remediated to call readl(), that invo=
lves
a swab32(), causing double swaps on ioread32be() on Big Endian systems.

So provide our versions of big endian IO accessors to ensure io barrier
calls while also keeping them optimal

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org  [4.2+]
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/io.h | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/arch/arc/include/asm/io.h b/arch/arc/include/asm/io.h
index 17f85c9c73cf..c22b181e8206 100644
--- a/arch/arc/include/asm/io.h
+++ b/arch/arc/include/asm/io.h
@@ -13,6 +13,15 @@
 #include <asm/byteorder.h>
 #include <asm/page.h>
=20
+#ifdef CONFIG_ISA_ARCV2
+#include <asm/barrier.h>
+#define __iormb()        rmb()
+#define __iowmb()        wmb()
+#else
+#define __iormb()        do { } while (0)
+#define __iowmb()        do { } while (0)
+#endif
+
 extern void __iomem *ioremap(phys_addr_t paddr, unsigned long size);
 extern void __iomem *ioremap_prot(phys_addr_t paddr, unsigned long siz=
e,
                   unsigned long flags);
@@ -31,6 +40,15 @@ extern void iounmap(const void __iomem *addr);
 #define ioremap_wc(phy, sz)        ioremap(phy, sz)
 #define ioremap_wt(phy, sz)        ioremap(phy, sz)
=20
+/*
+ * io{read,write}{16,32}be() macros
+ */
+#define ioread16be(p)        ({ u16 __v =3D be16_to_cpu((__force
__be16)__raw_readw(p)); __iormb(); __v; })
+#define ioread32be(p)        ({ u32 __v =3D be32_to_cpu((__force
__be32)__raw_readl(p)); __iormb(); __v; })
+
+#define iowrite16be(v,p)    ({ __iowmb(); __raw_writew((__force
u16)cpu_to_be16(v), p); })
+#define iowrite32be(v,p)    ({ __iowmb(); __raw_writel((__force
u32)cpu_to_be32(v), p); })
+
 /* Change struct page to physical address */
 #define page_to_phys(page)        (page_to_pfn(page) << PAGE_SHIFT)
=20
@@ -108,15 +126,6 @@ static inline void __raw_writel(u32 w, volatile vo=
id __iomem
*addr)
=20
 }
=20
-#ifdef CONFIG_ISA_ARCV2
-#include <asm/barrier.h>
-#define __iormb()        rmb()
-#define __iowmb()        wmb()
-#else
-#define __iormb()        do { } while (0)
-#define __iowmb()        do { } while (0)
-#endif
-
 /*
  * MMIO can also get buffered/optimized in micro-arch, so barriers nee=
ded
  * Based on ARM model for the typical use case
--=20
2.5.0
