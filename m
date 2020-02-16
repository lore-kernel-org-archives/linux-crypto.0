Return-Path: <SRS0=RXXs=4E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C515CC2BA83
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Feb 2020 09:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A58FB22522
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Feb 2020 09:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgBPJAC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Feb 2020 04:00:02 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:58615 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726203AbgBPJAC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Feb 2020 04:00:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07417;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Tq4ZmV._1581843595;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Tq4ZmV._1581843595)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 16 Feb 2020 16:59:55 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@kernel.org, pvanleeuwen@rambus.com, zohar@linux.ibm.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] crypto: testmgr - Add SM2 test vectors
Date:   Sun, 16 Feb 2020 16:59:26 +0800
Message-Id: <20200216085928.108838-6-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216085928.108838-1-tianjia.zhang@linux.alibaba.com>
References: <20200216085928.108838-1-tianjia.zhang@linux.alibaba.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add testmgr tests and vectors for SM2 asymmetric cipher.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 crypto/testmgr.c |  7 +++++++
 crypto/testmgr.h | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index db9b5ac878e7..ecc6b27c1dd3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5050,6 +5050,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(sha512_tv_template)
 		}
+	}, {
+		.alg = "sm2",
+		.test = alg_test_akcipher,
+		.fips_allowed = 1,
+		.suite = {
+			.akcipher = __VECS(sm2_tv_template)
+		}
 	}, {
 		.alg = "sm3",
 		.test = alg_test_hash,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 48da646651cb..d46720b07fcf 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -809,6 +809,22 @@ static const struct akcipher_testvec pkcs1pad_rsa_tv_template[] = {
 	}
 };
 
+/*
+ * SM2 test vectors.
+ */
+static const struct akcipher_testvec sm2_tv_template[] = {
+	{
+	.key =
+	"\xbd\xca\x64\x55\xa5\x5b\x9c\x27\x22\xd0\xf5\x80\xf7\xf3\xc5\x63"
+	"\x3c\xbf\xce\xe8\x55\x17\xaa\xa5\x7f\x11\x9b\x4b\x25\x56\x9b\x43",
+	.m = "\x39\xb3\x2c\x59\x82\xc7\xdf\x11\x8a\x64\x2d",
+	.c = NULL,
+	.key_len = 32,
+	.m_size = 11,
+	.c_size = 0,
+	}
+};
+
 static const struct kpp_testvec dh_tv_template[] = {
 	{
 	.secret =
-- 
2.17.1

