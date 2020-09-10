Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA766C433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB996208FE
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 12:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgIJMR7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Sep 2020 08:17:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11783 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730067AbgIJMQ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Sep 2020 08:16:57 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BDD51C605CCF5055E20D;
        Thu, 10 Sep 2020 19:26:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 10 Sep 2020 19:26:39 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] crypto: hisilicon/hpre - misc clean up and fixes
Date:   Thu, 10 Sep 2020 19:25:19 +0800
Message-ID: <1599737122-20734-1-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Adjust some tiny coding problems and fix a bug of DH algorithm.

Meng Yu (3):
  crypto: hisilicon/hpre - delete an useless member
  crypto: hisilicon/hpre - adjust some coding style
  crypto: hisilicon/hpre - fix a bug in dh algorithm

 drivers/crypto/hisilicon/hpre/hpre.h        |  1 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 15 +++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

-- 
2.8.1

