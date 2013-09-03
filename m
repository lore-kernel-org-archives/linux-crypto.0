From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH] crypto: sha256_ssse3 - use correct module alias for sha224
Date: Tue, 03 Sep 2013 16:26:49 +0300
Message-ID: <20130903132649.6239.4068.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:55143 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932941Ab3ICNgE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Sep 2013 09:36:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit a710f761f (crypto: sha256_ssse3 - add sha224 support) attempted to add
MODULE_ALIAS for SHA-224, but it ended up being "sha384", probably because
mix-up with previous commit 340991e30 (crypto: sha512_ssse3 - add sha384
support). Patch corrects module alias to "sha224".

Reported-by: Pierre-Mayeul Badaire <pierre-mayeul.badaire@m4x.org>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/sha256_ssse3_glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index 50226c4..85021a4 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -319,4 +319,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm, Supplemental SSE3 accelerated");
 
 MODULE_ALIAS("sha256");
-MODULE_ALIAS("sha384");
+MODULE_ALIAS("sha224");
