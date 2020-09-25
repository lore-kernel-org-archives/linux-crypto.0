Return-Path: <SRS0=J/bj=DC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95326C4727D
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 14:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67751208A9
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Sep 2020 14:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgIYOJL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Sep 2020 10:09:11 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:47124 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728963AbgIYOJB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Sep 2020 10:09:01 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4865998FC9D03104DFCE;
        Fri, 25 Sep 2020 22:08:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 25 Sep 2020 22:08:49 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH RESEND 0/4] crypto: hisilicon/zip - misc clean up
Date:   Fri, 25 Sep 2020 22:06:13 +0800
Message-ID: <1601042777-26150-1-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset fix some bug:
patch 1:clear the debug registers when remove driver
patch 2:intercept invalid input when using decompress
patch 3:replace the return value '-EBUSY' with '-EAGAIN' when
    device is busy
patch 4:initialize the 'curr_qm_qp_num' when probe device

Resend this patch series because it depends on
https://patchwork.kernel.org/cover/11760159/
(crypto: hisilicon/zip - misc clean up).
Now the patch series has been applied.

Hao Fang (1):
  crypto: hisilicon/zip - fix the uncleared debug registers

Sihang Chen (1):
  crypto: hisilicon/zip - fix the uninitalized 'curr_qm_qp_num'

Yang Shen (1):
  crypto: hisilicon/zip - fix the return value when device is busy

Zhou Wang (1):
  crypto: hisilicon/zip - fix zero length input in GZIP decompress

 drivers/crypto/hisilicon/zip/zip_crypto.c | 26 +++++++++++++++++++-------
 drivers/crypto/hisilicon/zip/zip_main.c   | 19 +++++++++++++++++++
 2 files changed, 38 insertions(+), 7 deletions(-)

--
2.7.4

