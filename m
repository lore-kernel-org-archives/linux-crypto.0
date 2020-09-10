Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C5EC43461
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 21:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8916720756
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 21:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgIJVmf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Sep 2020 17:42:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11769 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730127AbgIJL6D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Sep 2020 07:58:03 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C54A9C3594118A33E39B
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2020 19:57:53 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 19:57:49 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH 0/5] crypto: hisilicon - update ACC module parameter
Date:   Thu, 10 Sep 2020 19:56:38 +0800
Message-ID: <1599739003-23448-1-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to pass kernel crypto test, the ACC module parameter
pf_q_num needs to be set to an integer greater than 1,
and then fixed two bugs.

Longfang Liu (5):
  crypto: hisilicon - update mininum queue
  crypto: hisilicon - update HPRE module parameter description
  crypto: hisilicon - update SEC module parameter description
  crypto: hisilicon - update ZIP module parameter description
  crypto: hisilicon - fixed memory allocation error

 drivers/crypto/hisilicon/hpre/hpre_main.c  |  2 +-
 drivers/crypto/hisilicon/qm.h              |  4 ++--
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 16 ++++++++++++----
 drivers/crypto/hisilicon/sec2/sec_main.c   |  2 +-
 drivers/crypto/hisilicon/zip/zip_main.c    |  2 +-
 5 files changed, 17 insertions(+), 9 deletions(-)

-- 
2.8.1

