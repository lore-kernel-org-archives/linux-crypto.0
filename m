Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727545AbfAJUSX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:23 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Vitaly Chikunov <vt@altlinux.org>
Subject: [PATCH 03/11] crypto: streebog - use correct endianness type
Date: Thu, 10 Jan 2019 12:17:54 -0800
Message-Id: <20190110201802.82442-4-ebiggers@kernel.org>
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

streebog_uint512::qword needs to be __le64, not u64.  This fixes a large
number of sparse warnings:

    crypto/streebog_generic.c:25:9: warning: incorrect type in initializer (different base types)
    crypto/streebog_generic.c:25:9:    expected unsigned long long
    crypto/streebog_generic.c:25:9:    got restricted __le64 [usertype]
    [omitted many similar warnings]

No actual change in behavior.

Cc: Vitaly Chikunov <vt@altlinux.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/streebog_generic.c | 2 +-
 include/crypto/streebog.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/streebog_generic.c b/crypto/streebog_generic.c
index 03272a22afcec..5a2eafed9c29f 100644
--- a/crypto/streebog_generic.c
+++ b/crypto/streebog_generic.c
@@ -960,7 +960,7 @@ static int streebog_init(struct shash_desc *desc)
 	memset(ctx, 0, sizeof(struct streebog_state));
 	for (i = 0; i < 8; i++) {
 		if (digest_size == STREEBOG256_DIGEST_SIZE)
-			ctx->h.qword[i] = 0x0101010101010101ULL;
+			ctx->h.qword[i] = cpu_to_le64(0x0101010101010101ULL);
 	}
 	return 0;
 }
diff --git a/include/crypto/streebog.h b/include/crypto/streebog.h
index 4af119f7e07b9..856e32af86574 100644
--- a/include/crypto/streebog.h
+++ b/include/crypto/streebog.h
@@ -19,7 +19,7 @@
 #define STREEBOG_BLOCK_SIZE	64
 
 struct streebog_uint512 {
-	u64 qword[8];
+	__le64 qword[8];
 };
 
 struct streebog_state {
-- 
2.20.1.97.g81188d93c3-goog
