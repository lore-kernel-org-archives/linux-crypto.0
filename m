Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC980C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7D602063F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="f1qXAIP6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfF1E2S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 00:28:18 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:59180 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfF1E1u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 00:27:50 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S4Rg4d105197;
        Thu, 27 Jun 2019 23:27:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561696062;
        bh=ZR7ExBieDCbC/Ll+RuC+Fd2NF0nFKFip1MVtigD4OPs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=f1qXAIP6HCPQQH7lTu6RLh3UbHLwFmii4R+4e8CLacP+CrnAiiatI3qLXXjLgpnWU
         G/i+4mD1rhrqCkRX5+AoLk14nmXUrIaUzT7UpjUwGatNpLPr37Z665o8ckH9FxjKQI
         lvaQF4RxoxLG8q7pwuZBRdz13yn+MboCKpoRcohA=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S4Rgg1113424
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Jun 2019 23:27:42 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 27
 Jun 2019 23:27:42 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 27 Jun 2019 23:27:42 -0500
Received: from a0393675ula.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RKPQ062595;
        Thu, 27 Jun 2019 23:27:39 -0500
From:   Keerthy <j-keerthy@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <j-keerthy@ti.com>, <linux-crypto@vger.kernel.org>, <nm@ti.com>
Subject: [RESEND PATCH 06/10] crypto: sa2ul: Add hmac(sha256)cbc(aes) AEAD Algo support
Date:   Fri, 28 Jun 2019 09:57:41 +0530
Message-ID: <20190628042745.28455-7-j-keerthy@ti.com>
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

Add aead support for hmac(sha256)cbc(aes) algorithm. Authenticated
encryption (AE) and authenticated encryption with associated data
(AEAD) is a form of encryption which simultaneously provides
confidentiality, integrity, and authenticity assurances on the data.

hmac(sha256) has a digest size of 32 bytes is used for authetication
and AES in CBC mode is used in conjunction for encryption/decryption.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 drivers/crypto/sa2ul.c | 92 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 1a1bd882e0d2..9c9008e21867 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -271,6 +271,42 @@ void sa_hmac_sha1_get_pad(const u8 *key, u16 key_sz, u32 *ipad, u32 *opad)
 		opad[i] = cpu_to_be32(opad[i]);
 }
 
+void sha256_init(u32 *buf)
+{
+	buf[0] = SHA256_H0;
+	buf[1] = SHA256_H1;
+	buf[2] = SHA256_H2;
+	buf[3] = SHA256_H3;
+	buf[4] = SHA256_H4;
+	buf[5] = SHA256_H5;
+	buf[6] = SHA256_H6;
+	buf[7] = SHA256_H7;
+}
+
+static void sa_hmac_sha256_get_pad(const u8 *key, u16 key_sz, u32 *ipad,
+				   u32 *opad)
+{
+	u8 k_ipad[SHA_MESSAGE_BYTES];
+	u8 k_opad[SHA_MESSAGE_BYTES];
+	int i;
+
+	prepare_kiopad(k_ipad, k_opad, key, key_sz);
+
+	/* SHA-256 on k_ipad */
+	sha256_init(ipad);
+	sha256_transform(ipad, k_ipad);
+
+	for (i = 0; i < SHA256_DIGEST_WORDS; i++)
+		ipad[i] = cpu_to_be32(ipad[i]);
+
+	/* SHA-256 on k_opad */
+	sha256_init(opad);
+	sha256_transform(opad, k_opad);
+
+	for (i = 0; i < SHA256_DIGEST_WORDS; i++)
+		opad[i] = cpu_to_be32(opad[i]);
+}
+
 /* Derive the inverse key used in AES-CBC decryption operation */
 static inline int sa_aes_inv_key(u8 *inv_key, const u8 *key, u16 key_sz)
 {
@@ -1198,6 +1234,37 @@ static int sa_aead_cbc_sha1_setkey(struct crypto_aead *authenc,
 	return sa_aead_setkey(authenc, key, keylen, ad);
 }
 
+static int sa_aead_cbc_sha256_setkey(struct crypto_aead *authenc,
+				     const u8 *key, unsigned int keylen)
+{
+	struct algo_data *ad = kzalloc(sizeof(*ad), GFP_KERNEL);
+	struct crypto_authenc_keys keys;
+	int ret = 0, key_idx;
+
+	ret = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (ret)
+		return ret;
+
+	/* Convert the key size (16/24/32) to the key size index (0/1/2) */
+	key_idx = (keys.enckeylen >> 3) - 2;
+
+	ad->enc_eng.eng_id = SA_ENG_ID_EM1;
+	ad->enc_eng.sc_size = SA_CTX_ENC_TYPE1_SZ;
+	ad->auth_eng.eng_id = SA_ENG_ID_AM1;
+	ad->auth_eng.sc_size = SA_CTX_AUTH_TYPE2_SZ;
+	ad->mci_enc = mci_cbc_enc_array[key_idx];
+	ad->mci_dec = mci_cbc_dec_array[key_idx];
+	ad->inv_key = true;
+	ad->keyed_mac = true;
+	ad->ealg_id = SA_EALG_ID_AES_CBC;
+	ad->aalg_id = SA_AALG_ID_HMAC_SHA2_256;
+	ad->hash_size = SHA256_DIGEST_SIZE;
+	ad->auth_ctrl = 0x4;
+	ad->prep_iopad = sa_hmac_sha256_get_pad;
+
+	return sa_aead_setkey(authenc, key, keylen, ad);
+}
+
 static int sa_aead_run(struct aead_request *req, u8 *iv, int enc)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
@@ -1418,6 +1485,31 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.decrypt = sa_aead_decrypt,
 		}
 	},
+	{.type	= CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+				.base = {
+				.cra_name = "authenc(hmac(sha256),cbc(aes))",
+				.cra_driver_name =
+					"authenc(hmac(sha256),cbc(aes))-keystone-sa",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AEAD |
+					CRYPTO_ALG_KERN_DRIVER_ONLY |
+					CRYPTO_ALG_ASYNC,
+				.cra_ctxsize = sizeof(struct sa_tfm_ctx),
+				.cra_module = THIS_MODULE,
+				.cra_alignmask = 0,
+				.cra_priority = 3000,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+
+			.init = sa_cra_init_aead,
+			.exit = sa_exit_tfm_aead,
+			.setkey = sa_aead_cbc_sha256_setkey,
+			.encrypt = sa_aead_encrypt,
+			.decrypt = sa_aead_decrypt,
+		}
+	},
 };
 
 /* Register the algorithms in crypto framework */
-- 
2.17.1

