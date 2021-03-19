Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE22C433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 10:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E381D64F10
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 10:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhCSKrY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Mar 2021 06:47:24 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:14383 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbhCSKqu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Mar 2021 06:46:50 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F20s152Rbz91Cv;
        Fri, 19 Mar 2021 18:44:53 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Fri, 19 Mar 2021 18:46:42 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] crypto: hisilicon/hpre - remove 'CONFIG_CRYPTO_DH'
Date:   Fri, 19 Mar 2021 18:44:17 +0800
Message-ID: <1616150659-10756-1-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove 'CONFIG_CRYPTO_DH' and optimise 'hpre_algs_register' error path.

Hui Tang (2):
  crypto: hisilicon/hpre - delete wrap of 'CONFIG_CRYPTO_DH'
  crypto: hisilicon/hpre - optimise 'hpre_algs_register' error path

 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 30 ++++++++++-------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

--
2.8.1

