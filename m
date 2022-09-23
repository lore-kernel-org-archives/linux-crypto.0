Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5A4C6FA90
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 10:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiIWKwu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 06:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbiIWKwl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 06:52:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F40A6C57;
        Fri, 23 Sep 2022 03:52:39 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MYpnR2WhqzbncV;
        Fri, 23 Sep 2022 18:49:47 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500022.china.huawei.com
 (7.185.36.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 23 Sep
 2022 18:52:37 +0800
From:   Zeng Heng <zengheng4@huawei.com>
To:     <dhowells@redhat.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC:     <keyrings@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <liwei391@huawei.com>, <zengheng4@huawei.com>
Subject: [PATCH -next] crypto: KEYS: fix undefined reference errors in fips_signature_selftest
Date:   Fri, 23 Sep 2022 18:59:32 +0800
Message-ID: <20220923105932.3294400-1-zengheng4@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When the menuconfig set as below:

CONFIG_FIPS_SIGNATURE_SELFTEST = y
CONFIG_PKCS7_MESSAGE_PARSER = m

it would raise below compile errors:
ld: crypto/asymmetric_keys/selftest.o: in function `fips_signature_selftest':
.../crypto/asymmetric_keys/selftest.c:205: undefined reference to `pkcs7_parse_message'
ld: .../crypto/asymmetric_keys/selftest.c:209: undefined reference to `pkcs7_supply_detached_data'
ld: .../crypto/asymmetric_keys/selftest.c:211: undefined reference to `pkcs7_verify'
ld: .../crypto/asymmetric_keys/selftest.c:215: undefined reference to `pkcs7_validate_trust'
ld: .../crypto/asymmetric_keys/selftest.c:219: undefined reference to `pkcs7_free_message'

FIPS_SIGNATURE_SELFTEST needs pkcs7_parser.o compiled
into kernel indeed, so select PKCS7_MESSAGE_PARSER
when enable FIPS_SIGNATURE_SELFTEST.

Signed-off-by: Zeng Heng <zengheng4@huawei.com>
---
 crypto/asymmetric_keys/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 3df3fe4ed95f..9d74bf5fbb63 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -83,6 +83,6 @@ config FIPS_SIGNATURE_SELFTEST
 	  for FIPS.
 	depends on KEYS
 	depends on ASYMMETRIC_KEY_TYPE
-	depends on PKCS7_MESSAGE_PARSER
+	select PKCS7_MESSAGE_PARSER
 
 endif # ASYMMETRIC_KEY_TYPE
-- 
2.25.1

