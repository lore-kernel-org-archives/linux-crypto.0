Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC52ECE588
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 16:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79F3520872
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 16:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbfJOQSU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Oct 2019 12:18:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:33016 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbfJOQSU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Oct 2019 12:18:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 670E5B4B0;
        Tue, 15 Oct 2019 16:18:18 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH] drivers,crypto/cavium: Fix barrier barrier usage after atomic_set()
Date:   Tue, 15 Oct 2019 09:16:57 -0700
Message-Id: <20191015161657.10760-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Because it is not a Rmw operation, atomic_set() is not serialized,
and therefore the 'upgradable' smp_mb__after_atomic() call after
the atomic_set() is completely bogus (not to mention the comment
could also use some love, but that's a different matter).

This patch replaces these with smp_mb(), which seems like the
original intent of when the code was written.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/crypto/cavium/nitrox/nitrox_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index bc924980e10c..da2e0edceb50 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -504,7 +504,7 @@ static int nitrox_probe(struct pci_dev *pdev,
 
 	atomic_set(&ndev->state, __NDEV_READY);
 	/* barrier to sync with other cpus */
-	smp_mb__after_atomic();
+	smp_mb();
 
 	err = nitrox_crypto_register();
 	if (err)
@@ -551,7 +551,7 @@ static void nitrox_remove(struct pci_dev *pdev)
 
 	atomic_set(&ndev->state, __NDEV_NOT_READY);
 	/* barrier to sync with other cpus */
-	smp_mb__after_atomic();
+	smp_mb();
 
 	nitrox_remove_from_devlist(ndev);
 
-- 
2.16.4

