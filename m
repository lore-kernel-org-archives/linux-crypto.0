From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 3/3] arm64: enable 128-bit memory read/write support
Date: Wed, 24 Jan 2018 12:05:19 +0300
Message-ID: <20180124090519.6680-4-ynorov@caviumnetworks.com>
References: <20180124090519.6680-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yury Norov <ynorov@caviumnetworks.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Pinski <Andrew.Pinski@cavium.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Geethasowjanya Akula <Geethasowjanya.Akula@cavium.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Laura Abbott <labbott@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sunil Goutham <Sunil.Goutham@cavium.com>,
        Will Deacon <will.deacon@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180124090519.6680-1-ynorov@caviumnetworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Introduce __raw_writeo(), __raw_reado() and other arch-specific
RW functions for 128-bit memory access, and enable it for arm64.

128-bit I/O is required for example by Octeon TX2 device to access
some registers. According to Hardware Reference Manual:

A 128-bit write to the OP_FREE0/1 registers frees a pointer into a
given [...] pool. All other accesses to these registers (e.g. reads
and 64-bit writes) are RAZ/WI.

Starting from ARMv8.4, stp and ldp instructions become atomic, and
API for 128-bit access would be helpful for core code.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 arch/Kconfig                |  7 +++++++
 arch/arm64/include/asm/io.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 76c0b54443b1..2baff7de405d 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -116,6 +116,13 @@ config UPROBES
 	    managed by the kernel and kept transparent to the probed
 	    application. )
 
+config HAVE_128BIT_ACCESS
+	def_bool ARM64
+	help
+	  Architectures having 128-bit access require corresponding APIs,
+	  like reado() and writeo(), which stands for reading and writing
+	  the octet of bytes at once.
+
 config HAVE_64BIT_ALIGNED_ACCESS
 	def_bool 64BIT && !HAVE_EFFICIENT_UNALIGNED_ACCESS
 	help
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 35b2e50f17fb..7c5d834abfd8 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -60,6 +60,18 @@ static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
 	asm volatile("str %x0, [%1]" : : "rZ" (val), "r" (addr));
 }
 
+#define __raw_writeo __raw_writeo
+static inline void __raw_writeo(__uint128_t val, volatile void __iomem *addr)
+{
+	u64 l = (u64) val;
+	u64 h = (u64) (val >> 64);
+	__uint128_t *__addr = (__uint128_t *) addr;
+
+	asm volatile("stp %x[x0], %x[x1], %x[p1]"
+		     : [p1]"=Ump"(*__addr)
+		     : [x0]"r"(l), [x1]"r"(h));
+}
+
 #define __raw_readb __raw_readb
 static inline u8 __raw_readb(const volatile void __iomem *addr)
 {
@@ -105,6 +117,19 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 	return val;
 }
 
+#define __raw_reado __raw_reado
+static inline __uint128_t __raw_reado(const volatile void __iomem *addr)
+{
+	u64 l, h;
+	__uint128_t *__addr = (__uint128_t *) addr;
+
+	asm volatile("ldp %x[x0], %x[x1], %x[p1]"
+		     : [x0]"=r"(l), [x1]"=r"(h)
+		     : [p1]"Ump"(*__addr));
+
+	return (__uint128_t) l | ((__uint128_t) h) << 64;
+}
+
 /* IO barriers */
 #define __iormb()		rmb()
 #define __iowmb()		wmb()
@@ -120,11 +145,13 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 #define readw_relaxed(c)	({ u16 __r = le16_to_cpu((__force __le16)__raw_readw(c)); __r; })
 #define readl_relaxed(c)	({ u32 __r = le32_to_cpu((__force __le32)__raw_readl(c)); __r; })
 #define readq_relaxed(c)	({ u64 __r = le64_to_cpu((__force __le64)__raw_readq(c)); __r; })
+#define reado_relaxed(c)	({ __uint128_t __r = le128_to_cpu((__force __le128)__raw_reado(c)); __r; })
 
 #define writeb_relaxed(v,c)	((void)__raw_writeb((v),(c)))
 #define writew_relaxed(v,c)	((void)__raw_writew((__force u16)cpu_to_le16(v),(c)))
 #define writel_relaxed(v,c)	((void)__raw_writel((__force u32)cpu_to_le32(v),(c)))
 #define writeq_relaxed(v,c)	((void)__raw_writeq((__force u64)cpu_to_le64(v),(c)))
+#define writeo_relaxed(v,c)	((void)__raw_writeo((__force __uint128_t)cpu_to_le128(v),(c)))
 
 /*
  * I/O memory access primitives. Reads are ordered relative to any
@@ -135,11 +162,13 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 #define readw(c)		({ u16 __v = readw_relaxed(c); __iormb(); __v; })
 #define readl(c)		({ u32 __v = readl_relaxed(c); __iormb(); __v; })
 #define readq(c)		({ u64 __v = readq_relaxed(c); __iormb(); __v; })
+#define reado(c)		({ __uint128_t __v = reado_relaxed(c); __iormb(); __v; })
 
 #define writeb(v,c)		({ __iowmb(); writeb_relaxed((v),(c)); })
 #define writew(v,c)		({ __iowmb(); writew_relaxed((v),(c)); })
 #define writel(v,c)		({ __iowmb(); writel_relaxed((v),(c)); })
 #define writeq(v,c)		({ __iowmb(); writeq_relaxed((v),(c)); })
+#define writeo(v,c)		({ __iowmb(); writeo_relaxed((v),(c)); })
 
 /*
  *  I/O port access primitives.
@@ -188,10 +217,12 @@ extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
 #define ioread16be(p)		({ __u16 __v = be16_to_cpu((__force __be16)__raw_readw(p)); __iormb(); __v; })
 #define ioread32be(p)		({ __u32 __v = be32_to_cpu((__force __be32)__raw_readl(p)); __iormb(); __v; })
 #define ioread64be(p)		({ __u64 __v = be64_to_cpu((__force __be64)__raw_readq(p)); __iormb(); __v; })
+#define ioread128be(p)		({ __uint128_t __v = be128_to_cpu((__force __be128)__raw_readq(p)); __iormb(); __v; })
 
 #define iowrite16be(v,p)	({ __iowmb(); __raw_writew((__force __u16)cpu_to_be16(v), p); })
 #define iowrite32be(v,p)	({ __iowmb(); __raw_writel((__force __u32)cpu_to_be32(v), p); })
 #define iowrite64be(v,p)	({ __iowmb(); __raw_writeq((__force __u64)cpu_to_be64(v), p); })
+#define iowrite128be(v,p)	({ __iowmb(); __raw_writeo((__force __u128)cpu_to_be128(v), p); })
 
 #include <asm-generic/io.h>
 
-- 
2.11.0
