Return-Path: <SRS0=OEQJ=RW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7588FC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 13:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4902D2085A
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Mar 2019 13:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfCSNoW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Mar 2019 09:44:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54072 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfCSNoW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Mar 2019 09:44:22 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 48390F94433ADEB429A1;
        Tue, 19 Mar 2019 21:44:15 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.408.0; Tue, 19 Mar 2019
 21:44:08 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <george.cherian@cavium.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: cavium - Make some functions static
Date:   Tue, 19 Mar 2019 21:43:48 +0800
Message-ID: <20190319134348.19648-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warnings:

drivers/crypto/cavium/cpt/cptvf_reqmanager.c:226:5: warning: symbol 'send_cpt_command' was not declared. Should it be static?
drivers/crypto/cavium/cpt/cptvf_reqmanager.c:273:6: warning: symbol 'do_request_cleanup' was not declared. Should it be static?
drivers/crypto/cavium/cpt/cptvf_reqmanager.c:319:6: warning: symbol 'do_post_process' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/cavium/cpt/cptvf_reqmanager.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
index ca549c5..f16f615 100644
--- a/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
+++ b/drivers/crypto/cavium/cpt/cptvf_reqmanager.c
@@ -223,7 +223,7 @@ static inline int setup_sgio_list(struct cpt_vf *cptvf,
 	return ret;
 }
 
-int send_cpt_command(struct cpt_vf *cptvf, union cpt_inst_s *cmd,
+static int send_cpt_command(struct cpt_vf *cptvf, union cpt_inst_s *cmd,
 		     u32 qno)
 {
 	struct pci_dev *pdev = cptvf->pdev;
@@ -270,7 +270,7 @@ int send_cpt_command(struct cpt_vf *cptvf, union cpt_inst_s *cmd,
 	return ret;
 }
 
-void do_request_cleanup(struct cpt_vf *cptvf,
+static void do_request_cleanup(struct cpt_vf *cptvf,
 			struct cpt_info_buffer *info)
 {
 	int i;
@@ -316,7 +316,7 @@ void do_request_cleanup(struct cpt_vf *cptvf,
 	kzfree(info);
 }
 
-void do_post_process(struct cpt_vf *cptvf, struct cpt_info_buffer *info)
+static void do_post_process(struct cpt_vf *cptvf, struct cpt_info_buffer *info)
 {
 	struct pci_dev *pdev = cptvf->pdev;
 
-- 
2.7.4


