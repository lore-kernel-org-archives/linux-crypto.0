From: Yury Norov <ynorov@caviumnetworks.com>
Subject: [PATCH 2/3] asm-generic/io.h: API for 128-bit memory accessors
Date: Wed, 24 Jan 2018 12:05:18 +0300
Message-ID: <20180124090519.6680-3-ynorov@caviumnetworks.com>
References: <20180124090519.6680-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Pinski <Andrew.Pinski@cavium.com>,
 Sunil Goutham <Sunil.Goutham@cavium.com>, Kees Cook <keescook@chromium.org>,
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Ingo Molnar <mingo@kernel.org>,
 Geethasowjanya Akula <Geethasowjanya.Akula@cavium.com>,
 Yury Norov <ynorov@caviumnetworks.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Laura Abbott <labbott@redhat.com>,
 "David S . Miller" <davem@davemloft.net>
To: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180124090519.6680-1-ynorov@caviumnetworks.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Some architectures, like arm64, support 128-bit memory access. For
ARM64 - using load/store pair instructions. This patch introduces
reado() and writeo() functions family, where suffix 'o' stands for
reading and writing the octet of bytes at once.

Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
---
 include/asm-generic/io.h | 147 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 147 insertions(+)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index b4531e3b2120..ac4a4de69efc 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -67,6 +67,16 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef __raw_reado
+#define __raw_reado __raw_reado
+static inline __uint128_t __raw_reado(const volatile void __iomem *addr)
+{
+	return *(const volatile __uint128_t __force *)addr;
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 #ifndef __raw_writeb
 #define __raw_writeb __raw_writeb
 static inline void __raw_writeb(u8 value, volatile void __iomem *addr)
@@ -101,6 +111,16 @@ static inline void __raw_writeq(u64 value, volatile void __iomem *addr)
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef __raw_writeo
+#define __raw_writeo __raw_writeo
+static inline void __raw_writeo(__uint128_t value, volatile void __iomem *addr)
+{
+	*(volatile __uint128_t __force *)addr = value;
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 /*
  * {read,write}{b,w,l,q}() access little endian memory and return result in
  * native endianness.
@@ -140,6 +160,16 @@ static inline u64 readq(const volatile void __iomem *addr)
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef reado
+#define reado reado
+static inline __uint128_t reado(const volatile void __iomem *addr)
+{
+	return __le128_to_cpu(__raw_reado(addr));
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 #ifndef writeb
 #define writeb writeb
 static inline void writeb(u8 value, volatile void __iomem *addr)
@@ -174,6 +204,16 @@ static inline void writeq(u64 value, volatile void __iomem *addr)
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef writeo
+#define writeo writeo
+static inline void writeo(__uint128_t value, volatile void __iomem *addr)
+{
+	__raw_writeo(__cpu_to_le128(value), addr);
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 /*
  * {read,write}{b,w,l,q}_relaxed() are like the regular version, but
  * are not guaranteed to provide ordering against spinlocks or memory
@@ -195,6 +235,10 @@ static inline void writeq(u64 value, volatile void __iomem *addr)
 #define readq_relaxed readq
 #endif
 
+#if defined(reado) && !defined(reado_relaxed)
+#define reado_relaxed reado
+#endif
+
 #ifndef writeb_relaxed
 #define writeb_relaxed writeb
 #endif
@@ -211,6 +255,10 @@ static inline void writeq(u64 value, volatile void __iomem *addr)
 #define writeq_relaxed writeq
 #endif
 
+#if defined(writeo) && !defined(writeo_relaxed)
+#define writeo_relaxed writeo
+#endif
+
 /*
  * {read,write}s{b,w,l,q}() repeatedly access the same memory address in
  * native endianness in 8-, 16-, 32- or 64-bit chunks (@count times).
@@ -281,6 +329,24 @@ static inline void readsq(const volatile void __iomem *addr, void *buffer,
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef readso
+#define readso readso
+static inline void readso(const volatile void __iomem *addr, void *buffer,
+			  unsigned int count)
+{
+	if (count) {
+		__uint128_t *buf = buffer;
+
+		do {
+			__uint128_t x = __raw_reado(addr);
+			*buf++ = x;
+		} while (--count);
+	}
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 #ifndef writesb
 #define writesb writesb
 static inline void writesb(volatile void __iomem *addr, const void *buffer,
@@ -343,6 +409,23 @@ static inline void writesq(volatile void __iomem *addr, const void *buffer,
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef writeso
+#define writeso writeso
+static inline void writeso(volatile void __iomem *addr, const void *buffer,
+			   unsigned int count)
+{
+	if (count) {
+		const __uint128_t *buf = buffer;
+
+		do {
+			__raw_writeo(*buf++, addr);
+		} while (--count);
+	}
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 #ifndef PCI_IOBASE
 #define PCI_IOBASE ((void __iomem *)0)
 #endif
@@ -595,6 +678,16 @@ static inline u64 ioread64(const volatile void __iomem *addr)
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef ioread128
+#define ioread128 ioread128
+static inline __uint128_t ioread128(const volatile void __iomem *addr)
+{
+	return reado(addr);
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 #ifndef iowrite8
 #define iowrite8 iowrite8
 static inline void iowrite8(u8 value, volatile void __iomem *addr)
@@ -629,6 +722,16 @@ static inline void iowrite64(u64 value, volatile void __iomem *addr)
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef iowrite128
+#define iowrite128 iowrite128
+static inline void iowrite128(__uint128_t value, volatile void __iomem *addr)
+{
+	writeo(value, addr);
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 #ifndef ioread16be
 #define ioread16be ioread16be
 static inline u16 ioread16be(const volatile void __iomem *addr)
@@ -655,6 +758,16 @@ static inline u64 ioread64be(const volatile void __iomem *addr)
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef ioread128be
+#define ioread128be ioread128be
+static inline __uint128_t ioread128be(const volatile void __iomem *addr)
+{
+	return swab128(reado(addr));
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 #ifndef iowrite16be
 #define iowrite16be iowrite16be
 static inline void iowrite16be(u16 value, void volatile __iomem *addr)
@@ -681,6 +794,16 @@ static inline void iowrite64be(u64 value, volatile void __iomem *addr)
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef iowrite128be
+#define iowrite128be iowrite128be
+static inline void iowrite128be(__uint128_t value, volatile void __iomem *addr)
+{
+	writeo(swab128(value), addr);
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 #ifndef ioread8_rep
 #define ioread8_rep ioread8_rep
 static inline void ioread8_rep(const volatile void __iomem *addr, void *buffer,
@@ -719,6 +842,17 @@ static inline void ioread64_rep(const volatile void __iomem *addr,
 #endif
 #endif /* CONFIG_64BIT */
 
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef ioread128_rep
+#define ioread128_rep ioread128_rep
+static inline void ioread128_rep(const volatile void __iomem *addr,
+				 void *buffer, unsigned int count)
+{
+	readso(addr, buffer, count);
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 #ifndef iowrite8_rep
 #define iowrite8_rep iowrite8_rep
 static inline void iowrite8_rep(volatile void __iomem *addr,
@@ -760,6 +894,19 @@ static inline void iowrite64_rep(volatile void __iomem *addr,
 }
 #endif
 #endif /* CONFIG_64BIT */
+
+#ifdef CONFIG_HAVE_128BIT_ACCESS
+#ifndef iowrite128_rep
+#define iowrite128_rep iowrite128_rep
+static inline void iowrite128_rep(volatile void __iomem *addr,
+				  const void *buffer,
+				  unsigned int count)
+{
+	writeso(addr, buffer, count);
+}
+#endif
+#endif /* CONFIG_HAVE_128BIT_ACCESS */
+
 #endif /* CONFIG_GENERIC_IOMAP */
 
 #ifdef __KERNEL__
-- 
2.11.0
