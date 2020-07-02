Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D3A5C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 02:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52ADC2082F
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 02:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgGBCcD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 22:32:03 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7339 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726759AbgGBCcC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 22:32:02 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E72F6CF4A606805838DC;
        Thu,  2 Jul 2020 10:31:58 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 10:31:51 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/6] crypto: hisilicon/hpre bugfix - misc fixes
Date:   Thu, 2 Jul 2020 10:31:13 +0800
Message-ID: <1593657079-31990-1-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Bugfix: crypto: hisilicon/hpre - modify the macros, add a switch in
	sriov_configure, unified debugfs interface, and disable
	hardware FLR.

Hui Tang (2):
  crypto: hisilicon/hpre - HPRE_OVERTIME_THRHLD can be written by
    debugfs
  crypto: hisilicon/hpre - disable FLR triggered by hardware

Meng Yu (4):
  crypto: hisilicon/hpre - Init the value of current_q of debugfs
  crypto: hisilicon/hpre - Modify the Macro definition and format
  crypto: hisilicon/hpre - Add a switch in sriov_configure
  crypto: hisilicon/hpre - update debugfs interface parameters

 drivers/crypto/hisilicon/hpre/hpre_main.c | 114 ++++++++++++++++--------------
 1 file changed, 62 insertions(+), 52 deletions(-)

-- 
2.8.1

