From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 2/3] crypto: omap-aes - Staticize local symbols
Date: Fri, 13 Sep 2013 17:06:46 +0530
Message-ID: <1379072207-11179-2-git-send-email-sachin.kamat@linaro.org>
References: <1379072207-11179-1-git-send-email-sachin.kamat@linaro.org>
Cc: herbert@gondor.apana.org.au, sachin.kamat@linaro.org,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:43390 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab3IMLy6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Sep 2013 07:54:58 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl13so2436694pab.34
        for <linux-crypto@vger.kernel.org>; Fri, 13 Sep 2013 04:54:58 -0700 (PDT)
In-Reply-To: <1379072207-11179-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Local symbols used only in this file are made static.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-aes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ce791c2..e1e58d0 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -554,7 +554,7 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
 	return err;
 }
 
-int omap_aes_check_aligned(struct scatterlist *sg)
+static int omap_aes_check_aligned(struct scatterlist *sg)
 {
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, 4))
@@ -566,7 +566,7 @@ int omap_aes_check_aligned(struct scatterlist *sg)
 	return 0;
 }
 
-int omap_aes_copy_sgs(struct omap_aes_dev *dd)
+static int omap_aes_copy_sgs(struct omap_aes_dev *dd)
 {
 	void *buf_in, *buf_out;
 	int pages;
-- 
1.7.9.5
