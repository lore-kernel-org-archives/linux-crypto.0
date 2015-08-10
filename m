From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: [PATCH] Fix email address mistypo for NX/VMX crypto driver maintainers
Date: Mon, 10 Aug 2015 16:14:17 -0300
Message-ID: <1439234057-24206-1-git-send-email-pfsmorigo@linux.vnet.ibm.com>
Cc: leosilva@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:59415 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbbHJTOv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 15:14:51 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <pfsmorigo@linux.vnet.ibm.com>;
	Mon, 10 Aug 2015 16:14:49 -0300
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa748b0..97e7822 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5061,7 +5061,7 @@ F:	arch/ia64/
 
 IBM Power VMX Cryptographic instructions
 M:	Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
-M: 	Paulo Flabiano Smorigo <pfsmorigo.vnet.ibm.com>
+M:	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/vmx/Makefile
@@ -5073,7 +5073,7 @@ F:	drivers/crypto/vmx/ppc-xlate.pl
 
 IBM Power in-Nest Crypto Acceleration
 M:	Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
-M:	Paulo Flabiano Smorigo <pfsmorigo.vnet.ibm.com>
+M:	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/nx/Makefile
-- 
2.1.0
