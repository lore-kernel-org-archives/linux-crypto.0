Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0653FC43214
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 07:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D99186104F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 07:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbhHMHzj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Aug 2021 03:55:39 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:55105 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239042AbhHMHzi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Aug 2021 03:55:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Uis59gQ_1628841310;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Uis59gQ_1628841310)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 13 Aug 2021 15:55:10 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v2 3/3] crypto: tcrypt: add GCM/CCM mode test for SM4 algorithm
Date:   Fri, 13 Aug 2021 15:55:08 +0800
Message-Id: <20210813075508.98854-4-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20210813075508.98854-1-tianjia.zhang@linux.alibaba.com>
References: <20210813075508.98854-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tcrypt supports GCM/CCM mode, CMAC, CBCMAC, and speed test of
SM4 algorithm.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/tcrypt.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 170102e92f7d..82b0400985a5 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1916,6 +1916,14 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("streebog512");
 		break;
 
+	case 55:
+		ret += tcrypt_test("gcm(sm4)");
+		break;
+
+	case 56:
+		ret += tcrypt_test("ccm(sm4)");
+		break;
+
 	case 100:
 		ret += tcrypt_test("hmac(md5)");
 		break;
@@ -2007,6 +2015,15 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 	case 157:
 		ret += tcrypt_test("authenc(hmac(sha1),ecb(cipher_null))");
 		break;
+
+	case 158:
+		ret += tcrypt_test("cbcmac(sm4)");
+		break;
+
+	case 159:
+		ret += tcrypt_test("cmac(sm4)");
+		break;
+
 	case 181:
 		ret += tcrypt_test("authenc(hmac(sha1),cbc(des))");
 		break;
@@ -2336,6 +2353,34 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				NULL, 0, 16, 8, speed_template_16);
 		break;
 
+	case 222:
+		test_aead_speed("gcm(sm4)", ENCRYPT, sec,
+				NULL, 0, 16, 8, speed_template_16);
+		test_aead_speed("gcm(sm4)", DECRYPT, sec,
+				NULL, 0, 16, 8, speed_template_16);
+		break;
+
+	case 223:
+		test_aead_speed("rfc4309(ccm(sm4))", ENCRYPT, sec,
+				NULL, 0, 16, 16, aead_speed_template_19);
+		test_aead_speed("rfc4309(ccm(sm4))", DECRYPT, sec,
+				NULL, 0, 16, 16, aead_speed_template_19);
+		break;
+
+	case 224:
+		test_mb_aead_speed("gcm(sm4)", ENCRYPT, sec, NULL, 0, 16, 8,
+				   speed_template_16, num_mb);
+		test_mb_aead_speed("gcm(sm4)", DECRYPT, sec, NULL, 0, 16, 8,
+				   speed_template_16, num_mb);
+		break;
+
+	case 225:
+		test_mb_aead_speed("rfc4309(ccm(sm4))", ENCRYPT, sec, NULL, 0,
+				   16, 16, aead_speed_template_19, num_mb);
+		test_mb_aead_speed("rfc4309(ccm(sm4))", DECRYPT, sec, NULL, 0,
+				   16, 16, aead_speed_template_19, num_mb);
+		break;
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
-- 
2.19.1.3.ge56e4f7

