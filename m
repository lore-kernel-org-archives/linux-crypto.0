Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C23C64E7A
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 09:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BF12221F7
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 09:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgK0JmK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 04:42:10 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8132 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729344AbgK0JmJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 04:42:09 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cj8ln2qCXz15K6R;
        Fri, 27 Nov 2020 17:41:41 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Fri, 27 Nov 2020 17:41:53 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Alexandre Torgue" <alexandre.torgue@st.com>
CC:     <linux-crypto@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH 0/2] crypto: stm32 - fix reference leak
Date:   Fri, 27 Nov 2020 17:46:07 +0800
Message-ID: <20201127094609.121614-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to putting operation will result in a
reference leak here. 

Use pm_runtime_resume_and_get to fix it.

Qinglang Miao (2):
  crypto: stm32/cryp - fix reference leak in stm32_cryp_remove
  crypto: stm32/hash - fix reference leak in stm32_hash_remove

 drivers/crypto/stm32/stm32-cryp.c | 2 +-
 drivers/crypto/stm32/stm32-hash.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.23.0

