From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 2/8] asm-generic/io.h: add io{read,write}64 accessors
Date: Thu, 5 May 2016 18:35:56 +0300
Message-ID: <1462462556-27684-1-git-send-email-horia.geanta@nxp.com>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0067.outbound.protection.outlook.com ([157.56.111.67]:2176
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757638AbcEEPgG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 11:36:06 -0400
In-Reply-To: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This will allow device drivers to consistently use io{read,write}XX
also for 64-bit accesses.

Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
---
 include/asm-generic/io.h    | 63 +++++++++++++++++++++++++++++++++++++=
++++++++
 include/asm-generic/iomap.h |  8 ++++++
 2 files changed, 71 insertions(+)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index b79fb2c248a1..2af6ea95762d 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -585,6 +585,16 @@ static inline u32 ioread32(const volatile void __i=
omem *addr)
 }
 #endif
=20
+#ifdef CONFIG_64BIT
+#ifndef ioread64
+#define ioread64 ioread64
+static inline u64 ioread64(const volatile void __iomem *addr)
+{
+	return readq(addr);
+}
+#endif
+#endif /* CONFIG_64BIT */
+
 #ifndef iowrite8
 #define iowrite8 iowrite8
 static inline void iowrite8(u8 value, volatile void __iomem *addr)
@@ -609,6 +619,16 @@ static inline void iowrite32(u32 value, volatile v=
oid __iomem *addr)
 }
 #endif
=20
+#ifdef CONFIG_64BIT
+#ifndef iowrite64
+#define iowrite64 iowrite64
+static inline void iowrite64(u64 value, volatile void __iomem *addr)
+{
+	writeq(value, addr);
+}
+#endif
+#endif /* CONFIG_64BIT */
+
 #ifndef ioread16be
 #define ioread16be ioread16be
 static inline u16 ioread16be(const volatile void __iomem *addr)
@@ -625,6 +645,16 @@ static inline u32 ioread32be(const volatile void _=
_iomem *addr)
 }
 #endif
=20
+#ifdef CONFIG_64BIT
+#ifndef ioread64be
+#define ioread64be ioread64be
+static inline u64 ioread64be(const volatile void __iomem *addr)
+{
+	return swab64(readq(addr));
+}
+#endif
+#endif /* CONFIG_64BIT */
+
 #ifndef iowrite16be
 #define iowrite16be iowrite16be
 static inline void iowrite16be(u16 value, void volatile __iomem *addr)
@@ -641,6 +671,16 @@ static inline void iowrite32be(u32 value, volatile=
 void __iomem *addr)
 }
 #endif
=20
+#ifdef CONFIG_64BIT
+#ifndef iowrite64be
+#define iowrite64be iowrite64be
+static inline void iowrite64be(u64 value, volatile void __iomem *addr)
+{
+	writeq(swab64(value), addr);
+}
+#endif
+#endif /* CONFIG_64BIT */
+
 #ifndef ioread8_rep
 #define ioread8_rep ioread8_rep
 static inline void ioread8_rep(const volatile void __iomem *addr, void=
 *buffer,
@@ -668,6 +708,17 @@ static inline void ioread32_rep(const volatile voi=
d __iomem *addr,
 }
 #endif
=20
+#ifdef CONFIG_64BIT
+#ifndef ioread64_rep
+#define ioread64_rep ioread64_rep
+static inline void ioread64_rep(const volatile void __iomem *addr,
+				void *buffer, unsigned int count)
+{
+	readsq(addr, buffer, count);
+}
+#endif
+#endif /* CONFIG_64BIT */
+
 #ifndef iowrite8_rep
 #define iowrite8_rep iowrite8_rep
 static inline void iowrite8_rep(volatile void __iomem *addr,
@@ -697,6 +748,18 @@ static inline void iowrite32_rep(volatile void __i=
omem *addr,
 	writesl(addr, buffer, count);
 }
 #endif
+
+#ifdef CONFIG_64BIT
+#ifndef iowrite64_rep
+#define iowrite64_rep iowrite64_rep
+static inline void iowrite64_rep(volatile void __iomem *addr,
+				 const void *buffer,
+				 unsigned int count)
+{
+	writesq(addr, buffer, count);
+}
+#endif
+#endif /* CONFIG_64BIT */
 #endif /* CONFIG_GENERIC_IOMAP */
=20
 #ifdef __KERNEL__
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index d8f8622fa044..650fede33c25 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -30,12 +30,20 @@ extern unsigned int ioread16(void __iomem *);
 extern unsigned int ioread16be(void __iomem *);
 extern unsigned int ioread32(void __iomem *);
 extern unsigned int ioread32be(void __iomem *);
+#ifdef CONFIG_64BIT
+extern u64 ioread64(void __iomem *);
+extern u64 ioread64be(void __iomem *);
+#endif
=20
 extern void iowrite8(u8, void __iomem *);
 extern void iowrite16(u16, void __iomem *);
 extern void iowrite16be(u16, void __iomem *);
 extern void iowrite32(u32, void __iomem *);
 extern void iowrite32be(u32, void __iomem *);
+#ifdef CONFIG_64BIT
+extern void iowrite64(u64, void __iomem *);
+extern void iowrite64be(u64, void __iomem *);
+#endif
=20
 /*
  * "string" versions of the above. Note that they
--=20
2.4.4
