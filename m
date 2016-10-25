From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: caam: fix type mismatch warning
Date: Tue, 25 Oct 2016 23:29:10 +0200
Message-ID: <20161025212923.2452320-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Catalin Vasile <cata.vasile@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Building the caam driver on arm64 produces a harmless warning:

drivers/crypto/caam/caamalg.c:140:139: warning: comparison of distinct pointer types lacks a cast

We can use min_t to tell the compiler which type we want it to use
here.

Fixes: 5ecf8ef9103c ("crypto: caam - fix sg dump")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This is currently the only warning reported by kernelci.org for
linux-4.9 on arm, arm64 and x86.
---
 drivers/crypto/caam/caamalg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 156aad167cd6..8de85dfb1b04 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -137,7 +137,7 @@ static void dbg_dump_sg(const char *level, const char *prefix_str,
 		}
 
 		buf = it_page + it->offset;
-		len = min(tlen, it->length);
+		len = min_t(size_t, tlen, it->length);
 		print_hex_dump(level, prefix_str, prefix_type, rowsize,
 			       groupsize, buf, len, ascii);
 		tlen -= len;
-- 
2.9.0
