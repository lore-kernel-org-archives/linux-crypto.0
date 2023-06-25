Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F7B7EB64DD
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Jun 2023 01:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjFYBu4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 21:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjFYBuz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 21:50:55 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BA610D1
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 18:50:54 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QpYpS68Mxz1HBZc;
        Sun, 25 Jun 2023 09:50:40 +0800 (CST)
Received: from huawei.com (10.67.175.31) by dggpemm500024.china.huawei.com
 (7.185.36.203) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Sun, 25 Jun
 2023 09:50:52 +0800
From:   GUO Zihua <guozihua@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH RFC v3 1/3] MPI: Export mpi_add_ui and mpi_mod for SM9
Date:   Sun, 25 Jun 2023 09:49:56 +0800
Message-ID: <20230625014958.32631-2-guozihua@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230625014958.32631-1-guozihua@huawei.com>
References: <20230625014958.32631-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.31]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SM9 which could be built as a module would be using mpi_add_ui and mpi_mod.
So export them.

Signed-off-by: GUO Zihua <guozihua@huawei.com>
---
 lib/mpi/mpi-add.c | 2 +-
 lib/mpi/mpi-mod.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/mpi/mpi-add.c b/lib/mpi/mpi-add.c
index 9056fc5167fc..d34c6c1c6fab 100644
--- a/lib/mpi/mpi-add.c
+++ b/lib/mpi/mpi-add.c
@@ -62,7 +62,7 @@ void mpi_add_ui(MPI w, MPI u, unsigned long v)
 	w->nlimbs = wsize;
 	w->sign   = wsign;
 }
-
+EXPORT_SYMBOL_GPL(mpi_add_ui);
 
 void mpi_add(MPI w, MPI u, MPI v)
 {
diff --git a/lib/mpi/mpi-mod.c b/lib/mpi/mpi-mod.c
index 54fcc01564d9..8136f4aff287 100644
--- a/lib/mpi/mpi-mod.c
+++ b/lib/mpi/mpi-mod.c
@@ -26,6 +26,7 @@ void mpi_mod(MPI rem, MPI dividend, MPI divisor)
 {
 	mpi_fdiv_r(rem, dividend, divisor);
 }
+EXPORT_SYMBOL_GPL(mpi_mod);
 
 /* This function returns a new context for Barrett based operations on
  * the modulus M.  This context needs to be released using
-- 
2.17.1

