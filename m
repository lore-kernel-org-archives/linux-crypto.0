From: Aaron Sierra <asierra@xes-inc.com>
Subject: [PATCH] crypto: talitos: Init zero_entry more compatibly
Date: Fri, 31 Jul 2015 12:27:41 -0500 (CDT)
Message-ID: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com>
References: <767312390.183043.1438296525267.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:19369 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbbGaSRq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Jul 2015 14:17:46 -0400
In-Reply-To: <767312390.183043.1438296525267.JavaMail.zimbra@xes-inc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Compiling this driver with my GCC 4.3.1 e500v2 cross-compiler
resulted in a failed build due to the anonymous union/structures
introduced in this commit:

  crypto: talitos - enhanced talitos_desc struct for SEC1

The build error was:

  drivers/crypto/talitos.h:56: error: unknown field 'len' specified in initializer
  drivers/crypto/talitos.h:56: warning: missing braces around initializer
  drivers/crypto/talitos.h:56: warning: (near initialization for 'zero_entry.<anonymous>')
  drivers/crypto/talitos.h:57: error: unknown field 'j_extent' specified in initializer
  drivers/crypto/talitos.h:58: error: unknown field 'eptr' specified in initializer
  drivers/crypto/talitos.h:58: warning: excess elements in struct initializer
  drivers/crypto/talitos.h:58: warning: (near initialization for 'zero_entry')
  make[2]: *** [drivers/crypto/talitos.o] Error 1
  make[1]: *** [drivers/crypto] Error 2
  make: *** [drivers] Error 2

This patch works around the errors by changing the static constant
zero_entry's initializer to use an initialization shorthand.

Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
---
 drivers/crypto/talitos.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 314daf5..bf88fe7 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -52,12 +52,7 @@ struct talitos_ptr {
 	__be32 ptr;     /* address */
 };
 
-static const struct talitos_ptr zero_entry = {
-	.len = 0,
-	.j_extent = 0,
-	.eptr = 0,
-	.ptr = 0
-};
+static const struct talitos_ptr zero_entry = {{{ 0 }}};
 
 /* descriptor */
 struct talitos_desc {
-- 
1.9.1
