Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042E5C10F0E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 12:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF84820693
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 12:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbfDOMga (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 08:36:30 -0400
Received: from [110.188.70.11] ([110.188.70.11]:51454 "EHLO spam2.hygon.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727025AbfDOMga (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 08:36:30 -0400
Received: from spam2.hygon.cn (localhost [127.0.0.2] (may be forged))
        by spam2.hygon.cn with ESMTP id x3FC9jZf059355;
        Mon, 15 Apr 2019 20:09:45 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from MK-FE.hygon.cn ([172.23.18.61])
        by spam2.hygon.cn with ESMTP id x3FC7PM4059208;
        Mon, 15 Apr 2019 20:07:25 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from cncheex02.Hygon.cn ([172.23.18.12])
        by MK-FE.hygon.cn with ESMTP id x3FC6op0022121;
        Mon, 15 Apr 2019 20:06:50 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from harry-Inspiron-5675.higon.com (172.23.18.44) by
 cncheex02.Hygon.cn (172.23.18.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Mon, 15 Apr
 2019 20:07:20 +0800
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
Subject: [PATCH 3/6] crypto: ccp: Implement SEV_GM_PUBKEY_GEN ioctl command
Date:   Mon, 15 Apr 2019 20:04:25 +0800
Message-ID: <1555329868-17895-4-git-send-email-fenghao@hygon.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
References: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.23.18.44]
X-ClientProxiedBy: cncheex02.Hygon.cn (172.23.18.12) To cncheex02.Hygon.cn
 (172.23.18.12)
X-MAIL: spam2.hygon.cn x3FC7PM4059208
X-DNSRBL: 
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SEV_GM_PUBKEY_GEN command is used to get SM2 random public key
from SEV firmware to start SM2 key exchange, guest owner will use the
random public key to compute share key.

Signed-off-by: Hao Feng <fenghao@hygon.cn>
---
 drivers/crypto/ccp/psp-dev.c | 83 ++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/psp-sev.h | 17 +++++++++
 2 files changed, 100 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index fafebf4..c165847c 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -720,6 +720,86 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_do_gm_pubkey_gen(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_gm_pubkey_gen input;
+	void *key_id_blob = NULL, *pubkey_blob = NULL;
+	struct sev_data_gm_pubkey_gen *data;
+	int ret;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* Userspace wants to query the public key length. */
+	if (!input.pubkey_address ||
+	    !input.pubkey_len)
+		goto cmd;
+
+	/* Copy key id blob from userspace. */
+	key_id_blob = psp_copy_user_blob(input.key_id_address, input.key_id_len);
+	if (IS_ERR(key_id_blob)) {
+		ret = PTR_ERR(key_id_blob);
+		goto e_free;
+	}
+
+	data->key_id_address = __psp_pa(key_id_blob);
+	data->key_id_len = input.key_id_len;
+
+	/* Allocate a physically contiguous buffer to store the public key blob. */
+	if ((input.pubkey_len > SEV_FW_BLOB_MAX_SIZE) ||
+	    !access_ok(input.pubkey_address, input.pubkey_len)) {
+		ret = -EFAULT;
+		goto e_free_key_id;
+	}
+
+	pubkey_blob = kmalloc(input.pubkey_len, GFP_KERNEL);
+	if (!pubkey_blob) {
+		ret = -ENOMEM;
+		goto e_free_key_id;
+	}
+
+	data->pubkey_address = __psp_pa(pubkey_blob);
+	data->pubkey_len = input.pubkey_len;
+
+cmd:
+	/* If platform is not in INIT state then transition it to INIT. */
+	if (psp_master->sev_state != SEV_STATE_INIT) {
+		ret = __sev_platform_init_locked(&argp->error);
+		if (ret)
+			goto e_free_pubkey;
+	}
+
+	ret = __sev_do_cmd_locked(SEV_CMD_GM_PUBKEY_GEN, data, &argp->error);
+
+	/* If we query the length, FW responded with expected data. */
+	input.pubkey_len = data->pubkey_len;
+
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
+		ret = -EFAULT;
+		goto e_free_pubkey;
+	}
+
+	if (pubkey_blob) {
+		if (copy_to_user((void __user *)input.pubkey_address,
+				 pubkey_blob, input.pubkey_len)) {
+			ret = -EFAULT;
+			goto e_free_pubkey;
+		}
+	}
+
+e_free_pubkey:
+	kfree(pubkey_blob);
+e_free_key_id:
+	kfree(key_id_blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -766,6 +846,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_GET_ID:
 		ret = sev_ioctl_do_get_id(&input);
 		break;
+	case SEV_GM_PUBKEY_GEN:
+		ret = sev_ioctl_do_gm_pubkey_gen(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index ac8c60b..7482cbd 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -32,6 +32,8 @@ enum {
 	SEV_PEK_CERT_IMPORT,
 	SEV_GET_ID,
 
+	SEV_GM_PUBKEY_GEN,
+
 	SEV_MAX,
 };
 
@@ -136,6 +138,21 @@ struct sev_user_data_get_id {
 } __packed;
 
 /**
+ * struct sev_user_data_gm_pubkey_gen - GM_PUBKEY_GEN command parameters
+ *
+ * @key_id_address: address of key id
+ * @key_id_len: len of key id
+ * @pubkey_address: address of GM public key
+ * @pubkey_len: len of GM public key
+ */
+struct sev_user_data_gm_pubkey_gen {
+	__u64 key_id_address;		/* In */
+	__u32 key_id_len;			/* In */
+	__u64 pubkey_address;		/* In */
+	__u32 pubkey_len;			/* In/Out */
+} __packed;
+
+/**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
  * @cmd: SEV commands to execute
-- 
2.7.4

