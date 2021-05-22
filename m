Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC0CFC4707F
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 02:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 972E6613B6
	for <linux-crypto@archiver.kernel.org>; Sat, 22 May 2021 02:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhEVCtM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 22:49:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3624 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhEVCtJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 22:49:09 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fn78p0kgdzQpkH;
        Sat, 22 May 2021 10:44:10 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 10:47:42 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 10:47:42 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/4] crypto: ecdh - add test suite for NIST P384
Date:   Sat, 22 May 2021 10:44:31 +0800
Message-ID: <1621651471-42010-5-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621651471-42010-1-git-send-email-tanghui20@huawei.com>
References: <1621651471-42010-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add test vector params for NIST P384, add test vector for
NIST P384 on vector of tests.

Vector param from:
https://datatracker.ietf.org/doc/html/rfc5903#section-3.1

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 crypto/testmgr.c |  7 +++++++
 crypto/testmgr.h | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 26e40db..1f7f63e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4912,6 +4912,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.kpp = __VECS(ecdh_p256_tv_template)
 		}
 	}, {
+		.alg = "ecdh-nist-p384",
+		.test = alg_test_kpp,
+		.fips_allowed = 1,
+		.suite = {
+			.kpp = __VECS(ecdh_p384_tv_template)
+		}
+	}, {
 		.alg = "ecdsa-nist-p192",
 		.test = alg_test_akcipher,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index fe1e59d..5a95b39 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -2812,6 +2812,67 @@ static const struct kpp_testvec ecdh_p256_tv_template[] = {
 };
 
 /*
+ * NIST P384 test vectors from RFC5903
+ */
+static const struct kpp_testvec ecdh_p384_tv_template[] = {
+	{
+	.secret =
+#ifdef __LITTLE_ENDIAN
+	"\x02\x00" /* type */
+	"\x36\x00" /* len */
+	"\x30\x00" /* key_size */
+#else
+	"\x00\x02" /* type */
+	"\x00\x36" /* len */
+	"\x00\x30" /* key_size */
+#endif
+	"\x09\x9F\x3C\x70\x34\xD4\xA2\xC6"
+	"\x99\x88\x4D\x73\xA3\x75\xA6\x7F"
+	"\x76\x24\xEF\x7C\x6B\x3C\x0F\x16"
+	"\x06\x47\xB6\x74\x14\xDC\xE6\x55"
+	"\xE3\x5B\x53\x80\x41\xE6\x49\xEE"
+	"\x3F\xAE\xF8\x96\x78\x3A\xB1\x94",
+	.b_public =
+	"\xE5\x58\xDB\xEF\x53\xEE\xCD\xE3"
+	"\xD3\xFC\xCF\xC1\xAE\xA0\x8A\x89"
+	"\xA9\x87\x47\x5D\x12\xFD\x95\x0D"
+	"\x83\xCF\xA4\x17\x32\xBC\x50\x9D"
+	"\x0D\x1A\xC4\x3A\x03\x36\xDE\xF9"
+	"\x6F\xDA\x41\xD0\x77\x4A\x35\x71"
+	"\xDC\xFB\xEC\x7A\xAC\xF3\x19\x64"
+	"\x72\x16\x9E\x83\x84\x30\x36\x7F"
+	"\x66\xEE\xBE\x3C\x6E\x70\xC4\x16"
+	"\xDD\x5F\x0C\x68\x75\x9D\xD1\xFF"
+	"\xF8\x3F\xA4\x01\x42\x20\x9D\xFF"
+	"\x5E\xAA\xD9\x6D\xB9\xE6\x38\x6C",
+	.expected_a_public =
+	"\x66\x78\x42\xD7\xD1\x80\xAC\x2C"
+	"\xDE\x6F\x74\xF3\x75\x51\xF5\x57"
+	"\x55\xC7\x64\x5C\x20\xEF\x73\xE3"
+	"\x16\x34\xFE\x72\xB4\xC5\x5E\xE6"
+	"\xDE\x3A\xC8\x08\xAC\xB4\xBD\xB4"
+	"\xC8\x87\x32\xAE\xE9\x5F\x41\xAA"
+	"\x94\x82\xED\x1F\xC0\xEE\xB9\xCA"
+	"\xFC\x49\x84\x62\x5C\xCF\xC2\x3F"
+	"\x65\x03\x21\x49\xE0\xE1\x44\xAD"
+	"\xA0\x24\x18\x15\x35\xA0\xF3\x8E"
+	"\xEB\x9F\xCF\xF3\xC2\xC9\x47\xDA"
+	"\xE6\x9B\x4C\x63\x45\x73\xA8\x1C",
+	.expected_ss =
+	"\x11\x18\x73\x31\xC2\x79\x96\x2D"
+	"\x93\xD6\x04\x24\x3F\xD5\x92\xCB"
+	"\x9D\x0A\x92\x6F\x42\x2E\x47\x18"
+	"\x75\x21\x28\x7E\x71\x56\xC5\xC4"
+	"\xD6\x03\x13\x55\x69\xB9\xE9\xD0"
+	"\x9C\xF5\xD4\xA2\x70\xF5\x97\x46",
+	.secret_size = 54,
+	.b_public_size = 96,
+	.expected_a_public_size = 96,
+	.expected_ss_size = 48
+	}
+};
+
+/*
  * MD4 test vectors from RFC1320
  */
 static const struct hash_testvec md4_tv_template[] = {
-- 
2.8.1

