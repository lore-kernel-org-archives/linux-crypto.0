From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH 2/7] iomap: implement ioread64 and iowrite64
Date: Thu, 22 Jun 2017 10:48:12 -0600
Message-ID: <20170622164817.25515-3-logang@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-alpha@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20170622164817.25515-1-logang@deltatee.com>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently, ioread64 and iowrite64 are not impleminted in the generic
iomap implementation. The prototypes are defined if CONFIG_64BIT is set
but there is no actual implementation.

Seeing the functions are not universally available, they are unusable
for driver developers. This leads to ugly hacks such as those at
the top of

drivers/ntb/hw/intel/ntb_hw_intel.c

This patch adds generic implementations for these functions. We add
the obvious version if readq/writeq are implemented and fall back
to using two io32 calls in cases that don't provide direct 64bit
accesses. Thus making the functions universally available to
configurations with CONFIG_GENERIC_IOMAP=y.

For any pio accesses, the 64bit operations remain unsupported and
simply call bad_io_access in cases readq would be called.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Suresh Warrier <warrier@linux.vnet.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/io.h |  2 ++
 include/asm-generic/iomap.h   |  4 ---
 lib/iomap.c                   | 62 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 422f99cf9924..11a83667d2c3 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -788,8 +788,10 @@ extern void __iounmap_at(void *ea, unsigned long size);
 
 #define mmio_read16be(addr)		readw_be(addr)
 #define mmio_read32be(addr)		readl_be(addr)
+#define mmio_read64be(addr)		readq_be(addr)
 #define mmio_write16be(val, addr)	writew_be(val, addr)
 #define mmio_write32be(val, addr)	writel_be(val, addr)
+#define mmio_write64be(val, addr)	writeq_be(val, addr)
 #define mmio_insb(addr, dst, count)	readsb(addr, dst, count)
 #define mmio_insw(addr, dst, count)	readsw(addr, dst, count)
 #define mmio_insl(addr, dst, count)	readsl(addr, dst, count)
diff --git a/include/asm-generic/iomap.h b/include/asm-generic/iomap.h
index 650fede33c25..43ec4ea9f6f9 100644
--- a/include/asm-generic/iomap.h
+++ b/include/asm-generic/iomap.h
@@ -30,20 +30,16 @@ extern unsigned int ioread16(void __iomem *);
 extern unsigned int ioread16be(void __iomem *);
 extern unsigned int ioread32(void __iomem *);
 extern unsigned int ioread32be(void __iomem *);
-#ifdef CONFIG_64BIT
 extern u64 ioread64(void __iomem *);
 extern u64 ioread64be(void __iomem *);
-#endif
 
 extern void iowrite8(u8, void __iomem *);
 extern void iowrite16(u16, void __iomem *);
 extern void iowrite16be(u16, void __iomem *);
 extern void iowrite32(u32, void __iomem *);
 extern void iowrite32be(u32, void __iomem *);
-#ifdef CONFIG_64BIT
 extern void iowrite64(u64, void __iomem *);
 extern void iowrite64be(u64, void __iomem *);
-#endif
 
 /*
  * "string" versions of the above. Note that they
diff --git a/lib/iomap.c b/lib/iomap.c
index fc3dcb4b238e..e38e036cb52f 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -66,6 +66,7 @@ static void bad_io_access(unsigned long port, const char *access)
 #ifndef mmio_read16be
 #define mmio_read16be(addr) be16_to_cpu(__raw_readw(addr))
 #define mmio_read32be(addr) be32_to_cpu(__raw_readl(addr))
+#define mmio_read64be(addr) be64_to_cpu(__raw_readq(addr))
 #endif
 
 unsigned int ioread8(void __iomem *addr)
@@ -93,11 +94,45 @@ unsigned int ioread32be(void __iomem *addr)
 	IO_COND(addr, return pio_read32be(port), return mmio_read32be(addr));
 	return 0xffffffff;
 }
+
+#ifdef readq
+u64 ioread64(void __iomem *addr)
+{
+	IO_COND(addr, bad_io_access(port, "ioread64"), return readq(addr));
+	return 0xffffffffffffffffLL;
+}
+u64 ioread64be(void __iomem *addr)
+{
+	IO_COND(addr, bad_io_access(port, "ioread64be"),
+		return mmio_read64be(addr));
+	return 0xffffffffffffffffLL;
+}
+#else
+u64 ioread64(void __iomem *addr)
+{
+	u64 low, high;
+
+	low = ioread32(addr);
+	high = ioread32(addr + sizeof(u32));
+	return low | (high << 32);
+}
+u64 ioread64be(void __iomem *addr)
+{
+	u64 low, high;
+
+	low = ioread32be(addr + sizeof(u32));
+	high = ioread32be(addr);
+	return low | (high << 32);
+}
+#endif
+
 EXPORT_SYMBOL(ioread8);
 EXPORT_SYMBOL(ioread16);
 EXPORT_SYMBOL(ioread16be);
 EXPORT_SYMBOL(ioread32);
 EXPORT_SYMBOL(ioread32be);
+EXPORT_SYMBOL(ioread64);
+EXPORT_SYMBOL(ioread64be);
 
 #ifndef pio_write16be
 #define pio_write16be(val,port) outw(swab16(val),port)
@@ -107,6 +142,7 @@ EXPORT_SYMBOL(ioread32be);
 #ifndef mmio_write16be
 #define mmio_write16be(val,port) __raw_writew(be16_to_cpu(val),port)
 #define mmio_write32be(val,port) __raw_writel(be32_to_cpu(val),port)
+#define mmio_write64be(val,port) __raw_writeq(be64_to_cpu(val),port)
 #endif
 
 void iowrite8(u8 val, void __iomem *addr)
@@ -129,11 +165,37 @@ void iowrite32be(u32 val, void __iomem *addr)
 {
 	IO_COND(addr, pio_write32be(val,port), mmio_write32be(val, addr));
 }
+
+#ifdef writeq
+void iowrite64(u64 val, void __iomem *addr)
+{
+	IO_COND(addr, bad_io_access(port, "iowrite64"), writeq(val, addr));
+}
+void iowrite64be(u64 val, void __iomem *addr)
+{
+	IO_COND(addr, bad_io_access(port, "iowrite64be"),
+		mmio_write64be(val, addr));
+}
+#else
+void iowrite64(u64 val, void __iomem *addr)
+{
+	iowrite32(val, addr);
+	iowrite32(val >> 32, addr + sizeof(u32));
+}
+void iowrite64be(u64 val, void __iomem *addr)
+{
+	iowrite32be(val >> 32, addr);
+	iowrite32be(val, addr + sizeof(u32));
+}
+#endif
+
 EXPORT_SYMBOL(iowrite8);
 EXPORT_SYMBOL(iowrite16);
 EXPORT_SYMBOL(iowrite16be);
 EXPORT_SYMBOL(iowrite32);
 EXPORT_SYMBOL(iowrite32be);
+EXPORT_SYMBOL(iowrite64);
+EXPORT_SYMBOL(iowrite64be);
 
 /*
  * These are the "repeat MMIO read/write" functions.
-- 
2.11.0
