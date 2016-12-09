From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/7] hwrng: core: rewrite better comparison to NULL
Date: Fri,  9 Dec 2016 15:21:34 +0100
Message-ID: <1481293299-21697-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:34666 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932427AbcLIOYN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2016 09:24:13 -0500
In-Reply-To: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
2.7.3
