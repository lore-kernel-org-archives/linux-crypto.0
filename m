From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH 2/4] crypto: gf128mul - remove xx() macro
Date: Tue, 14 Feb 2017 13:43:28 -0800
Message-ID: <20170214214330.99845-3-ebiggers@google.com>
References: <20170214214330.99845-1-ebiggers@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Alex Cope <alexcope@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:37084 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753175AbdBNVqC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 16:46:02 -0500
Received: by mail-it0-f53.google.com with SMTP id x75so50917401itb.0
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2017 13:46:02 -0800 (PST)
In-Reply-To: <20170214214330.99845-1-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The xx() macro serves no purpose and can be removed.

Cc: Alex Cope <alexcope@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/gf128mul.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index d9e3eecc218a..c050cf6f5aa9 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -97,20 +97,18 @@
     the table above
 */
 
-#define xx(p, q)	0x##p##q
-
 #define xda_bbe(i) ( \
-	(i & 0x80 ? xx(43, 80) : 0) ^ (i & 0x40 ? xx(21, c0) : 0) ^ \
-	(i & 0x20 ? xx(10, e0) : 0) ^ (i & 0x10 ? xx(08, 70) : 0) ^ \
-	(i & 0x08 ? xx(04, 38) : 0) ^ (i & 0x04 ? xx(02, 1c) : 0) ^ \
-	(i & 0x02 ? xx(01, 0e) : 0) ^ (i & 0x01 ? xx(00, 87) : 0) \
+	(i & 0x80 ? 0x4380 : 0) ^ (i & 0x40 ? 0x21c0 : 0) ^ \
+	(i & 0x20 ? 0x10e0 : 0) ^ (i & 0x10 ? 0x0870 : 0) ^ \
+	(i & 0x08 ? 0x0438 : 0) ^ (i & 0x04 ? 0x021c : 0) ^ \
+	(i & 0x02 ? 0x010e : 0) ^ (i & 0x01 ? 0x0087 : 0) \
 )
 
 #define xda_lle(i) ( \
-	(i & 0x80 ? xx(e1, 00) : 0) ^ (i & 0x40 ? xx(70, 80) : 0) ^ \
-	(i & 0x20 ? xx(38, 40) : 0) ^ (i & 0x10 ? xx(1c, 20) : 0) ^ \
-	(i & 0x08 ? xx(0e, 10) : 0) ^ (i & 0x04 ? xx(07, 08) : 0) ^ \
-	(i & 0x02 ? xx(03, 84) : 0) ^ (i & 0x01 ? xx(01, c2) : 0) \
+	(i & 0x80 ? 0xe100 : 0) ^ (i & 0x40 ? 0x7080 : 0) ^ \
+	(i & 0x20 ? 0x3840 : 0) ^ (i & 0x10 ? 0x1c20 : 0) ^ \
+	(i & 0x08 ? 0x0e10 : 0) ^ (i & 0x04 ? 0x0708 : 0) ^ \
+	(i & 0x02 ? 0x0384 : 0) ^ (i & 0x01 ? 0x01c2 : 0) \
 )
 
 static const u16 gf128mul_table_lle[256] = gf128mul_dat(xda_lle);
-- 
2.11.0.483.g087da7b7c-goog
