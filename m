Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDFCC07E95
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 11:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7D29613AF
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Jul 2021 11:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhGPLHv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Jul 2021 07:07:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46834 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhGPLHi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Jul 2021 07:07:38 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5126D205D0;
        Fri, 16 Jul 2021 11:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626433482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HceJLNMFK+S5VmLX+VuhIAS83UvPhvgcnBrYweUEkuc=;
        b=T8BS8lR9aml35038eioBJs1SkHJqd/WQpEsoIhxYQTiqcJITDmRwLcjn40Dbkamg1a5QT7
        CialbHBrlVH9JoFbHvk5e/X+9Lk4YQwuCflR9tQrhTXtuoKZXv6GT83bi/OtLGC/fxH0o5
        NjPe5yITTxwbB0RDzNMjPDmA140NZQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626433482;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HceJLNMFK+S5VmLX+VuhIAS83UvPhvgcnBrYweUEkuc=;
        b=KyNI5rd/reoPeSQ/YSHlAq2+8c32RgQrbCHluxySeirwE5q2Y0ThwyVL38qsYk8A57SDz0
        3ehufJDA2i8Fn7CQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 474D0A3BB8;
        Fri, 16 Jul 2021 11:04:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 931925171610; Fri, 16 Jul 2021 13:04:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        linux-nvme@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/11] nvme: Implement In-Band authentication
Date:   Fri, 16 Jul 2021 13:04:23 +0200
Message-Id: <20210716110428.9727-7-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210716110428.9727-1-hare@suse.de>
References: <20210716110428.9727-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement NVMe-oF In-Band authentication. This patch adds two new
fabric options 'dhchap_key' to specify the PSK and 'dhchap_authenticate'
to request bi-directional authentication of both the host and the controller.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/Kconfig   |  11 +
 drivers/nvme/host/Makefile  |   1 +
 drivers/nvme/host/auth.c    | 813 ++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/auth.h    |  23 +
 drivers/nvme/host/core.c    |  77 +++-
 drivers/nvme/host/fabrics.c |  65 ++-
 drivers/nvme/host/fabrics.h |   8 +
 drivers/nvme/host/nvme.h    |  15 +
 drivers/nvme/host/trace.c   |  32 ++
 9 files changed, 1041 insertions(+), 4 deletions(-)
 create mode 100644 drivers/nvme/host/auth.c
 create mode 100644 drivers/nvme/host/auth.h

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index c3f3d77f1aac..853c546305e9 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -85,3 +85,14 @@ config NVME_TCP
 	  from https://github.com/linux-nvme/nvme-cli.
 
 	  If unsure, say N.
+
+config NVME_AUTH
+	bool "NVM Express over Fabrics In-Band Authentication"
+	depends on NVME_TCP
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	help
+	  This provides support for NVMe over Fabrics In-Band Authentication
+	  for the NVMe over TCP transport.
+
+	  If unsure, say N.
diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
index cbc509784b2e..03748a55a12b 100644
--- a/drivers/nvme/host/Makefile
+++ b/drivers/nvme/host/Makefile
@@ -20,6 +20,7 @@ nvme-core-$(CONFIG_NVME_HWMON)		+= hwmon.o
 nvme-y					+= pci.o
 
 nvme-fabrics-y				+= fabrics.o
+nvme-fabrics-$(CONFIG_NVME_AUTH)	+= auth.o
 
 nvme-rdma-y				+= rdma.o
 
diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
new file mode 100644
index 000000000000..448a3adebea6
--- /dev/null
+++ b/drivers/nvme/host/auth.c
@@ -0,0 +1,813 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Hannes Reinecke, SUSE Linux
+ */
+
+#include <linux/crc32.h>
+#include <linux/base64.h>
+#include <asm/unaligned.h>
+#include <crypto/hash.h>
+#include <crypto/kpp.h>
+#include "nvme.h"
+#include "fabrics.h"
+#include "auth.h"
+
+static u32 nvme_dhchap_seqnum;
+
+struct nvme_dhchap_context {
+	struct crypto_shash *shash_tfm;
+	unsigned char *key;
+	size_t key_len;
+	int qid;
+	u32 s1;
+	u32 s2;
+	u16 transaction;
+	u8 status;
+	u8 hash_id;
+	u8 hash_len;
+	u8 c1[64];
+	u8 c2[64];
+	u8 response[64];
+	u8 *ctrl_key;
+	int ctrl_key_len;
+	u8 *host_key;
+	int host_key_len;
+	u8 *sess_key;
+	int sess_key_len;
+};
+
+struct nvmet_dhchap_hash_map {
+	int id;
+	int hash_len;
+	const char hmac[15];
+	const char digest[15];
+} hash_map[] = {
+	{.id = NVME_AUTH_DHCHAP_HASH_SHA256,
+	 .hash_len = 32,
+	 .hmac = "hmac(sha256)", .digest = "sha256" },
+	{.id = NVME_AUTH_DHCHAP_HASH_SHA384,
+	 .hash_len = 48,
+	 .hmac = "hmac(sha384)", .digest = "sha384" },
+	{.id = NVME_AUTH_DHCHAP_HASH_SHA512,
+	 .hash_len = 64,
+	 .hmac = "hmac(sha512)", .digest = "sha512" },
+};
+
+const char *nvme_auth_hmac_name(int hmac_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
+		if (hash_map[i].id == hmac_id)
+			return hash_map[i].hmac;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_hmac_name);
+
+const char *nvme_auth_digest_name(int hmac_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
+		if (hash_map[i].id == hmac_id)
+			return hash_map[i].digest;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_digest_name);
+
+int nvme_auth_hmac_len(int hmac_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
+		if (hash_map[i].id == hmac_id)
+			return hash_map[i].hash_len;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_hmac_len);
+
+int nvme_auth_hmac_id(const char *hmac_name)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
+		if (!strncmp(hash_map[i].hmac, hmac_name,
+			     strlen(hash_map[i].hmac)))
+			return hash_map[i].id;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_hmac_id);
+
+unsigned char *nvme_auth_extract_secret(unsigned char *dhchap_secret,
+					size_t *dhchap_key_len)
+{
+	unsigned char *dhchap_key;
+	u32 crc;
+	int key_len;
+	size_t allocated_len;
+
+	allocated_len = strlen(dhchap_secret) - 10;
+	dhchap_key = kzalloc(allocated_len, GFP_KERNEL);
+	if (!dhchap_key)
+		return ERR_PTR(-ENOMEM);
+
+	key_len = base64_decode(dhchap_secret + 10,
+				allocated_len, dhchap_key);
+	if (key_len != 36 && key_len != 52 &&
+	    key_len != 68) {
+		pr_debug("Invalid DH-HMAC-CHAP key len %d\n",
+			 key_len);
+		kfree(dhchap_key);
+		return ERR_PTR(-EINVAL);
+	}
+	pr_debug("DH-HMAC-CHAP Key: %*ph\n",
+		 (int)key_len, dhchap_key);
+
+	/* The last four bytes is the CRC in little-endian format */
+	key_len -= 4;
+	/*
+	 * The linux implementation doesn't do pre- and post-increments,
+	 * so we have to do it manually.
+	 */
+	crc = ~crc32(~0, dhchap_key, key_len);
+
+	if (get_unaligned_le32(dhchap_key + key_len) != crc) {
+		pr_debug("DH-HMAC-CHAP crc mismatch (key %08x, crc %08x)\n",
+		       get_unaligned_le32(dhchap_key + key_len), crc);
+		kfree(dhchap_key);
+		return ERR_PTR(-EKEYREJECTED);
+	}
+	*dhchap_key_len = key_len;
+	return dhchap_key;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_extract_secret);
+
+static int nvme_auth_send(struct nvme_ctrl *ctrl, int qid,
+			  void *data, size_t tl)
+{
+	struct nvme_command cmd = {};
+	blk_mq_req_flags_t flags = qid == NVME_QID_ANY ?
+		0 : BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED;
+	struct request_queue *q = qid == NVME_QID_ANY ?
+		ctrl->fabrics_q : ctrl->connect_q;
+	int ret;
+
+	cmd.auth_send.opcode = nvme_fabrics_command;
+	cmd.auth_send.fctype = nvme_fabrics_type_auth_send;
+	cmd.auth_send.secp = NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER;
+	cmd.auth_send.spsp0 = 0x01;
+	cmd.auth_send.spsp1 = 0x01;
+	cmd.auth_send.tl = tl;
+
+	ret = __nvme_submit_sync_cmd(q, &cmd, NULL, data, tl, 0, qid,
+				     0, flags);
+	if (ret)
+		dev_dbg(ctrl->device,
+			"%s: qid %d error %d\n", __func__, qid, ret);
+	return ret;
+}
+
+static int nvme_auth_receive(struct nvme_ctrl *ctrl, int qid,
+			     void *buf, size_t al,
+			     u16 transaction, u8 expected_msg )
+{
+	struct nvme_command cmd = {};
+	struct nvmf_auth_dhchap_failure_data *data = buf;
+	blk_mq_req_flags_t flags = qid == NVME_QID_ANY ?
+		0 : BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED;
+	struct request_queue *q = qid == NVME_QID_ANY ?
+		ctrl->fabrics_q : ctrl->connect_q;
+	int ret;
+
+	cmd.auth_receive.opcode = nvme_fabrics_command;
+	cmd.auth_receive.fctype = nvme_fabrics_type_auth_receive;
+	cmd.auth_receive.secp = NVME_AUTH_DHCHAP_PROTOCOL_IDENTIFIER;
+	cmd.auth_receive.spsp0 = 0x01;
+	cmd.auth_receive.spsp1 = 0x01;
+	cmd.auth_receive.al = al;
+
+	ret = __nvme_submit_sync_cmd(q, &cmd, NULL, buf, al, 0, qid,
+				     0, flags);
+	if (ret > 0) {
+		dev_dbg(ctrl->device, "%s: qid %d nvme status %x\n",
+			__func__, qid, ret);
+		ret = -EIO;
+	}
+	if (ret < 0) {
+		dev_dbg(ctrl->device, "%s: qid %d error %d\n",
+			__func__, qid, ret);
+		return ret;
+	}
+	dev_dbg(ctrl->device, "%s: qid %d auth_type %d auth_id %x\n",
+		__func__, qid, data->auth_type, data->auth_id);
+	if (data->auth_type == NVME_AUTH_COMMON_MESSAGES &&
+	    data->auth_id == NVME_AUTH_DHCHAP_MESSAGE_FAILURE1) {
+		return data->reason_code_explanation;
+	}
+	if (data->auth_type != NVME_AUTH_DHCHAP_MESSAGES ||
+	    data->auth_id != expected_msg) {
+		dev_warn(ctrl->device,
+			 "qid %d invalid message %02x/%02x\n",
+			 qid, data->auth_type, data->auth_id);
+		return NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
+	}
+	if (le16_to_cpu(data->t_id) != transaction) {
+		dev_warn(ctrl->device,
+			 "qid %d invalid transaction ID %d\n",
+			 qid, le16_to_cpu(data->t_id));
+		return NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
+	}
+
+	return 0;
+}
+
+static int nvme_auth_dhchap_negotiate(struct nvme_ctrl *ctrl,
+				      struct nvme_dhchap_context *chap,
+				      void *buf, size_t buf_size)
+{
+	struct nvmf_auth_dhchap_negotiate_data *data = buf;
+	size_t size = sizeof(*data) + sizeof(union nvmf_auth_protocol);
+
+	if (buf_size < size)
+		return -EINVAL;
+
+	memset((u8 *)buf, 0, size);
+	data->auth_type = NVME_AUTH_COMMON_MESSAGES;
+	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
+	data->t_id = cpu_to_le16(chap->transaction);
+	data->sc_c = 0; /* No secure channel concatenation */
+	data->napd = 1;
+	data->auth_protocol[0].dhchap.authid = NVME_AUTH_DHCHAP_AUTH_ID;
+	data->auth_protocol[0].dhchap.halen = 3;
+	data->auth_protocol[0].dhchap.dhlen = 1;
+	data->auth_protocol[0].dhchap.idlist[0] = NVME_AUTH_DHCHAP_HASH_SHA256;
+	data->auth_protocol[0].dhchap.idlist[1] = NVME_AUTH_DHCHAP_HASH_SHA384;
+	data->auth_protocol[0].dhchap.idlist[2] = NVME_AUTH_DHCHAP_HASH_SHA512;
+	data->auth_protocol[0].dhchap.idlist[3] = NVME_AUTH_DHCHAP_DHGROUP_NULL;
+
+	return size;
+}
+
+static int nvme_auth_dhchap_challenge(struct nvme_ctrl *ctrl,
+				      struct nvme_dhchap_context *chap,
+				      void *buf, size_t buf_size)
+{
+	struct nvmf_auth_dhchap_challenge_data *data = buf;
+	size_t size = sizeof(*data) + data->hl + data->dhvlen;
+	const char *gid_name;
+
+	if (buf_size < size) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
+		return -ENOMSG;
+	}
+
+	if (data->hashid != NVME_AUTH_DHCHAP_HASH_SHA256 &&
+	    data->hashid != NVME_AUTH_DHCHAP_HASH_SHA384 &&
+	    data->hashid != NVME_AUTH_DHCHAP_HASH_SHA512) {
+		dev_warn(ctrl->device,
+			 "qid %d: DH-HMAC-CHAP: invalid HASH ID %d\n",
+			 chap->qid, data->hashid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
+		return -EPROTO;
+	}
+	switch (data->dhgid) {
+	case NVME_AUTH_DHCHAP_DHGROUP_NULL:
+		gid_name = "null";
+		break;
+	default:
+		gid_name = NULL;
+		break;
+	}
+	if (!gid_name) {
+		dev_warn(ctrl->device,
+			 "qid %d: DH-HMAC-CHAP: invalid DH group id %d\n",
+			 chap->qid, data->dhgid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
+		return -EPROTO;
+	}
+	if (data->dhgid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
+		return -EPROTO;
+	}
+	if (data->dhgid == NVME_AUTH_DHCHAP_DHGROUP_NULL && data->dhvlen != 0) {
+		dev_warn(ctrl->device,
+			 "qid %d: DH-HMAC-CHAP: invalid DH value for NULL DH\n",
+			chap->qid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
+		return -EPROTO;
+	}
+	dev_dbg(ctrl->device, "%s: qid %d requested hash id %d\n",
+		__func__, chap->qid, data->hashid);
+	if (nvme_auth_hmac_len(data->hashid) != data->hl) {
+		dev_warn(ctrl->device,
+			 "qid %d: DH-HMAC-CHAP: invalid hash length\n",
+			chap->qid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
+		return -EPROTO;
+	}
+	chap->hash_id = data->hashid;
+	chap->hash_len = data->hl;
+	chap->s1 = le32_to_cpu(data->seqnum);
+	memcpy(chap->c1, data->cval, chap->hash_len);
+
+	return 0;
+}
+
+static int nvme_auth_dhchap_reply(struct nvme_ctrl *ctrl,
+				  struct nvme_dhchap_context *chap,
+				  void *buf, size_t buf_size)
+{
+	struct nvmf_auth_dhchap_reply_data *data = buf;
+	size_t size = sizeof(*data);
+
+	size += 2 * chap->hash_len;
+	if (ctrl->opts->dhchap_auth) {
+		get_random_bytes(chap->c2, chap->hash_len);
+		chap->s2 = nvme_dhchap_seqnum++;
+	} else
+		memset(chap->c2, 0, chap->hash_len);
+
+	if (chap->host_key_len)
+		size += chap->host_key_len;
+
+	if (buf_size < size)
+		return -EINVAL;
+
+	memset(buf, 0, size);
+	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
+	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_REPLY;
+	data->t_id = cpu_to_le16(chap->transaction);
+	data->hl = chap->hash_len;
+	data->dhvlen = chap->host_key_len;
+	data->seqnum = cpu_to_le32(chap->s2);
+	memcpy(data->rval, chap->response, chap->hash_len);
+	if (ctrl->opts->dhchap_auth) {
+		dev_dbg(ctrl->device, "%s: qid %d ctrl challenge %*ph\n",
+			__func__, chap->qid,
+			chap->hash_len, chap->c2);
+		data->cvalid = 1;
+		memcpy(data->rval + chap->hash_len, chap->c2,
+		       chap->hash_len);
+	}
+	if (chap->host_key_len)
+		memcpy(data->rval + 2 * chap->hash_len, chap->host_key,
+		       chap->host_key_len);
+
+	return size;
+}
+
+static int nvme_auth_dhchap_success1(struct nvme_ctrl *ctrl,
+				     struct nvme_dhchap_context *chap,
+				     void *buf, size_t buf_size)
+{
+	struct nvmf_auth_dhchap_success1_data *data = buf;
+	size_t size = sizeof(*data);
+
+	if (ctrl->opts->dhchap_auth)
+		size += chap->hash_len;
+
+
+	if (buf_size < size) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
+		return -ENOMSG;
+	}
+
+	if (data->hl != chap->hash_len) {
+		dev_warn(ctrl->device,
+			 "qid %d: DH-HMAC-CHAP: invalid hash length %d\n",
+			 chap->qid, data->hl);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
+		return -EPROTO;
+	}
+
+	if (!data->rvalid)
+		return 0;
+
+	/* Validate controller response */
+	if (memcmp(chap->response, data->rval, data->hl)) {
+		dev_dbg(ctrl->device, "%s: qid %d ctrl response %*ph\n",
+			__func__, chap->qid, chap->hash_len, data->rval);
+		dev_dbg(ctrl->device, "%s: qid %d host response %*ph\n",
+			__func__, chap->qid, chap->hash_len, chap->response);
+		dev_warn(ctrl->device,
+			 "qid %d: DH-HMAC-CHAP: controller authentication failed\n",
+			 chap->qid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INVALID_PAYLOAD;
+		return -EPROTO;
+	}
+	dev_info(ctrl->device,
+		 "qid %d: DH-HMAC-CHAP: controller authenticated\n",
+		chap->qid);
+	return 0;
+}
+
+static int nvme_auth_dhchap_success2(struct nvme_ctrl *ctrl,
+				     struct nvme_dhchap_context *chap,
+				     void *buf, size_t buf_size)
+{
+	struct nvmf_auth_dhchap_success2_data *data = buf;
+	size_t size = sizeof(*data);
+
+	memset(buf, 0, size);
+	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
+	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2;
+	data->t_id = cpu_to_le16(chap->transaction);
+
+	return size;
+}
+
+static int nvme_auth_dhchap_failure2(struct nvme_ctrl *ctrl,
+				     struct nvme_dhchap_context *chap,
+				     void *buf, size_t buf_size)
+{
+	struct nvmf_auth_dhchap_failure_data *data = buf;
+	size_t size = sizeof(*data);
+
+	memset(buf, 0, size);
+	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
+	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_FAILURE2;
+	data->t_id = cpu_to_le16(chap->transaction);
+	data->reason_code = 1;
+	data->reason_code_explanation = chap->status;
+
+	return size;
+}
+
+int nvme_auth_select_hash(struct nvme_ctrl *ctrl,
+			  struct nvme_dhchap_context *chap)
+{
+	char *hash_name;
+	int ret;
+
+	switch (chap->hash_id) {
+	case NVME_AUTH_DHCHAP_HASH_SHA256:
+		hash_name = "hmac(sha256)";
+		break;
+	case NVME_AUTH_DHCHAP_HASH_SHA384:
+		hash_name = "hmac(sha384)";
+		break;
+	case NVME_AUTH_DHCHAP_HASH_SHA512:
+		hash_name = "hmac(sha512)";
+		break;
+	default:
+		hash_name = NULL;
+		break;
+	}
+	if (!hash_name) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
+		return -EPROTO;
+	}
+	chap->shash_tfm = crypto_alloc_shash(hash_name, 0,
+					     CRYPTO_ALG_ALLOCATES_MEMORY);
+	if (IS_ERR(chap->shash_tfm)) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
+		chap->shash_tfm = NULL;
+		return -EPROTO;
+	}
+	if (!chap->key) {
+		dev_warn(ctrl->device, "qid %d: cannot select hash, no key\n",
+			 chap->qid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
+		crypto_free_shash(chap->shash_tfm);
+		chap->shash_tfm = NULL;
+		return -EINVAL;
+	}
+	ret = crypto_shash_setkey(chap->shash_tfm, chap->key, chap->key_len);
+	if (ret) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_NOT_USABLE;
+		crypto_free_shash(chap->shash_tfm);
+		chap->shash_tfm = NULL;
+		return ret;
+	}
+	dev_info(ctrl->device, "qid %d: DH-HMAC_CHAP: selected hash %s\n",
+		 chap->qid, hash_name);
+	return 0;
+}
+
+static int nvme_auth_dhchap_host_response(struct nvme_ctrl *ctrl,
+					  struct nvme_dhchap_context *chap)
+{
+	SHASH_DESC_ON_STACK(shash, chap->shash_tfm);
+	u8 buf[4], *challenge = chap->c1;
+	int ret;
+
+	dev_dbg(ctrl->device, "%s: qid %d host response seq %d transaction %d\n",
+		__func__, chap->qid, chap->s1, chap->transaction);
+	shash->tfm = chap->shash_tfm;
+	ret = crypto_shash_init(shash);
+	if (ret)
+		goto out;
+	ret = crypto_shash_update(shash, challenge, chap->hash_len);
+	if (ret)
+		goto out;
+	put_unaligned_le32(chap->s1, buf);
+	ret = crypto_shash_update(shash, buf, 4);
+	if (ret)
+		goto out;
+	put_unaligned_le16(chap->transaction, buf);
+	ret = crypto_shash_update(shash, buf, 2);
+	if (ret)
+		goto out;
+	memset(buf, 0, sizeof(buf));
+	ret = crypto_shash_update(shash, buf, 1);
+	if (ret)
+		goto out;
+	ret = crypto_shash_update(shash, "HostHost", 8);
+	if (ret)
+		goto out;
+	ret = crypto_shash_update(shash, ctrl->opts->host->nqn,
+				  strlen(ctrl->opts->host->nqn));
+	if (ret)
+		goto out;
+	ret = crypto_shash_update(shash, buf, 1);
+	if (ret)
+		goto out;
+	ret = crypto_shash_update(shash, ctrl->opts->subsysnqn,
+			    strlen(ctrl->opts->subsysnqn));
+	if (ret)
+		goto out;
+	ret = crypto_shash_final(shash, chap->response);
+out:
+	return ret;
+}
+
+static int nvme_auth_dhchap_ctrl_response(struct nvme_ctrl *ctrl,
+					  struct nvme_dhchap_context *chap)
+{
+	SHASH_DESC_ON_STACK(shash, chap->shash_tfm);
+	u8 buf[4], *challenge = chap->c2;
+	int ret;
+
+	dev_dbg(ctrl->device, "%s: qid %d host response seq %d transaction %d\n",
+		__func__, chap->qid, chap->s2, chap->transaction);
+	dev_dbg(ctrl->device, "%s: qid %d challenge %*ph\n",
+		__func__, chap->qid, chap->hash_len, challenge);
+	dev_dbg(ctrl->device, "%s: qid %d subsysnqn %s\n",
+		__func__, chap->qid, ctrl->opts->subsysnqn);
+	dev_dbg(ctrl->device, "%s: qid %d hostnqn %s\n",
+		__func__, chap->qid, ctrl->opts->host->nqn);
+	shash->tfm = chap->shash_tfm;
+	ret = crypto_shash_init(shash);
+	if (ret)
+		goto out;
+	ret = crypto_shash_update(shash, challenge, chap->hash_len);
+	if (ret)
+		goto out;
+	put_unaligned_le32(chap->s2, buf);
+	ret = crypto_shash_update(shash, buf, 4);
+	if (ret)
+		goto out;
+	put_unaligned_le16(chap->transaction, buf);
+	ret = crypto_shash_update(shash, buf, 2);
+	if (ret)
+		goto out;
+	memset(buf, 0, 4);
+	ret = crypto_shash_update(shash, buf, 1);
+	if (ret)
+		goto out;
+	ret = crypto_shash_update(shash, "Controller", 10);
+	if (ret)
+		goto out;
+	ret = crypto_shash_update(shash, ctrl->opts->subsysnqn,
+				  strlen(ctrl->opts->subsysnqn));
+	if (ret)
+		goto out;
+	ret = crypto_shash_update(shash, buf, 1);
+	if (ret)
+		goto out;
+	ret = crypto_shash_update(shash, ctrl->opts->host->nqn,
+				  strlen(ctrl->opts->host->nqn));
+	if (ret)
+		goto out;
+	ret = crypto_shash_final(shash, chap->response);
+out:
+	return ret;
+}
+
+int nvme_auth_generate_key(struct nvme_ctrl *ctrl,
+			   struct nvme_dhchap_context *chap)
+{
+	int ret;
+	u8 key_hash;
+	const char *hmac_name;
+	struct crypto_shash *key_tfm;
+
+	if (sscanf(ctrl->opts->dhchap_secret, "DHHC-1:%hhd:%*s:",
+		   &key_hash) != 1)
+		return -EINVAL;
+
+	chap->key = nvme_auth_extract_secret(ctrl->opts->dhchap_secret,
+					     &chap->key_len);
+	if (IS_ERR(chap->key)) {
+		ret = PTR_ERR(chap->key);
+		chap->key = NULL;
+		return ret;
+	}
+
+	if (key_hash == 0)
+		return 0;
+
+	hmac_name = nvme_auth_hmac_name(key_hash);
+	if (!hmac_name) {
+		pr_debug("Invalid key hash id %d\n", key_hash);
+		return -EKEYREJECTED;
+	}
+
+	key_tfm = crypto_alloc_shash(hmac_name, 0, 0);
+	if (IS_ERR(key_tfm)) {
+		kfree(chap->key);
+		chap->key = NULL;
+		ret = PTR_ERR(key_tfm);
+	} else {
+		SHASH_DESC_ON_STACK(shash, key_tfm);
+
+		shash->tfm = key_tfm;
+		ret = crypto_shash_setkey(key_tfm, chap->key,
+					  chap->key_len);
+		if (ret < 0) {
+			crypto_free_shash(key_tfm);
+			kfree(chap->key);
+			chap->key = NULL;
+			return ret;
+		}
+		crypto_shash_init(shash);
+		crypto_shash_update(shash, ctrl->opts->host->nqn,
+				    strlen(ctrl->opts->host->nqn));
+		crypto_shash_update(shash, "NVMe-over-Fabrics", 17);
+		crypto_shash_final(shash, chap->key);
+		crypto_free_shash(key_tfm);
+	}
+	return 0;
+}
+
+void nvme_auth_free(struct nvme_dhchap_context *chap)
+{
+	if (chap->shash_tfm)
+		crypto_free_shash(chap->shash_tfm);
+	if (chap->key)
+		kfree(chap->key);
+	if (chap->ctrl_key)
+		kfree(chap->ctrl_key);
+	if (chap->host_key)
+		kfree(chap->host_key);
+	if (chap->sess_key)
+		kfree(chap->sess_key);
+	kfree(chap);
+}
+
+int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid)
+{
+	struct nvme_dhchap_context *chap;
+	void *buf;
+	size_t buf_size, tl;
+	int ret = 0;
+
+	chap = kzalloc(sizeof(*chap), GFP_KERNEL);
+	if (!chap)
+		return -ENOMEM;
+	chap->qid = qid;
+	chap->transaction = ctrl->transaction++;
+
+	ret = nvme_auth_generate_key(ctrl, chap);
+	if (ret) {
+		dev_dbg(ctrl->device, "%s: failed to generate key, error %d\n",
+			__func__, ret);
+		nvme_auth_free(chap);
+		return ret;
+	}
+
+	/*
+	 * Allocate a large enough buffer for the entire negotiation:
+	 * 4k should be enough to ffdhe8192.
+	 */
+	buf_size = 4096;
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* DH-HMAC-CHAP Step 1: send negotiate */
+	dev_dbg(ctrl->device, "%s: qid %d DH-HMAC-CHAP negotiate\n",
+		__func__, qid);
+	ret = nvme_auth_dhchap_negotiate(ctrl, chap, buf, buf_size);
+	if (ret < 0)
+		goto out;
+	tl = ret;
+	ret = nvme_auth_send(ctrl, qid, buf, tl);
+	if (ret)
+		goto out;
+
+	memset(buf, 0, buf_size);
+	ret = nvme_auth_receive(ctrl, qid, buf, buf_size, chap->transaction,
+				NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE);
+	if (ret < 0) {
+		dev_dbg(ctrl->device,
+			"%s: qid %d DH-HMAC-CHAP failed to receive challenge\n",
+			__func__, qid);
+		goto out;
+	}
+	if (ret > 0) {
+		chap->status = ret;
+		goto fail1;
+	}
+
+	/* DH-HMAC-CHAP Step 2: receive challenge */
+	dev_dbg(ctrl->device, "%s: qid %d DH-HMAC-CHAP challenge\n",
+		__func__, qid);
+
+	ret = nvme_auth_dhchap_challenge(ctrl, chap, buf, buf_size);
+	if (ret) {
+		/* Invalid parameters for negotiate */
+		goto fail2;
+	}
+
+	dev_dbg(ctrl->device, "%s: qid %d DH-HMAC-CHAP select hash\n",
+		__func__, qid);
+	ret = nvme_auth_select_hash(ctrl, chap);
+	if (ret)
+		goto fail2;
+
+	dev_dbg(ctrl->device, "%s: qid %d DH-HMAC-CHAP host response\n",
+		__func__, qid);
+	ret = nvme_auth_dhchap_host_response(ctrl, chap);
+	if (ret)
+		goto fail2;
+
+	/* DH-HMAC-CHAP Step 3: send reply */
+	dev_dbg(ctrl->device, "%s: qid %d DH-HMAC-CHAP reply\n",
+		__func__, qid);
+	ret = nvme_auth_dhchap_reply(ctrl, chap, buf, buf_size);
+	if (ret < 0)
+		goto fail2;
+
+	tl = ret;
+	ret = nvme_auth_send(ctrl, qid, buf, tl);
+	if (ret)
+		goto fail2;
+
+	memset(buf, 0, buf_size);
+	ret = nvme_auth_receive(ctrl, qid, buf, buf_size, chap->transaction,
+				NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1);
+	if (ret < 0) {
+		dev_dbg(ctrl->device,
+			"%s: qid %d DH-HMAC-CHAP failed to receive success1\n",
+			__func__, qid);
+		goto out;
+	}
+	if (ret > 0) {
+		chap->status = ret;
+		goto fail1;
+	}
+
+	if (ctrl->opts->dhchap_auth) {
+		dev_dbg(ctrl->device,
+			"%s: qid %d DH-HMAC-CHAP controller response\n",
+			__func__, qid);
+		ret = nvme_auth_dhchap_ctrl_response(ctrl, chap);
+		if (ret)
+			goto fail2;
+	}
+
+	/* DH-HMAC-CHAP Step 4: receive success1 */
+	dev_dbg(ctrl->device, "%s: qid %d DH-HMAC-CHAP success1\n",
+		__func__, qid);
+	ret = nvme_auth_dhchap_success1(ctrl, chap, buf, buf_size);
+	if (ret < 0) {
+		/* Controller authentication failed */
+		goto fail2;
+	}
+	tl = ret;
+	/* DH-HMAC-CHAP Step 5: send success2 */
+	dev_dbg(ctrl->device, "%s: qid %d DH-HMAC-CHAP success2\n",
+		__func__, qid);
+	tl = nvme_auth_dhchap_success2(ctrl, chap, buf, buf_size);
+	ret = nvme_auth_send(ctrl, qid, buf, tl);
+	if (!ret)
+		goto out;
+
+fail1:
+	dev_dbg(ctrl->device, "%s: qid %d DH-HMAC-CHAP failure1, status %x\n",
+		__func__, qid, chap->status);
+	goto out;
+
+fail2:
+	dev_dbg(ctrl->device, "%s: qid %d DH-HMAC-CHAP failure2, status %x\n",
+		__func__, qid, chap->status);
+	tl = nvme_auth_dhchap_failure2(ctrl, chap, buf, buf_size);
+	ret = nvme_auth_send(ctrl, qid, buf, tl);
+
+out:
+	if (!ret && chap->status)
+		ret = -EPROTO;
+	if (!ret) {
+		ctrl->dhchap_hash = chap->hash_id;
+	}
+	kfree(buf);
+	nvme_auth_free(chap);
+	return ret;
+}
diff --git a/drivers/nvme/host/auth.h b/drivers/nvme/host/auth.h
new file mode 100644
index 000000000000..4950b1cb9470
--- /dev/null
+++ b/drivers/nvme/host/auth.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Hannes Reinecke, SUSE Software Solutions
+ */
+
+#ifndef _NVME_AUTH_H
+#define _NVME_AUTH_H
+
+const char *nvme_auth_dhgroup_name(int dhgroup_id);
+int nvme_auth_dhgroup_pubkey_size(int dhgroup_id);
+int nvme_auth_dhgroup_privkey_size(int dhgroup_id);
+const char *nvme_auth_dhgroup_kpp(int dhgroup_id);
+int nvme_auth_dhgroup_id(const char *dhgroup_name);
+
+const char *nvme_auth_hmac_name(int hmac_id);
+const char *nvme_auth_digest_name(int hmac_id);
+int nvme_auth_hmac_id(const char *hmac_name);
+int nvme_auth_hmac_len(int hmac_len);
+
+unsigned char *nvme_auth_extract_secret(unsigned char *dhchap_secret,
+					size_t *dhchap_key_len);
+
+#endif /* _NVME_AUTH_H */
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 11779be42186..7ce9b666dc09 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -708,7 +708,9 @@ bool __nvme_check_ready(struct nvme_ctrl *ctrl, struct request *rq,
 		switch (ctrl->state) {
 		case NVME_CTRL_CONNECTING:
 			if (blk_rq_is_passthrough(rq) && nvme_is_fabrics(req->cmd) &&
-			    req->cmd->fabrics.fctype == nvme_fabrics_type_connect)
+			    (req->cmd->fabrics.fctype == nvme_fabrics_type_connect ||
+			     req->cmd->fabrics.fctype == nvme_fabrics_type_auth_send ||
+			     req->cmd->fabrics.fctype == nvme_fabrics_type_auth_receive))
 				return true;
 			break;
 		default:
@@ -3426,6 +3428,66 @@ static ssize_t nvme_ctrl_fast_io_fail_tmo_store(struct device *dev,
 static DEVICE_ATTR(fast_io_fail_tmo, S_IRUGO | S_IWUSR,
 	nvme_ctrl_fast_io_fail_tmo_show, nvme_ctrl_fast_io_fail_tmo_store);
 
+#ifdef CONFIG_NVME_AUTH
+struct nvmet_dhchap_hash_map {
+	int id;
+	const char name[15];
+} hash_map[] = {
+	{.id = NVME_AUTH_DHCHAP_HASH_SHA256,
+	 .name = "hmac(sha256)", },
+	{.id = NVME_AUTH_DHCHAP_HASH_SHA384,
+	 .name = "hmac(sha384)", },
+	{.id = NVME_AUTH_DHCHAP_HASH_SHA512,
+	 .name = "hmac(sha512)", },
+};
+
+static ssize_t dhchap_hash_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(hash_map); i++) {
+		if (hash_map[i].id == ctrl->dhchap_hash)
+			return sprintf(buf, "%s\n", hash_map[i].name);
+	}
+	return sprintf(buf, "none\n");
+}
+DEVICE_ATTR_RO(dhchap_hash);
+
+struct nvmet_dhchap_group_map {
+	int id;
+	const char name[15];
+} dhgroup_map[] = {
+	{.id = NVME_AUTH_DHCHAP_DHGROUP_NULL,
+	 .name = "NULL", },
+	{.id = NVME_AUTH_DHCHAP_DHGROUP_2048,
+	 .name = "ffdhe2048", },
+	{.id = NVME_AUTH_DHCHAP_DHGROUP_3072,
+	 .name = "ffdhe3072", },
+	{.id = NVME_AUTH_DHCHAP_DHGROUP_4096,
+	 .name = "ffdhe4096", },
+	{.id = NVME_AUTH_DHCHAP_DHGROUP_6144,
+	 .name = "ffdhe6144", },
+	{.id = NVME_AUTH_DHCHAP_DHGROUP_8192,
+	 .name = "ffdhe8192", },
+};
+
+static ssize_t dhchap_dhgroup_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
+		if (hash_map[i].id == ctrl->dhchap_dhgroup)
+			return sprintf(buf, "%s\n", dhgroup_map[i].name);
+	}
+	return sprintf(buf, "none\n");
+}
+DEVICE_ATTR_RO(dhchap_dhgroup);
+#endif
+
 static struct attribute *nvme_dev_attrs[] = {
 	&dev_attr_reset_controller.attr,
 	&dev_attr_rescan_controller.attr,
@@ -3447,6 +3509,10 @@ static struct attribute *nvme_dev_attrs[] = {
 	&dev_attr_reconnect_delay.attr,
 	&dev_attr_fast_io_fail_tmo.attr,
 	&dev_attr_kato.attr,
+#ifdef CONFIG_NVME_AUTH
+	&dev_attr_dhchap_hash.attr,
+	&dev_attr_dhchap_dhgroup.attr,
+#endif
 	NULL
 };
 
@@ -3470,6 +3536,10 @@ static umode_t nvme_dev_attrs_are_visible(struct kobject *kobj,
 		return 0;
 	if (a == &dev_attr_fast_io_fail_tmo.attr && !ctrl->opts)
 		return 0;
+#ifdef CONFIG_NVME_AUTH
+	if (a == &dev_attr_dhchap_hash.attr && !ctrl->opts)
+		return 0;
+#endif
 
 	return a->mode;
 }
@@ -4581,6 +4651,11 @@ static inline void _nvme_check_size(void)
 	BUILD_BUG_ON(sizeof(struct nvme_smart_log) != 512);
 	BUILD_BUG_ON(sizeof(struct nvme_dbbuf) != 64);
 	BUILD_BUG_ON(sizeof(struct nvme_directive_cmd) != 64);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_negotiate_data) != 8);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_challenge_data) != 16);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_reply_data) != 16);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_success1_data) != 16);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_success2_data) != 16);
 }
 
 
diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index a5469fd9d4c3..6404ab9b604b 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -366,6 +366,7 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl)
 	union nvme_result res;
 	struct nvmf_connect_data *data;
 	int ret;
+	u32 result;
 
 	cmd.connect.opcode = nvme_fabrics_command;
 	cmd.connect.fctype = nvme_fabrics_type_connect;
@@ -398,8 +399,18 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl)
 		goto out_free_data;
 	}
 
-	ctrl->cntlid = le16_to_cpu(res.u16);
-
+	result = le32_to_cpu(res.u32);
+	ctrl->cntlid = result & 0xFFFF;
+	if ((result >> 16) & 2) {
+		/* Authentication required */
+		ret = nvme_auth_negotiate(ctrl, NVME_QID_ANY);
+		if (ret)
+			dev_warn(ctrl->device,
+				 "qid 0: authentication failed\n");
+		else
+			dev_info(ctrl->device,
+				 "qid 0: authenticated\n");
+	}
 out_free_data:
 	kfree(data);
 	return ret;
@@ -432,6 +443,7 @@ int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid)
 	struct nvmf_connect_data *data;
 	union nvme_result res;
 	int ret;
+	u32 result;
 
 	cmd.connect.opcode = nvme_fabrics_command;
 	cmd.connect.fctype = nvme_fabrics_type_connect;
@@ -457,6 +469,17 @@ int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid)
 		nvmf_log_connect_error(ctrl, ret, le32_to_cpu(res.u32),
 				       &cmd, data);
 	}
+	result = le32_to_cpu(res.u32);
+	if ((result >> 16) & 2) {
+		/* Authentication required */
+		ret = nvme_auth_negotiate(ctrl, qid);
+		if (ret)
+			dev_warn(ctrl->device,
+				 "qid %u: authentication failed\n", qid);
+		else
+			dev_info(ctrl->device,
+				 "qid %u: authenticated\n", qid);
+	}
 	kfree(data);
 	return ret;
 }
@@ -548,6 +571,9 @@ static const match_table_t opt_tokens = {
 	{ NVMF_OPT_NR_POLL_QUEUES,	"nr_poll_queues=%d"	},
 	{ NVMF_OPT_TOS,			"tos=%d"		},
 	{ NVMF_OPT_FAIL_FAST_TMO,	"fast_io_fail_tmo=%d"	},
+	{ NVMF_OPT_DHCHAP_SECRET,	"dhchap_secret=%s"	},
+	{ NVMF_OPT_DHCHAP_AUTH,		"authenticate"		},
+	{ NVMF_OPT_DHCHAP_GROUP,	"dhchap_group=%s"	},
 	{ NVMF_OPT_ERR,			NULL			}
 };
 
@@ -824,6 +850,35 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			}
 			opts->tos = token;
 			break;
+		case NVMF_OPT_DHCHAP_SECRET:
+			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			if (strncmp(p, "DHHC-1:00:", 10)) {
+				pr_err("Invalid DH-CHAP secret %s\n", p);
+				ret = -EINVAL;
+				goto out;
+			}
+			kfree(opts->dhchap_secret);
+			opts->dhchap_secret = p;
+			break;
+		case NVMF_OPT_DHCHAP_AUTH:
+			opts->dhchap_auth = true;
+			break;
+		case NVMF_OPT_DHCHAP_GROUP:
+			if (match_int(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			if (token <= 0) {
+				pr_err("Invalid dhchap_group %d\n", token);
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->dhchap_group = token;
+			break;
 		default:
 			pr_warn("unknown parameter or missing value '%s' in ctrl creation request\n",
 				p);
@@ -942,6 +997,7 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 	kfree(opts->subsysnqn);
 	kfree(opts->host_traddr);
 	kfree(opts->host_iface);
+	kfree(opts->dhchap_secret);
 	kfree(opts);
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
@@ -951,7 +1007,10 @@ EXPORT_SYMBOL_GPL(nvmf_free_options);
 				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
 				 NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT |\
 				 NVMF_OPT_DISABLE_SQFLOW |\
-				 NVMF_OPT_FAIL_FAST_TMO)
+				 NVMF_OPT_CTRL_LOSS_TMO |\
+				 NVMF_OPT_FAIL_FAST_TMO |\
+				 NVMF_OPT_DHCHAP_SECRET |\
+				 NVMF_OPT_DHCHAP_AUTH | NVMF_OPT_DHCHAP_GROUP)
 
 static struct nvme_ctrl *
 nvmf_create_ctrl(struct device *dev, const char *buf)
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index a146cb903869..535bc544f0f6 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -67,6 +67,9 @@ enum {
 	NVMF_OPT_TOS		= 1 << 19,
 	NVMF_OPT_FAIL_FAST_TMO	= 1 << 20,
 	NVMF_OPT_HOST_IFACE	= 1 << 21,
+	NVMF_OPT_DHCHAP_SECRET	= 1 << 22,
+	NVMF_OPT_DHCHAP_AUTH	= 1 << 23,
+	NVMF_OPT_DHCHAP_GROUP	= 1 << 24,
 };
 
 /**
@@ -96,6 +99,8 @@ enum {
  * @max_reconnects: maximum number of allowed reconnect attempts before removing
  *              the controller, (-1) means reconnect forever, zero means remove
  *              immediately;
+ * @dhchap_secret: DH-HMAC-CHAP secret
+ * @dhchap_auth: DH-HMAC-CHAP authenticate controller
  * @disable_sqflow: disable controller sq flow control
  * @hdr_digest: generate/verify header digest (TCP)
  * @data_digest: generate/verify data digest (TCP)
@@ -120,6 +125,9 @@ struct nvmf_ctrl_options {
 	unsigned int		kato;
 	struct nvmf_host	*host;
 	int			max_reconnects;
+	char			*dhchap_secret;
+	int			dhchap_group;
+	bool			dhchap_auth;
 	bool			disable_sqflow;
 	bool			hdr_digest;
 	bool			data_digest;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 18ef8dd03a90..bcd5b8276c26 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -328,6 +328,12 @@ struct nvme_ctrl {
 	struct work_struct ana_work;
 #endif
 
+#ifdef CONFIG_NVME_AUTH
+	u16 transaction;
+	u8 dhchap_hash;
+	u8 dhchap_dhgroup;
+#endif
+
 	/* Power saving configuration */
 	u64 ps_max_latency_us;
 	bool apst_enabled;
@@ -874,6 +880,15 @@ static inline bool nvme_ctrl_sgl_supported(struct nvme_ctrl *ctrl)
 	return ctrl->sgls & ((1 << 0) | (1 << 1));
 }
 
+#ifdef CONFIG_NVME_AUTH
+int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid);
+#else
+static inline int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid)
+{
+	return -EPROTONOSUPPORT;
+}
+#endif
+
 u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 			 u8 opcode);
 int nvme_execute_passthru_rq(struct request *rq);
diff --git a/drivers/nvme/host/trace.c b/drivers/nvme/host/trace.c
index 6543015b6121..66f75d8ea925 100644
--- a/drivers/nvme/host/trace.c
+++ b/drivers/nvme/host/trace.c
@@ -271,6 +271,34 @@ static const char *nvme_trace_fabrics_property_get(struct trace_seq *p, u8 *spc)
 	return ret;
 }
 
+static const char *nvme_trace_fabrics_auth_send(struct trace_seq *p, u8 *spc)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	u8 spsp0 = spc[1];
+	u8 spsp1 = spc[2];
+	u8 secp = spc[3];
+	u32 tl = get_unaligned_le32(spc + 4);
+
+	trace_seq_printf(p, "spsp0=%02x, spsp1=%02x, secp=%02x, tl=%u",
+			 spsp0, spsp1, secp, tl);
+	trace_seq_putc(p, 0);
+	return ret;
+}
+
+static const char *nvme_trace_fabrics_auth_receive(struct trace_seq *p, u8 *spc)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+	u8 spsp0 = spc[1];
+	u8 spsp1 = spc[2];
+	u8 secp = spc[3];
+	u32 al = get_unaligned_le32(spc + 4);
+
+	trace_seq_printf(p, "spsp0=%02x, spsp1=%02x, secp=%02x, al=%u",
+			 spsp0, spsp1, secp, al);
+	trace_seq_putc(p, 0);
+	return ret;
+}
+
 static const char *nvme_trace_fabrics_common(struct trace_seq *p, u8 *spc)
 {
 	const char *ret = trace_seq_buffer_ptr(p);
@@ -290,6 +318,10 @@ const char *nvme_trace_parse_fabrics_cmd(struct trace_seq *p,
 		return nvme_trace_fabrics_connect(p, spc);
 	case nvme_fabrics_type_property_get:
 		return nvme_trace_fabrics_property_get(p, spc);
+	case nvme_fabrics_type_auth_send:
+		return nvme_trace_fabrics_auth_send(p, spc);
+	case nvme_fabrics_type_auth_receive:
+		return nvme_trace_fabrics_auth_receive(p, spc);
 	default:
 		return nvme_trace_fabrics_common(p, spc);
 	}
-- 
2.29.2

