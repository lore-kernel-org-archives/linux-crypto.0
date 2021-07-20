Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDB1C07E95
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 03:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8358A6113B
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jul 2021 03:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhGTDGu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 23:06:50 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54122 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348042AbhGTDGJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 23:06:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0UgNap9n_1626752804;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UgNap9n_1626752804)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 20 Jul 2021 11:46:45 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Markku-Juhani O . Saarinen" <mjos@iki.fi>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v3 4/4] crypto: tcrypt - add the asynchronous speed test for SM4
Date:   Tue, 20 Jul 2021 11:46:42 +0800
Message-Id: <20210720034642.19230-5-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
In-Reply-To: <20210720034642.19230-1-tianjia.zhang@linux.alibaba.com>
References: <20210720034642.19230-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tcrypt supports testing of SM4 cipher algorithms that use avx
instruction set acceleration. The implementation of sm4 instruction
set acceleration supports up to 8 blocks in parallel encryption and
decryption, which is 128 bytes. Therefore, the 128-byte block size
is also added to block_sizes.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/tcrypt.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index f8d06da78e4f..d73a42fdaa9b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -77,7 +77,7 @@ static const char *check[] = {
 	NULL
 };
 
-static const int block_sizes[] = { 16, 64, 256, 1024, 1420, 4096, 0 };
+static const int block_sizes[] = { 16, 64, 128, 256, 1024, 1420, 4096, 0 };
 static const int aead_sizes[] = { 16, 64, 256, 512, 1024, 1420, 4096, 8192, 0 };
 
 #define XBUFSIZE 8
@@ -2031,6 +2031,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 	case 191:
 		ret += tcrypt_test("ecb(sm4)");
 		ret += tcrypt_test("cbc(sm4)");
+		ret += tcrypt_test("cfb(sm4)");
 		ret += tcrypt_test("ctr(sm4)");
 		break;
 	case 200:
@@ -2289,6 +2290,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				speed_template_16);
 		test_cipher_speed("cbc(sm4)", DECRYPT, sec, NULL, 0,
 				speed_template_16);
+		test_cipher_speed("cfb(sm4)", ENCRYPT, sec, NULL, 0,
+				speed_template_16);
+		test_cipher_speed("cfb(sm4)", DECRYPT, sec, NULL, 0,
+				speed_template_16);
 		test_cipher_speed("ctr(sm4)", ENCRYPT, sec, NULL, 0,
 				speed_template_16);
 		test_cipher_speed("ctr(sm4)", DECRYPT, sec, NULL, 0,
@@ -2757,6 +2762,25 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 				   speed_template_8_32);
 		break;
 
+	case 518:
+		test_acipher_speed("ecb(sm4)", ENCRYPT, sec, NULL, 0,
+				speed_template_16);
+		test_acipher_speed("ecb(sm4)", DECRYPT, sec, NULL, 0,
+				speed_template_16);
+		test_acipher_speed("cbc(sm4)", ENCRYPT, sec, NULL, 0,
+				speed_template_16);
+		test_acipher_speed("cbc(sm4)", DECRYPT, sec, NULL, 0,
+				speed_template_16);
+		test_acipher_speed("cfb(sm4)", ENCRYPT, sec, NULL, 0,
+				speed_template_16);
+		test_acipher_speed("cfb(sm4)", DECRYPT, sec, NULL, 0,
+				speed_template_16);
+		test_acipher_speed("ctr(sm4)", ENCRYPT, sec, NULL, 0,
+				speed_template_16);
+		test_acipher_speed("ctr(sm4)", DECRYPT, sec, NULL, 0,
+				speed_template_16);
+		break;
+
 	case 600:
 		test_mb_skcipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				       speed_template_16_24_32, num_mb);
-- 
2.19.1.3.ge56e4f7

