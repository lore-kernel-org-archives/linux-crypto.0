From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH 3/7] asm-generic/io.h: make ioread64 and iowrite64 universally available
Date: Thu, 22 Jun 2017 10:48:13 -0600
Message-ID: <20170622164817.25515-4-logang@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-alpha@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170622164817.25515-1-logang@deltatee.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, ioread64 and iowrite64 are only available io CONFIG_64BIT=y
and CONFIG_GENERIC_IOMAP=n. Thus, seeing the functions are not
universally available, it makes them unusable for driver developers.
This leads to ugly hacks such as those at the top of

drivers/ntb/hw/intel/ntb_hw_intel.c

This patch adds fallback implementations for when CONFIG_64BIT and
CONFIG_GENERIC_IOMAP are not set. These functions use two io32 based
calls to complete the operation.

Note, we do not use the volatile keyword in these functions like the
others in the same file. It is necessary to avoid a compiler warning
on arm.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/io.h | 54 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 7ef015eb3403..817edaa3da78 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -585,15 +585,24 @@ static inline u32 ioread32(const volatile void __iomem *addr)
 }
 #endif
 
-#ifdef CONFIG_64BIT
 #ifndef ioread64
 #define ioread64 ioread64
-static inline u64 ioread64(const volatile void __iomem *addr)
+#ifdef readq
+static inline u64 ioread64(const void __iomem *addr)
 {
 	return readq(addr);
 }
+#else
+static inline u64 ioread64(const void __iomem *addr)
+{
+	u64 low, high;
+
+	low = ioread32(addr);
+	high = ioread32(addr + sizeof(u32));
+	return low | (high << 32);
+}
+#endif
 #endif
-#endif /* CONFIG_64BIT */
 
 #ifndef iowrite8
 #define iowrite8 iowrite8
@@ -619,15 +628,21 @@ static inline void iowrite32(u32 value, volatile void __iomem *addr)
 }
 #endif
 
-#ifdef CONFIG_64BIT
 #ifndef iowrite64
 #define iowrite64 iowrite64
-static inline void iowrite64(u64 value, volatile void __iomem *addr)
+#ifdef writeq
+static inline void iowrite64(u64 value, void __iomem *addr)
 {
 	writeq(value, addr);
 }
+#else
+static inline void iowrite64(u64 value, void __iomem *addr)
+{
+	iowrite32(value, addr);
+	iowrite32(value >> 32, addr + sizeof(u32));
+}
+#endif
 #endif
-#endif /* CONFIG_64BIT */
 
 #ifndef ioread16be
 #define ioread16be ioread16be
@@ -645,15 +660,24 @@ static inline u32 ioread32be(const volatile void __iomem *addr)
 }
 #endif
 
-#ifdef CONFIG_64BIT
 #ifndef ioread64be
 #define ioread64be ioread64be
-static inline u64 ioread64be(const volatile void __iomem *addr)
+#ifdef readq
+static inline u64 ioread64be(const void __iomem *addr)
 {
 	return swab64(readq(addr));
 }
+#else
+static inline u64 ioread64be(const void __iomem *addr)
+{
+	u64 low, high;
+
+	low = ioread32be(addr + sizeof(u32));
+	high = ioread32be(addr);
+	return low | (high << 32);
+}
+#endif
 #endif
-#endif /* CONFIG_64BIT */
 
 #ifndef iowrite16be
 #define iowrite16be iowrite16be
@@ -671,15 +695,21 @@ static inline void iowrite32be(u32 value, volatile void __iomem *addr)
 }
 #endif
 
-#ifdef CONFIG_64BIT
 #ifndef iowrite64be
 #define iowrite64be iowrite64be
-static inline void iowrite64be(u64 value, volatile void __iomem *addr)
+#ifdef writeq
+static inline void iowrite64be(u64 value, void __iomem *addr)
 {
 	writeq(swab64(value), addr);
 }
+#else
+static inline void iowrite64be(u64 value, void __iomem *addr)
+{
+	iowrite32be(value >> 32, addr);
+	iowrite32be(value, addr + sizeof(u32));
+}
+#endif
 #endif
-#endif /* CONFIG_64BIT */
 
 #ifndef ioread8_rep
 #define ioread8_rep ioread8_rep
-- 
2.11.0
