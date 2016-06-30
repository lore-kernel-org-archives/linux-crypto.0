From: Jan Stancek <jstancek@redhat.com>
Subject: [PATCH] crypto: qat - make qat_asym_algs.o depend on asn1 headers
Date: Thu, 30 Jun 2016 12:23:51 +0200
Message-ID: <a53076f443d43d1153dcef0fb35126b5753b08c7.1467281942.git.jstancek@redhat.com>
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, jstancek@redhat.com
To: tadeusz.struk@intel.com, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Parallel build can sporadically fail because asn1 headers may
not be built yet by the time qat_asym_algs.o is compiled:
  drivers/crypto/qat/qat_common/qat_asym_algs.c:55:32: fatal error: qat_rsapubkey-asn1.h: No such file or directory
   #include "qat_rsapubkey-asn1.h"

Signed-off-by: Jan Stancek <jstancek@redhat.com>
Cc: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/qat/qat_common/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 6d74b91f2152..5fc3dbb9ada0 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -2,6 +2,7 @@ $(obj)/qat_rsapubkey-asn1.o: $(obj)/qat_rsapubkey-asn1.c \
 			     $(obj)/qat_rsapubkey-asn1.h
 $(obj)/qat_rsaprivkey-asn1.o: $(obj)/qat_rsaprivkey-asn1.c \
 			      $(obj)/qat_rsaprivkey-asn1.h
+$(obj)/qat_asym_algs.o: $(obj)/qat_rsapubkey-asn1.h $(obj)/qat_rsaprivkey-asn1.h
 
 clean-files += qat_rsapubkey-asn1.c qat_rsapubkey-asn1.h
 clean-files += qat_rsaprivkey-asn1.c qat_rsaprivkey-asn1.h
-- 
1.8.3.1
