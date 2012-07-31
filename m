From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: [PATCH] crypto: Add a MAINTAINERS entry for P7+ in-Nest crypto driver
Date: Tue, 31 Jul 2012 14:49:34 -0500
Message-ID: <20120731194931.GA23426@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53832 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756145Ab2GaUOK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Jul 2012 16:14:10 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <key@linux.vnet.ibm.com>;
	Tue, 31 Jul 2012 16:14:08 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a MAINTAINERS entry for the IBM Power in-Nest Crypto Acceleators
driver.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb036a0..757fe60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3414,6 +3414,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git
 S:	Maintained
 F:	arch/ia64/
 
+IBM Power in-Nest Crypto Acceleration
+M:	Kent Yoder <key@linux.vnet.ibm.com>
+L:	linux-crypto@vger.kernel.org
+S:	Supported
+F:	drivers/crypto/nx/
+
 IBM Power Linux RAID adapter
 M:	Brian King <brking@us.ibm.com>
 S:	Supported
-- 
1.7.5.4
