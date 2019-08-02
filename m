Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4493C32750
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 08:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E0142087C
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 08:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403984AbfHBIQ5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 04:16:57 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53762 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403917AbfHBIQ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 04:16:57 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8BA3F2BD5A830FA16EA4;
        Fri,  2 Aug 2019 16:16:55 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Fri, 2 Aug 2019 16:16:45 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v3 7/7] MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver
Date:   Fri, 2 Aug 2019 15:57:56 +0800
Message-ID: <1564732676-35987-8-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
References: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add Zhou Wang as a maintainer for HiSilicon QM and ZIP controller driver.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 783569e..667aac4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7307,6 +7307,17 @@ S:	Supported
 F:	drivers/scsi/hisi_sas/
 F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
 
+HISILICON QM AND ZIP Controller DRIVER
+M:	Zhou Wang <wangzhou1@hisilicon.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/hisilicon/qm.c
+F:	drivers/crypto/hisilicon/qm.h
+F:	drivers/crypto/hisilicon/sgl.c
+F:	drivers/crypto/hisilicon/sgl.h
+F:	drivers/crypto/hisilicon/zip/
+F:	Documentation/ABI/testing/debugfs-hisi-zip
+
 HMM - Heterogeneous Memory Management
 M:	Jérôme Glisse <jglisse@redhat.com>
 L:	linux-mm@kvack.org
-- 
2.8.1

