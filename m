Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A7C5C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Mar 2021 09:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB095619BB
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Mar 2021 09:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhCaJdV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Mar 2021 05:33:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15055 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbhCaJdL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Mar 2021 05:33:11 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F9Ldf5q1fzNrKC;
        Wed, 31 Mar 2021 17:30:30 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Wed, 31 Mar 2021
 17:33:01 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 0/5] bug fix and clear coding style
Date:   Wed, 31 Mar 2021 17:30:27 +0800
Message-ID: <1617183032-30983-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fixup coding style such as delete unneeded variable
initialization. Add a comment for block size initialization.
Add  data cleared operation in sg buf unmap, and other misc fix.

v1 -> v2:
 1. fix [PATCH v2] error in v1.
 2. v1 use a macro replace of magic number, v2 use a comment 
    for block size initialization.

Kai Ye (5):
  crypto: hisilicon/sgl - add a comment for block size initialization
  crypto: hisilicon/sgl - delete unneeded variable initialization
  crypto: hisilicon/sgl - add some dfx logs
  crypto: hisilicon/sgl - fix the soft sg map to hardware sg
  crypto: hisilicon/sgl - fix the sg buf unmap

 drivers/crypto/hisilicon/sgl.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

-- 
2.8.1

