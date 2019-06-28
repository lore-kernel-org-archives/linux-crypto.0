Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE64C5B579
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 977322063F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="E5adlXvS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfF1E2B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 00:28:01 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:46424 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfF1E2A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 00:28:00 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S4Rpxq053756;
        Thu, 27 Jun 2019 23:27:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561696071;
        bh=0zvb4oMtQmrHpjjM5stcwnynpmyBJnr20M+fOpeBneo=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=E5adlXvStpirkGksVZe34Ewjpv2NrQ/U6P2LtEFE9HeZPbKiubPsu8eWwXJOL9jDY
         bEiVaigGsNiXcsG9hn9hKAcG9rKyZEDSXHKKTyg+zxoUh3TbefKbS0T6KOVaukqNRt
         pZf2PsBerwVsVNkBv7Sr7Ls9cNxtUnsSOsifDJ6Y=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S4RpVN077055
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Jun 2019 23:27:51 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 27
 Jun 2019 23:27:51 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 27 Jun 2019 23:27:51 -0500
Received: from a0393675ula.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RKPT062595;
        Thu, 27 Jun 2019 23:27:48 -0500
From:   Keerthy <j-keerthy@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <j-keerthy@ti.com>, <linux-crypto@vger.kernel.org>, <nm@ti.com>
Subject: [RESEND PATCH 09/10] sa2ul: Add 3DES ECB & CBC Mode support
Date:   Fri, 28 Jun 2019 09:57:44 +0530
Message-ID: <20190628042745.28455-10-j-keerthy@ti.com>
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

Triple DES (3DES), officially the Triple Data Encryption Algorithm
(TDEA or Triple DEA), is a symmetric-key block cipher, which applies
the DES cipher algorithm three times to each data block

Add 3DES ECB(Electronic code book) & CBC(Cipher Block Chaining)
Mode support.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/crypto/sa2ul.c | 112 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 74211cd21c62..8d535fc9867f 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -210,6 +210,35 @@ static u8 mci_ecb_dec_array[3][27] = {
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
 };
 
+/*
+ * Mode Control Instructions for DES algorithm
+ * For CBC (Cipher Block Chaining) mode and ECB mode
+ * encryption and for decryption respectively
+ */
+static u8 mci_cbc_3des_enc_array[MODE_CONTROL_BYTES] = {
+	0x20, 0x00, 0x00, 0x18, 0x88, 0x52, 0xaa, 0x4b, 0x7e, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00,
+};
+
+static u8 mci_cbc_3des_dec_array[MODE_CONTROL_BYTES] = {
+	0x30, 0x00, 0x00, 0x85, 0x0a, 0xca, 0x98, 0xf4, 0x40, 0xc0, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00,
+};
+
+static u8 mci_ecb_3des_enc_array[MODE_CONTROL_BYTES] = {
+	0x20, 0x00, 0x00, 0x85, 0x0a, 0x04, 0xb7, 0x90, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00,
+};
+
+static u8 mci_ecb_3des_dec_array[MODE_CONTROL_BYTES] = {
+	0x30, 0x00, 0x00, 0x85, 0x0a, 0x04, 0xb7, 0x90, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00,
+};
+
 /*
  * Perform 16 byte or 128 bit swizzling
  * The SA2UL Expects the security context to
@@ -877,6 +906,39 @@ static int sa_aes_ecb_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	return sa_aes_setkey(tfm, key, keylen, ad);
 }
 
+static int sa_3des_cbc_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct algo_data *ad = kzalloc(sizeof(*ad), GFP_KERNEL);
+
+	ad->enc_eng.eng_id = SA_ENG_ID_EM1;
+	ad->enc_eng.sc_size = SA_CTX_ENC_TYPE1_SZ;
+	ad->auth_eng.eng_id = SA_ENG_ID_NONE;
+	ad->auth_eng.sc_size = 0;
+	ad->mci_enc = mci_cbc_3des_enc_array;
+	ad->mci_dec = mci_cbc_3des_dec_array;
+	ad->ealg_id = SA_EALG_ID_3DES_CBC;
+	ad->aalg_id = SA_AALG_ID_NONE;
+
+	return sa_aes_setkey(tfm, key, keylen, ad);
+}
+
+static int sa_3des_ecb_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
+			      unsigned int keylen)
+{
+	struct algo_data *ad = kzalloc(sizeof(*ad), GFP_KERNEL);
+
+	ad->enc_eng.eng_id = SA_ENG_ID_EM1;
+	ad->enc_eng.sc_size = SA_CTX_ENC_TYPE1_SZ;
+	ad->auth_eng.eng_id = SA_ENG_ID_NONE;
+	ad->auth_eng.sc_size = 0;
+	ad->mci_enc = mci_ecb_3des_enc_array;
+	ad->mci_dec = mci_ecb_3des_dec_array;
+	ad->aalg_id = SA_AALG_ID_NONE;
+
+	return sa_aes_setkey(tfm, key, keylen, ad);
+}
+
 static void sa_aes_dma_in_callback(void *data)
 {
 	struct sa_rx_data *rxd = (struct sa_rx_data *)data;
@@ -1787,6 +1849,56 @@ static struct sa_alg_tmpl sa_algs[] = {
 			}
 		}
 	},
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
+			.cra_name = "cbc(des3_ede)",
+			.cra_driver_name = "cbc-des3-sa2ul",
+			.cra_priority = 30000,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_KERN_DRIVER_ONLY |
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sa_tfm_ctx),
+			.cra_alignmask = 0,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_module = THIS_MODULE,
+			.cra_init = sa_aes_cra_init,
+			.cra_exit = sa_aes_cra_exit,
+			.cra_u.ablkcipher = {
+				.min_keysize    = 3 * DES_KEY_SIZE,
+				.max_keysize    = 3 * DES_KEY_SIZE,
+				.ivsize		= DES_BLOCK_SIZE,
+				.setkey		= sa_3des_cbc_setkey,
+				.encrypt	= sa_aes_cbc_encrypt,
+				.decrypt	= sa_aes_cbc_decrypt,
+			}
+		}
+	},
+	{	.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.alg.crypto = {
+			.cra_name = "ecb(des3_ede)",
+			.cra_driver_name = "ecb-des3-sa2ul",
+			.cra_priority = 30000,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+					CRYPTO_ALG_KERN_DRIVER_ONLY |
+				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize = DES_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct sa_tfm_ctx),
+			.cra_alignmask = 0,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_module = THIS_MODULE,
+			.cra_init = sa_aes_cra_init,
+			.cra_exit = sa_aes_cra_exit,
+			.cra_u.ablkcipher = {
+				.min_keysize    = 3 * DES_KEY_SIZE,
+				.max_keysize    = 3 * DES_KEY_SIZE,
+				.ivsize		= DES_BLOCK_SIZE,
+				.setkey		= sa_3des_ecb_setkey,
+				.encrypt	= sa_aes_cbc_encrypt,
+				.decrypt	= sa_aes_cbc_decrypt,
+			}
+		}
+	},
 	/* AEAD algorithms */
 	{.type	= CRYPTO_ALG_TYPE_AEAD,
 		.alg.aead = {
-- 
2.17.1

