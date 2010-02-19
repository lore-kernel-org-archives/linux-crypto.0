From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 04/19] crypto: md5 - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:21:56 +0100
Message-ID: <1266538917-3212-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/md5.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/md5.c b/crypto/md5.c
index 83eb529..d7cc5f8 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Cryptographic API.
  *
  * MD5 Message Digest Algorithm (RFC1321).
@@ -8,10 +8,10 @@
  *
  * Copyright (c) Cryptoapi developers.
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
- * 
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  */
@@ -201,7 +201,7 @@ static int md5_final(struct shash_desc *desc, u8 *out)
 
 	*p++ = 0x80;
 	if (padding < 0) {
-		memset(p, 0x00, padding + sizeof (u64));
+		memset(p, 0x00, padding + sizeof(u64));
 		md5_transform_helper(mctx);
 		p = (char *)mctx->block;
 		padding = 56;
-- 
1.6.6.1
