Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D5BBC18E5A
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 08:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE59C2467F
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 08:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCJInf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 04:43:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11198 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726613AbgCJIne (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 04:43:34 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2B7A45BB7320238C421E;
        Tue, 10 Mar 2020 16:43:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 10 Mar 2020 16:43:21 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <wangzhou1@hisilicon.com>,
        <xuzaibo@huawei.com>
Subject: [PATCH v2 0/4] crypto: hisilicon - Refactor find device related code 
Date:   Tue, 10 Mar 2020 16:42:48 +0800
Message-ID: <1583829772-53372-1-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

By binding device finding with create QP logic to fix the bug of creating
QP failure occasionally. Then, merge the find device related code into
qm.c to reduce redundancy.

This series depends upon this patchset:
https://lore.kernel.org/linux-crypto/1583373985-718-1-git-send-email-xuzaibo@huawei.com/

Changes v1 -> v2:
	- Fix bug of compile when disable NUMA config.

Hui Tang (1):
  crypto: hisilicon/hpre - Optimize finding hpre device process

Kai Ye (1):
  crypto: hisilicon/sec2 - Add new create qp process

Shukun Tan (1):
  crypto: hisilicon/zip - Use hisi_qm_alloc_qps_node() when init ctx

Weili Qian (1):
  crypto: hisilicon/qm - Put device finding logic into QM

 drivers/crypto/hisilicon/hpre/hpre.h        |   3 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  20 ++---
 drivers/crypto/hisilicon/hpre/hpre_main.c   |  52 +++---------
 drivers/crypto/hisilicon/qm.c               | 125 ++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h               |  31 +++++++
 drivers/crypto/hisilicon/sec2/sec.h         |   5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |  17 ++--
 drivers/crypto/hisilicon/sec2/sec_main.c    |  81 +++++++-----------
 drivers/crypto/hisilicon/zip/zip.h          |   2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  54 ++++++------
 drivers/crypto/hisilicon/zip/zip_main.c     |  92 ++------------------
 11 files changed, 252 insertions(+), 230 deletions(-)

-- 
2.7.4

