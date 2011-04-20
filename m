From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 1/4] crypto: omap-sham - fix concurrent sha1 calculations
Date: Wed, 20 Apr 2011 13:34:55 +0300
Message-ID: <f99ac830803c8c7877ceed3b89593e2461836b56.1303295558.git.dmitry.kasatkin@nokia.com>
References: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	Markku Kylanpaa <ext-markku.kylanpaa@nokia.com>
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:33173 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab1DTKet (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2011 06:34:49 -0400
In-Reply-To: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
References: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markku Kylanpaa <ext-markku.kylanpaa@nokia.com>

SHA1 accelerator can also be busy. Add -EBUSY status return option and
return busy status from omap_sham_finup().

Signed-off-by: Markku Kylanpaa <ext-markku.kylanpaa@nokia.com>
---
 drivers/crypto/omap-sham.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 465cde3..e36032b 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -835,7 +835,7 @@ static int omap_sham_finup(struct ahash_request *req)
 	ctx->flags |= FLAGS_FINUP;
 
 	err1 = omap_sham_update(req);
-	if (err1 == -EINPROGRESS)
+	if (err1 == -EINPROGRESS || err1 == -EBUSY)
 		return err1;
 	/*
 	 * final() has to be always called to cleanup resources
-- 
1.7.1
