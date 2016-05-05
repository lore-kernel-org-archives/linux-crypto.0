From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH v2 4/8] powerpc: add io{read,write}64 accessors
Date: Thu, 5 May 2016 18:36:13 +0300
Message-ID: <1462462573-27779-1-git-send-email-horia.geanta@nxp.com>
References: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	"Michael Ellerman" <mpe@ellerman.id.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462462435-27403-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This will allow device drivers to consistently use io{read,write}XX
also for 64-bit accesses.

Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
---
 arch/powerpc/kernel/iomap.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/powerpc/kernel/iomap.c b/arch/powerpc/kernel/iomap.c
index 12e48d56f771..3963f0b68d52 100644
--- a/arch/powerpc/kernel/iomap.c
+++ b/arch/powerpc/kernel/iomap.c
@@ -38,6 +38,18 @@ EXPORT_SYMBOL(ioread16);
 EXPORT_SYMBOL(ioread16be);
 EXPORT_SYMBOL(ioread32);
 EXPORT_SYMBOL(ioread32be);
+#ifdef __powerpc64__
+u64 ioread64(void __iomem *addr)
+{
+	return readq(addr);
+}
+u64 ioread64be(void __iomem *addr)
+{
+	return readq_be(addr);
+}
+EXPORT_SYMBOL(ioread64);
+EXPORT_SYMBOL(ioread64be);
+#endif /* __powerpc64__ */
=20
 void iowrite8(u8 val, void __iomem *addr)
 {
@@ -64,6 +76,18 @@ EXPORT_SYMBOL(iowrite16);
 EXPORT_SYMBOL(iowrite16be);
 EXPORT_SYMBOL(iowrite32);
 EXPORT_SYMBOL(iowrite32be);
+#ifdef __powerpc64__
+void iowrite64(u64 val, void __iomem *addr)
+{
+	writeq(val, addr);
+}
+void iowrite64be(u64 val, void __iomem *addr)
+{
+	writeq_be(val, addr);
+}
+EXPORT_SYMBOL(iowrite64);
+EXPORT_SYMBOL(iowrite64be);
+#endif /* __powerpc64__ */
=20
 /*
  * These are the "repeat read/write" functions. Note the
--=20
2.4.4
