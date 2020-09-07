Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E75C43461
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 08:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD94D208C7
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 08:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgIGIYe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 04:24:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37764 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726997AbgIGIYc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 04:24:32 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A93C9ACA92DB2CE89C2A;
        Mon,  7 Sep 2020 16:24:29 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Sep 2020 16:24:23 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v2 00/10] crypto: hisilicon/zip - misc clean up
Date:   Mon, 7 Sep 2020 16:21:52 +0800
Message-ID: <1599466922-10323-1-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset make some clean up:
patch 1:remove useless parameters
patch 4:replace 'sprintf' with 'scnprintf'
patch 7:fix static check warning
and the rest patch fix some coding style

v2:
- remove the return check of 'scnprintf' in PATCH 4

Shukun Tan (1):
  crypto: hisilicon/zip - modify debugfs interface parameters

Yang Shen (9):
  crypto: hisilicon/zip - remove some useless parameters
  crypto: hisilicon/zip - unify naming style for functions and macros
  crypto: hisilicon/zip - replace 'sprintf' with 'scnprintf'
  crypto: hisilicon/zip - use a enum parameter instead of some macros
  crypto: hisilicon/zip - add print for error branch
  crypto: hisilicon/zip - fix static check warning
  crypto: hisilicon/zip - move some private macros from 'zip.h' to
    'zip_crypto.c'
  crypto: hisilicon/zip - supplement some comments
  crypto: hisilicon/zip - fix some coding styles

 drivers/crypto/hisilicon/zip/zip.h        |  15 ----
 drivers/crypto/hisilicon/zip/zip_crypto.c | 112 ++++++++++++++++++--------
 drivers/crypto/hisilicon/zip/zip_main.c   | 126 ++++++++++++++----------------
 3 files changed, 135 insertions(+), 118 deletions(-)

--
2.7.4

