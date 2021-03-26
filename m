Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFD86C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 01:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A566C61A32
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 01:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhCZBXc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Mar 2021 21:23:32 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14878 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhCZBX0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Mar 2021 21:23:26 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F641b1vGcz9tBs;
        Fri, 26 Mar 2021 09:21:23 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.498.0; Fri, 26 Mar 2021
 09:23:15 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 0/3] crypto: replace memset by memzero_explicit
Date:   Fri, 26 Mar 2021 09:20:45 +0800
Message-ID: <1616721648-56258-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

 use memzero_explicit instead of memset to clear sensitive data,
 such as buffer or key.

Kai Ye (3):
  crypto: atmel - use memzero_explicit() for clearing data
  crypto: qce - use memzero_explicit() for clearing data
  crypto: stm32 - use memzero_explicit() for clearing data

 drivers/crypto/atmel-sha.c        | 2 +-
 drivers/crypto/qce/sha.c          | 1 +
 drivers/crypto/stm32/stm32-cryp.c | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.8.1

