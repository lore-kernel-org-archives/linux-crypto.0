Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1748AC433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Mar 2022 05:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbiCDF6p (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Mar 2022 00:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236265AbiCDF6p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Mar 2022 00:58:45 -0500
Received: from out199-10.us.a.mail.aliyun.com (out199-10.us.a.mail.aliyun.com [47.90.199.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A684132A;
        Thu,  3 Mar 2022 21:57:55 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V6AtyKh_1646373464;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V6AtyKh_1646373464)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Mar 2022 13:57:48 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     bbrezillon@kernel.org
Cc:     arno@natisbad.org, schalla@marvell.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] crypto: marvell/octeontx - Use swap() instead of open coding it
Date:   Fri,  4 Mar 2022 13:57:42 +0800
Message-Id: <20220304055742.89125-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clean the following coccicheck warning:

./drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:1645:16-17: WARNING
opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index ccbef01888d4..01c48ddc4eeb 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -1639,11 +1639,8 @@ static void swap_func(void *lptr, void *rptr, int size)
 {
 	struct cpt_device_desc *ldesc = (struct cpt_device_desc *) lptr;
 	struct cpt_device_desc *rdesc = (struct cpt_device_desc *) rptr;
-	struct cpt_device_desc desc;
 
-	desc = *ldesc;
-	*ldesc = *rdesc;
-	*rdesc = desc;
+	swap(*ldesc, *rdesc);
 }
 
 int otx_cpt_crypto_init(struct pci_dev *pdev, struct module *mod,
-- 
2.20.1.7.g153144c

