From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] jent: use safe format string parameters
Date: Fri, 24 Jul 2015 15:41:27 -0700
Message-ID: <20150724224127.GA29924@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.outflux.net ([198.145.64.163]:45102 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbbGXWlf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 18:41:35 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since the API for jent_panic() does not include format string parameters,
adjust the call to panic() to use a literal string to avoid any future
callers from leaking format strings into the panic message.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/jitterentropy-kcapi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index b32d834144cd..ceea83d13168 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -79,7 +79,7 @@ int jent_fips_enabled(void)
 
 void jent_panic(char *s)
 {
-	panic(s);
+	panic("%s", s);
 }
 
 void jent_memcpy(void *dest, const void *src, unsigned int n)
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
