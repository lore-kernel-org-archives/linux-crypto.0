Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9958EFA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 11:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79717205F4
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 11:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbfJPLp0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 07:45:26 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:49635 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731586AbfJPLp0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 07:45:26 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKhjx-00062v-JZ; Wed, 16 Oct 2019 12:45:17 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iKhjw-000281-Ug; Wed, 16 Oct 2019 12:45:16 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: inside-secure - fix unexported warnings
Date:   Wed, 16 Oct 2019 12:45:12 +0100
Message-Id: <20191016114512.8138-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The safexcel_pci_remove, pcireg_rc and ofreg_rc are
not exported or declared externally so make them static.

This avoids the following sparse warnings:

drivers/crypto/inside-secure/safexcel.c:1760:6: warning: symbol 'safexcel_pci_remove' was not declared. Should it be static?
drivers/crypto/inside-secure/safexcel.c:1794:5: warning: symbol 'pcireg_rc' was not declared. Should it be static?
drivers/crypto/inside-secure/safexcel.c:1797:5: warning: symbol 'ofreg_rc' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/inside-secure/safexcel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 4ab1bde8dd9b..223d1bfdc7e6 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1757,7 +1757,7 @@ static int safexcel_pci_probe(struct pci_dev *pdev,
 	return rc;
 }
 
-void safexcel_pci_remove(struct pci_dev *pdev)
+static void safexcel_pci_remove(struct pci_dev *pdev)
 {
 	struct safexcel_crypto_priv *priv = pci_get_drvdata(pdev);
 	int i;
@@ -1791,10 +1791,10 @@ static struct pci_driver safexcel_pci_driver = {
 
 /* Unfortunately, we have to resort to global variables here */
 #if IS_ENABLED(CONFIG_PCI)
-int pcireg_rc = -EINVAL; /* Default safe value */
+static int pcireg_rc = -EINVAL; /* Default safe value */
 #endif
 #if IS_ENABLED(CONFIG_OF)
-int ofreg_rc = -EINVAL; /* Default safe value */
+static int ofreg_rc = -EINVAL; /* Default safe value */
 #endif
 
 static int __init safexcel_init(void)
-- 
2.23.0

