From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 2/7] hwrng: core: rewrite better comparison to NULL
Date: Tue, 13 Dec 2016 15:51:10 +0100
Message-ID: <20161213145115.30082-2-clabbe.montjoie@gmail.com>
References: <20161213145115.30082-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161213145115.30082-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch fix the checkpatch warning "Comparison to NULL could be written "!ptr"

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 00cbb81..7029246 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -439,8 +439,7 @@ int hwrng_register(struct hwrng *rng)
 	int err = -EINVAL;
 	struct hwrng *old_rng, *tmp;
 
-	if (rng->name == NULL ||
-	    (rng->data_read == NULL && rng->read == NULL))
+	if (!rng->name || (!rng->data_read && !rng->read))
 		goto out;
 
 	mutex_lock(&rng_mutex);
-- 
2.10.2
