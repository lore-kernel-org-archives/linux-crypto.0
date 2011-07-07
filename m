From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto, gf128: fix call to memset()
Date: Thu,  7 Jul 2011 10:33:50 +0200
Message-ID: <1310027630-26488-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grimli.r00tworld.net ([83.169.44.195]:45539 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab1GGImo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Jul 2011 04:42:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In gf128mul_lle() and gf128mul_bbe() r isn't completely initialized with
zero because the size argument passed to memset() is the size of the
pointer, not the structure it points to.

Luckily there are no in-kernel users of those functions so the ABI
change implied by this fix should break no existing code.

Based on a patch by the PaX Team.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: PaX Team <pageexec@freemail.hu>
---
 crypto/gf128mul.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/gf128mul.c b/crypto/gf128mul.c
index df35e4c..5276607 100644
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -182,7 +182,7 @@ void gf128mul_lle(be128 *r, const be128 *b)
 	for (i = 0; i < 7; ++i)
 		gf128mul_x_lle(&p[i + 1], &p[i]);
 
-	memset(r, 0, sizeof(r));
+	memset(r, 0, sizeof(*r));
 	for (i = 0;;) {
 		u8 ch = ((u8 *)b)[15 - i];
 
@@ -220,7 +220,7 @@ void gf128mul_bbe(be128 *r, const be128 *b)
 	for (i = 0; i < 7; ++i)
 		gf128mul_x_bbe(&p[i + 1], &p[i]);
 
-	memset(r, 0, sizeof(r));
+	memset(r, 0, sizeof(*r));
 	for (i = 0;;) {
 		u8 ch = ((u8 *)b)[i];
 
-- 
1.5.6.5
