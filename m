From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 2/2] crypto/drbg: account for no longer returning -EALREADY
Date: Thu, 19 Oct 2017 22:45:06 +0200
Message-ID: <20171019204506.25090-2-Jason@zx2c4.com>
References: <CAHmME9qwoSwFi7fsg1Z+gcEh1fBY+KY2rJ81UTHYn2ZMcjjwFA@mail.gmail.com>
 <20171019204506.25090-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        tytso@mit.edu, gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171019204506.25090-1-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We now structure things in a way that assumes the seeding function is
always eventually called.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 crypto/drbg.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 70018397e59a..501e013cb96c 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1411,18 +1411,8 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
 
 	err = add_random_ready_callback(&drbg->random_ready);
 
-	switch (err) {
-	case 0:
-		break;
-
-	case -EALREADY:
-		err = 0;
-		/* fall through */
-
-	default:
-		drbg->random_ready.func = NULL;
+	if (err)
 		return err;
-	}
 
 	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
 
@@ -1432,7 +1422,7 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
 	 */
 	drbg->reseed_threshold = 50;
 
-	return err;
+	return 0;
 }
 
 /*
@@ -1526,9 +1516,9 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
  */
 static int drbg_uninstantiate(struct drbg_state *drbg)
 {
-	if (drbg->random_ready.func) {
-		del_random_ready_callback(&drbg->random_ready);
-		cancel_work_sync(&drbg->seed_work);
+	del_random_ready_callback(&drbg->random_ready);
+	cancel_work_sync(&drbg->seed_work);
+	if (drbg->jent) {
 		crypto_free_rng(drbg->jent);
 		drbg->jent = NULL;
 	}
-- 
2.14.2
