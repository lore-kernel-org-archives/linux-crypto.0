Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53DBC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 08:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F94D20721
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 08:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390442AbgDCIRj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 04:17:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36234 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390296AbgDCIRj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 04:17:39 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BBAE78F12C36645211D3;
        Fri,  3 Apr 2020 16:17:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Fri, 3 Apr 2020 16:17:25 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, Shukun Tan <tanshukun1@huawei.com>
Subject: [PATCH 0/5] crypto: hisilicon - add controller reset support
Date:   Fri, 3 Apr 2020 16:16:37 +0800
Message-ID: <1585901802-48945-1-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support controller reset for ZIP/HPRE/SEC drivers, put the main
implementation into QM. Meanwhile modified the logic of the queue
stop judgment.

This series depends upon:
https://patchwork.kernel.org/cover/11470171/ 

Hui Tang (1):
  crypto: hisilicon/hpre - add controller reset support for HPRE

Shukun Tan (2):
  crypto: hisilicon/qm - add controller reset interface
  crypto: hisilicon/zip - add controller reset support for zip

Yang Shen (2):
  crypto: hisilicon/sec2 - add controller reset support for SEC2
  crypto: hisilicon/qm - stop qp by judging sq and cq tail

 drivers/crypto/hisilicon/hpre/hpre_main.c |  46 ++-
 drivers/crypto/hisilicon/qm.c             | 667 +++++++++++++++++++++++++++++-
 drivers/crypto/hisilicon/qm.h             |  16 +
 drivers/crypto/hisilicon/sec2/sec_main.c  |  40 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |  57 ++-
 5 files changed, 790 insertions(+), 36 deletions(-)

-- 
2.7.4

