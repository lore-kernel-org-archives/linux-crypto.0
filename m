From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 18/18] crypto: skcipher - Fix blkcipher walk OOM crash
Date: Thu, 27 Oct 2016 17:29:51 +0300
Message-ID: <1477578591-28924-19-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit acdb04d0b36769b3e05990c488dc74d8b7ac8060 upstream.

When we need to allocate a temporary blkcipher_walk_next and it
fails, the code is supposed to take the slow path of processing
the data block by block.  However, due to an unrelated change
we instead end up dereferencing the NULL pointer.

This patch fixes it by moving the unrelated bsize setting out
of the way so that we enter the slow path as inteded.

Fixes: 7607bd8ff03b ("[CRYPTO] blkcipher: Added blkcipher_walk_virt_block")
Cc: stable@vger.kernel.org
Reported-by: xiakaixu <xiakaixu@huawei.com>
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/blkcipher.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 37af08e..39b09f25 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -238,6 +238,8 @@ static int blkcipher_walk_next(struct blkcipher_desc *desc,
 		return blkcipher_walk_done(desc, walk, -EINVAL);
 	}
 
+	bsize = min(walk->blocksize, n);
+
 	walk->flags &= ~(BLKCIPHER_WALK_SLOW | BLKCIPHER_WALK_COPY |
 			 BLKCIPHER_WALK_DIFF);
 	if (!scatterwalk_aligned(&walk->in, alignmask) ||
@@ -250,7 +252,6 @@ static int blkcipher_walk_next(struct blkcipher_desc *desc,
 		}
 	}
 
-	bsize = min(walk->blocksize, n);
 	n = scatterwalk_clamp(&walk->in, n);
 	n = scatterwalk_clamp(&walk->out, n);
 
-- 
2.7.3
