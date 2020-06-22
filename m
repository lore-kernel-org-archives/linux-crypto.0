Return-Path: <SRS0=/YgZ=AD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AD2C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 11:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 095A720716
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jun 2020 11:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgFVLS4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jun 2020 07:18:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6383 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728635AbgFVLSW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jun 2020 07:18:22 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6657613E2A665F574F36;
        Mon, 22 Jun 2020 19:18:19 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Mon, 22 Jun 2020 19:18:09 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vitaly Chikunov <vt@altlinux.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH] KEYS: asymmetric: fix error return code in software_key_query()
Date:   Mon, 22 Jun 2020 11:21:36 +0000
Message-ID: <20200622112136.72745-1-weiyongjun1@huawei.com>
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

Fix to return negative error code -ENOMEM from kmalloc() error handling
case instead of 0, as done elsewhere in this function.

Fixes: f1774cb8956a ("X.509: parse public key parameters from x509 for akcipher")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 crypto/asymmetric_keys/public_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index d7f43d4ea925..c15bde024b4c 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -119,6 +119,7 @@ static int software_key_query(const struct kernel_pkey_params *params,
 	if (IS_ERR(tfm))
 		return PTR_ERR(tfm);
 
+	ret = -ENOMEM;
 	key = kmalloc(pkey->keylen + sizeof(u32) * 2 + pkey->paramlen,
 		      GFP_KERNEL);
 	if (!key)



