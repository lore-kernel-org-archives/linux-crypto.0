From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v13 01/10] iomap: Use correct endian conversion function in mmio_writeXXbe
Date: Wed, 21 Mar 2018 10:37:36 -0600
Message-ID: <20180321163745.12286-2-logang@deltatee.com>
References: <20180321163745.12286-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180321163745.12286-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The semantics of the iowriteXXbe() functions are to write a
value in CPU endianess to an IO register that is known by the
caller to be in Big Endian. The mmio_writeXXbe() macro, which
is called by iowriteXXbe(), should therefore use cpu_to_beXX()
instead of beXX_to_cpu().

Seeing both beXX_to_cpu() and cpu_to_beXX() are both functionally
implemented as either null operations or swabXX operations there
was no noticable bug here. But it is confusing for both developers
and code analysis tools alike.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Philippe Ombredanne <pombredanne@nexb.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 lib/iomap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/iomap.c b/lib/iomap.c
index 541d926da95e..be120c13d6cc 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -106,8 +106,8 @@ EXPORT_SYMBOL(ioread32be);
 #endif
 
 #ifndef mmio_write16be
-#define mmio_write16be(val,port) __raw_writew(be16_to_cpu(val),port)
-#define mmio_write32be(val,port) __raw_writel(be32_to_cpu(val),port)
+#define mmio_write16be(val,port) __raw_writew(cpu_to_be16(val),port)
+#define mmio_write32be(val,port) __raw_writel(cpu_to_be32(val),port)
 #endif
 
 void iowrite8(u8 val, void __iomem *addr)
-- 
2.11.0
