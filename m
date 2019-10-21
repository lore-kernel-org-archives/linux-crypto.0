Return-Path: <SRS0=EZON=YO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED839CA9EBB
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 07:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDF932086D
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Oct 2019 07:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfJUHkb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Oct 2019 03:40:31 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:57396 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727097AbfJUHka (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Oct 2019 03:40:30 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D33854A323ABC7A7D38C;
        Mon, 21 Oct 2019 15:40:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 21 Oct 2019 15:40:18 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <wangzhou1@hisilicon.com>, <linux-crypto@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH 0/4] Misc fixes and optimisation patch
Date:   Mon, 21 Oct 2019 15:40:59 +0800
Message-ID: <1571643663-29593-1-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series mainly fix sparse warnings, optimise the code to be more concise.

Shukun Tan (3):
  crypto: hisilicon - Fix using plain integer as NULL pointer
  crypto: hisilicon - fix param should be static when not external.
  crypto: hisilicon - fix endianness verification problem of QM

Zhou Wang (1):
  crypto: hisilicon - tiny fix about QM/ZIP error callback print

 drivers/crypto/hisilicon/qm.c             | 96 +++++++++++++++----------------
 drivers/crypto/hisilicon/qm.h             |  2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c |  2 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |  9 ++-
 4 files changed, 52 insertions(+), 57 deletions(-)

-- 
2.7.4

