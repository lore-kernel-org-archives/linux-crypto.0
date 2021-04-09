Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B75C433ED
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 09:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B781F611AE
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 09:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhDIJHD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Apr 2021 05:07:03 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16868 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhDIJHC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Apr 2021 05:07:02 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FGsf45KKBzlWyQ;
        Fri,  9 Apr 2021 17:05:00 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Fri, 9 Apr 2021
 17:06:37 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yekai13@huawei.com>
Subject: [PATCH v3 0/5] bug fix and clear coding style
Date:   Fri, 9 Apr 2021 17:03:59 +0800
Message-ID: <1617959044-11023-1-git-send-email-yekai13@huawei.com>
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
Add a data cleared operation in sg buf unmap, and other misc fix.

v1 -> v2:
 1. fix [PATCH v2] error in v1.
 2. v1 use a macro replace of magic number, v2 use a comment 
    for block size initialization.
v2 -> v3:
 fix a sparse warning

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

