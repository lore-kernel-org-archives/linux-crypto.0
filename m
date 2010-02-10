From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in fcrypt.c
Date: Wed, 10 Feb 2010 02:35:39 +0100
Message-ID: <1265765740-27103-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53956 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab0BJBgM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 20:36:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/fcrypt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index b82d61f..c33107e 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -60,13 +60,13 @@ do {								\
 	u32 t = lo & ((1 << n) - 1);				\
 	lo = (lo >> n) | ((hi & ((1 << n) - 1)) << (32 - n));	\
 	hi = (hi >> n) | (t << (24-n));				\
-} while(0)
+} while (0)
 
 /* Rotate right one 64 bit number as a 56 bit number */
 #define ror56_64(k, n)						\
 do {								\
 	k = (k >> n) | ((k & ((1 << n) - 1)) << (56 - n));	\
-} while(0)
+} while (0)
 
 /*
  * Sboxes for Feistel network derived from
@@ -228,7 +228,7 @@ do {									\
 	union lc4 { __be32 l; u8 c[4]; } u;				\
 	u.l = sched ^ R;						\
 	L ^= sbox0[u.c[0]] ^ sbox1[u.c[1]] ^ sbox2[u.c[2]] ^ sbox3[u.c[3]]; \
-} while(0)
+} while (0)
 
 /*
  * encryptor
-- 
1.6.6.1

