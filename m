Return-Path: <SRS0=FtFJ=5D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E124C5ACD6
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Mar 2020 02:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EF7D20724
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Mar 2020 02:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgCRCIq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 22:08:46 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11714 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbgCRCIp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 22:08:45 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AC76B3D0B051E3C9A6F8;
        Wed, 18 Mar 2020 10:08:40 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Mar 2020 10:08:25 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] crypto: ccree - remove duplicated include from cc_aead.c
Date:   Wed, 18 Mar 2020 02:00:40 +0000
Message-ID: <20200318020040.175704-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/ccree/cc_aead.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 875fa79a03eb..1cf51edbc4b9 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -9,7 +9,6 @@
 #include <crypto/gcm.h>
 #include <linux/rtnetlink.h>
 #include <crypto/internal/des.h>
-#include <linux/rtnetlink.h>
 #include "cc_driver.h"
 #include "cc_buffer_mgr.h"
 #include "cc_aead.h"



