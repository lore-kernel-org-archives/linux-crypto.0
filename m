Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3DCC3A5A7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 03:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DF6C22CEA
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 03:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbfIDDEX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 23:04:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5748 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726770AbfIDDEX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 23:04:23 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 81B97BBBC75515CF42AB;
        Wed,  4 Sep 2019 11:04:21 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 11:04:13 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <arno@natisbad.org>, <joro@8bytes.org>,
        <gregkh@linuxfoundation.org>
CC:     <zhongjiang@huawei.com>, <iommu@lists.linux-foundation.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Use kzfree instead of memset() + kfree() 
Date:   Wed, 4 Sep 2019 11:01:16 +0800
Message-ID: <1567566079-7412-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

th the help of Coccinelle. We find some place to replace.

@@
expression M, S;
@@

- memset(M, 0, S);
- kfree(M);
+ kzfree(M); 

zhong jiang (3):
  crypto: marvell: Use kzfree rather than its implementation
  iommu/pamu: Use kzfree rather than its implementation
  Staging: rtl8723bs: Use kzfree rather than its implementation

 drivers/crypto/marvell/hash.c                 | 3 +--
 drivers/iommu/fsl_pamu.c                      | 6 ++----
 drivers/staging/rtl8723bs/core/rtw_security.c | 3 +--
 3 files changed, 4 insertions(+), 8 deletions(-)

-- 
1.7.12.4

