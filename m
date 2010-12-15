From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] crypto: ghash-clmulni-intel_glue needs err.h
Date: Tue, 14 Dec 2010 16:26:41 -0800
Message-ID: <20101214162641.3e229f12.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	akpm <akpm@linux-foundation.org>
To: lkml <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:42452 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab0LOA1z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Dec 2010 19:27:55 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing header file:

arch/x86/crypto/ghash-clmulni-intel_glue.c:256: error: implicit declaration of function 'IS_ERR'
arch/x86/crypto/ghash-clmulni-intel_glue.c:257: error: implicit declaration of function 'PTR_ERR'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20101214.orig/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ linux-next-20101214/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -10,6 +10,7 @@
  * by the Free Software Foundation.
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
