Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51219C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 03:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DB7264EBA
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 03:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhCADyG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Feb 2021 22:54:06 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13012 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhCADyF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Feb 2021 22:54:05 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DpmXc2CYFzjTZ1;
        Mon,  1 Mar 2021 11:51:44 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 1 Mar 2021 11:53:22 +0800
From:   Tian Tao <tiantao6@hisilicon.com>
To:     <gcherian@marvell.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: cavium - remove unused including <linux/version.h>
Date:   Mon, 1 Mar 2021 11:54:12 +0800
Message-ID: <1614570852-40648-1-git-send-email-tiantao6@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove including <linux/version.h> that don't need it.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 711b1ac..06ee42e 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -10,7 +10,6 @@
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/printk.h>
-#include <linux/version.h>
 
 #include "cptpf.h"
 
-- 
2.7.4

