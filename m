Return-Path: <SRS0=hy52=AG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8457BC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jun 2020 12:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D75320720
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jun 2020 12:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404852AbgFYM71 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jun 2020 08:59:27 -0400
Received: from mga04.intel.com ([192.55.52.120]:8441 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404845AbgFYM71 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jun 2020 08:59:27 -0400
IronPort-SDR: qmP23hgdpM0dyz8t3cDCL64JXXonSBeTvkIOQuxAWA3XWCYracFh1jrZGJcJyHynwm+gzM3cd1
 ENpfI4PvGzWg==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="142362238"
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="142362238"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2020 05:59:26 -0700
IronPort-SDR: QHjSwyKX4KhSilTRfZoK0PG7KZjxqb/L5cRfudW8BmjZkzvRlFvWXjWKhuiGlxJJOYbAdlmZeW
 kc0FZ9PGVHow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,279,1589266800"; 
   d="scan'208";a="301979118"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jun 2020 05:59:25 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/4] crypto: qat - validate xts key
Date:   Thu, 25 Jun 2020 13:59:02 +0100
Message-Id: <20200625125904.142840-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625125904.142840-1-giovanni.cabiddu@intel.com>
References: <20200625125904.142840-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Validate xts key using the function xts_verify_key() to prevent
malformed keys.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 6bea6f868395..11f36eafda0c 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -995,6 +995,12 @@ static int qat_alg_skcipher_ctr_setkey(struct crypto_skcipher *tfm,
 static int qat_alg_skcipher_xts_setkey(struct crypto_skcipher *tfm,
 				       const u8 *key, unsigned int keylen)
 {
+	int ret;
+
+	ret = xts_verify_key(tfm, key, keylen);
+	if (ret)
+		return ret;
+
 	return qat_alg_skcipher_setkey(tfm, key, keylen,
 				       ICP_QAT_HW_CIPHER_XTS_MODE);
 }
-- 
2.26.2

