From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 4/8] DRBG: remove superflowous memset(0)
Date: Sun, 17 Aug 2014 17:38:58 +0200
Message-ID: <10134662.iYyEj4XcbG@myon.chronox.de>
References: <7044529.FG2KhbPc9P@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7044529.FG2KhbPc9P@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove memset(0) which is not needed due to the kzalloc of the memory.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 89d732b..d13f588 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -728,11 +728,9 @@ static int drbg_hmac_update(struct drbg_state *drbg, struct list_head *seed,
 	LIST_HEAD(seedlist);
 	LIST_HEAD(vdatalist);
 
-	if (!reseed) {
-		/* 10.1.2.3 step 2 */
-		memset(drbg->C, 0, drbg_statelen(drbg));
+	if (!reseed)
+		/* 10.1.2.3 step 2 -- memset(0) of C is implicit with kzalloc */
 		memset(drbg->V, 1, drbg_statelen(drbg));
-	}
 
 	drbg_string_fill(&seed1, drbg->V, drbg_statelen(drbg));
 	list_add_tail(&seed1.list, &seedlist);
-- 
1.9.3
