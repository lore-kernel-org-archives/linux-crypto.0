From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v4 1/4] crypto: lrw - Fix out-of bounds access on counter overflow
Date: Thu, 13 Sep 2018 10:51:31 +0200
Message-ID: <20180913085134.11694-2-omosnace@redhat.com>
References: <20180913085134.11694-1-omosnace@redhat.com>
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180913085134.11694-1-omosnace@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When the LRW block counter overflows, the current implementation returns
128 as the index to the precomputed multiplication table, which has 128
entries. This patch fixes it to return the correct value (127).

Fixes: 64470f1b8510 ("[CRYPTO] lrw: Liskov Rivest Wagner, a tweakable narrow block cipher mode")
Cc: <stable@vger.kernel.org> # 2.6.20+
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 crypto/lrw.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 393a782679c7..5504d1325a56 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -143,7 +143,12 @@ static inline int get_index128(be128 *block)
 		return x + ffz(val);
 	}
 
-	return x;
+	/*
+	 * If we get here, then x == 128 and we are incrementing the counter
+	 * from all ones to all zeros. This means we must return index 127, i.e.
+	 * the one corresponding to key2*{ 1,...,1 }.
+	 */
+	return 127;
 }
 
 static int post_crypt(struct skcipher_request *req)
-- 
2.17.1
