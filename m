Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7DACA9EB9
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 07:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5278C21479
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 07:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfJUHk3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 03:40:29 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57408 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726480AbfJUHk2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 03:40:28 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DC349153C0D17B04B565;
        Mon, 21 Oct 2019 15:40:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 21 Oct 2019 15:40:19 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <wangzhou1@hisilicon.com>, <linux-crypto@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon - fix param should be static when not external.
Date:   Mon, 21 Oct 2019 15:41:02 +0800
Message-ID: <1571643663-29593-4-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571643663-29593-1-git-send-email-tanshukun1@huawei.com>
References: <1571643663-29593-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes following sparse warning:
zip_main.c:87:1: warning: symbol 'hisi_zip_list' was not declared.
Should it be static?
zip_main.c:88:1: warning: symbol 'hisi_zip_list_lock' was not declared.
Should it be static?
zip_main.c:948:68: warning: Using plain integer as NULL pointer

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 5546edc..9f45bb5 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -84,8 +84,8 @@
 
 static const char hisi_zip_name[] = "hisi_zip";
 static struct dentry *hzip_debugfs_root;
-LIST_HEAD(hisi_zip_list);
-DEFINE_MUTEX(hisi_zip_list_lock);
+static LIST_HEAD(hisi_zip_list);
+static DEFINE_MUTEX(hisi_zip_list_lock);
 
 #ifdef CONFIG_NUMA
 static struct hisi_zip *find_zip_device_numa(int node)
@@ -944,7 +944,7 @@ static struct pci_driver hisi_zip_pci_driver = {
 	.probe			= hisi_zip_probe,
 	.remove			= hisi_zip_remove,
 	.sriov_configure	= IS_ENABLED(CONFIG_PCI_IOV) ?
-					hisi_zip_sriov_configure : 0,
+					hisi_zip_sriov_configure : NULL,
 	.err_handler		= &hisi_zip_err_handler,
 };
 
-- 
2.7.4

