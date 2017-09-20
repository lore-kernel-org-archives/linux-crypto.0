From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: bcm: use of_device_get_match_data
Date: Wed, 20 Sep 2017 20:47:26 +0200
Message-ID: <20170920184726.22706-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35302 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdITStg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2017 14:49:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The usage of of_device_get_match_data reduce the code size a bit.
Furthermore, it prevents an improbable dereference when
of_match_device() return NULL.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/bcm/cipher.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 537a67483aa3..92e97a6da811 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -4818,7 +4818,6 @@ static int spu_dt_read(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct spu_hw *spu = &iproc_priv.spu;
 	struct resource *spu_ctrl_regs;
-	const struct of_device_id *match;
 	const struct spu_type_subtype *matched_spu_type;
 	struct device_node *dn = pdev->dev.of_node;
 	int err, i;
@@ -4826,14 +4825,12 @@ static int spu_dt_read(struct platform_device *pdev)
 	/* Count number of mailbox channels */
 	spu->num_chan = of_count_phandle_with_args(dn, "mboxes", "#mbox-cells");
 
-	match = of_match_device(of_match_ptr(bcm_spu_dt_ids), dev);
-	if (!match) {
+	matched_spu_type = of_device_get_match_data(dev);
+	if (!matched_spu_type) {
 		dev_err(&pdev->dev, "Failed to match device\n");
 		return -ENODEV;
 	}
 
-	matched_spu_type = match->data;
-
 	spu->spu_type = matched_spu_type->type;
 	spu->spu_subtype = matched_spu_type->subtype;
 
-- 
2.13.5
