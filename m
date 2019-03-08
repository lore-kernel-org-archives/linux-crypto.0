Return-Path: <SRS0=1D0u=RL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E2BC43381
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Mar 2019 00:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA17820652
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Mar 2019 00:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfCHAZ2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Mar 2019 19:25:28 -0500
Received: from smtprelay0062.hostedemail.com ([216.40.44.62]:42956 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726227AbfCHAZ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Mar 2019 19:25:28 -0500
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2019 19:25:27 EST
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave06.hostedemail.com (Postfix) with ESMTP id D99588122535
        for <linux-crypto@vger.kernel.org>; Fri,  8 Mar 2019 00:15:59 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 0245A837F27D;
        Fri,  8 Mar 2019 00:15:58 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: join62_16dde06a1a41a
X-Filterd-Recvd-Size: 2967
Received: from XPS-9350 (unknown [149.142.244.224])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Fri,  8 Mar 2019 00:15:57 +0000 (UTC)
Message-ID: <5ef0cab4dee128058a43f43c723c13924662e80d.camel@perches.com>
Subject: [possible PATCH] crypto: sahara - Use #ifdef DEBUG not
 IS_ENABLED(DEBUG)
From:   Joe Perches <joe@perches.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 07 Mar 2019 16:15:55 -0800
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Normal use of IS_ENABLED is with a CONFIG_<SYMBOL> and
there is no -DDEBUG in the Makefile here.

Replace the IS_ENABLED(DEBUG) with #ifdef DEBUG/#endif
blocks.

Miscellanea:

o Move the sahara_state array into the function that uses it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/crypto/sahara.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 8c32a3059b4a..d2b4bd483507 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -348,14 +348,13 @@ static void sahara_decode_error(struct sahara_dev *dev, unsigned int error)
 	dev_err(dev->device, "\n");
 }
 
-static const char *sahara_state[4] = { "Idle", "Busy", "Error", "HW Fault" };
-
 static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
 {
+#ifdef DEBUG
 	u8 state;
-
-	if (!IS_ENABLED(DEBUG))
-		return;
+	static const char *sahara_state[4] = {
+		"Idle", "Busy", "Error", "HW Fault"
+	};
 
 	state = SAHARA_STATUS_GET_STATE(status);
 
@@ -400,15 +399,14 @@ static void sahara_decode_status(struct sahara_dev *dev, unsigned int status)
 		sahara_read(dev, SAHARA_REG_CDAR));
 	dev_dbg(dev->device, "Initial DAR: 0x%08x\n\n",
 		sahara_read(dev, SAHARA_REG_IDAR));
+#endif
 }
 
 static void sahara_dump_descriptors(struct sahara_dev *dev)
 {
+#ifdef DEBUG
 	int i;
 
-	if (!IS_ENABLED(DEBUG))
-		return;
-
 	for (i = 0; i < SAHARA_MAX_HW_DESC; i++) {
 		dev_dbg(dev->device, "Descriptor (%d) (%pad):\n",
 			i, &dev->hw_phys_desc[i]);
@@ -421,15 +419,14 @@ static void sahara_dump_descriptors(struct sahara_dev *dev)
 			dev->hw_desc[i]->next);
 	}
 	dev_dbg(dev->device, "\n");
+#endif
 }
 
 static void sahara_dump_links(struct sahara_dev *dev)
 {
+#ifdef DEBUG
 	int i;
 
-	if (!IS_ENABLED(DEBUG))
-		return;
-
 	for (i = 0; i < SAHARA_MAX_HW_LINK; i++) {
 		dev_dbg(dev->device, "Link (%d) (%pad):\n",
 			i, &dev->hw_phys_link[i]);
@@ -439,6 +436,7 @@ static void sahara_dump_links(struct sahara_dev *dev)
 			dev->hw_link[i]->next);
 	}
 	dev_dbg(dev->device, "\n");
+#endif
 }
 
 static int sahara_hw_descriptor_create(struct sahara_dev *dev)


