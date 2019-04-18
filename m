Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D514C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8D5A217FA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbfDRNkC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:40:02 -0400
Received: from foss.arm.com ([217.140.101.70]:33524 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389005AbfDRNkC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:40:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15E0380D;
        Thu, 18 Apr 2019 06:40:02 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E8BC3F5AF;
        Thu, 18 Apr 2019 06:40:00 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/35] crypto: ccree: add SM4 protected keys support
Date:   Thu, 18 Apr 2019 16:38:42 +0300
Message-Id: <20190418133913.9122-8-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the registration for the SM4 based policy protected keys ciphers.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c | 36 ++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index d1754d1156ee..8acedbafbcb3 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -1578,6 +1578,42 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.min_hw_rev = CC_HW_REV_713,
 		.std_body = CC_STD_OSCCA,
 	},
+	{
+		.name = "cbc(psm4)",
+		.driver_name = "cbc-psm4-ccree",
+		.blocksize = SM4_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = SM4_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CBC,
+		.flow_mode = S_DIN_to_SM4,
+		.min_hw_rev = CC_HW_REV_713,
+		.std_body = CC_STD_OSCCA,
+		.sec_func = true,
+	},
+	{
+		.name = "ctr(psm4)",
+		.driver_name = "ctr-psm4-ccree",
+		.blocksize = SM4_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = SM4_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_CTR,
+		.flow_mode = S_DIN_to_SM4,
+		.min_hw_rev = CC_HW_REV_713,
+		.std_body = CC_STD_OSCCA,
+		.sec_func = true,
+	},
 };
 
 static struct cc_crypto_alg *cc_create_alg(const struct cc_alg_template *tmpl,
-- 
2.21.0

