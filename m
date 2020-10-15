Return-Path: <SRS0=zNo2=DW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C1DC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Oct 2020 02:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4451620691
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Oct 2020 02:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgJOCY0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Oct 2020 22:24:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15290 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726575AbgJOCY0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Oct 2020 22:24:26 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 11DD9A0BB286B6F65952
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2020 10:24:25 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Thu, 15 Oct 2020
 10:24:20 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH 0/2] crypto: hisilicon - misc fixes
Date:   Thu, 15 Oct 2020 10:23:02 +0800
Message-ID: <1602728584-47722-1-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset fixes some coding style.

Longfang Liu (2):
  crypto: hisilicon - delete unused structure member variables
  crypto: hisilicon - fixes some coding style

 drivers/crypto/hisilicon/sec2/sec.h        |  2 --
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 17 ++++++-----------
 drivers/crypto/hisilicon/sec2/sec_main.c   | 30 ++++++++++++------------------
 3 files changed, 18 insertions(+), 31 deletions(-)

-- 
2.8.1

