Return-Path: <SRS0=m/1o=EG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1CEC4741F
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9CF32076D
	for <linux-crypto@archiver.kernel.org>; Sat, 31 Oct 2020 09:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgJaJJK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 31 Oct 2020 05:09:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7018 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgJaJIr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 31 Oct 2020 05:08:47 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CNYJ95KZFzhcfL;
        Sat, 31 Oct 2020 17:08:41 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Sat, 31 Oct 2020 17:08:33 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 0/8] crypto: hisilicon/qm - misc clean up
Date:   Sat, 31 Oct 2020 17:07:00 +0800
Message-ID: <1604135228-18410-1-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset makes some clean up, please see comments in each patch.

Weili Qian (8):
  crypto: hisilicon/qm - numbers are replaced by macros
  crypto: hisilicon/qm - modify the return type of function
  crypto: hisilicon/qm - modify the return type of debugfs interface
  crypto: hisilicon/qm - modify return type of 'qm_set_sqctype'
  crypto: hisilicon/qm - replace 'sprintf' with 'scnprintf'
  crypto: hisilicon/qm - split 'qm_qp_ctx_cfg' into smaller pieces
  crypto: hisilicon/qm - split 'qm_eq_ctx_cfg' into smaller pieces
  crypto: hisilicon/qm - split 'hisi_qm_init' into smaller pieces

 drivers/crypto/hisilicon/hpre/hpre_main.c |   4 +-
 drivers/crypto/hisilicon/qm.c             | 207 +++++++++++++++++++-----------
 drivers/crypto/hisilicon/qm.h             |   2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c  |   4 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |   4 +-
 5 files changed, 134 insertions(+), 87 deletions(-)

-- 
2.8.1

