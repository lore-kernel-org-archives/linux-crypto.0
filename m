Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C5B7C6379D
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Nov 2020 03:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B22C221FC
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Nov 2020 03:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbgKRDs4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 22:48:56 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7642 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbgKRDsz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 22:48:55 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CbTLW0B5tz15N1N;
        Wed, 18 Nov 2020 11:48:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Wed, 18 Nov 2020 11:48:41 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/5] crypto: hisilicon/hpre - add 'ECDH' algorithm
Date:   Wed, 18 Nov 2020 11:47:00 +0800
Message-ID: <1605671221-30692-5-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1605671221-30692-1-git-send-email-yumeng18@huawei.com>
References: <1605671221-30692-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Enable 'ECDH' algorithm in Kunpeng 930.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre.h        |   2 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 802 +++++++++++++++++++++++++++-
 drivers/crypto/hisilicon/hpre/hpre_main.c   |   1 +
 3 files changed, 800 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index 02193e1..50e6b2e 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -83,6 +83,7 @@ enum hpre_alg_type {
 	HPRE_ALG_KG_CRT = 0x3,
 	HPRE_ALG_DH_G2 = 0x4,
 	HPRE_ALG_DH = 0x5,
+	HPRE_ALG_ECC_MUL = 0xD,
 };
 
 struct hpre_sqe {
@@ -104,5 +105,4 @@ struct hisi_qp *hpre_create_qp(u8 type);
 int hpre_algs_register(struct hisi_qm *qm);
 void hpre_algs_unregister(struct hisi_qm *qm);
 
-
 #endif
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 712bea9..b7814ce 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 HiSilicon Limited. */
 #include <crypto/akcipher.h>
 #include <crypto/dh.h>
+#include <crypto/ecdh.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/internal/kpp.h>
 #include <crypto/internal/rsa.h>
@@ -36,6 +37,342 @@ struct hpre_ctx;
 #define HPRE_DFX_SEC_TO_US	1000000
 #define HPRE_DFX_US_TO_NS	1000
 
+/* HPRE support 7 curves (include curve P192 and P256 in ecdh.h) */
+#define HPRE_ECC_CURVE_NIST_P128	0X0003
+#define HPRE_ECC_CURVE_NIST_P320	0X0004
+#define HPRE_ECC_CURVE_NIST_P384	0X0005
+#define HPRE_ECC_CURVE_NIST_P521	0X0006
+#define HPRE_ECC_CURVE_NIST_P224	0X0007
+
+/* size in bytes of the n prime */
+#define HPRE_ECC_NIST_P128_N_SIZE	16
+#define HPRE_ECC_NIST_P192_N_SIZE	24
+#define HPRE_ECC_NIST_P224_N_SIZE	28
+#define HPRE_ECC_NIST_P256_N_SIZE	32
+#define HPRE_ECC_NIST_P320_N_SIZE	40
+#define HPRE_ECC_NIST_P384_N_SIZE	48
+#define HPRE_ECC_NIST_P521_N_SIZE	66
+
+/* size in bytes */
+#define HPRE_ECC_HW256_KSZ_B	32
+#define HPRE_ECC_HW384_KSZ_B	48
+#define HPRE_ECC_HW576_KSZ_B	72
+
+#define HPRE_ECDH_MAX_SZ	HPRE_ECC_HW576_KSZ_B
+
+struct curve_param_desc {
+	__u32 id;
+	const unsigned char *p;
+	const unsigned char *a;
+	const unsigned char *b;
+	const unsigned char *gx;
+	const unsigned char *gy;
+	const unsigned char *n;
+};
+
+/* ECC CURVE PARAMS */
+/* 128 bits */
+static const unsigned char ecdh_p128_p[] = {
+	0xFF, 0xFF, 0xFF, 0xFD, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF
+};
+static const unsigned char ecdh_p128_a[] = {
+	0xFF, 0xFF, 0xFF, 0xFD, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFC
+};
+static const unsigned char ecdh_p128_b[] = {
+	0xE8, 0x75, 0x79, 0xC1, 0x10, 0x79, 0xF4, 0x3D, 0xD8, 0x24, 0x99, 0x3C,
+	0x2C, 0xEE, 0x5E, 0xD3
+};
+static const unsigned char ecdh_p128_x[] = {
+	0x16, 0x1F, 0xF7, 0x52, 0x8B, 0x89, 0x9B, 0x2D, 0x0C, 0x28, 0x60, 0x7C,
+	0xA5, 0x2C, 0x5B, 0x86
+};
+static const unsigned char ecdh_p128_y[] = {
+	0xcf, 0x5a, 0xc8, 0x39, 0x5b, 0xaf, 0xeb, 0x13, 0xc0, 0x2d, 0xa2, 0x92,
+	0xdd, 0xed, 0x7a, 0x83
+};
+static const unsigned char ecdh_p128_n[] = {
+	0xFF, 0xFF, 0xFF, 0xFE, 0x00, 0x00, 0x00, 0x00, 0x75, 0xA3, 0x0D, 0x1B,
+	0x90, 0x38, 0xA1, 0x15
+};
+
+/* 192 bits */
+static const unsigned char ecdh_p192_p[] = {
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
+};
+static const unsigned char ecdh_p192_a[] = {
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC
+};
+static const unsigned char ecdh_p192_b[] = {
+	0x64, 0x21, 0x05, 0x19, 0xE5, 0x9C, 0x80, 0xE7, 0x0F, 0xA7, 0xE9, 0xAB,
+	0x72, 0x24, 0x30, 0x49, 0xFE, 0xB8, 0xDE, 0xEC, 0xC1, 0x46, 0xB9, 0xB1
+};
+static const unsigned char ecdh_p192_x[] = {
+	0x18, 0x8D, 0xA8, 0x0E, 0xB0, 0x30, 0x90, 0xF6, 0x7C, 0xBF, 0x20, 0xEB,
+	0x43, 0xA1, 0x88, 0x00, 0xF4, 0xFF, 0x0A, 0xFD, 0x82, 0xFF, 0x10, 0x12
+};
+static const unsigned char ecdh_p192_y[] = {
+	0x07, 0x19, 0x2b, 0x95, 0xff, 0xc8, 0xda, 0x78, 0x63, 0x10, 0x11, 0xed,
+	0x6b, 0x24, 0xcd, 0xd5, 0x73, 0xf9, 0x77, 0xa1, 0x1e, 0x79, 0x48, 0x11
+};
+static const unsigned char ecdh_p192_n[] = {
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0x99, 0xDE, 0xF8, 0x36, 0x14, 0x6B, 0xC9, 0xB1, 0xB4, 0xD2, 0x28, 0x31
+};
+
+/* 224 bits */
+static const unsigned char ecdh_p224_p[] = {
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x01
+};
+static const unsigned char ecdh_p224_a[] = {
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFE
+};
+static const unsigned char ecdh_p224_b[] = {
+	0xB4, 0x05, 0x0A, 0x85, 0x0C, 0x04, 0xB3, 0xAB, 0xF5, 0x41, 0x32, 0x56,
+	0x50, 0x44, 0xB0, 0xB7, 0xD7, 0xBF, 0xD8, 0xBA, 0x27, 0x0B, 0x39, 0x43,
+	0x23, 0x55, 0xFF, 0xB4
+};
+static const unsigned char ecdh_p224_x[] = {
+	0xB7, 0x0E, 0x0C, 0xBD, 0x6B, 0xB4, 0xBF, 0x7F, 0x32, 0x13, 0x90, 0xB9,
+	0x4A, 0x03, 0xC1, 0xD3, 0x56, 0xC2, 0x11, 0x22, 0x34, 0x32, 0x80, 0xD6,
+	0x11, 0x5C, 0x1D, 0x21
+};
+static const unsigned char ecdh_p224_y[] = {
+	0xbd, 0x37, 0x63, 0x88, 0xb5, 0xf7, 0x23, 0xfb, 0x4c, 0x22, 0xdf, 0xe6,
+	0xcd, 0x43, 0x75, 0xa0, 0x5a, 0x07, 0x47, 0x64, 0x44, 0xd5, 0x81, 0x99,
+	0x85, 0x00, 0x7e, 0x34
+};
+static const unsigned char ecdh_p224_n[] = {
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0x16, 0xA2, 0xE0, 0xB8, 0xF0, 0x3E, 0x13, 0xDD, 0x29, 0x45,
+	0x5C, 0x5C, 0x2A, 0x3D
+};
+
+/* 256 bits */
+static const unsigned char ecdh_p256_p[] = {
+	0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
+};
+static const unsigned char ecdh_p256_a[] = {
+	0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC
+};
+static const unsigned char ecdh_p256_b[] = {
+	0x5A, 0xC6, 0x35, 0xD8, 0xAA, 0x3A, 0x93, 0xE7, 0xB3, 0xEB, 0xBD, 0x55,
+	0x76, 0x98, 0x86, 0xBC, 0x65, 0x1D, 0x06, 0xB0, 0xCC, 0x53, 0xB0, 0xF6,
+	0x3B, 0xCE, 0x3C, 0x3E, 0x27, 0xD2, 0x60, 0x4B
+};
+static const unsigned char ecdh_p256_x[] = {
+	0x6B, 0x17, 0xD1, 0xF2, 0xE1, 0x2C, 0x42, 0x47, 0xF8, 0xBC, 0xE6, 0xE5,
+	0x63, 0xA4, 0x40, 0xF2, 0x77, 0x03, 0x7D, 0x81, 0x2D, 0xEB, 0x33, 0xA0,
+	0xF4, 0xA1, 0x39, 0x45, 0xD8, 0x98, 0xC2, 0x96
+};
+static const unsigned char ecdh_p256_y[] = {
+	0x4f, 0xe3, 0x42, 0xe2, 0xfe, 0x1a, 0x7f, 0x9b, 0x8e, 0xe7, 0xeb, 0x4a,
+	0x7c, 0x0f, 0x9e, 0x16, 0x2b, 0xce, 0x33, 0x57, 0x6b, 0x31, 0x5e, 0xce,
+	0xcb, 0xb6, 0x40, 0x68, 0x37, 0xbf, 0x51, 0xf5
+};
+static const unsigned char ecdh_p256_n[] = {
+	0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xBC, 0xE6, 0xFA, 0xAD, 0xA7, 0x17, 0x9E, 0x84,
+	0xF3, 0xB9, 0xCA, 0xC2, 0xFC, 0x63, 0x25, 0x51
+};
+
+/* 320 bits */
+static const unsigned char ecdh_p320_p[] = {
+	0xD3, 0x5E, 0x47, 0x20, 0x36, 0xBC, 0x4F, 0xB7, 0xE1, 0x3C, 0x78, 0x5E,
+	0xD2, 0x01, 0xE0, 0x65, 0xF9, 0x8F, 0xCF, 0xA6, 0xF6, 0xF4, 0x0D, 0xEF,
+	0x4F, 0x92, 0xB9, 0xEC, 0x78, 0x93, 0xEC, 0x28, 0xFC, 0xD4, 0x12, 0xB1,
+	0xF1, 0xB3, 0x2E, 0x27
+};
+static const unsigned char ecdh_p320_a[] = {
+	0x3E, 0xE3, 0x0B, 0x56, 0x8F, 0xBA, 0xB0, 0xF8, 0x83, 0xCC, 0xEB, 0xD4,
+	0x6D, 0x3F, 0x3B, 0xB8, 0xA2, 0xA7, 0x35, 0x13, 0xF5, 0xEB, 0x79, 0xDA,
+	0x66, 0x19, 0x0E, 0xB0, 0x85, 0xFF, 0xA9, 0xF4, 0x92, 0xF3, 0x75, 0xA9,
+	0x7D, 0x86, 0x0E, 0xB4
+};
+static const unsigned char ecdh_p320_b[] = {
+	0x52, 0x08, 0x83, 0x94, 0x9D, 0xFD, 0xBC, 0x42, 0xD3, 0xAD, 0x19, 0x86,
+	0x40, 0x68, 0x8A, 0x6F, 0xE1, 0x3F, 0x41, 0x34, 0x95, 0x54, 0xB4, 0x9A,
+	0xCC, 0x31, 0xDC, 0xCD, 0x88, 0x45, 0x39, 0x81, 0x6F, 0x5E, 0xB4, 0xAC,
+	0x8F, 0xB1, 0xF1, 0xA6
+};
+static const unsigned char ecdh_p320_x[] = {
+	0x43, 0xBD, 0x7E, 0x9A, 0xFB, 0x53, 0xD8, 0xB8, 0x52, 0x89, 0xBC, 0xC4,
+	0x8E, 0xE5, 0xBF, 0xE6, 0xF2, 0x01, 0x37, 0xD1, 0x0A, 0x08, 0x7E, 0xB6,
+	0xE7, 0x87, 0x1E, 0x2A, 0x10, 0xA5, 0x99, 0xC7, 0x10, 0xAF, 0x8D, 0x0D,
+	0x39, 0xE2, 0x06, 0x11
+};
+static const unsigned char ecdh_p320_y[] = {
+	0x14, 0xFD, 0xD0, 0x55, 0x45, 0xEC, 0x1C, 0xC8, 0xAB, 0x40, 0x93, 0x24,
+	0x7F, 0x77, 0x27, 0x5E, 0x07, 0x43, 0xFF, 0xED, 0x11, 0x71, 0x82, 0xEA,
+	0xA9, 0xC7, 0x78, 0x77, 0xAA, 0xAC, 0x6A, 0xC7, 0xD3, 0x52, 0x45, 0xD1,
+	0x69, 0x2E, 0x8E, 0xE1
+};
+static const unsigned char ecdh_p320_n[] = {
+	0xD3, 0x5E, 0x47, 0x20, 0x36, 0xBC, 0x4F, 0xB7, 0xE1, 0x3C, 0x78, 0x5E,
+	0xD2, 0x01, 0xE0, 0x65, 0xF9, 0x8F, 0xCF, 0xA5, 0xB6, 0x8F, 0x12, 0xA3,
+	0x2D, 0x48, 0x2E, 0xC7, 0xEE, 0x86, 0x58, 0xE9, 0x86, 0x91, 0x55, 0x5B,
+	0x44, 0xC5, 0x93, 0x11
+};
+
+/* 384 bits */
+static const unsigned char ecdh_p384_p[] = {
+	0x8C, 0xB9, 0x1E, 0x82, 0xA3, 0x38, 0x6D, 0x28, 0x0F, 0x5D, 0x6F, 0x7E,
+	0x50, 0xE6, 0x41, 0xDF, 0x15, 0x2F, 0x71, 0x09, 0xED, 0x54, 0x56, 0xB4,
+	0x12, 0xB1, 0xDA, 0x19, 0x7F, 0xB7, 0x11, 0x23, 0xAC, 0xD3, 0xA7, 0x29,
+	0x90, 0x1D, 0x1A, 0x71, 0x87, 0x47, 0x00, 0x13, 0x31, 0x07, 0xEC, 0x53
+};
+static const unsigned char ecdh_p384_a[] = {
+	0x7B, 0xC3, 0x82, 0xC6, 0x3D, 0x8C, 0x15, 0x0C, 0x3C, 0x72, 0x08, 0x0A,
+	0xCE, 0x05, 0xAF, 0xA0, 0xC2, 0xBE, 0xA2, 0x8E, 0x4F, 0xB2, 0x27, 0x87,
+	0x13, 0x91, 0x65, 0xEF, 0xBA, 0x91, 0xF9, 0x0F, 0x8A, 0xA5, 0x81, 0x4A,
+	0x50, 0x3A, 0xD4, 0xEB, 0x04, 0xA8, 0xC7, 0xDD, 0x22, 0xCE, 0x28, 0x26
+};
+static const unsigned char ecdh_p384_b[] = {
+	0x04, 0xA8, 0xC7, 0xDD, 0x22, 0xCE, 0x28, 0x26, 0x8B, 0x39, 0xB5, 0x54,
+	0x16, 0xF0, 0x44, 0x7C, 0x2F, 0xB7, 0x7D, 0xE1, 0x07, 0xDC, 0xD2, 0xA6,
+	0x2E, 0x88, 0x0E, 0xA5, 0x3E, 0xEB, 0x62, 0xD5, 0x7C, 0xB4, 0x39, 0x02,
+	0x95, 0xDB, 0xC9, 0x94, 0x3A, 0xB7, 0x86, 0x96, 0xFA, 0x50, 0x4C, 0x11
+};
+static const unsigned char ecdh_p384_x[] = {
+	0x1D, 0x1C, 0x64, 0xF0, 0x68, 0xCF, 0x45, 0xFF, 0xA2, 0xA6, 0x3A, 0x81,
+	0xB7, 0xC1, 0x3F, 0x6B, 0x88, 0x47, 0xA3, 0xE7, 0x7E, 0xF1, 0x4F, 0xE3,
+	0xDB, 0x7F, 0xCA, 0xFE, 0x0C, 0xBD, 0x10, 0xE8, 0xE8, 0x26, 0xE0, 0x34,
+	0x36, 0xD6, 0x46, 0xAA, 0xEF, 0x87, 0xB2, 0xE2, 0x47, 0xD4, 0xAF, 0x1E
+};
+static const unsigned char ecdh_p384_y[] = {
+	0x8A, 0xBE, 0x1D, 0x75, 0x20, 0xF9, 0xC2, 0xA4, 0x5C, 0xB1, 0xEB, 0x8E,
+	0x95, 0xCF, 0xD5, 0x52, 0x62, 0xB7, 0x0B, 0x29, 0xFE, 0xEC, 0x58, 0x64,
+	0xE1, 0x9C, 0x05, 0x4F, 0xF9, 0x91, 0x29, 0x28, 0x0E, 0x46, 0x46, 0x21,
+	0x77, 0x91, 0x81, 0x11, 0x42, 0x82, 0x03, 0x41, 0x26, 0x3C, 0x53, 0x15
+};
+static const unsigned char ecdh_p384_n[] = {
+	0x8C, 0xB9, 0x1E, 0x82, 0xA3, 0x38, 0x6D, 0x28, 0x0F, 0x5D, 0x6F, 0x7E,
+	0x50, 0xE6, 0x41, 0xDF, 0x15, 0x2F, 0x71, 0x09, 0xED, 0x54, 0x56, 0xB3,
+	0x1F, 0x16, 0x6E, 0x6C, 0xAC, 0x04, 0x25, 0xA7, 0xCF, 0x3A, 0xB6, 0xAF,
+	0x6B, 0x7F, 0xC3, 0x10, 0x3B, 0x88, 0x32, 0x02, 0xE9, 0x04, 0x65, 0x65
+};
+
+/* 521 bits */
+static const unsigned char ecdh_p521_p[] = {
+	0x01, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
+};
+static const unsigned char ecdh_p521_a[] = {
+	0x01, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFC
+};
+static const unsigned char ecdh_p521_b[] = {
+	0x00, 0x51, 0x95, 0x3E, 0xB9, 0x61, 0x8E, 0x1C, 0x9A, 0x1F, 0x92, 0x9A,
+	0x21, 0xA0, 0xB6, 0x85, 0x40, 0xEE, 0xA2, 0xDA, 0x72, 0x5B, 0x99, 0xB3,
+	0x15, 0xF3, 0xB8, 0xB4, 0x89, 0x91, 0x8E, 0xF1, 0x09, 0xE1, 0x56, 0x19,
+	0x39, 0x51, 0xEC, 0x7E, 0x93, 0x7B, 0x16, 0x52, 0xC0, 0xBD, 0x3B, 0xB1,
+	0xBF, 0x07, 0x35, 0x73, 0xDF, 0x88, 0x3D, 0x2C, 0x34, 0xF1, 0xEF, 0x45,
+	0x1F, 0xD4, 0x6B, 0x50, 0x3F, 0x00
+};
+static const unsigned char ecdh_p521_x[] = {
+	0x00, 0xC6, 0x85, 0x8E, 0x06, 0xB7, 0x04, 0x04, 0xE9, 0xCD, 0x9E, 0x3E,
+	0xCB, 0x66, 0x23, 0x95, 0xB4, 0x42, 0x9C, 0x64, 0x81, 0x39, 0x05, 0x3F,
+	0xB5, 0x21, 0xF8, 0x28, 0xAF, 0x60, 0x6B, 0x4D, 0x3D, 0xBA, 0xA1, 0x4B,
+	0x5E, 0x77, 0xEF, 0xE7, 0x59, 0x28, 0xFE, 0x1D, 0xC1, 0x27, 0xA2, 0xFF,
+	0xA8, 0xDE, 0x33, 0x48, 0xB3, 0xC1, 0x85, 0x6A, 0x42, 0x9B, 0xF9, 0x7E,
+	0x7E, 0x31, 0xC2, 0xE5, 0xBD, 0x66
+};
+static const unsigned char ecdh_p521_y[] = {
+	0x01, 0x18, 0x39, 0x29, 0x6a, 0x78, 0x9a, 0x3b, 0xc0, 0x04, 0x5c, 0x8a,
+	0x5f, 0xb4, 0x2c, 0x7d, 0x1b, 0xd9, 0x98, 0xf5, 0x44, 0x49, 0x57, 0x9b,
+	0x44, 0x68, 0x17, 0xaf, 0xbd, 0x17, 0x27, 0x3e, 0x66, 0x2c, 0x97, 0xee,
+	0x72, 0x99, 0x5e, 0xf4, 0x26, 0x40, 0xc5, 0x50, 0xb9, 0x01, 0x3f, 0xad,
+	0x07, 0x61, 0x35, 0x3c, 0x70, 0x86, 0xa2, 0x72, 0xc2, 0x40, 0x88, 0xbe,
+	0x94, 0x76, 0x9f, 0xd1, 0x66, 0x50
+};
+static const unsigned char ecdh_p521_n[] = {
+	0x01, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFA, 0x51, 0x86,
+	0x87, 0x83, 0xBF, 0x2F, 0x96, 0x6B, 0x7F, 0xCC, 0x01, 0x48, 0xF7, 0x09,
+	0xA5, 0xD0, 0x3B, 0xB5, 0xC9, 0xB8, 0x89, 0x9C, 0x47, 0xAE, 0xBB, 0x6F,
+	0xB7, 0x1E, 0x91, 0x38, 0x64, 0x09
+};
+
+static const struct curve_param_desc ecdh_curve_list[] = {
+	{
+		.id = ECC_CURVE_NIST_P192,
+		.p = ecdh_p192_p,
+		.a = ecdh_p192_a,
+		.b = ecdh_p192_b,
+		.gx = ecdh_p192_x,
+		.gy = ecdh_p192_y,
+		.n = ecdh_p192_n,
+	}, {
+		.id = ECC_CURVE_NIST_P256,
+		.p = ecdh_p256_p,
+		.a = ecdh_p256_a,
+		.b = ecdh_p256_b,
+		.gx = ecdh_p256_x,
+		.gy = ecdh_p256_y,
+		.n = ecdh_p256_n,
+	}, {
+		.id = HPRE_ECC_CURVE_NIST_P128,
+		.p = ecdh_p128_p,
+		.a = ecdh_p128_a,
+		.b = ecdh_p128_b,
+		.gx = ecdh_p128_x,
+		.gy = ecdh_p128_y,
+		.n = ecdh_p128_n,
+	}, {
+		.id = HPRE_ECC_CURVE_NIST_P320,
+		.p = ecdh_p320_p,
+		.a = ecdh_p320_a,
+		.b = ecdh_p320_b,
+		.gx = ecdh_p320_x,
+		.gy = ecdh_p320_y,
+		.n = ecdh_p320_n,
+	}, {
+		.id = HPRE_ECC_CURVE_NIST_P384,
+		.p = ecdh_p384_p,
+		.a = ecdh_p384_a,
+		.b = ecdh_p384_b,
+		.gx = ecdh_p384_x,
+		.gy = ecdh_p384_y,
+		.n = ecdh_p384_n,
+	}, {
+		.id = HPRE_ECC_CURVE_NIST_P521,
+		.p = ecdh_p521_p,
+		.a = ecdh_p521_a,
+		.b = ecdh_p521_b,
+		.gx = ecdh_p521_x,
+		.gy = ecdh_p521_y,
+		.n = ecdh_p521_n,
+	}, {
+		.id = HPRE_ECC_CURVE_NIST_P224,
+		.p = ecdh_p224_p,
+		.a = ecdh_p224_a,
+		.b = ecdh_p224_b,
+		.gx = ecdh_p224_x,
+		.gy = ecdh_p224_y,
+		.n = ecdh_p224_n,
+	}
+};
+
 typedef void (*hpre_cb)(struct hpre_ctx *ctx, void *sqe);
 
 struct hpre_rsa_ctx {
@@ -61,14 +398,25 @@ struct hpre_dh_ctx {
 	 * else if base if the counterpart public key we
 	 * compute the shared secret
 	 *	ZZ = yb^xa mod p; [RFC2631 sec 2.1.1]
+	 * low address: d--->n, please refer to Hisilicon HPRE UM
 	 */
-	char *xa_p; /* low address: d--->n, please refer to Hisilicon HPRE UM */
+	char *xa_p;
 	dma_addr_t dma_xa_p;
 
 	char *g; /* m */
 	dma_addr_t dma_g;
 };
 
+struct hpre_ecdh_ctx {
+	/* low address: p->a->k->b */
+	unsigned char *p;
+	dma_addr_t dma_p;
+
+	/* low address: x->y */
+	unsigned char *g;
+	dma_addr_t dma_g;
+};
+
 struct hpre_ctx {
 	struct hisi_qp *qp;
 	struct hpre_asym_request **req_list;
@@ -80,7 +428,10 @@ struct hpre_ctx {
 	union {
 		struct hpre_rsa_ctx rsa;
 		struct hpre_dh_ctx dh;
+		struct hpre_ecdh_ctx ecdh;
 	};
+	/* for ecc algorithms */
+	unsigned int curve_id;
 };
 
 struct hpre_asym_request {
@@ -91,6 +442,7 @@ struct hpre_asym_request {
 	union {
 		struct akcipher_request *rsa;
 		struct kpp_request *dh;
+		struct kpp_request *ecdh;
 	} areq;
 	int err;
 	int req_id;
@@ -1115,6 +1467,416 @@ static void hpre_rsa_exit_tfm(struct crypto_akcipher *tfm)
 	crypto_free_akcipher(ctx->rsa.soft_tfm);
 }
 
+static void hpre_ecc_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all,
+			       bool is_ecdh)
+{
+	struct device *dev = HPRE_DEV(ctx);
+	unsigned int sz = ctx->key_sz;
+	unsigned int shift = sz << 1;
+
+	if (is_clear_all)
+		hisi_qm_stop_qp(ctx->qp);
+
+	if (is_ecdh && ctx->ecdh.p) {
+		/* ecdh: p->a->k->b */
+		memzero_explicit(ctx->ecdh.p + shift, sz);
+		dma_free_coherent(dev, sz << 3, ctx->ecdh.p, ctx->ecdh.dma_p);
+		ctx->ecdh.p = NULL;
+	}
+
+	ctx->curve_id = 0;
+	hpre_ctx_clear(ctx, is_clear_all);
+}
+
+/*
+ * only the bits of 128/192/224/256/320/384/521 are supported by HPRE,
+ * and convert the bits like:
+ * bits<=256, bits=256; 256<bits<=384, bits=384; 384<bits<=576, bits=576;
+ * If the parameter bit width is insufficient, then we fill in the
+ * high-order zeros by soft, so TASK_LENGTH1 is 0x3/0x5/0x8;
+ */
+static unsigned int hpre_ecdh_supported_curve(unsigned int curve_id)
+{
+	switch (curve_id) {
+	case ECC_CURVE_NIST_P192:
+	case ECC_CURVE_NIST_P256:
+	case HPRE_ECC_CURVE_NIST_P128:
+	case HPRE_ECC_CURVE_NIST_P224:
+		return HPRE_ECC_HW256_KSZ_B;
+	case HPRE_ECC_CURVE_NIST_P320:
+	case HPRE_ECC_CURVE_NIST_P384:
+		return HPRE_ECC_HW384_KSZ_B;
+	case HPRE_ECC_CURVE_NIST_P521:
+		return HPRE_ECC_HW576_KSZ_B;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static const struct curve_param_desc *ecdh_get_curve_param(__u32 curve_id)
+{
+	if (curve_id >= 1 && curve_id <= ARRAY_SIZE(ecdh_curve_list))
+		return &ecdh_curve_list[curve_id - 1];
+
+	return NULL;
+}
+
+static int hpre_ecdh_fill_curve(struct hpre_ctx *ctx, struct ecdh *params,
+				unsigned int cur_sz)
+{
+	unsigned int shifta = ctx->key_sz << 1;
+	unsigned int shiftb = ctx->key_sz << 2;
+	void *p = ctx->ecdh.p + ctx->key_sz - cur_sz;
+	void *a = ctx->ecdh.p + shifta - cur_sz;
+	void *b = ctx->ecdh.p + shiftb - cur_sz;
+	void *x = ctx->ecdh.g + ctx->key_sz - cur_sz;
+	void *y = ctx->ecdh.g + shifta - cur_sz;
+	const struct curve_param_desc *curve;
+	char *n;
+
+	n = kzalloc(ctx->key_sz, GFP_KERNEL);
+	if (!n)
+		return -ENOMEM;
+
+	curve = ecdh_get_curve_param(params->curve_id);
+	if (!curve)
+		goto free;
+
+	memcpy(p, curve->p, cur_sz);
+	memcpy(a, curve->a, cur_sz);
+	memcpy(b, curve->b, cur_sz);
+	memcpy(x, curve->gx, cur_sz);
+	memcpy(y, curve->gy, cur_sz);
+	memcpy(n, curve->n, cur_sz);
+
+	if (params->key_size == cur_sz && strcmp(params->key, n) >= 0)
+		goto free;
+
+	kfree(n);
+	return 0;
+
+free:
+	kfree(n);
+	return -EINVAL;
+}
+
+static unsigned int hpre_ecdh_get_curvesz(unsigned short id)
+{
+	switch (id) {
+	case ECC_CURVE_NIST_P192:
+		return HPRE_ECC_NIST_P192_N_SIZE;
+	case ECC_CURVE_NIST_P256:
+		return HPRE_ECC_NIST_P256_N_SIZE;
+	case HPRE_ECC_CURVE_NIST_P128:
+		return HPRE_ECC_NIST_P128_N_SIZE;
+	case HPRE_ECC_CURVE_NIST_P224:
+		return HPRE_ECC_NIST_P224_N_SIZE;
+	case HPRE_ECC_CURVE_NIST_P320:
+		return HPRE_ECC_NIST_P320_N_SIZE;
+	case HPRE_ECC_CURVE_NIST_P384:
+		return HPRE_ECC_NIST_P384_N_SIZE;
+	case HPRE_ECC_CURVE_NIST_P521:
+		return HPRE_ECC_NIST_P521_N_SIZE;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int hpre_ecdh_set_param(struct hpre_ctx *ctx, struct ecdh *params)
+{
+	struct device *dev = HPRE_DEV(ctx);
+	unsigned int sz, shift, curve_sz;
+	int ret;
+
+	ctx->key_sz = hpre_ecdh_supported_curve(params->curve_id);
+	if (!ctx->key_sz)
+		return -EINVAL;
+
+	curve_sz = hpre_ecdh_get_curvesz(params->curve_id);
+	if (!curve_sz || params->key_size > curve_sz)
+		return -EINVAL;
+
+	sz = ctx->key_sz;
+	ctx->curve_id = params->curve_id;
+
+	if (!ctx->ecdh.p) {
+		ctx->ecdh.p = dma_alloc_coherent(dev, sz << 3, &ctx->ecdh.dma_p,
+						 GFP_KERNEL);
+		if (!ctx->ecdh.p)
+			return -ENOMEM;
+	}
+
+	shift = sz << 2;
+	ctx->ecdh.g = ctx->ecdh.p + shift;
+	ctx->ecdh.dma_g = ctx->ecdh.dma_p + shift;
+
+	ret = hpre_ecdh_fill_curve(ctx, params, curve_sz);
+	if (ret) {
+		dma_free_coherent(dev, sz << 3, ctx->ecdh.p, ctx->ecdh.dma_p);
+		dev_err(dev, "failed to fill curve_param, ret = %d!\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static bool hpre_key_is_valid(char *key, unsigned short key_sz)
+{
+	int i;
+
+	for (i = 0; i < key_sz; i++)
+		if (key[i])
+			return true;
+
+	return false;
+}
+
+static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
+				unsigned int len)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct device *dev = HPRE_DEV(ctx);
+	unsigned int sz, sz_shift;
+	struct ecdh params;
+	int ret;
+
+	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
+		dev_err(dev, "failed to decode ecdh key!\n");
+		return -EINVAL;
+	}
+
+	if (!hpre_key_is_valid(params.key, params.key_size)) {
+		dev_err(dev, "Invalid hpre key!\n");
+		return -EINVAL;
+	}
+
+	hpre_ecc_clear_ctx(ctx, false, true);
+
+	ret = hpre_ecdh_set_param(ctx, &params);
+	if (ret < 0) {
+		dev_err(dev, "failed to set hpre param, ret = %d!\n", ret);
+		goto err_clear_ctx;
+	}
+
+	sz = ctx->key_sz;
+	sz_shift = (sz << 1) + sz - params.key_size;
+	memcpy(ctx->ecdh.p + sz_shift, params.key, params.key_size);
+	return 0;
+
+err_clear_ctx:
+	hpre_ecc_clear_ctx(ctx, false, true);
+	return ret;
+}
+
+static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
+				      struct hpre_asym_request *req,
+				      struct scatterlist *dst,
+				      struct scatterlist *src)
+{
+	struct device *dev = HPRE_DEV(ctx);
+	struct hpre_sqe *sqe = &req->req;
+	dma_addr_t dma;
+
+	dma = le64_to_cpu(sqe->in);
+	if (unlikely(!dma))
+		return;
+
+	if (src && req->src)
+		dma_free_coherent(dev, ctx->key_sz << 2, req->src, dma);
+
+	dma = le64_to_cpu(sqe->out);
+	if (unlikely(!dma))
+		return;
+
+	if (req->dst)
+		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
+	if (dst)
+		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
+}
+
+static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
+{
+	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
+	struct hpre_asym_request *req = NULL;
+	struct kpp_request *areq;
+	u64 overtime_thrhld;
+	int ret;
+
+	ret = hpre_alg_res_post_hf(ctx, resp, (void **)&req);
+	areq = req->areq.ecdh;
+	areq->dst_len = ctx->key_sz << 1;
+
+	overtime_thrhld = atomic64_read(&dfx[HPRE_OVERTIME_THRHLD].value);
+	if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
+		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
+
+	hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);
+	kpp_request_complete(areq, ret);
+
+	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
+}
+
+static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
+				     struct kpp_request *req)
+{
+	struct hpre_asym_request *h_req;
+	struct hpre_sqe *msg;
+	int req_id;
+	void *tmp;
+
+	if (req->dst_len < ctx->key_sz << 1) {
+		req->dst_len = ctx->key_sz << 1;
+		return -EINVAL;
+	}
+
+	tmp = kpp_request_ctx(req);
+	h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
+	h_req->cb = hpre_ecdh_cb;
+	h_req->areq.ecdh = req;
+	msg = &h_req->req;
+	memset(msg, 0, sizeof(*msg));
+	msg->key = cpu_to_le64(ctx->ecdh.dma_p);
+
+	msg->dw0 |= cpu_to_le32(0x1U << HPRE_SQE_DONE_SHIFT);
+	msg->task_len1 = (ctx->key_sz >> HPRE_BITS_2_BYTES_SHIFT) - 1;
+	h_req->ctx = ctx;
+
+	req_id = hpre_add_req_to_ctx(h_req);
+	if (req_id < 0)
+		return -EBUSY;
+
+	msg->tag = cpu_to_le16((u16)req_id);
+	return 0;
+}
+
+static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
+				   struct scatterlist *data, unsigned int len)
+{
+	struct hpre_sqe *msg = &hpre_req->req;
+	struct hpre_ctx *ctx = hpre_req->ctx;
+	struct device *dev = HPRE_DEV(ctx);
+	unsigned int tmpshift;
+	dma_addr_t dma = 0;
+	void *ptr;
+	int shift;
+
+	/* Src_data include gx and gy. */
+	shift = ctx->key_sz - (len >> 1);
+	if (unlikely(shift < 0))
+		return -EINVAL;
+
+	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, GFP_KERNEL);
+	if (unlikely(!ptr))
+		return -ENOMEM;
+
+	tmpshift = ctx->key_sz << 1;
+	scatterwalk_map_and_copy(ptr + tmpshift, data, 0, len, 0);
+	memcpy(ptr + shift, ptr + tmpshift, len >> 1);
+	memcpy(ptr + ctx->key_sz + shift, ptr + tmpshift + (len >> 1), len >> 1);
+
+	hpre_req->src = ptr;
+	msg->in = cpu_to_le64(dma);
+	return 0;
+}
+
+static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
+				   struct scatterlist *data, unsigned int len)
+{
+	struct hpre_sqe *msg = &hpre_req->req;
+	struct hpre_ctx *ctx = hpre_req->ctx;
+	struct device *dev = HPRE_DEV(ctx);
+	unsigned int dst_len;
+	dma_addr_t dma = 0;
+	void *ptr;
+
+	if (sg_is_last(data)) {
+		hpre_req->dst = NULL;
+		dma = dma_map_single(dev, sg_virt(data), len, DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(dev, dma))) {
+			dev_err(dev, "dma map data err!\n");
+			return -ENOMEM;
+		}
+	} else {
+		dst_len = ctx->key_sz << 1;
+		ptr = dma_alloc_coherent(dev, dst_len, &dma, GFP_KERNEL);
+		if (unlikely(!ptr))
+			return -ENOMEM;
+		hpre_req->dst = ptr;
+	}
+
+	msg->out = cpu_to_le64(dma);
+	return 0;
+}
+
+static int hpre_ecdh_compute_value(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct device *dev = HPRE_DEV(ctx);
+	void *tmp = kpp_request_ctx(req);
+	struct hpre_asym_request *hpre_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
+	struct hpre_sqe *msg = &hpre_req->req;
+	int ret;
+
+	ret = hpre_ecdh_msg_request_set(ctx, req);
+	if (unlikely(ret)) {
+		dev_err(dev, "failed to set ecdh request, ret = %d!\n", ret);
+		return ret;
+	}
+
+	if (req->src) {
+		ret = hpre_ecdh_src_data_init(hpre_req, req->src, req->src_len);
+		if (unlikely(ret)) {
+			dev_err(dev, "failed to init src data, ret = %d!\n", ret);
+			goto clear_all;
+		}
+	} else {
+		msg->in = cpu_to_le64(ctx->ecdh.dma_g);
+	}
+
+	ret = hpre_ecdh_dst_data_init(hpre_req, req->dst, req->dst_len);
+	if (unlikely(ret)) {
+		dev_err(dev, "failed to init dst data, ret = %d!\n", ret);
+		goto clear_all;
+	}
+
+	msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) | HPRE_ALG_ECC_MUL);
+	ret = hpre_send(ctx, msg);
+	if (likely(!ret))
+		return -EINPROGRESS;
+
+clear_all:
+	hpre_rm_req_from_ctx(hpre_req);
+	hpre_ecdh_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
+	return ret;
+}
+
+static unsigned int hpre_ecdh_max_size(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	/* max size is the pub_key_size, include x and y */
+	return ctx->key_sz << 1;
+}
+
+static int hpre_ecdh_init_tfm(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+}
+
+static void hpre_ecdh_exit_tfm(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	hpre_ecc_clear_ctx(ctx, true, true);
+}
+
 static struct akcipher_alg rsa = {
 	.sign = hpre_rsa_dec,
 	.verify = hpre_rsa_enc,
@@ -1154,6 +1916,22 @@ static struct kpp_alg dh = {
 };
 #endif
 
+static struct kpp_alg ecdh = {
+	.set_secret = hpre_ecdh_set_secret,
+	.generate_public_key = hpre_ecdh_compute_value,
+	.compute_shared_secret = hpre_ecdh_compute_value,
+	.max_size = hpre_ecdh_max_size,
+	.init = hpre_ecdh_init_tfm,
+	.exit = hpre_ecdh_exit_tfm,
+	.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
+	.base = {
+		.cra_ctxsize = sizeof(struct hpre_ctx),
+		.cra_priority = HPRE_CRYPTO_ALG_PRI,
+		.cra_name = "ecdh",
+		.cra_driver_name = "hpre-ecdh",
+		.cra_module = THIS_MODULE,
+	},
+};
 int hpre_algs_register(struct hisi_qm *qm)
 {
 	int ret;
@@ -1164,17 +1942,33 @@ int hpre_algs_register(struct hisi_qm *qm)
 		return ret;
 #ifdef CONFIG_CRYPTO_DH
 	ret = crypto_register_kpp(&dh);
-	if (ret)
+	if (ret) {
 		crypto_unregister_akcipher(&rsa);
+		return ret;
+	}
 #endif
 
-	return ret;
+	if (qm->ver >= QM_HW_V3) {
+		ret = crypto_register_kpp(&ecdh);
+		if (ret) {
+#ifdef CONFIG_CRYPTO_DH
+			crypto_unregister_kpp(&dh);
+#endif
+			crypto_unregister_akcipher(&rsa);
+			return ret;
+		}
+	}
+
+	return 0;
 }
 
 void hpre_algs_unregister(struct hisi_qm *qm)
 {
-	crypto_unregister_akcipher(&rsa);
+	if (qm->ver >= QM_HW_V3)
+		crypto_unregister_kpp(&ecdh);
+
 #ifdef CONFIG_CRYPTO_DH
 	crypto_unregister_kpp(&dh);
 #endif
+	crypto_unregister_akcipher(&rsa);
 }
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 1ae8fa1..2ccc3dc 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1020,4 +1020,5 @@ module_exit(hpre_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Zaibo Xu <xuzaibo@huawei.com>");
+MODULE_AUTHOR("Meng Yu <yumeng18@huawei.com>");
 MODULE_DESCRIPTION("Driver for HiSilicon HPRE accelerator");
-- 
2.8.1

