Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFEFDC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ABC920760
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731039AbgF2Tp2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:45:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:58002 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387829AbgF2Tko (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:44 -0400
IronPort-SDR: sQDU65sbwKMJBaJpo/YD9eYziTFxBOHq2PDuGSyI7yEduEU/uuZE7VtQpw1c9rOU2Pvn3WYAR7
 uVnwowGQg7UA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="211091679"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="211091679"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 10:16:38 -0700
IronPort-SDR: b/ia9QQ8Pdm0iF1UD0geaYywFkKql6uBzX01MsPwFdVFCJl7hCrEALpkfIvwS++wd9foS1ANhc
 jIKR8iSHfvvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="264891342"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jun 2020 10:16:37 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 2/4] crypto: qat - validate xts key
Date:   Mon, 29 Jun 2020 18:16:18 +0100
Message-Id: <20200629171620.2989-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629171620.2989-1-giovanni.cabiddu@intel.com>
References: <20200629171620.2989-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Validate AES-XTS key using the function xts_verify_key() to prevent
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

