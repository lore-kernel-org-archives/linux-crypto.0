Return-Path: <SRS0=ErXm=O7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:16652 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725814AbeLVXgF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 18:36:05 -0500
From: Zhou Wang <wangzhou1@hisilicon.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH 4/4] MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver
Date: Sat, 22 Dec 2018 15:51:45 +0800
Message-ID: <1545465105-133138-5-git-send-email-wangzhou1@hisilicon.com>
In-Reply-To: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
References: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Zhou Wang as a maintainer for HiSilicon QM and ZIP controller driver.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0767f1d..5be84e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6785,6 +6785,14 @@ S:	Supported
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
