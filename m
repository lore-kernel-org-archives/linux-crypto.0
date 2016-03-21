From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] MAINTAINERS: Add a new maintainer for the CCP driver
Date: Mon, 21 Mar 2016 11:43:22 -0500
Message-ID: <20160321164321.22405.94570.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Gary Hook <gary.hook@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0083.outbound.protection.outlook.com ([157.56.110.83]:34253
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756270AbcCUQnc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 12:43:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Gary will be taking over future development of the CCP driver, so add
him as a co-maintainer of the driver.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 30aca4a..8c42c07 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -623,6 +623,7 @@ F:	include/linux/altera_jtaguart.h
 
 AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER
 M:	Tom Lendacky <thomas.lendacky@amd.com>
+M:	Gary Hook <gary.hook@amd.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/ccp/
