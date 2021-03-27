Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681F7C433C1
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 07:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2789561A05
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 07:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhC0Hb4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Mar 2021 03:31:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14630 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbhC0Hba (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Mar 2021 03:31:30 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6r7n3N5pz1BFg3;
        Sat, 27 Mar 2021 15:29:25 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 15:31:19 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v2 0/4] crypto: hisilicon/zip - support new 'sqe' type in Kunpeng930
Date:   Sat, 27 Mar 2021 15:28:44 +0800
Message-ID: <1616830128-46827-1-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In Kunpeng930, some field meanings in 'sqe' are changed, so driver need to
distinguish the type on different platform.

To avoid checking the platform everytime when driver fills the 'sqe', add a
struct 'hisi_zip_sqe_ops' to describe the 'sqe' operations. The driver only
need to choose the 'ops' once when call 'hisi_zip_acomp_init'.

v1 -> v2:
* fix a sparse warning

Yang Shen (4):
  crypto: hisilicon/zip - adjust functions location
  crypto: hisilicon/zip - add comments for 'hisi_zip_sqe'
  crypto: hisilicon/zip - initialize operations about 'sqe' in
    'acomp_alg.init'
  crypto: hisilicon/zip - support new 'sqe' type in Kunpeng930

 drivers/crypto/hisilicon/zip/zip.h        |  46 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c | 706 +++++++++++++++++-------------
 2 files changed, 438 insertions(+), 314 deletions(-)

--
2.8.1

