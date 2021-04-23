Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF5CC433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Apr 2021 11:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEB8B61468
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Apr 2021 11:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhDWLJR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:09:17 -0400
Received: from 8bytes.org ([81.169.241.247]:35996 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhDWLJP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Apr 2021 07:09:15 -0400
Received: from cap.home.8bytes.org (p5b0069de.dip0.t-ipconnect.de [91.0.105.222])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id AD1B4F3;
        Fri, 23 Apr 2021 13:08:37 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@sev.home.8bytes.org>, stable@vger.kernel.org
Subject: [PATCH] crypto: ccp: Annotate SEV Firmware file names
Date:   Fri, 23 Apr 2021 13:08:33 +0200
Message-Id: <20210423110833.10922-1-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Joerg Roedel <joro@sev.home.8bytes.org>

Annotate the firmware files CCP might need using MODULE_FIRMWARE().
This will get them included into an initrd when CCP is also included
there. Otherwise the CCP module will not find its firmware when loaded
before the root-fs is mounted.
This can cause problems when the pre-loaded SEV firmware is too old to
support current SEV and SEV-ES virtualization features.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joro@sev.home.8bytes.org>
---
 drivers/crypto/ccp/sev-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index cb9b4c4e371e..9883e3afe10b 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -42,6 +42,9 @@ static int psp_probe_timeout = 5;
 module_param(psp_probe_timeout, int, 0644);
 MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
 
+MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin");
+MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin");
+
 static bool psp_dead;
 static int psp_timeout;
 
-- 
2.31.1

