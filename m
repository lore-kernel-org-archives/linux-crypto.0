From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] Add maintainer entries for padata/pcrypt
Date: Wed, 11 Aug 2010 20:13:15 +0200
Message-ID: <20100811181315.GA4097@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([195.81.216.161]:40135 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab0HKSIe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Aug 2010 14:08:34 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 MAINTAINERS |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8939947..3e9502e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4327,6 +4327,15 @@ L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/busses/i2c-pasemi.c
 
+PADATA PARALLEL EXECUTION MECHANISM
+M:	Steffen Klassert <steffen.klassert@secunet.com>
+L:	linux-kernel@vger.kernel.org
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	kernel/padata.c
+F:	include/linux/padata.h
+F:	Documentation/padata.txt
+
 PANASONIC LAPTOP ACPI EXTRAS DRIVER
 M:	Harald Welte <laforge@gnumonks.org>
 L:	platform-driver-x86@vger.kernel.org
@@ -4447,6 +4456,13 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/pcnet32.c
 
+PCRYPT PARALLEL CRYPTO ENGINE
+M:	Steffen Klassert <steffen.klassert@secunet.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	crypto/pcrypt.c
+F:	include/crypto/pcrypt.h
+
 PER-TASK DELAY ACCOUNTING
 M:	Balbir Singh <balbir@linux.vnet.ibm.com>
 S:	Maintained
-- 
1.5.6.5
