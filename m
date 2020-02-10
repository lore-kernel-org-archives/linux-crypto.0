Return-Path: <SRS0=9Lzg=36=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCE4C352A4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 12:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 793572051A
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Feb 2020 12:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbgBJMou (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Feb 2020 07:44:50 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:60893 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730700AbgBJMou (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Feb 2020 07:44:50 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Tpbr4vV_1581338685;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0Tpbr4vV_1581338685)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 10 Feb 2020 20:44:45 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, ebiggers@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ima: add sm3 algorithm to hash algorithm configuration list
Date:   Mon, 10 Feb 2020 20:44:40 +0800
Message-Id: <20200210124440.23929-3-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200210124440.23929-1-tianjia.zhang@linux.alibaba.com>
References: <20200210124440.23929-1-tianjia.zhang@linux.alibaba.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

sm3 has been supported by the ima hash algorithm, but it is not
yet in the Kconfig configuration list. After adding, both ima and tpm2
can support sm3 well.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 security/integrity/ima/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 838476d780e5..ace6762c1cf1 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -112,6 +112,10 @@ choice
 	config IMA_DEFAULT_HASH_WP512
 		bool "WP512"
 		depends on CRYPTO_WP512=y && !IMA_TEMPLATE
+
+	config IMA_DEFAULT_HASH_SM3
+		bool "SM3"
+		depends on CRYPTO_SM3=y && !IMA_TEMPLATE
 endchoice
 
 config IMA_DEFAULT_HASH
@@ -121,6 +125,7 @@ config IMA_DEFAULT_HASH
 	default "sha256" if IMA_DEFAULT_HASH_SHA256
 	default "sha512" if IMA_DEFAULT_HASH_SHA512
 	default "wp512" if IMA_DEFAULT_HASH_WP512
+	default "sm3" if IMA_DEFAULT_HASH_SM3
 
 config IMA_WRITE_POLICY
 	bool "Enable multiple writes to the IMA policy"
-- 
2.17.1

