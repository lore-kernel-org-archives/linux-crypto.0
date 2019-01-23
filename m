Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED0DC282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 13:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D33EF21848
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 13:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfAWNIn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 08:08:43 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:36364 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726104AbfAWNIn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 08:08:43 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3EE7F737A955BA830DF1;
        Wed, 23 Jan 2019 21:08:40 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.408.0; Wed, 23 Jan 2019 21:08:31 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v2 4/4] MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver
Date:   Wed, 23 Jan 2019 21:08:53 +0800
Message-ID: <1548248933-149853-5-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
References: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
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
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 51029a4..6e6be9b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6868,6 +6868,14 @@ S:	Supported
 F:	drivers/scsi/hisi_sas/
 F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
 
+HISILICON QM AND ZIP Controller DRIVER
+M:	Zhou Wang <wangzhou1@hisilicon.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/hisilicon/qm.c
+F:	drivers/crypto/hisilicon/qm.h
+F:	drivers/crypto/hisilicon/zip/
+
 HMM - Heterogeneous Memory Management
 M:	Jérôme Glisse <jglisse@redhat.com>
 L:	linux-mm@kvack.org
-- 
2.8.1

