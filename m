From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] MAINTAINERS: update maintainer for qat
Date: Fri, 24 Jun 2016 07:01:33 -0700
Message-ID: <1466776893-27788-1-git-send-email-tadeusz.struk@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Tadeusz Struk <tadeusz.struk@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1164 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbcFXOBx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 10:01:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Giovanni and Salvatore who will take over the qat maintenance.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f4a9c13..5d813a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9292,7 +9292,8 @@ L:	rtc-linux@googlegroups.com
 S:	Maintained
 
 QAT DRIVER
-M:	Tadeusz Struk <tadeusz.struk@intel.com>
+M:	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
+M:	Salvatore Benedetto <salvatore.benedetto@intel.com>
 L:	qat-linux@intel.com
 S:	Supported
 F:	drivers/crypto/qat/
-- 
2.7.4
