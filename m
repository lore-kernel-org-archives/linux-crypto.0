Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19CDCCA9ECE
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 08:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDB932086D
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 08:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfJaIiS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 04:38:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41382 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbfJaIiS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 04:38:18 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BB25CA13BD9FC27C6540;
        Thu, 31 Oct 2019 16:38:14 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 16:38:03 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <mpm@selenic.com>
CC:     <linux-crypto@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>,
        <wangkefeng.wang@huawei.com>, <qianweili@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH 0/2] hw_random: hisilicon - add HiSilicon TRNG V2 support
Date:   Thu, 31 Oct 2019 16:34:28 +0800
Message-ID: <1572510870-40390-1-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds HiSilicon True Random Number Generator (TRNG) version 2
driver in hw_random subsystem.

Zaibo Xu (2):
  hw_random: add HiSilicon TRNG driver support
  MAINTAINERS: Add maintainer for HiSilicon TRNG V2 driver

 MAINTAINERS                           |  5 ++
 drivers/char/hw_random/Kconfig        | 13 +++++
 drivers/char/hw_random/Makefile       |  1 +
 drivers/char/hw_random/hisi-trng-v2.c | 99 +++++++++++++++++++++++++++++++++++
 4 files changed, 118 insertions(+)
 create mode 100644 drivers/char/hw_random/hisi-trng-v2.c

-- 
2.8.1

