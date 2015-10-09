From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH v3 1/5] crypto: ensure algif_hash does not pass a zero-sized
 state
Date: Fri, 09 Oct 2015 20:43:33 +0100
Message-ID: <E1ZkdZl-0005IT-IU@rmk-PC.arm.linux.org.uk>
References: <20151009194309.GA7401@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:51390 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbbJITnl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 15:43:41 -0400
In-Reply-To: <20151009194309.GA7401@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the algorithm passed a zero statesize, do not pass a valid pointer
into the export/import functions.  Passing a valid pointer covers up
bugs in driver code which then go on to smash the kernel stack.
Instead, pass NULL, which will cause any attempt to write to the
pointer to fail.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 crypto/ahash.c | 3 ++-
 crypto/shash.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 8acb886032ae..9c1dc8d6106a 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -544,7 +544,8 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	struct crypto_alg *base = &alg->halg.base;
 
 	if (alg->halg.digestsize > PAGE_SIZE / 8 ||
-	    alg->halg.statesize > PAGE_SIZE / 8)
+	    alg->halg.statesize > PAGE_SIZE / 8 ||
+	    alg->halg.statesize == 0)
 		return -EINVAL;
 
 	base->cra_type = &crypto_ahash_type;
diff --git a/crypto/shash.c b/crypto/shash.c
index ecb1e3d39bf0..ab3384b38542 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -585,7 +585,8 @@ static int shash_prepare_alg(struct shash_alg *alg)
 
 	if (alg->digestsize > PAGE_SIZE / 8 ||
 	    alg->descsize > PAGE_SIZE / 8 ||
-	    alg->statesize > PAGE_SIZE / 8)
+	    alg->statesize > PAGE_SIZE / 8 ||
+	    alg->statesize == 0)
 		return -EINVAL;
 
 	base->cra_type = &crypto_shash_type;
-- 
2.1.0
