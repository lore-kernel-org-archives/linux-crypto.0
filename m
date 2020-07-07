Return-Path: <SRS0=MSze=AS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4CDC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 01:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8585B20708
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jul 2020 01:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgGGBQU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jul 2020 21:16:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7259 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725892AbgGGBQU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jul 2020 21:16:20 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9AF82321442BA7CBA335
        for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2020 09:16:16 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Tue, 7 Jul 2020
 09:16:15 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH v2 0/5] crypto: hisilicon/sec2 - fix SEC bugs and coding styles
Date:   Tue, 7 Jul 2020 09:15:36 +0800
Message-ID: <1594084541-22177-1-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix some SEC driver bugs and modify some coding styles

Changes v1 -> v2:
	- Apply MAY_BACKLOG.

Kai Ye (2):
  crypto: hisilicon/sec2 - clear SEC debug regs
  crypto:hisilicon/sec2 - update busy processing logic

Longfang Liu (3):
  crypto: hisilicon/sec2 - update SEC initialization and reset
  crypto: hisilicon/sec2 - update debugfs interface parameters
  crypto: hisilicon/sec2 - fix some coding styles

 drivers/crypto/hisilicon/qm.h              |   1 +
 drivers/crypto/hisilicon/sec2/sec.h        |   4 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  91 +++++++++++++++------
 drivers/crypto/hisilicon/sec2/sec_main.c   | 126 +++++++++++++++--------------
 4 files changed, 138 insertions(+), 84 deletions(-)

-- 
2.8.1

