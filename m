From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 2/2] MAINTAINERS: add crypto-API.tmpl
Date: Fri, 06 Mar 2015 21:36:21 +0100
Message-ID: <2391509.L1I9IBRz2l@tachyon.chronox.de>
References: <1463694.oXIsepBPWM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36541 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460AbbCFUge (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 15:36:34 -0500
In-Reply-To: <1463694.oXIsepBPWM@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The file Documentation/DocBook/crypto-API.tmpl documents the kernel
crypto API and is maintained.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddc5a8c..c10814e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2805,6 +2805,7 @@ L:	linux-crypto@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
 S:	Maintained
 F:	Documentation/crypto/
+F:	Documentation/DocBook/crypto-API.tmpl
 F:	arch/*/crypto/
 F:	crypto/
 F:	drivers/crypto/
-- 
2.1.0
