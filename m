From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] sha: prevent removal of memset as dead store in sha1_update()
Date: Thu, 25 Feb 2010 16:10:27 +0100
Message-ID: <4B8692E3.9030509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Mikael Pettersson <mikpe@it.uu.se>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundat
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36136 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204Ab0BYPKe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 10:10:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Due to optimization A call to memset() may be removed as a dead store when
the buffer is not used after its value is overwritten.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
see http://cwe.mitre.org/data/slices/2000.html#14

checkpatch.pl, compile and sparse tested. Comments?

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 0416091..86de0da 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -49,8 +49,8 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 	src = data;
 
 	if ((partial + len) > 63) {
-		u32 temp[SHA_WORKSPACE_WORDS];
