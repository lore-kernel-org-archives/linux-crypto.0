Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2930FC433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 06:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1119227C3
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jan 2021 06:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbhAEGTs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jan 2021 01:19:48 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9669 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbhAEGTs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jan 2021 01:19:48 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D92Nd2YL1z15pCc;
        Tue,  5 Jan 2021 14:17:53 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.498.0; Tue, 5 Jan 2021
 14:18:42 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] crypto: hisilicon - register device to uacce
Date:   Tue, 5 Jan 2021 14:16:41 +0800
Message-ID: <1609827404-6024-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Add parameter of UACCE mode selection for ZIP.
2. Register SEC and HPRE devices to UACCE framework for user space drivers.

Kai Ye (3):
  crypto: hisilicon - add ZIP device using mode parameter
  crypto: hisilicon/hpre - register HPRE device to uacce
  crypto: hisilicon/sec - register SEC device to uacce

 drivers/crypto/hisilicon/hpre/hpre_main.c | 54 +++++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.c             |  2 +-
 drivers/crypto/hisilicon/qm.h             | 27 ++++++++++++++++
 drivers/crypto/hisilicon/sec2/sec_main.c  | 39 +++++++++++++++++++++-
 drivers/crypto/hisilicon/zip/zip_main.c   | 14 ++++++++
 5 files changed, 134 insertions(+), 2 deletions(-)

-- 
2.8.1

