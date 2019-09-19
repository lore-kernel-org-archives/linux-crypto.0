Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA69C4CEC4
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 14:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FF6A208C0
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 14:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388656AbfISOHR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:07:17 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:42117 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387729AbfISOHQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 10:07:16 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MORIm-1iZmOB2Z3e-00PuQo; Thu, 19 Sep 2019 16:06:53 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [v2] crypto: hisilicon - avoid unused function warning
Date:   Thu, 19 Sep 2019 16:05:52 +0200
Message-Id: <20190919140650.1289963-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ZwJdmyrwyvAI76lZVS7F1Q8hQNWt/yXcQvcpDiKbJDFJbDM1PnS
 SCGltrDG4/QulNus1EXaz8kBZEpEXCtB/frd0rciuFNCTO+cYNMAVjrPCi28ANd2PY7Fe1X
 mrNE0r9FQQKm8SiQPru/4aPaWmLIi7nqLg6p1e4IHPRuWHA5TTFJ+CVXZrkq9+XWmCSvmac
 0k0J8et2IJZT/RVHuUh1A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:AyJRZaop9Qw=:JWNvO9GCfOBjZv2Q7mViev
 bp0qwy3iPUvTA+bEAXvfHqIFUOhkyk3yd01jpqubGOzLzGZh9jtJa/kMjpisnGrQyBaKBOwQQ
 NfvzbxBRpoB33nXZxA1jnKmkPMpxvEJpjWOFr56tp2z8TUQI7KX42wiqLcX28gssl8u3s+PJy
 kBBx2LXL6kTT9Zxhg3eqg88VXYWPnN51k+jHHeLu4MFz6zbJJMEE6+40fwA0CowRW1TmaQCoi
 WA9e8++HhDftI4+uEel42ouL6ZtBgX2EAERrk627wJiLXrye0THl2lCWOxYNHyoZu+lIisajA
 Pe9li7AS35xA8zSwJmvFBX0PD+VN8VKfMWyPxglV834ktXL4Yhdmt8c5cxZB/Q5H61L+aLgsl
 XJZUyWO5EOuZrzz9u8S5V7QR5uz1bhBafL6fKmlwPfIiSDNkjLCKA9mfXngr8qUggIp235+6n
 1DkM/7QNxNHd1qt78yeCq5/zUJkG+XNRHhHwecXvEzvmZKrvR5HSdLeDWdalK7edXxgs2hBtm
 DJn7SWVGrkpIV7jOIAcCjftXcJULc6Gc28qQe+9GuC2xOWNl4sWLkftBVP8BuAEFx2rxleujp
 ED1fiYdZP0GLnYjZ128Je1y2RBhgbY5f81PqTpLqLg/JcbYMfejIErIOWghJhhTq9jeYYUggI
 hx62hXGvs8LdNFVaRAKQbDIXoH5vJDiZ5+FhgAvk7XO2d3MiGTe1pkB8T+xc3TpfkGdgfKwJW
 OU3HQ9Q89XVo1BiyHszCTpvUGYttRbWO4S7FweB3SGLYTEFPEzh2yQSjqZmHfCmDVIM/Krspb
 th2eOzGKRS9MwIUWcdVdRBbG5G5nHRY4MPFf04IO5O0Sgt5+WWiCwWdg1tYC5Csg7eY+ISUMP
 gswxLundN5wmNmm4jHiA==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The only caller of hisi_zip_vf_q_assign() is hidden in an #ifdef,
so the function causes a warning when CONFIG_PCI_IOV is disabled:

drivers/crypto/hisilicon/zip/zip_main.c:740:12: error: unused function 'hisi_zip_vf_q_assign' [-Werror,-Wunused-function]

Replace the #ifdef with an IS_ENABLED() check that leads to the
function being dropped based on the configuration.

Fixes: 79e09f30eeba ("crypto: hisilicon - add SRIOV support for ZIP")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 6e0ca75585d4..1b2ee96c888d 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -785,7 +785,6 @@ static int hisi_zip_clear_vft_config(struct hisi_zip *hisi_zip)
 
 static int hisi_zip_sriov_enable(struct pci_dev *pdev, int max_vfs)
 {
-#ifdef CONFIG_PCI_IOV
 	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
 	int pre_existing_vfs, num_vfs, ret;
 
@@ -815,9 +814,6 @@ static int hisi_zip_sriov_enable(struct pci_dev *pdev, int max_vfs)
 	}
 
 	return num_vfs;
-#else
-	return 0;
-#endif
 }
 
 static int hisi_zip_sriov_disable(struct pci_dev *pdev)
@@ -948,7 +944,8 @@ static struct pci_driver hisi_zip_pci_driver = {
 	.id_table		= hisi_zip_dev_ids,
 	.probe			= hisi_zip_probe,
 	.remove			= hisi_zip_remove,
-	.sriov_configure	= hisi_zip_sriov_configure,
+	.sriov_configure	= IS_ENABLED(CONFIG_PCI_IOV) ?
+					hisi_zip_sriov_configure : 0,
 	.err_handler		= &hisi_zip_err_handler,
 };
 
-- 
2.20.0

