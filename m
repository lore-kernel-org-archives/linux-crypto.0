Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A00C678D5
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Mar 2023 16:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCGQVv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Mar 2023 11:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjCGQVA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2023 11:21:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29898303DA;
        Tue,  7 Mar 2023 08:20:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B680261460;
        Tue,  7 Mar 2023 16:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC1BC433D2;
        Tue,  7 Mar 2023 16:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678206054;
        bh=5hhKsNoDQIsh54m9/QrCUyGCfOvHbzc2kQt6KXDZb+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMqgPDMJQNOHZaXRQn3AUL3l8+2rw7e11Zrrx5KQ8j+MP+AzCAs68wYZZFJpcbXlh
         pgA3LmKN2/Eq2Tq/w3QiX+Xjug8cBPyUY2j+sDQi9IlALhuxaFpSKUfAUSvPDW1tWy
         8QFFCSWkq/Yd4RWSfCQQa/zE52py4gusFqliyrjP+c+QzatLLo9L36q48vZf8RUvc/
         2BIzIdLHo63ceWFFHPgJ9S5s7nAsQxYBp8T9QjD2rJnTBGAi0WxkLncOJnHIxkJ7F1
         s1pdiUVx3DbCz8y3rnS47r++3Luc2fufCFanDdl0Rx3DzOF2OuL8Id4WSv6TCqkFSO
         vmtWuVqTgNHeA==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kai Ye <yekai13@huawei.com>,
        Longfang Liu <liulongfang@huawei.com>
Subject: [PATCH 5/6] crypto: hisilicon/sec - remove unnecessary aer.h include
Date:   Tue,  7 Mar 2023 10:19:46 -0600
Message-Id: <20230307161947.857491-6-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230307161947.857491-1-helgaas@kernel.org>
References: <20230307161947.857491-1-helgaas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

<linux/aer.h> is unused, so remove it.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kai Ye <yekai13@huawei.com>
Cc: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 93572c0d4faa..77f9f131b850 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -2,7 +2,6 @@
 /* Copyright (c) 2019 HiSilicon Limited. */
 
 #include <linux/acpi.h>
-#include <linux/aer.h>
 #include <linux/bitops.h>
 #include <linux/debugfs.h>
 #include <linux/init.h>
-- 
2.25.1

