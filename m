From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v13 05/10] powerpc: iomap.c: introduce io{read|write}64_{lo_hi|hi_lo}
Date: Wed, 21 Mar 2018 10:37:40 -0600
Message-ID: <20180321163745.12286-6-logang@deltatee.com>
References: <20180321163745.12286-1-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180321163745.12286-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These functions will be introduced into the generic iomap.c so
they can deal with PIO accesses in hi-lo/lo-hi variants. Thus,
the powerpc version of iomap.c will need to provide the same
functions even though, in this arch, they are identical to the
regular io{read|write}64 functions.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Tested-by: Horia Geantă <horia.geanta@nxp.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/kernel/iomap.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/powerpc/kernel/iomap.c b/arch/powerpc/kernel/iomap.c
index aab456ed2a00..5ac84efc6ede 100644
--- a/arch/powerpc/kernel/iomap.c
+++ b/arch/powerpc/kernel/iomap.c
@@ -45,12 +45,32 @@ u64 ioread64(void __iomem *addr)
 {
 	return readq(addr);
 }
+u64 ioread64_lo_hi(void __iomem *addr)
+{
+	return readq(addr);
+}
+u64 ioread64_hi_lo(void __iomem *addr)
+{
+	return readq(addr);
+}
 u64 ioread64be(void __iomem *addr)
 {
 	return readq_be(addr);
 }
+u64 ioread64be_lo_hi(void __iomem *addr)
+{
+	return readq_be(addr);
+}
+u64 ioread64be_hi_lo(void __iomem *addr)
+{
+	return readq_be(addr);
+}
 EXPORT_SYMBOL(ioread64);
+EXPORT_SYMBOL(ioread64_lo_hi);
+EXPORT_SYMBOL(ioread64_hi_lo);
 EXPORT_SYMBOL(ioread64be);
+EXPORT_SYMBOL(ioread64be_lo_hi);
+EXPORT_SYMBOL(ioread64be_hi_lo);
 #endif /* __powerpc64__ */
 
 void iowrite8(u8 val, void __iomem *addr)
@@ -83,12 +103,32 @@ void iowrite64(u64 val, void __iomem *addr)
 {
 	writeq(val, addr);
 }
+void iowrite64_lo_hi(u64 val, void __iomem *addr)
+{
+	writeq(val, addr);
+}
+void iowrite64_hi_lo(u64 val, void __iomem *addr)
+{
+	writeq(val, addr);
+}
 void iowrite64be(u64 val, void __iomem *addr)
 {
 	writeq_be(val, addr);
 }
+void iowrite64be_lo_hi(u64 val, void __iomem *addr)
+{
+	writeq_be(val, addr);
+}
+void iowrite64be_hi_lo(u64 val, void __iomem *addr)
+{
+	writeq_be(val, addr);
+}
 EXPORT_SYMBOL(iowrite64);
+EXPORT_SYMBOL(iowrite64_lo_hi);
+EXPORT_SYMBOL(iowrite64_hi_lo);
 EXPORT_SYMBOL(iowrite64be);
+EXPORT_SYMBOL(iowrite64be_lo_hi);
+EXPORT_SYMBOL(iowrite64be_hi_lo);
 #endif /* __powerpc64__ */
 
 /*
-- 
2.11.0
