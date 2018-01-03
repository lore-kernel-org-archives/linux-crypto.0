From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH v9 2/8] powerpc: io.h: move iomap.h include so that it can use readq/writeq defs
Date: Wed,  3 Jan 2018 11:06:12 -0700
Message-ID: <20180103180618.18401-3-logang@deltatee.com>
References: <20180103180618.18401-1-logang@deltatee.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        "Oliver O'Halloran" <oohall@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180103180618.18401-1-logang@deltatee.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Subsequent patches in this series makes use of the readq and writeq
defines in iomap.h. However, as is, they get missed on the powerpc
platform seeing the include comes before the define. This patch
moves the include down to fix this.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suresh Warrier <warrier@linux.vnet.ibm.com>
Cc: "Oliver O'Halloran" <oohall@gmail.com>
---
 arch/powerpc/include/asm/io.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 422f99cf9924..af074923d598 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -33,8 +33,6 @@ extern struct pci_dev *isa_bridge_pcidev;
 #include <asm/mmu.h>
 #include <asm/ppc_asm.h>

-#include <asm-generic/iomap.h>
-
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
 #endif
@@ -663,6 +661,8 @@ static inline void name at					\
 #define writel_relaxed(v, addr)	writel(v, addr)
 #define writeq_relaxed(v, addr)	writeq(v, addr)

+#include <asm-generic/iomap.h>
+
 #ifdef CONFIG_PPC32
 #define mmiowb()
 #else
--
2.11.0
