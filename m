From: Mandeep Singh Baines <msb@google.com>
Subject: [PATCH v3] crypto: sha1: use SHA1_BLOCK_SIZE
Date: Thu, 23 Jun 2011 12:02:27 -0700
Message-ID: <20110623190227.GH13916@google.com>
References: <1306379477-24552-1-git-send-email-msb@chromium.org>
 <20110525.233411.1372538972166578285.davem@davemloft.net>
 <20110526232058.GQ11023@google.com>
 <20110531052245.GA17068@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mandeep Singh Baines <msb@chromium.org>,
	David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Joe Perches <joe@perches.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110531052245.GA17068@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Modify sha1_update to use SHA1_BLOCK_SIZE.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
---
 crypto/sha1_generic.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 0416091..00ae60e 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -43,25 +43,26 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
 	unsigned int partial, done;
 	const u8 *src;
 
-	partial = sctx->count & 0x3f;
+	partial = sctx->count % SHA1_BLOCK_SIZE;
 	sctx->count += len;
 	done = 0;
 	src = data;
 
-	if ((partial + len) > 63) {
+	if ((partial + len) >= SHA1_BLOCK_SIZE) {
 		u32 temp[SHA_WORKSPACE_WORDS];
 
 		if (partial) {
 			done = -partial;
-			memcpy(sctx->buffer + partial, data, done + 64);
+			memcpy(sctx->buffer + partial, data,
+			       done + SHA1_BLOCK_SIZE);
 			src = sctx->buffer;
 		}
 
 		do {
 			sha_transform(sctx->state, src, temp);
-			done += 64;
+			done += SHA1_BLOCK_SIZE;
 			src = data + done;
-		} while (done + 63 < len);
+		} while (done + SHA1_BLOCK_SIZE <= len);
 
 		memset(temp, 0, sizeof(temp));
 		partial = 0;
-- 
1.7.3.1
