Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD9AC352A2
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 09:22:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C7BB20838
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 09:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgBGJWi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 04:22:38 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:58115 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726451AbgBGJWi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 04:22:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04455;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0TpLWpJm_1581067344;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TpLWpJm_1581067344)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 07 Feb 2020 17:22:24 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ima: add sm3-256 algorithm to hash algorithm configuration list
Date:   Fri,  7 Feb 2020 17:22:19 +0800
Message-Id: <20200207092219.115056-3-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200207092219.115056-1-tianjia.zhang@linux.alibaba.com>
References: <20200207092219.115056-1-tianjia.zhang@linux.alibaba.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

sm3-256 has been supported by the ima hash algorithm, but it is not
yet in the Kconfig configuration list. After adding, both ima and tpm2
can support sm3-256 well.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 security/integrity/ima/Kconfig | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 838476d780e5..27b5df895808 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -112,6 +112,10 @@ choice
 	config IMA_DEFAULT_HASH_WP512
 		bool "WP512"
 		depends on CRYPTO_WP512=y && !IMA_TEMPLATE
+
+	config IMA_DEFAULT_HASH_SM3_256
+		bool "SM3_256"
+		depends on CRYPTO_SM3=y && !IMA_TEMPLATE
 endchoice
 
 config IMA_DEFAULT_HASH
@@ -121,6 +125,7 @@ config IMA_DEFAULT_HASH
 	default "sha256" if IMA_DEFAULT_HASH_SHA256
 	default "sha512" if IMA_DEFAULT_HASH_SHA512
 	default "wp512" if IMA_DEFAULT_HASH_WP512
+	default "sm3-256" if IMA_DEFAULT_HASH_SM3_256
 
 config IMA_WRITE_POLICY
 	bool "Enable multiple writes to the IMA policy"
-- 
2.17.1

