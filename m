From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH 4/7] alpha: provide ioread64 and iowrite64 implementations
Date: Thu, 22 Jun 2017 10:48:14 -0600
Message-ID: <20170622164817.25515-5-logang@deltatee.com>
References: <20170622164817.25515-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-alpha@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:53880 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753301AbdFVQtW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 12:49:22 -0400
In-Reply-To: <20170622164817.25515-1-logang@deltatee.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Alpha implements its own io operation and doesn't use the
common library. Thus to make ioread64 and iowrite64 globally
available we need to add implementations for alpha.

For this, we simply use calls that chain two 32-bit operations.
(mostly because I don't really understand the alpha architecture.)

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/include/asm/io.h |  2 ++
 arch/alpha/kernel/io.c      | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index ff4049155c84..15588092c062 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -493,8 +493,10 @@ extern inline void writeq(u64 b, volatile void __iomem *addr)
 
 #define ioread16be(p) be16_to_cpu(ioread16(p))
 #define ioread32be(p) be32_to_cpu(ioread32(p))
+#define ioread64be(p) be64_to_cpu(ioread64(p))
 #define iowrite16be(v,p) iowrite16(cpu_to_be16(v), (p))
 #define iowrite32be(v,p) iowrite32(cpu_to_be32(v), (p))
+#define iowrite64be(v,p) iowrite32(cpu_to_be64(v), (p))
 
 #define inb_p		inb
 #define inw_p		inw
diff --git a/arch/alpha/kernel/io.c b/arch/alpha/kernel/io.c
index 19c5875ab398..8c28026f7849 100644
--- a/arch/alpha/kernel/io.c
+++ b/arch/alpha/kernel/io.c
@@ -59,6 +59,24 @@ EXPORT_SYMBOL(iowrite8);
 EXPORT_SYMBOL(iowrite16);
 EXPORT_SYMBOL(iowrite32);
 
+u64 ioread64(void __iomem *addr)
+{
+	u64 low, high;
+
+	low = ioread32(addr);
+	high = ioread32(addr + sizeof(u32));
+	return low | (high << 32);
+}
+
+void iowrite64(u64 val, void __iomem *addr)
+{
+	iowrite32(val, addr);
+	iowrite32(val >> 32, addr + sizeof(u32));
+}
+
+EXPORT_SYMBOL(ioread64);
+EXPORT_SYMBOL(iowrite64);
+
 u8 inb(unsigned long port)
 {
 	return ioread8(ioport_map(port, 1));
-- 
2.11.0
