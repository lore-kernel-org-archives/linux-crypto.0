Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB22DC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Mar 2022 02:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbiCIC7F (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Mar 2022 21:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiCIC7E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Mar 2022 21:59:04 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F24127D44;
        Tue,  8 Mar 2022 18:58:06 -0800 (PST)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KCxZz6tFZz1GBxv;
        Wed,  9 Mar 2022 10:53:15 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (7.193.23.191) by
 kwepemi500008.china.huawei.com (7.221.188.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 10:58:04 +0800
Received: from huawei.com (10.67.165.24) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 9 Mar
 2022 10:58:03 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alex.williamson@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>, <liulongfang@huawei.com>
Subject: [PATCH] MAINTAINERS: update HPRE/SEC2/TRNG driver maintainers list
Date:   Wed, 9 Mar 2022 10:52:44 +0800
Message-ID: <20220309025244.25838-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Zaibo moved projects and is not looking into crypto stuff.
I am responsible for checking the patches of these modules.
so the maintainers list needs to be updated.

I take care of HPRE, Qian Weili take care of TRNG,
Ye Kai and me take care of SEC2.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Kai Ye <yekai12@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6ee244105f5f..e4400d4346bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8635,7 +8635,7 @@ S:	Maintained
 F:	drivers/gpio/gpio-hisi.c
 
 HISILICON HIGH PERFORMANCE RSA ENGINE DRIVER (HPRE)
-M:	Zaibo Xu <xuzaibo@huawei.com>
+M:	Longfang Liu <liulongfang@huawei.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	Documentation/ABI/testing/debugfs-hisi-hpre
@@ -8715,8 +8715,8 @@ F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
 F:	drivers/scsi/hisi_sas/
 
 HISILICON SECURITY ENGINE V2 DRIVER (SEC2)
-M:	Zaibo Xu <xuzaibo@huawei.com>
 M:	Kai Ye <yekai13@huawei.com>
+M:	Longfang Liu <liulongfang@huawei.com>
 L:	linux-crypto@vger.kernel.org
 S:	Maintained
 F:	Documentation/ABI/testing/debugfs-hisi-sec
@@ -8747,7 +8747,7 @@ F:	Documentation/devicetree/bindings/mfd/hisilicon,hi6421-spmi-pmic.yaml
 F:	drivers/mfd/hi6421-spmi-pmic.c
 
 HISILICON TRUE RANDOM NUMBER GENERATOR V2 SUPPORT
-M:	Zaibo Xu <xuzaibo@huawei.com>
+M:	Weili Qian <qianweili@huawei.com>
 S:	Maintained
 F:	drivers/crypto/hisilicon/trng/trng.c
 
-- 
2.33.0

