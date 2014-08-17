From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 5/8] DRBG: use kmalloc instead of kzalloc for V and C
Date: Sun, 17 Aug 2014 17:39:31 +0200
Message-ID: <1908749.s83x5fJMRR@myon.chronox.de>
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

When allocating V, C, the zeroization is only needed when
allocating a new instance of the DRBG, i.e. when performing an
initial seeding. For all other allocations, the memcpy implemented in
drbg_copy_drbg ensures that the memory is filled with the correct
information.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index d13f588..997c510 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1142,6 +1142,11 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		pr_devel("DRBG: using personalization string\n");
 	}
 
+	if (!reseed) {
+		memset(drbg->V, 0, drbg_statelen(drbg));
+		memset(drbg->C, 0, drbg_statelen(drbg));
+	}
+
 	ret = drbg->d_ops->update(drbg, &seedlist, reseed);
 	if (ret)
 		goto out;
@@ -1186,14 +1191,14 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	if (!drbg)
 		return -EINVAL;
 
-	drbg->V = kzalloc(drbg_statelen(drbg), GFP_KERNEL);
+	drbg->V = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
 	if (!drbg->V)
 		goto err;
-	drbg->C = kzalloc(drbg_statelen(drbg), GFP_KERNEL);
+	drbg->C = kmalloc(drbg_statelen(drbg), GFP_KERNEL);
 	if (!drbg->C)
 		goto err;
 #ifdef CONFIG_CRYPTO_FIPS
-	drbg->prev = kzalloc(drbg_blocklen(drbg), GFP_KERNEL);
+	drbg->prev = kmalloc(drbg_blocklen(drbg), GFP_KERNEL);
 	if (!drbg->prev)
 		goto err;
 	drbg->fips_primed = false;
-- 
1.9.3
