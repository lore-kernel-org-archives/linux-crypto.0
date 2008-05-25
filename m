From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] CRYPTO:  Simplify code using ARRAY_SIZE() macro.
Date: Sun, 25 May 2008 07:32:45 -0400 (EDT)
Message-ID: <alpine.LFD.1.10.0805250731530.23219@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:47406 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbYEYLcs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 May 2008 07:32:48 -0400
Received: from cpe001d60ad7267-cm001225dbafb6.cpe.net.cable.rogers.com ([99.236.100.208] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1K0ET0-0001bY-Oc
	for linux-crypto@vger.kernel.org; Sun, 25 May 2008 07:32:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 81f3f95..c4c018d 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -894,7 +894,7 @@ static int hifn_enable_crypto(struct hifn_device *dev)
 	char *offtbl = NULL;
 	int i;

-	for (i = 0; i < sizeof(pci2id)/sizeof(pci2id[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(pci2id)); i++) {
 		if (pci2id[i].pci_vendor == dev->pdev->vendor &&
 				pci2id[i].pci_prod == dev->pdev->device) {
 			offtbl = pci2id[i].card_id;

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
