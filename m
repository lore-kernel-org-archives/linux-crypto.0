Return-Path: <SRS0=zLA1=EI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DB7C5DF9D
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 02:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC9D1221FC
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 02:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgKBCdB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Nov 2020 21:33:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6718 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727445AbgKBCdB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Nov 2020 21:33:01 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CPcQc4vKtzkdKf;
        Mon,  2 Nov 2020 10:32:56 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 10:32:49 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/5] crypto: hisilicon/hpre - add something for 'Kunpeng 930'
Date:   Mon, 2 Nov 2020 10:31:00 +0800
Message-ID: <1604284265-1271-1-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Add initial settings, version and new type to adapt 'Kunpeng 930';
2. Add algorithms(ECDH and CURVE25519) in 'Kunpeng 930';

Hui Tang (1):
  crypto: hisilicon/hpre - add initial settings adapt to 'Kunpeng 930'

Meng Yu (4):
  crypto: hisilicon/hpre - add version adapt to new algorithms
  crypto: hisilicon/hpre - add algorithm type
  crypto: hisilicon/hpre - add 'ECDH' algorithm
  crypto: hisilicon/hpre - add 'CURVE25519' algorithm

 drivers/crypto/hisilicon/hpre/hpre.h        |   25 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 1187 ++++++++++++++++++++++++++-
 drivers/crypto/hisilicon/hpre/hpre_main.c   |  105 ++-
 drivers/crypto/hisilicon/qm.c               |    4 +-
 drivers/crypto/hisilicon/qm.h               |    4 +-
 drivers/crypto/hisilicon/sec2/sec.h         |    4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |    4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.h  |    4 +-
 drivers/crypto/hisilicon/zip/zip.h          |    4 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c   |    4 +-
 10 files changed, 1282 insertions(+), 63 deletions(-)

-- 
2.8.1

