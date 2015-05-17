From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/6] crypto: md5: add MD5 initial vectors
Date: Sun, 17 May 2015 12:54:12 +0200
Message-ID: <1431860057-5232-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-mips@linux-mips.org,
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
	mpe@ellerman.id.au, aaro.koskinen@iki.fi
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch simply adds the MD5 IV in the md5 header.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 include/crypto/md5.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/crypto/md5.h b/include/crypto/md5.h
index 65f299b..146af82 100644
--- a/include/crypto/md5.h
+++ b/include/crypto/md5.h
@@ -8,6 +8,11 @@
 #define MD5_BLOCK_WORDS		16
 #define MD5_HASH_WORDS		4
 
+#define MD5_H0	0x67452301UL
+#define MD5_H1	0xefcdab89UL
+#define MD5_H2	0x98badcfeUL
+#define MD5_H3	0x10325476UL
+
 struct md5_state {
 	u32 hash[MD5_HASH_WORDS];
 	u32 block[MD5_BLOCK_WORDS];
-- 
2.3.6

