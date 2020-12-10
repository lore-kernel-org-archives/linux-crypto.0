Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DCD3C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 11:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1413223D9B
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Dec 2020 11:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389394AbgLJLPB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Dec 2020 06:15:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8740 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387702AbgLJLMs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Dec 2020 06:12:48 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CsB795gBtzkn1c;
        Thu, 10 Dec 2020 19:11:17 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Dec 2020
 19:11:55 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 6/6] crypto: hisilicon/sec - add new algorithm test case
Date:   Thu, 10 Dec 2020 19:10:07 +0800
Message-ID: <1607598607-8728-7-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1607598607-8728-1-git-send-email-liulongfang@huawei.com>
References: <1607598607-8728-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add testing cases for new algorithms such as
'XTS(SM4)', 'CCM(SM4)' and 'GCM(SM4)' to 'Crypto testmgr'.

Except for CCM(AES) exiting with unexpected success,
other algorithms have successfully  passed the
crypto self-tests.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 arch/arm64/configs/defconfig |  2 +-
 crypto/testmgr.c             | 26 ++++++++++++++++
 crypto/testmgr.h             | 72 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 646c3b4..b62d0ba 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -113,7 +113,7 @@ CONFIG_KVM=y
 CONFIG_ARM64_CRYPTO=y
 CONFIG_CRYPTO_SHA1_ARM64_CE=y
 CONFIG_CRYPTO_SHA2_ARM64_CE=y
-CONFIG_CRYPTO_SHA512_ARM64_CE=m
+CONFIG_CRYPTO_SHA512_ARM64_CE=y
 CONFIG_CRYPTO_SHA3_ARM64=m
 CONFIG_CRYPTO_SM3_ARM64_CE=m
 CONFIG_CRYPTO_GHASH_ARM64_CE=y
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 321e38e..494cc0a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4464,6 +4464,16 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "ccm(sm4)",
+		.test = alg_test_aead,
+		.fips_allowed = 1,
+		.suite = {
+			.aead = {
+				____VECS(sm4_ccm_tv_template),
+				.einval_allowed = 1,
+			}
+		}
+	}, {
 		.alg = "cfb(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
@@ -4942,6 +4952,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = __VECS(aes_gcm_tv_template)
 		}
 	}, {
+		.alg = "gcm(sm4)",
+		.generic_driver = "gcm(sm4)",
+		.test = alg_test_aead,
+		.fips_allowed = 1,
+		.suite = {
+			.aead = __VECS(sm4_gcm_tv_template)
+		}
+	}, {
 		.alg = "ghash",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
@@ -5493,6 +5511,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.cipher = __VECS(serpent_xts_tv_template)
 		}
 	}, {
+		.alg = "xts(sm4)",
+		.generic_driver = "xts(sm4))",
+		.test = alg_test_skcipher,
+		.fips_allowed = 1,
+		.suite = {
+			.cipher = __VECS(sm4_xts_tv_template)
+		}
+	}, {
 		.alg = "xts(twofish)",
 		.generic_driver = "xts(ecb(twofish-generic))",
 		.test = alg_test_skcipher,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 8c83811..69bb29c 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -13319,6 +13319,78 @@ static const struct cipher_testvec sm4_cfb_tv_template[] = {
 	}
 };
 
+static const struct cipher_testvec sm4_xts_tv_template[] = {
+	{
+		.key	= "\x11\x11\x11\x11\x11\x11\x11\x11"
+			  "\x11\x11\x11\x11\x11\x11\x11\x11"
+			  "\x22\x22\x22\x22\x22\x22\x22\x22"
+			  "\x22\x22\x22\x22\x22\x22\x22\x22",
+		.klen	= 32,
+		.iv	= "\x33\x33\x33\x33\x33\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "\x44\x44\x44\x44\x44\x44\x44\x44"
+			  "\x44\x44\x44\x44\x44\x44\x44\x44"
+			  "\x44\x44\x44\x44\x44\x44\x44\x44"
+			  "\x44\x44\x44\x44\x44\x44\x44\x44",
+		.ctext	= "\xA7\x4D\x72\x6C\x11\x19\x6A\x32"
+			  "\xBE\x04\xE0\x01\xFF\x29\xD0\xC7"
+			  "\x93\x2F\x9F\x3E\xC2\x9B\xFC\xB6"
+			  "\x4D\xD1\x7F\x63\xCB\xD3\xEA\x31",
+		.len	= 32,
+	}
+};
+
+static const struct aead_testvec sm4_ccm_tv_template[] = {
+	{
+		.key	= "\xc0\xc1\xc2\xc3\xc4\xc5\xc6\xc7"
+			  "\xc8\xc9\xca\xcb\xcc\xcd\xce\xcf",
+		.klen	= 16,
+		.iv	= "\x01\x00\x00\x00\x03\x02\x01\x00"
+			  "\xa0\xa1\xa2\xa3\xa4\xa5\x00\x00",
+		.assoc	= "\x00\x01\x02\x03\x04\x05\x06\x07",
+		.alen	= 8,
+		.ptext	= "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e",
+		.plen	= 23,
+		.ctext	= "\x7B\xFF\x4A\x15\xF5\x73\xCE\x82"
+			  "\x6E\xC2\x31\x1D\xE2\x53\x02\xAC"
+			  "\xA4\x48\xF9\xE4\xF5\x1F\x81\x70"
+			  "\x18\xBC\xB6\x84\x01\xB8\xAE",
+		.clen	= 31,
+	}
+};
+
+static const struct aead_testvec sm4_gcm_tv_template[] = {
+	{
+		.key	= "\xfe\xff\xe9\x92\x86\x65\x73\x1c"
+			  "\x6d\x6a\x8f\x94\x67\x30\x83\x08",
+		.klen	= 16,
+		.iv	= "\xca\xfe\xba\xbe\xfa\xce\xdb\xad"
+			  "\xde\xca\xf8\x88",
+		.ptext	= "\xd9\x31\x32\x25\xf8\x84\x06\xe5"
+			  "\xa5\x59\x09\xc5\xaf\xf5\x26\x9a"
+			  "\x86\xa7\xa9\x53\x15\x34\xf7\xda"
+			  "\x2e\x4c\x30\x3d\x8a\x31\x8a\x72"
+			  "\x1c\x3c\x0c\x95\x95\x68\x09\x53"
+			  "\x2f\xcf\x0e\x24\x49\xa6\xb5\x25"
+			  "\xb1\x6a\xed\xf5\xaa\x0d\xe6\x57"
+			  "\xba\x63\x7b\x39\x1a\xaf\xd2\x55",
+		.plen	= 64,
+		.ctext	= "\xe4\x11\x0f\xf1\xc1\x41\x97\xe6"
+			  "\x76\x21\x6a\x33\x83\x10\x41\xeb"
+			  "\x09\x58\x00\x11\x7b\xdc\x3f\x75"
+			  "\x1a\x49\x6e\xfc\xf2\xbb\xdf\xdb"
+			  "\x3a\x2e\x13\xfd\xc5\xc1\x9d\x07"
+			  "\x1a\xe5\x48\x3f\xed\xde\x98\x5d"
+			  "\x3f\x2d\x5b\x4e\xee\x0b\xb6\xdf"
+			  "\xe3\x63\x36\x83\x23\xf7\x5b\x80"
+			  "\x7d\xfe\x77\xef\x71\xb1\x5e\xc9"
+			  "\x52\x6b\x09\xab\x84\x28\x4b\x8a",
+		.clen	= 80,
+	}
+};
+
 /* Cast6 test vectors from RFC 2612 */
 static const struct cipher_testvec cast6_tv_template[] = {
 	{
-- 
2.8.1

