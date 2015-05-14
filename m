From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: [PATCH] crypto: vmx - fix two mistyped texts
Date: Thu, 14 May 2015 12:21:04 -0300
Message-ID: <1431616869-31080-1-git-send-email-pfsmorigo@linux.vnet.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	"Marcelo H. Cerri" <mhcerri@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API)
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

One mistyped description and another mistyped target were corrected.

Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
---
 drivers/crypto/vmx/Makefile | 2 +-
 drivers/crypto/vmx/vmx.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
index c699c6e..d28ab96 100644
--- a/drivers/crypto/vmx/Makefile
+++ b/drivers/crypto/vmx/Makefile
@@ -4,7 +4,7 @@ vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o gha
 ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
 TARGET := linux-ppc64le
 else
-TARGET := linux-pcc64
+TARGET := linux-ppc64
 endif
 
 quiet_cmd_perl = PERL $@
diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
index 44d8d5c..4c398dd 100644
--- a/drivers/crypto/vmx/vmx.c
+++ b/drivers/crypto/vmx/vmx.c
@@ -82,7 +82,7 @@ module_init(p8_init);
 module_exit(p8_exit);
 
 MODULE_AUTHOR("Marcelo Cerri<mhcerri@br.ibm.com>");
-MODULE_DESCRIPTION("IBM VMX cryptogaphic acceleration instructions support on Power 8");
+MODULE_DESCRIPTION("IBM VMX cryptographic acceleration instructions support on Power 8");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0.0");
 
-- 
2.1.0
