Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C34DC433DF
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 09:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68A1D206A4
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 09:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgFBJUY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 05:20:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:46639 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgFBJUY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 05:20:24 -0400
IronPort-SDR: lf17E/kVavegwCPnyWpBcv+JllMifcQKS06JwcQjKA2MF/U4ynoz/fNTDoNd/Umn3BC3OGhEoD
 1BEBYAqatcEw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 02:20:24 -0700
IronPort-SDR: Jo0Jws7oY7n8GaIe6nF3LrJGqfoVuSUCxz0EXNDxHwnP014AubnHRg1PNkB8IVUXPPPgPDamHT
 zA8owAcpkXsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,463,1583222400"; 
   d="scan'208";a="268639346"
Received: from gklab-125-110.igk.intel.com ([10.91.125.110])
  by orsmga003.jf.intel.com with ESMTP; 02 Jun 2020 02:20:22 -0700
From:   Piotr Stankiewicz <piotr.stankiewicz@intel.com>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Subject: [PATCH 05/15] crypto: inside-secure - use PCI_IRQ_MSI_TYPES where appropriate
Date:   Tue,  2 Jun 2020 11:20:19 +0200
Message-Id: <20200602092019.31878-1-piotr.stankiewicz@intel.com>
X-Mailer: git-send-email 2.17.2
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Seeing as there is shorthand available to use when asking for any type
of interrupt, or any type of message signalled interrupt, leverage it.

Signed-off-by: Piotr Stankiewicz <piotr.stankiewicz@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 2cb53fbae841..1b2faa2a6ab0 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1567,7 +1567,7 @@ static int safexcel_probe_generic(void *pdev,
 		ret = pci_alloc_irq_vectors(pci_pdev,
 					    priv->config.rings + 1,
 					    priv->config.rings + 1,
-					    PCI_IRQ_MSI | PCI_IRQ_MSIX);
+					    PCI_IRQ_MSI_TYPES);
 		if (ret < 0) {
 			dev_err(dev, "Failed to allocate PCI MSI interrupts\n");
 			return ret;
-- 
2.17.2

