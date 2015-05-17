From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/6] crypto: sparc/md5: use md5 IV MD5_HX instead of their raw value
Date: Sun, 17 May 2015 12:54:15 +0200
Message-ID: <1431860057-5232-4-git-send-email-clabbe.montjoie@gmail.com>
References: <1431860057-5232-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-mips@linux-mips.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
	mpe@ellerman.id.au, aaro.koskinen@iki.fi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f194.google.com ([209.85.212.194]:36070 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbbEQKy3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 May 2015 06:54:29 -0400
In-Reply-To: <1431860057-5232-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since MD5 IV are now available in crypto/md5.h, use them.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 arch/sparc/crypto/md5_glue.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/crypto/md5_glue.c b/arch/sparc/crypto/md5_glue.c
index b688731..c9d2b92 100644
--- a/arch/sparc/crypto/md5_glue.c
+++ b/arch/sparc/crypto/md5_glue.c
@@ -33,10 +33,10 @@ static int md5_sparc64_init(struct shash_desc *desc)
 {
 	struct md5_state *mctx = shash_desc_ctx(desc);
 
-	mctx->hash[0] = cpu_to_le32(0x67452301);
-	mctx->hash[1] = cpu_to_le32(0xefcdab89);
-	mctx->hash[2] = cpu_to_le32(0x98badcfe);
-	mctx->hash[3] = cpu_to_le32(0x10325476);
+	mctx->hash[0] = cpu_to_le32(MD5_H0);
+	mctx->hash[1] = cpu_to_le32(MD5_H1);
+	mctx->hash[2] = cpu_to_le32(MD5_H2);
+	mctx->hash[3] = cpu_to_le32(MD5_H3);
 	mctx->byte_count = 0;
 
 	return 0;
-- 
2.3.6
