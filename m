Return-Path: <SRS0=xfQ5=UA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35939C28CC4
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 14:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F4EE2773A
	for <linux-crypto@archiver.kernel.org>; Sat,  1 Jun 2019 14:51:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.ca header.i=@yahoo.ca header.b="inLolirg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfFAOt5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 1 Jun 2019 10:49:57 -0400
Received: from sonic306-20.consmr.mail.gq1.yahoo.com ([98.137.68.83]:38617
        "EHLO sonic306-20.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbfFAOt5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Jun 2019 10:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.ca; s=s2048; t=1559400594; bh=+FzsEswF8TO/uXcnNYhQmpuXhgJ4Ib1a9HuuWhRst2M=; h=From:To:Cc:Subject:Date:From:Subject; b=inLolirgV5LNclRrIx8nzdggEuMyGfPUi3HjN7gCB+4lp7VLU78RORfFU7MCjfuWP0tzq+pfEdFaMcaLsO08BXWESlyENEg2QhJw1zwkSZFY0NruJhnzGee8Uzobc/dON4+y80QH+4Ei5+9H38YTUV9BpOG6NyEitCpr/QPy0WUH88j2SZa6nZl//Krl6pWkSEDqyx0caQn4e9uK/v8TB2FcQ4VVGHvzQJ7IfEt2TfmKLmp/SCBNhgHC8K1Zha9SaDkM1w66nWVflvWlikKrCEjuLoIvholXxI3oyUZWVyL30ArVzqPsY9B2Oz1K1oc07DXN13DIuWeSmicXw4vcJA==
X-YMail-OSG: bs9eEw4VM1k_cUQemsl_R7K6eSi11LXPHCsKKbXcZ19749GV2DjRjlelFP0SS4N
 csgAxnXCLiGltmqAefoFiuIvU0mlxpBix7.oG2yBfRs6I10VjLnxbAeLvYdwAfNezE.TEKoMbG3W
 gR9.9tHD9lKe3mu7eOj9ewK20Fke7KnZZ9jgJPIk_9Q70AtHKBFpzzCVbM6OV4bDYWccxyOe5H8c
 Zo0UP0yOdNRHzNsLN5nK0xshAfXmuw0puDqctvl1PFVRqLTleOy0rh.fS4wGHPM0L5cwHJRb0ZuU
 7VVgv.NFsYiWAFqfZiju7xDyEKM7RUurtF_g47lSNdYf4WSYzTsS_9YvNRhmMIDiOmPLldgpZlnn
 hkZNCh6J9HjqgjOXTsueyVhFULAfjafnktpyg3Ln5jz9YU8JlFatUcA6S6v8.GTI_CJDJM9j7Y4h
 WaykDdXiHb0i28nnVGGs8ytTKacjHAgzQbuMucY2KcQhrBPn0GRuUa0OftPVqUI0dMOiy4fIwiNB
 GRunGnDoVixRv8vOFGogdjbkW0nn4DaAs.pg2nM9dpWQSsT.H99SoRD7004I4q96uPvxUtM7qUaR
 sffA4AX4Y3qU20ixgw2VgdetGEDYTbW1RnphDhd_rlhiCAWDnwdbYzEH7Hwv10j5UzVyhy2GD8lS
 LwkDD3ofzt7Jw36r7Lo3E.t20tkE9hlbT5cDcJLbjKHJY337.jCJoeP..rmgYgr2mTk8Kw2UCx2.
 hXaYllIYahsElF8YsK_t_vcgO1rF2f8QUEntfp4cEQa4i83Ij8EC8tLJD463T5rVf6N.J5rWZ0LI
 adsxPXaLWO9Dno2hu4eckJ9CZbd516XgEXKp9Bh5iE67SeVvrGJJApOKHKwrwDofX3LcGgdw3ReK
 Hi_FslLLL1O0mtMeNPHTV5xnRL7y8a0_pArdmsNntccGHzCdNecXlf.JyMUyi7FeH_Z7Iz3e9KPR
 MmTEO.duYZ5gUORst73Wm0fnLYMpwetiMMM4BZ_YL6Pa.K1m0UmshtzLRpCc43LT2wd7rBfZi9.i
 Z6.Ns1ylT6nm2To23xxEIAUhnXHatoZLabsm20nl.PgBpQu8r5Dz3ax0o0D8QdD_zxf.KVoRT525
 oL7XQuTx0_mCyPF3s6BlHN7lDzfmdRaQIR_uQHqEOSOsuHqy_x6LFhcv.cQogvw5Hbk7AoPboUAw
 kil6h.l6yXZWM87MWGZys7_WAIRYU
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.gq1.yahoo.com with HTTP; Sat, 1 Jun 2019 14:49:54 +0000
Received: from CPE00fc8de26033-CM00fc8de26030.cpe.net.cable.rogers.com (EHLO localhost) ([99.228.156.240])
          by smtp424.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 0c5696934456779ae32f2b5029b3dd5e;
          Sat, 01 Jun 2019 14:49:52 +0000 (UTC)
From:   "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tglx@linutronix.de
Cc:     allison@lohutok.net, alexios.zavras@intel.com, swinslow@gmail.com,
        rfontana@redhat.com, gregkh@linuxfoundation.org,
        linux-spdx@vger.kernel.org, torvalds@linux-foundation.org,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
Subject: [PATCH] crypto: ux500 - fix license comment syntax error
Date:   Sat,  1 Jun 2019 10:49:43 -0400
Message-Id: <20190601144943.126995-1-alex_y_xu@yahoo.ca>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Causes error: drivers/crypto/ux500/cryp/Makefile:5: *** missing
separator.  Stop.

Fixes: af873fcecef5 ("treewide: Replace GPLv2 boilerplate/reference with
SPDX - rule 194")

Signed-off-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
---
 drivers/crypto/ux500/cryp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ux500/cryp/Makefile b/drivers/crypto/ux500/cryp/Makefile
index a90b50597e5c..3e67531f484c 100644
--- a/drivers/crypto/ux500/cryp/Makefile
+++ b/drivers/crypto/ux500/cryp/Makefile
@@ -2,7 +2,7 @@
 #/*
 # * Copyright (C) ST-Ericsson SA 2010
 # * Author: shujuan.chen@stericsson.com for ST-Ericsson.
- */
+# */
 
 ccflags-$(CONFIG_CRYPTO_DEV_UX500_DEBUG) += -DDEBUG
 
-- 
2.21.0

