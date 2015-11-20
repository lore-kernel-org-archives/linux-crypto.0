From: Jim Davis <jim.epost@gmail.com>
Subject: [PATCH] drivers/crypto/qat/qat_common/Makefile: fix typo in clean-files
Date: Thu, 19 Nov 2015 17:06:19 -0700
Message-ID: <1447977979-16061-1-git-send-email-jim.epost@gmail.com>
To: tadeusz.struk@intel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34018 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934126AbbKTAGa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Nov 2015 19:06:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A typo in the Makefile leaves qat_rsaprivkey-asn1.h hanging around.

Signed-off-by: Jim Davis <jim.epost@gmail.com>
---
 drivers/crypto/qat/qat_common/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 9e9e196c6d51..12f40a38687e 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -4,7 +4,7 @@ $(obj)/qat_rsaprivkey-asn1.o: $(obj)/qat_rsaprivkey-asn1.c \
 			      $(obj)/qat_rsaprivkey-asn1.h
 
 clean-files += qat_rsapubkey-asn1.c qat_rsapubkey-asn1.h
-clean-files += qat_rsaprivkey-asn1.c qat_rsapvivkey-asn1.h
+clean-files += qat_rsaprivkey-asn1.c qat_rsaprivkey-asn1.h
 
 obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
 intel_qat-objs := adf_cfg.o \
-- 
2.6.2.195.g0c4dd78
