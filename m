Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDE4C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Apr 2021 08:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 482E1610C8
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Apr 2021 08:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhDZISl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Apr 2021 04:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbhDZISk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Apr 2021 04:18:40 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F78C061574;
        Mon, 26 Apr 2021 01:17:59 -0700 (PDT)
Received: from cap.home.8bytes.org (p5b0069de.dip0.t-ipconnect.de [91.0.105.222])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 80F942AC;
        Mon, 26 Apr 2021 10:17:56 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        joro@8bytes.org, Joerg Roedel <jroedel@suse.de>,
        stable@vger.kernel.org
Subject: [PATCH v4] crypto: ccp: Annotate SEV Firmware file names
Date:   Mon, 26 Apr 2021 10:17:48 +0200
Message-Id: <20210426081748.25419-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Annotate the firmware files CCP might need using MODULE_FIRMWARE().
This will get them included into an initrd when CCP is also included
there. Otherwise the CCP module will not find its firmware when loaded
before the root-fs is mounted.
This can cause problems when the pre-loaded SEV firmware is too old to
support current SEV and SEV-ES virtualization features.

Fixes: e93720606efd ("crypto: ccp - Allow SEV firmware to be chosen based on Family and Model")
Cc: stable@vger.kernel.org # v4.20+
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/crypto/ccp/sev-dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index cb9b4c4e371e..675ff925a59d 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -42,6 +42,10 @@ static int psp_probe_timeout = 5;
 module_param(psp_probe_timeout, int, 0644);
 MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
 
+MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
+MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
+MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
+
 static bool psp_dead;
 static int psp_timeout;
 
-- 
2.31.1

