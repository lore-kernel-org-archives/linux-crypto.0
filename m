Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E955C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 08:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D4AA2080C
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 08:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728906AbgFZIEw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 04:04:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:37504 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728687AbgFZIEw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 04:04:52 -0400
IronPort-SDR: Yc5I6/lLStPtjosmA2OFopKDrTSx7ono9KxqxDwd4xGHd2eiOKsRMcrjui4V+5gm5bZ3pU9rZT
 NFPAwwr4JgAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9663"; a="146739888"
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="146739888"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 01:04:52 -0700
IronPort-SDR: JYr5GWMRWYcS5ncRuKw7QB2BAI7Vy2TnoI3gxOKm/y16OEgGYStMEL608mlAPAFUDO6+xA0nx/
 Ue37YEA+0IuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,282,1589266800"; 
   d="scan'208";a="479756346"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jun 2020 01:04:49 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 2/4] crypto: qat - validate xts key
Date:   Fri, 26 Jun 2020 09:04:27 +0100
Message-Id: <20200626080429.155450-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626080429.155450-1-giovanni.cabiddu@intel.com>
References: <20200626080429.155450-1-giovanni.cabiddu@intel.com>
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

