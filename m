From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v12 1/9] iomap: Fix sparse endian check warnings
Date: Fri, 16 Mar 2018 09:48:44 -0600
Message-ID: <20180316154852.13206-2-logang@deltatee.com>
References: <20180316154852.13206-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Kate Stewart <kstewart@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180316154852.13206-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Warnings of the form:

lib/iomap.c:84:9: warning: cast to restricted __be16

Are found when running sparse checker with:

make C=2 CF=-D__CHECK_ENDIAN__

This patch casts them with __force to suppress the warnings.

Also, it looks like the wrong conversion function was used in
the mmio_writeXXbe macros: 'val' is a cpu value to be written to
a big endian register. Therefore cpu_to_beXX should have been used
instead of beXX_to_cpu. Both are equivalent, functionally, but have
different meanings. So there was no real bug just confusion
for people reading the code and the sparse endian check.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
---
 lib/iomap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/iomap.c b/lib/iomap.c
index 541d926da95e..a05d9fa21794 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -65,8 +65,8 @@ static void bad_io_access(unsigned long port, const char *access)
 #endif
 
 #ifndef mmio_read16be
-#define mmio_read16be(addr) be16_to_cpu(__raw_readw(addr))
-#define mmio_read32be(addr) be32_to_cpu(__raw_readl(addr))
+#define mmio_read16be(addr) be16_to_cpu((__be16 __force)__raw_readw(addr))
+#define mmio_read32be(addr) be32_to_cpu((__be32 __force)__raw_readl(addr))
 #endif
 
 unsigned int ioread8(void __iomem *addr)
@@ -106,8 +106,10 @@ EXPORT_SYMBOL(ioread32be);
 #endif
 
 #ifndef mmio_write16be
-#define mmio_write16be(val,port) __raw_writew(be16_to_cpu(val),port)
-#define mmio_write32be(val,port) __raw_writel(be32_to_cpu(val),port)
+#define mmio_write16be(val, port) \
+	__raw_writew((u16 __force)cpu_to_be16(val), port)
+#define mmio_write32be(val, port) \
+	__raw_writel((u32 __force)cpu_to_be32(val), port)
 #endif
 
 void iowrite8(u8 val, void __iomem *addr)
-- 
2.11.0
