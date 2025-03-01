Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C171F3594D
	for <linux-crypto@vger.kernel.org>; Sat,  1 Mar 2025 14:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740839933; cv=none; b=MNAlt2r1rf0pPS0Q3BiUyBSsCo8KGzvJ+2G9fGirlOYpaeAf4UXfNhYMYZNS6UUFyDykQsQsXkmct7RngZd2IQtYDLSY2dyyFTUwjfrHk+aAw3P8IgS1jjv5hywgQxn75a2p/z8NtuqpwP7h7w4ahiYWP4RYSkOLLL4rxmuyoNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740839933; c=relaxed/simple;
	bh=YU/capnsEz8eugDzdWDgZph/rkx5rRKO+yfVDcr36ic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oNoS+tl3cbinn/4nAWkf6aLkqh2OMF/v0axcYI/na0CuBpac1JvJFKGSPcGP1IPiu86gM/HiLazNv08BYItu0u6gjQoWzAqv7QSqJNENgZS2+wDK8d7Aut1js15fbxJIKf+EOhzmH5152hbNWh/3ouKOROOrxtBcSVJg1MezQjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from bozeman.lan (pool-96-240-17-61.nwrknj.fios.verizon.net [96.240.17.61])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mpagano)
	by smtp.gentoo.org (Postfix) with ESMTPSA id B6674342FEA;
	Sat, 01 Mar 2025 14:38:50 +0000 (UTC)
From: mpagano@gentoo.org
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	mpagano@gentoo.org
Subject: [PATCH] crypto: lib/aescfb - fix build with GCC 15 due to -Werror=unterminated-string-initialization
Date: Sat,  1 Mar 2025 09:38:42 -0500
Message-ID: <20250301143842.173872-1-mpagano@gentoo.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix char length error which appears when compiling with GCC 15:

CC      lib/crypto/aescfb.o
lib/crypto/aescfb.c:124:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
124 |                 .ptext  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
    |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/crypto/aescfb.c:132:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
132 |                 .ctext  = "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
    |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/crypto/aescfb.c:148:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
148 |                 .ptext  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
    |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/crypto/aescfb.c:156:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
156 |                 .ctext  = "\xcd\xc8\x0d\x6f\xdd\xf1\x8c\xab"
    |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/crypto/aescfb.c:166:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
166 |                 .key    = "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
    |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/crypto/aescfb.c:173:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
173 |                 .ptext  = "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
    |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lib/crypto/aescfb.c:181:27: error: initializer-string for array of ‘unsigned char’ is too long [-Werror=unterminated-string-initialization]
181 |                 .ctext  = "\xdc\x7e\x84\xbf\xda\x79\x16\x4b"
    |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Mike Pagano <mpagano@gentoo.org>
---
 lib/crypto/aescfb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/aescfb.c b/lib/crypto/aescfb.c
index 749dc1258..9db2ef86d 100644
--- a/lib/crypto/aescfb.c
+++ b/lib/crypto/aescfb.c
@@ -106,11 +106,11 @@ MODULE_LICENSE("GPL");
  */
 
 static struct {
-	u8	ptext[64];
-	u8	ctext[64];
+	u8	ptext[65];
+	u8	ctext[65];
 
-	u8	key[AES_MAX_KEY_SIZE];
-	u8	iv[AES_BLOCK_SIZE];
+	u8	key[AES_MAX_KEY_SIZE+1];
+	u8	iv[AES_BLOCK_SIZE+1];
 
 	int	klen;
 	int	len;
-- 
2.48.1

