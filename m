Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FA6C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 09:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E7AF2086C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 09:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfBTJV1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 04:21:27 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:35020 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726776AbfBTJV1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 04:21:27 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C9D79DE2D9B7A9F91F51;
        Wed, 20 Feb 2019 17:21:23 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.408.0; Wed, 20 Feb 2019 17:21:17 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Sumit Garg <sumit.garg@linaro.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
Date:   Wed, 20 Feb 2019 09:34:58 +0000
Message-ID: <20190220093458.159208-1-weiyongjun1@huawei.com>
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

Fixes the following sparse warning:

drivers/char/hw_random/optee-rng.c:265:35: warning:
 symbol 'optee_rng_id_table' was not declared. Should it be static?

Fixes: 5fe8b1cc6a03 ("hwrng: add OP-TEE based rng driver")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/char/hw_random/optee-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
index 2b9fc8ac5500..3a4dd6fc9ff4 100644
--- a/drivers/char/hw_random/optee-rng.c
+++ b/drivers/char/hw_random/optee-rng.c
@@ -262,7 +262,7 @@ static int optee_rng_remove(struct device *dev)
 	return 0;
 }
 
-const struct tee_client_device_id optee_rng_id_table[] = {
+static const struct tee_client_device_id optee_rng_id_table[] = {
 	{UUID_INIT(0xab7a617c, 0xb8e7, 0x4d8f,
 		   0x83, 0x01, 0xd0, 0x9b, 0x61, 0x03, 0x6b, 0x64)},
 	{}



