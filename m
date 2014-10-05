From: Mike Roocroft <mike.linux@btinternet.com>
Subject: [PATCH] Crypto: gf128mul : fixed a parentheses coding style issue
Date: Sun,  5 Oct 2014 11:35:41 +0100
Message-ID: <1412505341-20273-1-git-send-email-mike.linux@btinternet.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mike Roocroft <mike.linux@btinternet.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Mike Roocroft <mike.linux@btinternet.com>
---
 crypto/gf128mul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index 5276607..b143d84 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -97,7 +97,7 @@
     the table above
 */
 
-#define xx(p, q)	0x##p##q
+#define xx(p, q)	(0x##p##q)
 
 #define xda_bbe(i) ( \
 	(i & 0x80 ? xx(43, 80) : 0) ^ (i & 0x40 ? xx(21, c0) : 0) ^ \
-- 
2.1.0
