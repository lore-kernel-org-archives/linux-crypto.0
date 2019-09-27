Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF5FC4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 03:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C582E207FF
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 03:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbfI0DIq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 23:08:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728464AbfI0DIq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 23:08:46 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 267D0A00D84DDE2CEF49;
        Fri, 27 Sep 2019 11:08:44 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Fri, 27 Sep 2019 11:08:35 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [RFC PATCH] crypto: zlib-deflate - add zlib-deflate test case in tcrypt
Date:   Fri, 27 Sep 2019 11:05:15 +0800
Message-ID: <1569553515-47426-1-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As a type CRYPTO_ALG_TYPE_ACOMPRESS is needed to trigger crypto acomp test,
we introduce a new help function tcrypto_test_extend to pass type and mask
to alg_test.

Then tcrypto module can be used to do basic acomp test by:
insmod tcrypto.ko alg="zlib-deflate" mode=55 type=10

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 crypto/tcrypt.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 83ad0b1..6ad821c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -72,7 +72,7 @@ static char *check[] = {
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
 	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320",
 	"lzo", "lzo-rle", "cts", "sha3-224", "sha3-256", "sha3-384",
-	"sha3-512", "streebog256", "streebog512",
+	"sha3-512", "streebog256", "streebog512", "zlib-deflate",
 	NULL
 };
 
@@ -1657,6 +1657,19 @@ static inline int tcrypt_test(const char *alg)
 	return ret;
 }
 
+static inline int tcrypt_test_extend(const char *alg, u32 type, u32 mask)
+{
+	int ret;
+
+	pr_debug("testing %s\n", alg);
+
+	ret = alg_test(alg, alg, type, mask);
+	/* non-fips algs return -EINVAL in fips mode */
+	if (fips_enabled && ret == -EINVAL)
+		ret = 0;
+	return ret;
+}
+
 static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 {
 	int i;
@@ -1919,6 +1932,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("streebog512");
 		break;
 
+	case 55:
+		ret += tcrypt_test_extend("zlib-deflate", type, mask);
+		break;
+
 	case 100:
 		ret += tcrypt_test("hmac(md5)");
 		break;
-- 
2.8.1

