From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 2/7] arm64: add io{read,write}64be accessors
Date: Wed, 4 May 2016 20:16:30 +0300
Message-ID: <1462382190-11937-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:31420
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752759AbcEDRQk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 13:16:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This will allow device drivers to consistently use io{read,write}XXbe
also for 64-bit accesses.

Signed-off-by: Alex Porosanu <alexandru.porosanu@nxp.com>
Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
---
 arch/arm64/include/asm/io.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 44be1e03ed65..9b6e408cfa51 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -174,13 +174,15 @@ extern void __iomem *ioremap_cache(phys_addr_t ph=
ys_addr, size_t size);
 #define iounmap				__iounmap
=20
 /*
- * io{read,write}{16,32}be() macros
+ * io{read,write}{16,32,64}be() macros
  */
 #define ioread16be(p)		({ __u16 __v =3D be16_to_cpu((__force __be16)__=
raw_readw(p)); __iormb(); __v; })
 #define ioread32be(p)		({ __u32 __v =3D be32_to_cpu((__force __be32)__=
raw_readl(p)); __iormb(); __v; })
+#define ioread64be(p)		({ __u64 __v =3D be64_to_cpu((__force __be64)__=
raw_readq(p)); __iormb(); __v; })
=20
 #define iowrite16be(v,p)	({ __iowmb(); __raw_writew((__force __u16)cpu=
_to_be16(v), p); })
 #define iowrite32be(v,p)	({ __iowmb(); __raw_writel((__force __u32)cpu=
_to_be32(v), p); })
+#define iowrite64be(v,p)	({ __iowmb(); __raw_writeq((__force __u64)cpu=
_to_be64(v), p); })
=20
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
--=20
2.4.4
