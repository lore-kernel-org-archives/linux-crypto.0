Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 523D5C5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B84B20644
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="WfIbKHBa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfF1E1l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 00:27:41 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:58828 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfF1E1k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 00:27:40 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RXFV020836;
        Thu, 27 Jun 2019 23:27:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561696053;
        bh=LRrIRoI605SGe2Kd9jqNqCwySQtTN507at5OWZZ7EhQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=WfIbKHBaPYEcA6K9XLn1DmoHpG1ILHG/pIyTyRjTw5dqD5JLu7ARO+3qEz6rIwEp2
         gsvNH5RSUMNtnjsqbdnKup8UEwZyddFcgaQGnxj997Z6ApK5bJISBej2U7vv4iQ716
         HPW49EwC5czGc03/lIIq+qPo53T6RGVOFwJJYbhg=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S4RXLJ021546
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Jun 2019 23:27:33 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 27
 Jun 2019 23:27:32 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 27 Jun 2019 23:27:32 -0500
Received: from a0393675ula.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RKPN062595;
        Thu, 27 Jun 2019 23:27:30 -0500
From:   Keerthy <j-keerthy@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <j-keerthy@ti.com>, <linux-crypto@vger.kernel.org>, <nm@ti.com>
Subject: [RESEND PATCH 03/10] crypto: sa2ul: Add AES ECB Mode support
Date:   Fri, 28 Jun 2019 09:57:38 +0530
Message-ID: <20190628042745.28455-4-j-keerthy@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628042745.28455-1-j-keerthy@ti.com>
References: <20190628042745.28455-1-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for AES algorithm in ECB Mode. Data encryption modes
are supported via MCE engine (programmable mode control engine).
ECB (Electronic code book) is a mode of operation for a block cipher,
with the characteristic that each possible block of plaintext has a
defined corresponding ciphertext value and vice versa. In other words,
the same plaintext value will always result in the same ciphertext value.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/crypto/sa2ul.c | 76 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 64bdf6b2b879..a17c1f66c5c1 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -178,6 +178,38 @@ static u8 mci_cbc_dec_array[3][MODE_CONTROL_BYTES] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
 };
 
+/*
+ * Mode Control Instructions for various Key lengths 128, 192, 256
+ * For ECB (Electronic Code Book) mode for encryption
+ */
+static u8 mci_ecb_enc_array[3][27] = {
+	{	0x21, 0x00, 0x00, 0x80, 0x8a, 0x04, 0xb7, 0x90, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+	{	0x21, 0x00, 0x00, 0x84, 0x8a, 0x04, 0xb7, 0x90, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+	{	0x21, 0x00, 0x00, 0x88, 0x8a, 0x04, 0xb7, 0x90, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+};
+
+/*
+ * Mode Control Instructions for various Key lengths 128, 192, 256
+ * For ECB (Electronic Code Book) mode for decryption
+ */
+static u8 mci_ecb_dec_array[3][27] = {
+	{	0x31, 0x00, 0x00, 0x80, 0x8a, 0x04, 0xb7, 0x90, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+	{	0x31, 0x00, 0x00, 0x84, 0x8a, 0x04, 0xb7, 0x90, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+	{	0x31, 0x00, 0x00, 0x88, 0x8a, 0x04, 0xb7, 0x90, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
+};
+
 /*
  * Perform 16 byte or 128 bit swizzling
  * The SA2UL Expects the security context to
@@ -746,6 +778,26 @@ static int sa_aes_cbc_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	return sa_aes_setkey(tfm, key, keylen, ad);
 }
 
+static int sa_aes_ecb_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+			     unsigned int keylen)
+{
+	struct algo_data *ad = kzalloc(sizeof(*ad), GFP_KERNEL);
+	/* Convert the key size (16/24/32) to the key size index (0/1/2) */
+	int key_idx = (keylen >> 3) - 2;
+
+	ad->enc_eng.eng_id = SA_ENG_ID_EM1;
+	ad->enc_eng.sc_size = SA_CTX_ENC_TYPE1_SZ;
+	ad->auth_eng.eng_id = SA_ENG_ID_NONE;
+	ad->auth_eng.sc_size = 0;
+	ad->mci_enc = mci_ecb_enc_array[key_idx];
+	ad->mci_dec = mci_ecb_dec_array[key_idx];
+	ad->inv_key = true;
+	ad->ealg_id = SA_EALG_ID_AES_ECB;
+	ad->aalg_id = SA_AALG_ID_NONE;
+
+	return sa_aes_setkey(tfm, key, keylen, ad);
+}
+
 static void sa_aes_dma_in_callback(void *data)
 {
 	struct sa_rx_data *rxd = (struct sa_rx_data *)data;
@@ -940,6 +992,30 @@ static struct sa_alg_tmpl sa_algs[] = {
 					}
 			}
 	},
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
+			.cra_name = "ecb(aes)",
+			.cra_driver_name = "ecb-aes-sa2ul",
+			.cra_priority = 30000,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_KERN_DRIVER_ONLY |
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sa_tfm_ctx),
+			.cra_alignmask = 0,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_module = THIS_MODULE,
+			.cra_init = sa_aes_cra_init,
+			.cra_exit = sa_aes_cra_exit,
+			.cra_u.ablkcipher = {
+				.min_keysize    = AES_MIN_KEY_SIZE,
+				.max_keysize    = AES_MAX_KEY_SIZE,
+				.setkey		= sa_aes_ecb_setkey,
+				.encrypt	= sa_aes_cbc_encrypt,
+				.decrypt	= sa_aes_cbc_decrypt,
+			}
+		}
+	},
 };
 
 /* Register the algorithms in crypto framework */
-- 
2.17.1

