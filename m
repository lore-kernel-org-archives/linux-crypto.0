Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E62CDC10F0E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 12:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C178320693
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 12:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbfDOMgH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 08:36:07 -0400
Received: from [110.188.70.11] ([110.188.70.11]:62757 "EHLO spam1.hygon.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726298AbfDOMgH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 08:36:07 -0400
Received: from spam1.hygon.cn (localhost [127.0.0.2] (may be forged))
        by spam1.hygon.cn with ESMTP id x3FC9UDZ026863;
        Mon, 15 Apr 2019 20:09:30 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from MK-DB.hygon.cn ([172.23.18.60])
        by spam1.hygon.cn with ESMTP id x3FC7BGj026673;
        Mon, 15 Apr 2019 20:07:11 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from cncheex02.Hygon.cn ([172.23.18.12])
        by MK-DB.hygon.cn with ESMTP id x3FC73nU053922;
        Mon, 15 Apr 2019 20:07:03 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from harry-Inspiron-5675.higon.com (172.23.18.44) by
 cncheex02.Hygon.cn (172.23.18.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Mon, 15 Apr
 2019 20:07:07 +0800
From:   Hao Feng <fenghao@hygon.cn>
To:     "'Tom Lendacky '" <thomas.lendacky@amd.com>,
        "'Gary Hook '" <gary.hook@amd.com>,
        "'Herbert Xu '" <herbert@gondor.apana.org.au>,
        "' David S. Miller '" <davem@davemloft.net>,
        "'Janakarajan Natarajan '" <Janakarajan.Natarajan@amd.com>
CC:     "'Zhaohui Du '" <duzhaohui@hygon.cn>,
        "'Zhiwei Ying '" <yingzhiwei@hygon.cn>,
        "'Wen Pu '" <puwen@hygon.cn>, Hao Feng <fenghao@hygon.cn>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] crypto: ccp: Define Hygon SEV commands
Date:   Mon, 15 Apr 2019 20:04:24 +0800
Message-ID: <1555329868-17895-3-git-send-email-fenghao@hygon.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
References: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.23.18.44]
X-ClientProxiedBy: cncheex02.Hygon.cn (172.23.18.12) To cncheex02.Hygon.cn
 (172.23.18.12)
X-MAIL: spam1.hygon.cn x3FC7BGj026673
X-DNSRBL: 
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. SEV_CMD_GM_PUBKEY_GEN - Get SM2 random public key from SEV firmware
to start SM2 key exchange.

2. SEV_CMD_GM_GET_DIGEST - Get key digest from SEV firmware during SM2
key exchange.

3. SEV_CMD_GM_VERIFY_DIGEST - Verify guest owner's key digest during
SM2 key exchange.

Signed-off-by: Hao Feng <fenghao@hygon.cn>
---
 drivers/crypto/ccp/psp-dev.c |  3 +++
 include/linux/psp-sev.h      | 49 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index fadf859..fafebf4 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -139,6 +139,9 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_secret);
 	case SEV_CMD_DOWNLOAD_FIRMWARE:		return sizeof(struct sev_data_download_firmware);
 	case SEV_CMD_GET_ID:			return sizeof(struct sev_data_get_id);
+	case SEV_CMD_GM_PUBKEY_GEN:		return sizeof(struct sev_data_gm_pubkey_gen);
+	case SEV_CMD_GM_GET_DIGEST:		return sizeof(struct sev_data_gm_get_digest);
+	case SEV_CMD_GM_VERIFY_DIGEST:		return sizeof(struct sev_data_gm_verify_digest);
 	default:				return 0;
 	}
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 827c601..0171849 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -87,6 +87,11 @@ enum sev_cmd {
 	SEV_CMD_DBG_DECRYPT		= 0x060,
 	SEV_CMD_DBG_ENCRYPT		= 0x061,
 
+	/* GM specific commands */
+	SEV_CMD_GM_PUBKEY_GEN		= 0x070,
+	SEV_CMD_GM_GET_DIGEST		= 0x071,
+	SEV_CMD_GM_VERIFY_DIGEST	= 0x072,
+
 	SEV_CMD_MAX,
 };
 
@@ -485,6 +490,50 @@ struct sev_data_dbg {
 	u32 len;				/* In */
 } __packed;
 
+/**
+ * struct sev_data_gm_pubkey_gen - GM_PUBKEY_GEN command parameters
+ *
+ * @key_id_address: physical address containing key id
+ * @key_id_len: len of key id
+ * @pubkey_address: physical address containing GM public key
+ * @pubkey_len: len of GM public key
+ */
+struct sev_data_gm_pubkey_gen {
+	u64 key_id_address;		/* In */
+	u32 key_id_len;			/* In */
+	u32 reserved;
+	u64 pubkey_address;		/* In */
+	u32 pubkey_len;			/* In/Out */
+} __packed;
+
+/**
+ * struct sev_data_gm_get_digest - GM_GET_DIGEST command parameters
+ *
+ * @handle: handle of the VM to process
+ * @address: physical address containing the digest blob
+ * @len: len of digest blob
+ */
+struct sev_data_gm_get_digest {
+	u32 handle;				/* In */
+	u32 reserved;
+	u64 address;			/* In */
+	u32 len;				/* In/Out */
+} __packed;
+
+/**
+ * struct sev_data_gm_verify_digest - GM_VERIFY_DIGEST command parameters
+ *
+ * @handle: handle of the VM to verify
+ * @address: physical address containing the digest blob
+ * @len: len of digest blob
+ */
+struct sev_data_gm_verify_digest {
+	u32 handle;		/* In */
+	u32 reserved;
+	u64 address;	/* In */
+	u32 len;		/* In */
+};
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
-- 
2.7.4

