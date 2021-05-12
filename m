Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF89C433ED
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 06:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE0861942
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 06:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhELGbb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 02:31:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2787 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhELGb2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 02:31:28 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fg4ZS3WLzzmgKp;
        Wed, 12 May 2021 14:26:56 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 14:30:08 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/8] crypto: hisilicon/hpre - fix coding style
Date:   Wed, 12 May 2021 14:27:03 +0800
Message-ID: <1620800831-53346-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset fix coding style, as follows:

Hui Tang (8):
  crypto: hisilicon/hpre - the macro 'HPRE_ADDR' expands
  crypto: hisilicon/hpre - init a structure member each line
  crypto: hisilicon/hpre - replace macro with inline function
  crypto: hisilicon/hpre - remove the macro of 'HPRE_DEV'
  crypto: hisilicon/hpre - delete rudundant initialization
  crypto: hisilicon/hpre - use 'GENMASK' to generate mask value
  crypto: hisilicon/hpre - delete rudundant macro definition
  crypto: hisilicon/hpre - add 'default' for switch statement

v1 -> v2: fix build warnings reported by kernel test robot.

 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  67 ++++++------
 drivers/crypto/hisilicon/hpre/hpre_main.c   | 157 +++++++++++++++++-----------
 2 files changed, 128 insertions(+), 96 deletions(-)

--
2.8.1

