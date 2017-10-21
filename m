From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/3] crypto-ansi_cprng: Delete two variable assignments in
 get_prng_bytes()
Date: Sat, 21 Oct 2017 19:15:54 +0200
Message-ID: <7318b066-5233-426e-4b21-d4969b96bf67@users.sourceforge.net>
References: <d284473a-b968-2b3e-9147-1c8598a26f7c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d284473a-b968-2b3e-9147-1c8598a26f7c@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 21 Oct 2017 16:10:43 +0200

Adjust a jump target so that two error code assignments which are redundant
before condition checks can be removed because the same value will be set
as an exception handling at the end of this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 crypto/ansi_cprng.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 111c8982a47f..3d805bf6d0c6 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -192,19 +192,16 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
 
 
 	spin_lock_bh(&ctx->prng_lock);
-
-	err = -EINVAL;
 	if (ctx->flags & PRNG_NEED_RESET)
-		goto unlock;
+		goto failure_indication;
 
 	/*
 	 * If the FIXED_SIZE flag is on, only return whole blocks of
 	 * pseudo random data
 	 */
-	err = -EINVAL;
 	if (ctx->flags & PRNG_FIXED_SIZE) {
 		if (nbytes < DEFAULT_BLK_SZ)
-			goto unlock;
+			goto failure_indication;
 		byte_count = DEFAULT_BLK_SZ;
 	}
 
@@ -267,6 +264,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
 
 reset_memory:
 	memset(buf, 0, nbytes);
+failure_indication:
 	err = -EINVAL;
 	goto unlock;
 }
-- 
2.14.2
