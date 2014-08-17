From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 8/8] DRBG: remove unnecessary sanity check for shadow state
Date: Sun, 17 Aug 2014 17:41:38 +0200
Message-ID: <2900796.YflQD55GTj@myon.chronox.de>
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

During creation of the DRBG shadow state, it is ensured that the DRBG
state structure is already allocated. Thus, a sanity check for verifying
that the structure is allocated is removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index a556180..f009939 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1155,9 +1155,6 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	int ret = -ENOMEM;
 	unsigned int sb_size = 0;
 
-	if (!drbg)
-		return -EINVAL;
-
 	drbg->V = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
 	if (!drbg->V)
 		goto err;
-- 
1.9.3
