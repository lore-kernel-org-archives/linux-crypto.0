From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] crypto: move Kconfig 842 to end of list, default to N
Date: Fri, 22 May 2015 20:08:28 -0400
Message-ID: <1432339708-4340-1-git-send-email-ddstreet@ieee.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33538 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbbEWAIo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 20:08:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move the 842 compression alg choice to last in the list, so it's
not in the middle of LZO/LZ4/LZ4HC.  Change its default to N, as it
is a very slow alg, which generally should only be used with
compression hardware that's capable of doing it much faster.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 crypto/Kconfig | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 24df47b..62ced6f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1419,14 +1419,6 @@ config CRYPTO_LZO
 	help
 	  This is the LZO algorithm.
 
-config CRYPTO_842
-	tristate "842 compression algorithm"
-	select CRYPTO_ALGAPI
-	select 842_COMPRESS
-	select 842_DECOMPRESS
-	help
-	  This is the 842 algorithm.
-
 config CRYPTO_LZ4
 	tristate "LZ4 compression algorithm"
 	select CRYPTO_ALGAPI
@@ -1443,6 +1435,15 @@ config CRYPTO_LZ4HC
 	help
 	  This is the LZ4 high compression mode algorithm.
 
+config CRYPTO_842
+	tristate "842 compression algorithm"
+	default n
+	select CRYPTO_ALGAPI
+	select 842_COMPRESS
+	select 842_DECOMPRESS
+	help
+	  This is the 842 algorithm.
+
 comment "Random Number Generation"
 
 config CRYPTO_ANSI_CPRNG
-- 
2.1.0
