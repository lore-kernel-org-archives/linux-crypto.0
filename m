Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFBE6C33CA2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 07:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 846E02073A
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 07:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgAJHxy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 02:53:54 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:42440 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726276AbgAJHxx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 02:53:53 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 00BC0B2721FF11724E91;
        Fri, 10 Jan 2020 15:53:52 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Fri, 10 Jan 2020 15:53:42 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <zhangwei375@huawei.com>, <fanghao11@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH 0/9] crypto: hisilicon-SEC V2 AEAD added with some bugfixed
Date:   Fri, 10 Jan 2020 15:49:49 +0800
Message-ID: <1578642598-8584-1-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add AEAD algorithms supporting, and some bugfixed with
some updating on internal funcions to support more algorithms.

This series is based on:
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git

Zaibo Xu (9):
  crypto: hisilicon - fix debugfs usage of SEC V2
  crypto: hisilicon - fix print/comment of SEC V2
  crypto: hisilicon - Update some names on SEC V2
  crypto: hisilicon - Update QP resources of SEC V2
  crypto: hisilicon - Adjust some inner logic
  crypto: hisilicon - Add callback error check
  crypto: hisilicon - Add branch prediction macro
  crypto: hisilicon - redefine skcipher initiation
  crypto: hisilicon - Add aead support on SEC2

 drivers/crypto/hisilicon/Kconfig           |   8 +-
 drivers/crypto/hisilicon/sec2/sec.h        |  53 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 963 +++++++++++++++++++++++------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  22 +-
 drivers/crypto/hisilicon/sec2/sec_main.c   |  19 +-
 5 files changed, 838 insertions(+), 227 deletions(-)

-- 
2.8.1

