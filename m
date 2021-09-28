Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA3AC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 058DC6101A
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239334AbhI1GGn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:06:43 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51552 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239533AbhI1GFs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 02:05:48 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out1.suse.de (Postfix) with ESMTP id D5FDF2230F;
        Tue, 28 Sep 2021 06:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632809047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5oISyQ0zpfH2VO1anc1i9N3Oj5boOZT74YoYDaLVAPM=;
        b=gktKyqucFdIiY/GphGFEYl4evCYtyTrddLdG8qu7usVvXyz4i9Wf+1Wp2nGXe+wajFLzSF
        UXY20vybvSRX+zoyctO2CQGG/4YnksrnwGlAx5FHoME/qsalbywB6hpyCd62DIH2ac3+pT
        dwPvElz5O+TeTzBWqMnqShW+4eoQmIQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632809047;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5oISyQ0zpfH2VO1anc1i9N3Oj5boOZT74YoYDaLVAPM=;
        b=XH/+555Bwoc9v6dEOKL+h5IZ94+MtZtl3q/7U+B6H1u+n5q64jtU1K5lCqVD72uwTQLuBI
        FEzGxNMxyCLxGmDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay1.suse.de (Postfix) with ESMTP id C365925E6C;
        Tue, 28 Sep 2021 06:04:07 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 62AD1518EE2C; Tue, 28 Sep 2021 08:04:06 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/12] nvme: Implement In-Band authentication
Date:   Tue, 28 Sep 2021 08:03:51 +0200
Message-Id: <20210928060356.27338-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210928060356.27338-1-hare@suse.de>
References: <20210928060356.27338-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement NVMe-oF In-Band authentication according to NVMe TPAR 8006.
This patch adds two new fabric options 'dhchap_secret' to specify the
pre-shared key (in ASCII respresentation according to NVMe 2.0 section
8.13.5.8 'Secret representation') and 'dhchap_ctrl_secret' to specify
the pre-shared controller key for bi-directional authentication of both
the host and the controller.
Re-authentication can be triggered by writing the PSK into the new
controller sysfs attribute 'dhchap_secret' or 'dhchap_ctrl_secret'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/Kconfig   |   11 +
 drivers/nvme/host/Makefile  |    1 +
 drivers/nvme/host/auth.c    | 1069 +++++++++++++++++++++++++++++++++++
 drivers/nvme/host/auth.h    |   25 +
 drivers/nvme/host/core.c    |  128 ++++-
 drivers/nvme/host/fabrics.c |   81 ++-
 drivers/nvme/host/fabrics.h |    7 +
 drivers/nvme/host/nvme.h    |   33 ++
 drivers/nvme/host/trace.c   |   32 ++
 9 files changed, 1381 insertions(+), 6 deletions(-)
 create mode 100644 drivers/nvme/host/auth.c
 create mode 100644 drivers/nvme/host/auth.h

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index dc0450ca23a3..49269c581ec4 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -83,3 +83,14 @@ config NVME_TCP
 	  from https://github.com/linux-nvme/nvme-cli.
 
 	  If unsure, say N.
+
+config NVME_AUTH
+	bool "NVM Express over Fabrics In-Band Authentication"
+	depends on NVME_CORE
+	select CRYPTO_HMAC
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	help
+	  This provides support for NVMe over Fabrics In-Band Authentication.
+
+	  If unsure, say N.
diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
index dfaacd472e5d..4bae2a4a8d8c 100644
--- a/drivers/nvme/host/Makefile
+++ b/drivers/nvme/host/Makefile
@@ -15,6 +15,7 @@ nvme-core-$(CONFIG_NVME_MULTIPATH)	+= multipath.o
 nvme-core-$(CONFIG_BLK_DEV_ZONED)	+= zns.o
 nvme-core-$(CONFIG_FAULT_INJECTION_DEBUG_FS)	+= fault_inject.o
 nvme-core-$(CONFIG_NVME_HWMON)		+= hwmon.o
+nvme-core-$(CONFIG_NVME_AUTH)		+= auth.o
 
 nvme-y					+= pci.o
 
diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
new file mode 100644
index 000000000000..6dbd710ed876
--- /dev/null
+++ b/drivers/nvme/host/auth.c
@@ -0,0 +1,1069 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020 Hannes Reinecke, SUSE Linux
+ */
+
+#include <linux/crc32.h>
+#include <linux/base64.h>
+#include <asm/unaligned.h>
+#include <crypto/hash.h>
+#include <crypto/dh.h>
+#include <crypto/ffdhe.h>
+#include "nvme.h"
+#include "fabrics.h"
+#include "auth.h"
+
+static atomic_t nvme_dhchap_seqnum = ATOMIC_INIT(0);
+
+struct nvme_dhchap_queue_context {
+	struct list_head entry;
+	struct work_struct auth_work;
+	struct nvme_ctrl *ctrl;
+	struct crypto_shash *shash_tfm;
+	void *buf;
+	size_t buf_size;
+	int qid;
+	int error;
+	u32 s1;
+	u32 s2;
+	u16 transaction;
+	u8 status;
+	u8 hash_id;
+	u8 hash_len;
+	u8 dhgroup_id;
+	u8 c1[64];
+	u8 c2[64];
+	u8 response[64];
+	u8 *host_response;
+};
+
+static struct nvme_auth_dhgroup_map {
+	int id;
+	const char name[16];
+	const char kpp[16];
+	int privkey_size;
+	int pubkey_size;
+} dhgroup_map[] = {
+	{ .id = NVME_AUTH_DHCHAP_DHGROUP_NULL,
+	  .name = "null", .kpp = "null",
+	  .privkey_size = 0, .pubkey_size = 0 },
+	{ .id = NVME_AUTH_DHCHAP_DHGROUP_2048,
+	  .name = "ffdhe2048", .kpp = "dh",
+	  .privkey_size = 256, .pubkey_size = 256 },
+	{ .id = NVME_AUTH_DHCHAP_DHGROUP_3072,
+	  .name = "ffdhe3072", .kpp = "dh",
+	  .privkey_size = 384, .pubkey_size = 384 },
+	{ .id = NVME_AUTH_DHCHAP_DHGROUP_4096,
+	  .name = "ffdhe4096", .kpp = "dh",
+	  .privkey_size = 512, .pubkey_size = 512 },
+	{ .id = NVME_AUTH_DHCHAP_DHGROUP_6144,
+	  .name = "ffdhe6144", .kpp = "dh",
+	  .privkey_size = 768, .pubkey_size = 768 },
+	{ .id = NVME_AUTH_DHCHAP_DHGROUP_8192,
+	  .name = "ffdhe8192", .kpp = "dh",
+	  .privkey_size = 1024, .pubkey_size = 1024 },
+};
+
+const char *nvme_auth_dhgroup_name(int dhgroup_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
+		if (dhgroup_map[i].id == dhgroup_id)
+			return dhgroup_map[i].name;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_name);
+
+int nvme_auth_dhgroup_pubkey_size(int dhgroup_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
+		if (dhgroup_map[i].id == dhgroup_id)
+			return dhgroup_map[i].pubkey_size;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_pubkey_size);
+
+int nvme_auth_dhgroup_privkey_size(int dhgroup_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
+		if (dhgroup_map[i].id == dhgroup_id)
+			return dhgroup_map[i].privkey_size;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_privkey_size);
+
+const char *nvme_auth_dhgroup_kpp(int dhgroup_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
+		if (dhgroup_map[i].id == dhgroup_id)
+			return dhgroup_map[i].kpp;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_kpp);
+
+int nvme_auth_dhgroup_id(const char *dhgroup_name)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dhgroup_map); i++) {
+		if (!strncmp(dhgroup_map[i].name, dhgroup_name,
+			     strlen(dhgroup_map[i].name)))
+			return dhgroup_map[i].id;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_dhgroup_id);
+
+static struct nvme_dhchap_hash_map {
+	int id;
+	const char hmac[15];
+	const char digest[15];
+} hash_map[] = {
+	{.id = NVME_AUTH_DHCHAP_SHA256,
+	 .hmac = "hmac(sha256)", .digest = "sha256" },
+	{.id = NVME_AUTH_DHCHAP_SHA384,
+	 .hmac = "hmac(sha384)", .digest = "sha384" },
+	{.id = NVME_AUTH_DHCHAP_SHA512,
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
+unsigned char *nvme_auth_extract_secret(unsigned char *secret, size_t *out_len)
+{
+	unsigned char *key, *p;
+	u32 crc;
+	int key_len;
+	size_t allocated_len = strlen(secret);
+
+	/* Secret might be affixed with a ':' */
+	p = strrchr(secret, ':');
+	if (p)
+		allocated_len = p - secret;
+	key = kzalloc(allocated_len, GFP_KERNEL);
+	if (!key)
+		return ERR_PTR(-ENOMEM);
+
+	key_len = base64_decode(secret, allocated_len, key);
+	if (key_len != 36 && key_len != 52 &&
+	    key_len != 68) {
+		pr_debug("Invalid DH-HMAC-CHAP key len %d\n",
+			 key_len);
+		kfree_sensitive(key);
+		return ERR_PTR(-EINVAL);
+	}
+
+	/* The last four bytes is the CRC in little-endian format */
+	key_len -= 4;
+	/*
+	 * The linux implementation doesn't do pre- and post-increments,
+	 * so we have to do it manually.
+	 */
+	crc = ~crc32(~0, key, key_len);
+
+	if (get_unaligned_le32(key + key_len) != crc) {
+		pr_debug("DH-HMAC-CHAP key crc mismatch (key %08x, crc %08x)\n",
+		       get_unaligned_le32(key + key_len), crc);
+		kfree_sensitive(key);
+		return ERR_PTR(-EKEYREJECTED);
+	}
+	*out_len = key_len;
+	return key;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_extract_secret);
+
+u8 *nvme_auth_transform_key(u8 *key, size_t key_len, u8 key_hash, char *nqn)
+{
+	const char *hmac_name = nvme_auth_hmac_name(key_hash);
+	struct crypto_shash *key_tfm;
+	struct shash_desc *shash;
+	u8 *transformed_key;
+	int ret;
+
+	/* No key transformation required */
+	if (key_hash == 0)
+		return NULL;
+
+	if (!key || !key_len) {
+		pr_warn("No key specified\n");
+		return ERR_PTR(-ENOKEY);
+	}
+	if (!hmac_name) {
+		pr_warn("Invalid key hash id %d\n", key_hash);
+		return ERR_PTR(-EKEYREJECTED);
+	}
+
+	key_tfm = crypto_alloc_shash(hmac_name, 0, 0);
+	if (IS_ERR(key_tfm))
+		return (u8 *)key_tfm;
+
+	shash = kmalloc(sizeof(struct shash_desc) +
+			crypto_shash_descsize(key_tfm),
+			GFP_KERNEL);
+	if (!shash) {
+		ret = -ENOMEM;
+		goto out_free_key;
+	}
+
+	transformed_key = kzalloc(crypto_shash_digestsize(key_tfm), GFP_KERNEL);
+	if (!transformed_key) {
+		ret = -ENOMEM;
+		goto out_free_shash;
+	}
+
+	shash->tfm = key_tfm;
+	ret = crypto_shash_setkey(key_tfm, key, key_len);
+	if (ret < 0)
+		goto out_free_shash;
+	ret = crypto_shash_init(shash);
+	if (ret < 0)
+		goto out_free_shash;
+	ret = crypto_shash_update(shash, nqn, strlen(nqn));
+	if (ret < 0)
+		goto out_free_shash;
+	ret = crypto_shash_update(shash, "NVMe-over-Fabrics", 17);
+	if (ret < 0)
+		goto out_free_shash;
+	ret = crypto_shash_final(shash, transformed_key);
+out_free_shash:
+	kfree(shash);
+out_free_key:
+	crypto_free_shash(key_tfm);
+	if (ret < 0) {
+		kfree_sensitive(transformed_key);
+		return ERR_PTR(ret);
+	}
+	return transformed_key;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_transform_key);
+
+static int nvme_auth_send(struct nvme_ctrl *ctrl, int qid,
+		void *data, size_t tl)
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
+	cmd.auth_send.tl = cpu_to_le32(tl);
+
+	ret = __nvme_submit_sync_cmd(q, &cmd, NULL, data, tl, 0, qid,
+				     0, flags);
+	if (ret > 0)
+		dev_dbg(ctrl->device,
+			"%s: qid %d nvme status %d\n", __func__, qid, ret);
+	else if (ret < 0)
+		dev_dbg(ctrl->device,
+			"%s: qid %d error %d\n", __func__, qid, ret);
+	return ret;
+}
+
+static int nvme_auth_receive(struct nvme_ctrl *ctrl, int qid,
+		void *buf, size_t al)
+{
+	struct nvme_command cmd = {};
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
+	cmd.auth_receive.al = cpu_to_le32(al);
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
+
+	return 0;
+}
+
+static int nvme_auth_receive_validate(struct nvme_ctrl *ctrl, int qid,
+		struct nvmf_auth_dhchap_failure_data *data,
+		u16 transaction, u8 expected_msg)
+{
+	dev_dbg(ctrl->device, "%s: qid %d auth_type %d auth_id %x\n",
+		__func__, qid, data->auth_type, data->auth_id);
+
+	if (data->auth_type == NVME_AUTH_COMMON_MESSAGES &&
+	    data->auth_id == NVME_AUTH_DHCHAP_MESSAGE_FAILURE1) {
+		return data->rescode_exp;
+	}
+	if (data->auth_type != NVME_AUTH_DHCHAP_MESSAGES ||
+	    data->auth_id != expected_msg) {
+		dev_warn(ctrl->device,
+			 "qid %d invalid message %02x/%02x\n",
+			 qid, data->auth_type, data->auth_id);
+		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_MESSAGE;
+	}
+	if (le16_to_cpu(data->t_id) != transaction) {
+		dev_warn(ctrl->device,
+			 "qid %d invalid transaction ID %d\n",
+			 qid, le16_to_cpu(data->t_id));
+		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_MESSAGE;
+	}
+	return 0;
+}
+
+static int nvme_auth_set_dhchap_negotiate_data(struct nvme_ctrl *ctrl,
+		struct nvme_dhchap_queue_context *chap)
+{
+	struct nvmf_auth_dhchap_negotiate_data *data = chap->buf;
+	size_t size = sizeof(*data) + sizeof(union nvmf_auth_protocol);
+
+	if (chap->buf_size < size) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		return -EINVAL;
+	}
+	memset((u8 *)chap->buf, 0, size);
+	data->auth_type = NVME_AUTH_COMMON_MESSAGES;
+	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
+	data->t_id = cpu_to_le16(chap->transaction);
+	data->sc_c = 0; /* No secure channel concatenation */
+	data->napd = 1;
+	data->auth_protocol[0].dhchap.authid = NVME_AUTH_DHCHAP_AUTH_ID;
+	data->auth_protocol[0].dhchap.halen = 3;
+	data->auth_protocol[0].dhchap.dhlen = 6;
+	data->auth_protocol[0].dhchap.idlist[0] = NVME_AUTH_DHCHAP_SHA256;
+	data->auth_protocol[0].dhchap.idlist[1] = NVME_AUTH_DHCHAP_SHA384;
+	data->auth_protocol[0].dhchap.idlist[2] = NVME_AUTH_DHCHAP_SHA512;
+	data->auth_protocol[0].dhchap.idlist[3] = NVME_AUTH_DHCHAP_DHGROUP_NULL;
+	data->auth_protocol[0].dhchap.idlist[4] = NVME_AUTH_DHCHAP_DHGROUP_2048;
+	data->auth_protocol[0].dhchap.idlist[5] = NVME_AUTH_DHCHAP_DHGROUP_3072;
+	data->auth_protocol[0].dhchap.idlist[6] = NVME_AUTH_DHCHAP_DHGROUP_4096;
+	data->auth_protocol[0].dhchap.idlist[7] = NVME_AUTH_DHCHAP_DHGROUP_6144;
+	data->auth_protocol[0].dhchap.idlist[8] = NVME_AUTH_DHCHAP_DHGROUP_8192;
+
+	return size;
+}
+
+static int nvme_auth_process_dhchap_challenge(struct nvme_ctrl *ctrl,
+		struct nvme_dhchap_queue_context *chap)
+{
+	struct nvmf_auth_dhchap_challenge_data *data = chap->buf;
+	u16 dhvlen = le16_to_cpu(data->dhvlen);
+	size_t size = sizeof(*data) + data->hl + dhvlen;
+	const char *gid_name = nvme_auth_dhgroup_name(data->dhgid);
+	const char *hmac_name, *kpp_name;
+
+	if (chap->buf_size < size) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		return NVME_SC_INVALID_FIELD;
+	}
+
+	hmac_name = nvme_auth_hmac_name(data->hashid);
+	if (!hmac_name) {
+		dev_warn(ctrl->device,
+			 "qid %d: invalid HASH ID %d\n",
+			 chap->qid, data->hashid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
+		return NVME_SC_INVALID_FIELD;
+	}
+
+	if (chap->hash_id == data->hashid && chap->shash_tfm &&
+	    !strcmp(crypto_shash_alg_name(chap->shash_tfm), hmac_name) &&
+	    crypto_shash_digestsize(chap->shash_tfm) == data->hl) {
+		dev_dbg(ctrl->device,
+			"qid %d: reuse existing hash %s\n",
+			chap->qid, hmac_name);
+		goto select_kpp;
+	}
+
+	/* Reset if hash cannot be reused */
+	if (chap->shash_tfm) {
+		crypto_free_shash(chap->shash_tfm);
+		chap->hash_id = 0;
+		chap->hash_len = 0;
+	}
+	chap->shash_tfm = crypto_alloc_shash(hmac_name, 0,
+					     CRYPTO_ALG_ALLOCATES_MEMORY);
+	if (IS_ERR(chap->shash_tfm)) {
+		dev_warn(ctrl->device,
+			 "qid %d: failed to allocate hash %s, error %ld\n",
+			 chap->qid, hmac_name, PTR_ERR(chap->shash_tfm));
+		chap->shash_tfm = NULL;
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
+		return NVME_SC_AUTH_REQUIRED;
+	}
+
+	if (crypto_shash_digestsize(chap->shash_tfm) != data->hl) {
+		dev_warn(ctrl->device,
+			 "qid %d: invalid hash length %d\n",
+			 chap->qid, data->hl);
+		crypto_free_shash(chap->shash_tfm);
+		chap->shash_tfm = NULL;
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
+		return NVME_SC_AUTH_REQUIRED;
+	}
+
+	/* Reset host response if the hash had been changed */
+	if (chap->hash_id != data->hashid) {
+		kfree(chap->host_response);
+		chap->host_response = NULL;
+	}
+
+	chap->hash_id = data->hashid;
+	chap->hash_len = data->hl;
+	dev_dbg(ctrl->device, "qid %d: selected hash %s\n",
+		chap->qid, hmac_name);
+
+select_kpp:
+	kpp_name = nvme_auth_dhgroup_kpp(data->dhgid);
+	if (!kpp_name) {
+		dev_warn(ctrl->device,
+			 "qid %d: invalid DH group id %d\n",
+			 chap->qid, data->dhgid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
+		return NVME_SC_AUTH_REQUIRED;
+	}
+
+	if (data->dhgid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
+		dev_warn(ctrl->device,
+			 "qid %d: unsupported DH group %s\n",
+			 chap->qid, kpp_name);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
+		return NVME_SC_AUTH_REQUIRED;
+	} else if (dhvlen != 0) {
+		dev_warn(ctrl->device,
+			 "qid %d: invalid DH value for NULL DH\n",
+			chap->qid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		return NVME_SC_AUTH_REQUIRED;
+	}
+	chap->dhgroup_id = data->dhgid;
+	dev_dbg(ctrl->device, "qid %d: selected DH group %s\n",
+		chap->qid, gid_name);
+
+	chap->s1 = le32_to_cpu(data->seqnum);
+	memcpy(chap->c1, data->cval, chap->hash_len);
+
+	return 0;
+}
+
+static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
+		struct nvme_dhchap_queue_context *chap)
+{
+	struct nvmf_auth_dhchap_reply_data *data = chap->buf;
+	size_t size = sizeof(*data);
+
+	size += 2 * chap->hash_len;
+
+	if (chap->buf_size < size) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		return -EINVAL;
+	}
+
+	memset(chap->buf, 0, size);
+	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
+	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_REPLY;
+	data->t_id = cpu_to_le16(chap->transaction);
+	data->hl = chap->hash_len;
+	data->dhvlen = 0;
+	memcpy(data->rval, chap->response, chap->hash_len);
+	if (ctrl->opts->dhchap_ctrl_secret) {
+		get_random_bytes(chap->c2, chap->hash_len);
+		data->cvalid = 1;
+		chap->s2 = atomic_inc_return(&nvme_dhchap_seqnum);
+		memcpy(data->rval + chap->hash_len, chap->c2,
+		       chap->hash_len);
+		dev_dbg(ctrl->device, "%s: qid %d ctrl challenge %*ph\n",
+			__func__, chap->qid,
+			chap->hash_len, chap->c2);
+	} else {
+		memset(chap->c2, 0, chap->hash_len);
+		chap->s2 = 0;
+	}
+	data->seqnum = cpu_to_le32(chap->s2);
+	return size;
+}
+
+static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
+		struct nvme_dhchap_queue_context *chap)
+{
+	struct nvmf_auth_dhchap_success1_data *data = chap->buf;
+	size_t size = sizeof(*data);
+
+	if (ctrl->opts->dhchap_ctrl_secret)
+		size += chap->hash_len;
+
+	if (chap->buf_size < size) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		return NVME_SC_INVALID_FIELD;
+	}
+
+	if (data->hl != chap->hash_len) {
+		dev_warn(ctrl->device,
+			 "qid %d: invalid hash length %d\n",
+			 chap->qid, data->hl);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
+		return NVME_SC_INVALID_FIELD;
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
+			 "qid %d: controller authentication failed\n",
+			 chap->qid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
+		return NVME_SC_AUTH_REQUIRED;
+	}
+
+	/* Just print out information for the admin queue */
+	if (chap->qid == -1)
+		dev_info(ctrl->device,
+			 "qid 0: controller authenticated\n");
+	return 0;
+}
+
+static int nvme_auth_set_dhchap_success2_data(struct nvme_ctrl *ctrl,
+		struct nvme_dhchap_queue_context *chap)
+{
+	struct nvmf_auth_dhchap_success2_data *data = chap->buf;
+	size_t size = sizeof(*data);
+
+	memset(chap->buf, 0, size);
+	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
+	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_SUCCESS2;
+	data->t_id = cpu_to_le16(chap->transaction);
+
+	return size;
+}
+
+static int nvme_auth_set_dhchap_failure2_data(struct nvme_ctrl *ctrl,
+		struct nvme_dhchap_queue_context *chap)
+{
+	struct nvmf_auth_dhchap_failure_data *data = chap->buf;
+	size_t size = sizeof(*data);
+
+	memset(chap->buf, 0, size);
+	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
+	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_FAILURE2;
+	data->t_id = cpu_to_le16(chap->transaction);
+	data->rescode = NVME_AUTH_DHCHAP_FAILURE_REASON_FAILED;
+	data->rescode_exp = chap->status;
+
+	return size;
+}
+
+static int nvme_auth_dhchap_host_response(struct nvme_ctrl *ctrl,
+		struct nvme_dhchap_queue_context *chap)
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
+	if (challenge != chap->c1)
+		kfree(challenge);
+	return ret;
+}
+
+static int nvme_auth_dhchap_ctrl_response(struct nvme_ctrl *ctrl,
+		struct nvme_dhchap_queue_context *chap)
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
+	if (challenge != chap->c2)
+		kfree(challenge);
+	return ret;
+}
+
+int nvme_auth_generate_key(struct nvme_ctrl *ctrl)
+{
+	int ret = 0;
+	u8 *dhchap_secret = ctrl->opts->dhchap_secret;
+	u8 key_hash;
+
+	if (!dhchap_secret)
+		return 0;
+
+	if (ctrl->dhchap_key && ctrl->dhchap_key_len)
+		/* Key already set */
+		return 0;
+
+	if (sscanf(dhchap_secret, "DHHC-1:%hhd:%*s:", &key_hash) != 1)
+		return -EINVAL;
+
+	/* Pass in the secret without the 'DHHC-1:XX:' prefix */
+	ctrl->dhchap_key = nvme_auth_extract_secret(dhchap_secret + 10,
+						&ctrl->dhchap_key_len);
+	if (IS_ERR(ctrl->dhchap_key)) {
+		ret = PTR_ERR(ctrl->dhchap_key);
+		ctrl->dhchap_key = NULL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_generate_key);
+
+int nvme_auth_generate_ctrl_key(struct nvme_ctrl *ctrl)
+{
+	int ret = 0;
+	u8 *dhchap_secret = ctrl->opts->dhchap_ctrl_secret;
+	u8 key_hash;
+
+	if (!dhchap_secret)
+		return 0;
+
+	if (ctrl->dhchap_ctrl_key && ctrl->dhchap_ctrl_key_len)
+		/* Key already set */
+		return 0;
+
+	if (sscanf(dhchap_secret, "DHHC-1:%hhd:%*s:", &key_hash) != 1)
+		return -EINVAL;
+
+	/* Pass in the secret without the 'DHHC-1:XX:' prefix */
+	ctrl->dhchap_ctrl_key = nvme_auth_extract_secret(dhchap_secret + 10,
+						&ctrl->dhchap_ctrl_key_len);
+	if (IS_ERR(ctrl->dhchap_ctrl_key)) {
+		ret = PTR_ERR(ctrl->dhchap_ctrl_key);
+		ctrl->dhchap_ctrl_key = NULL;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_generate_ctrl_key);
+
+static void nvme_auth_reset(struct nvme_dhchap_queue_context *chap)
+{
+	chap->status = 0;
+	chap->error = 0;
+	chap->s1 = 0;
+	chap->s2 = 0;
+	chap->transaction = 0;
+	memset(chap->c1, 0, sizeof(chap->c1));
+	memset(chap->c2, 0, sizeof(chap->c2));
+}
+
+static void __nvme_auth_free(struct nvme_dhchap_queue_context *chap)
+{
+	if (chap->shash_tfm)
+		crypto_free_shash(chap->shash_tfm);
+	kfree_sensitive(chap->host_response);
+	kfree(chap->buf);
+	kfree(chap);
+}
+
+static void __nvme_auth_work(struct work_struct *work)
+{
+	struct nvme_dhchap_queue_context *chap =
+		container_of(work, struct nvme_dhchap_queue_context, auth_work);
+	struct nvme_ctrl *ctrl = chap->ctrl;
+	size_t tl;
+	int ret = 0;
+
+	chap->transaction = ctrl->transaction++;
+
+	/* DH-HMAC-CHAP Step 1: send negotiate */
+	dev_dbg(ctrl->device, "%s: qid %d send negotiate\n",
+		__func__, chap->qid);
+	ret = nvme_auth_set_dhchap_negotiate_data(ctrl, chap);
+	if (ret < 0) {
+		chap->error = ret;
+		return;
+	}
+	tl = ret;
+	ret = nvme_auth_send(ctrl, chap->qid, chap->buf, tl);
+	if (ret) {
+		chap->error = ret;
+		return;
+	}
+
+	/* DH-HMAC-CHAP Step 2: receive challenge */
+	dev_dbg(ctrl->device, "%s: qid %d receive challenge\n",
+		__func__, chap->qid);
+
+	memset(chap->buf, 0, chap->buf_size);
+	ret = nvme_auth_receive(ctrl, chap->qid, chap->buf, chap->buf_size);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "qid %d failed to receive challenge, %s %d\n",
+			 chap->qid, ret < 0 ? "error" : "nvme status", ret);
+		chap->error = ret;
+		return;
+	}
+	ret = nvme_auth_receive_validate(ctrl, chap->qid, chap->buf, chap->transaction,
+					 NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE);
+	if (ret) {
+		chap->status = ret;
+		chap->error = NVME_SC_AUTH_REQUIRED;
+		return;
+	}
+
+	ret = nvme_auth_process_dhchap_challenge(ctrl, chap);
+	if (ret) {
+		/* Invalid challenge parameters */
+		goto fail2;
+	}
+
+	dev_dbg(ctrl->device, "%s: qid %d host response\n",
+		__func__, chap->qid);
+	ret = nvme_auth_dhchap_host_response(ctrl, chap);
+	if (ret)
+		goto fail2;
+
+	/* DH-HMAC-CHAP Step 3: send reply */
+	dev_dbg(ctrl->device, "%s: qid %d send reply\n",
+		__func__, chap->qid);
+	ret = nvme_auth_set_dhchap_reply_data(ctrl, chap);
+	if (ret < 0)
+		goto fail2;
+
+	tl = ret;
+	ret = nvme_auth_send(ctrl, chap->qid, chap->buf, tl);
+	if (ret)
+		goto fail2;
+
+	/* DH-HMAC-CHAP Step 4: receive success1 */
+	dev_dbg(ctrl->device, "%s: qid %d receive success1\n",
+		__func__, chap->qid);
+
+	memset(chap->buf, 0, chap->buf_size);
+	ret = nvme_auth_receive(ctrl, chap->qid, chap->buf, chap->buf_size);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "qid %d failed to receive success1, %s %d\n",
+			 chap->qid, ret < 0 ? "error" : "nvme status", ret);
+		chap->error = ret;
+		return;
+	}
+	ret = nvme_auth_receive_validate(ctrl, chap->qid,
+					 chap->buf, chap->transaction,
+					 NVME_AUTH_DHCHAP_MESSAGE_SUCCESS1);
+	if (ret) {
+		chap->status = ret;
+		chap->error = NVME_SC_AUTH_REQUIRED;
+		return;
+	}
+
+	if (ctrl->opts->dhchap_ctrl_secret) {
+		dev_dbg(ctrl->device,
+			"%s: qid %d controller response\n",
+			__func__, chap->qid);
+		ret = nvme_auth_dhchap_ctrl_response(ctrl, chap);
+		if (ret)
+			goto fail2;
+	}
+
+	ret = nvme_auth_process_dhchap_success1(ctrl, chap);
+	if (ret < 0) {
+		/* Controller authentication failed */
+		goto fail2;
+	}
+
+	/* DH-HMAC-CHAP Step 5: send success2 */
+	dev_dbg(ctrl->device, "%s: qid %d send success2\n",
+		__func__, chap->qid);
+	tl = nvme_auth_set_dhchap_success2_data(ctrl, chap);
+	ret = nvme_auth_send(ctrl, chap->qid, chap->buf, tl);
+	if (!ret) {
+		chap->error = 0;
+		return;
+	}
+
+fail2:
+	dev_dbg(ctrl->device, "%s: qid %d send failure2, status %x\n",
+		__func__, chap->qid, chap->status);
+	tl = nvme_auth_set_dhchap_failure2_data(ctrl, chap);
+	ret = nvme_auth_send(ctrl, chap->qid, chap->buf, tl);
+	if (!ret)
+		ret = -EPROTO;
+	chap->error = ret;
+}
+
+int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid)
+{
+	struct nvme_dhchap_queue_context *chap;
+
+	if (!ctrl->dhchap_key || !ctrl->dhchap_key_len) {
+		dev_warn(ctrl->device, "qid %d: no key\n", qid);
+		return -ENOKEY;
+	}
+
+	mutex_lock(&ctrl->dhchap_auth_mutex);
+	/* Check if the context is already queued */
+	list_for_each_entry(chap, &ctrl->dhchap_auth_list, entry) {
+		if (chap->qid == qid) {
+			mutex_unlock(&ctrl->dhchap_auth_mutex);
+			queue_work(nvme_wq, &chap->auth_work);
+			return 0;
+		}
+	}
+	chap = kzalloc(sizeof(*chap), GFP_KERNEL);
+	if (!chap) {
+		mutex_unlock(&ctrl->dhchap_auth_mutex);
+		return -ENOMEM;
+	}
+	chap->qid = qid;
+	chap->ctrl = ctrl;
+
+	/*
+	 * Allocate a large enough buffer for the entire negotiation:
+	 * 4k should be enough to ffdhe8192.
+	 */
+	chap->buf_size = 4096;
+	chap->buf = kzalloc(chap->buf_size, GFP_KERNEL);
+	if (!chap->buf) {
+		mutex_unlock(&ctrl->dhchap_auth_mutex);
+		kfree(chap);
+		return -ENOMEM;
+	}
+
+	INIT_WORK(&chap->auth_work, __nvme_auth_work);
+	list_add(&chap->entry, &ctrl->dhchap_auth_list);
+	mutex_unlock(&ctrl->dhchap_auth_mutex);
+	queue_work(nvme_wq, &chap->auth_work);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_negotiate);
+
+int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid)
+{
+	struct nvme_dhchap_queue_context *chap;
+	int ret;
+
+	mutex_lock(&ctrl->dhchap_auth_mutex);
+	list_for_each_entry(chap, &ctrl->dhchap_auth_list, entry) {
+		if (chap->qid != qid)
+			continue;
+		mutex_unlock(&ctrl->dhchap_auth_mutex);
+		flush_work(&chap->auth_work);
+		ret = chap->error;
+		nvme_auth_reset(chap);
+		return ret;
+	}
+	mutex_unlock(&ctrl->dhchap_auth_mutex);
+	return -ENXIO;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_wait);
+
+static void nvme_dhchap_auth_work(struct work_struct *work)
+{
+	struct nvme_ctrl *ctrl =
+		container_of(work, struct nvme_ctrl, dhchap_auth_work);
+	int ret, q;
+
+	/* Authenticate admin queue first */
+	ret = nvme_auth_negotiate(ctrl, NVME_QID_ANY);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "qid 0: error %d setting up authentication\n", ret);
+		return;
+	}
+	ret = nvme_auth_wait(ctrl, NVME_QID_ANY);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "qid 0: authentication failed\n");
+		return;
+	}
+	dev_info(ctrl->device, "qid 0: authenticated\n");
+
+	for (q = 1; q < ctrl->queue_count; q++) {
+		ret = nvme_auth_negotiate(ctrl, q);
+		if (ret) {
+			dev_warn(ctrl->device,
+				 "qid %d: error %d setting up authentication\n",
+				 q, ret);
+			break;
+		}
+	}
+
+	/*
+	 * Failure is a soft-state; credentials remain valid until
+	 * the controller terminates the connection.
+	 */
+}
+
+void nvme_auth_init_ctrl(struct nvme_ctrl *ctrl)
+{
+	INIT_LIST_HEAD(&ctrl->dhchap_auth_list);
+	INIT_WORK(&ctrl->dhchap_auth_work, nvme_dhchap_auth_work);
+	mutex_init(&ctrl->dhchap_auth_mutex);
+	nvme_auth_generate_key(ctrl);
+	nvme_auth_generate_ctrl_key(ctrl);
+}
+EXPORT_SYMBOL_GPL(nvme_auth_init_ctrl);
+
+void nvme_auth_stop(struct nvme_ctrl *ctrl)
+{
+	struct nvme_dhchap_queue_context *chap = NULL, *tmp;
+
+	cancel_work_sync(&ctrl->dhchap_auth_work);
+	mutex_lock(&ctrl->dhchap_auth_mutex);
+	list_for_each_entry_safe(chap, tmp, &ctrl->dhchap_auth_list, entry)
+		cancel_work_sync(&chap->auth_work);
+	mutex_unlock(&ctrl->dhchap_auth_mutex);
+}
+EXPORT_SYMBOL_GPL(nvme_auth_stop);
+
+void nvme_auth_free(struct nvme_ctrl *ctrl)
+{
+	struct nvme_dhchap_queue_context *chap = NULL, *tmp;
+
+	mutex_lock(&ctrl->dhchap_auth_mutex);
+	list_for_each_entry_safe(chap, tmp, &ctrl->dhchap_auth_list, entry) {
+		list_del_init(&chap->entry);
+		flush_work(&chap->auth_work);
+		__nvme_auth_free(chap);
+	}
+	mutex_unlock(&ctrl->dhchap_auth_mutex);
+	kfree(ctrl->dhchap_key);
+	ctrl->dhchap_key = NULL;
+	ctrl->dhchap_key_len = 0;
+	kfree(ctrl->dhchap_ctrl_key);
+	ctrl->dhchap_ctrl_key = NULL;
+	ctrl->dhchap_ctrl_key_len = 0;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_free);
diff --git a/drivers/nvme/host/auth.h b/drivers/nvme/host/auth.h
new file mode 100644
index 000000000000..cf1255f9db6d
--- /dev/null
+++ b/drivers/nvme/host/auth.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Hannes Reinecke, SUSE Software Solutions
+ */
+
+#ifndef _NVME_AUTH_H
+#define _NVME_AUTH_H
+
+#include <crypto/kpp.h>
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
+
+unsigned char *nvme_auth_extract_secret(unsigned char *dhchap_secret,
+					size_t *dhchap_key_len);
+u8 *nvme_auth_transform_key(u8 *key, size_t key_len, u8 key_hash, char *nqn);
+
+#endif /* _NVME_AUTH_H */
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e486845d2c7e..737b744f564e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -23,6 +23,7 @@
 
 #include "nvme.h"
 #include "fabrics.h"
+#include "auth.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -198,6 +199,7 @@ int nvme_reset_ctrl(struct nvme_ctrl *ctrl)
 {
 	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
 		return -EBUSY;
+	nvme_auth_stop(ctrl);
 	if (!queue_work(nvme_reset_wq, &ctrl->reset_work))
 		return -EBUSY;
 	return 0;
@@ -321,6 +323,7 @@ enum nvme_disposition {
 	COMPLETE,
 	RETRY,
 	FAILOVER,
+	AUTHENTICATE,
 };
 
 static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
@@ -328,6 +331,9 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
 	if (likely(nvme_req(req)->status == 0))
 		return COMPLETE;
 
+	if ((nvme_req(req)->status & 0x7ff) == NVME_SC_AUTH_REQUIRED)
+		return AUTHENTICATE;
+
 	if (blk_noretry_request(req) ||
 	    (nvme_req(req)->status & NVME_SC_DNR) ||
 	    nvme_req(req)->retries >= nvme_max_retries)
@@ -360,11 +366,13 @@ static inline void nvme_end_req(struct request *req)
 
 void nvme_complete_rq(struct request *req)
 {
+	struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
+
 	trace_nvme_complete_rq(req);
 	nvme_cleanup_cmd(req);
 
-	if (nvme_req(req)->ctrl->kas)
-		nvme_req(req)->ctrl->comp_seen = true;
+	if (ctrl->kas)
+		ctrl->comp_seen = true;
 
 	switch (nvme_decide_disposition(req)) {
 	case COMPLETE:
@@ -376,6 +384,14 @@ void nvme_complete_rq(struct request *req)
 	case FAILOVER:
 		nvme_failover_req(req);
 		return;
+	case AUTHENTICATE:
+#ifdef CONFIG_NVME_AUTH
+		queue_work(nvme_wq, &ctrl->dhchap_auth_work);
+		nvme_retry_req(req);
+#else
+		nvme_end_req(req);
+#endif
+		return;
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_complete_rq);
@@ -706,7 +722,9 @@ bool __nvme_check_ready(struct nvme_ctrl *ctrl, struct request *rq,
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
@@ -3457,6 +3475,98 @@ static ssize_t nvme_ctrl_fast_io_fail_tmo_store(struct device *dev,
 static DEVICE_ATTR(fast_io_fail_tmo, S_IRUGO | S_IWUSR,
 	nvme_ctrl_fast_io_fail_tmo_show, nvme_ctrl_fast_io_fail_tmo_store);
 
+#ifdef CONFIG_NVME_AUTH
+static ssize_t nvme_ctrl_dhchap_secret_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+	struct nvmf_ctrl_options *opts = ctrl->opts;
+
+	if (!opts->dhchap_secret)
+		return sysfs_emit(buf, "none\n");
+	return sysfs_emit(buf, "%s\n", opts->dhchap_secret);
+}
+
+static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+	struct nvmf_ctrl_options *opts = ctrl->opts;
+	char *dhchap_secret;
+
+	if (!ctrl->opts->dhchap_secret)
+		return -EINVAL;
+	if (count < 7)
+		return -EINVAL;
+	if (memcmp(buf, "DHHC-1:", 7))
+		return -EINVAL;
+
+	dhchap_secret = kzalloc(count + 1, GFP_KERNEL);
+	if (!dhchap_secret)
+		return -ENOMEM;
+	memcpy(dhchap_secret, buf, count);
+	if (strcmp(dhchap_secret, opts->dhchap_secret)) {
+		kfree(opts->dhchap_secret);
+		opts->dhchap_secret = dhchap_secret;
+		/* Key has changed; re-authenticate with new key */
+		nvme_auth_free(ctrl);
+		nvme_auth_generate_key(ctrl);
+	}
+	/* Start re-authentication */
+	dev_info(ctrl->device, "re-authenticating controller\n");
+	queue_work(nvme_wq, &ctrl->dhchap_auth_work);
+
+	return count;
+}
+DEVICE_ATTR(dhchap_secret, S_IRUGO | S_IWUSR,
+	nvme_ctrl_dhchap_secret_show, nvme_ctrl_dhchap_secret_store);
+
+static ssize_t nvme_ctrl_dhchap_ctrl_secret_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+	struct nvmf_ctrl_options *opts = ctrl->opts;
+
+	if (!opts->dhchap_ctrl_secret)
+		return sysfs_emit(buf, "none\n");
+	return sysfs_emit(buf, "%s\n", opts->dhchap_ctrl_secret);
+}
+
+static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+	struct nvmf_ctrl_options *opts = ctrl->opts;
+	char *dhchap_secret;
+
+	if (!ctrl->opts->dhchap_ctrl_secret)
+		return -EINVAL;
+	if (count < 7)
+		return -EINVAL;
+	if (memcmp(buf, "DHHC-1:", 7))
+		return -EINVAL;
+
+	dhchap_secret = kzalloc(count + 1, GFP_KERNEL);
+	if (!dhchap_secret)
+		return -ENOMEM;
+	memcpy(dhchap_secret, buf, count);
+	if (strcmp(dhchap_secret, opts->dhchap_ctrl_secret)) {
+		kfree(opts->dhchap_ctrl_secret);
+		opts->dhchap_ctrl_secret = dhchap_secret;
+		/* Key has changed; re-authenticate with new key */
+		nvme_auth_free(ctrl);
+		nvme_auth_generate_ctrl_key(ctrl);
+	}
+	/* Start re-authentication */
+	dev_info(ctrl->device, "re-authenticating controller\n");
+	queue_work(nvme_wq, &ctrl->dhchap_auth_work);
+
+	return count;
+}
+DEVICE_ATTR(dhchap_ctrl_secret, S_IRUGO | S_IWUSR,
+	nvme_ctrl_dhchap_ctrl_secret_show, nvme_ctrl_dhchap_ctrl_secret_store);
+#endif
+
 static struct attribute *nvme_dev_attrs[] = {
 	&dev_attr_reset_controller.attr,
 	&dev_attr_rescan_controller.attr,
@@ -3478,6 +3588,10 @@ static struct attribute *nvme_dev_attrs[] = {
 	&dev_attr_reconnect_delay.attr,
 	&dev_attr_fast_io_fail_tmo.attr,
 	&dev_attr_kato.attr,
+#ifdef CONFIG_NVME_AUTH
+	&dev_attr_dhchap_secret.attr,
+	&dev_attr_dhchap_ctrl_secret.attr,
+#endif
 	NULL
 };
 
@@ -3501,6 +3615,10 @@ static umode_t nvme_dev_attrs_are_visible(struct kobject *kobj,
 		return 0;
 	if (a == &dev_attr_fast_io_fail_tmo.attr && !ctrl->opts)
 		return 0;
+#ifdef CONFIG_NVME_AUTH
+	if (a == &dev_attr_dhchap_secret.attr && !ctrl->opts)
+		return 0;
+#endif
 
 	return a->mode;
 }
@@ -4226,6 +4344,7 @@ static void nvme_fw_act_work(struct work_struct *work)
 		fw_act_timeout = jiffies +
 				msecs_to_jiffies(admin_timeout * 1000);
 
+	nvme_auth_stop(ctrl);
 	nvme_stop_queues(ctrl);
 	while (nvme_ctrl_pp_status(ctrl)) {
 		if (time_after(jiffies, fw_act_timeout)) {
@@ -4310,6 +4429,7 @@ EXPORT_SYMBOL_GPL(nvme_complete_async_event);
 void nvme_stop_ctrl(struct nvme_ctrl *ctrl)
 {
 	nvme_mpath_stop(ctrl);
+	nvme_auth_stop(ctrl);
 	nvme_stop_keep_alive(ctrl);
 	nvme_stop_failfast_work(ctrl);
 	flush_work(&ctrl->async_event_work);
@@ -4364,6 +4484,7 @@ static void nvme_free_ctrl(struct device *dev)
 
 	nvme_free_cels(ctrl);
 	nvme_mpath_uninit(ctrl);
+	nvme_auth_free(ctrl);
 	__free_page(ctrl->discard_page);
 
 	if (subsys) {
@@ -4454,6 +4575,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 
 	nvme_fault_inject_init(&ctrl->fault_inject, dev_name(ctrl->device));
 	nvme_mpath_init_ctrl(ctrl);
+	nvme_auth_init_ctrl(ctrl);
 
 	return 0;
 out_free_name:
diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 9a8eade7cd23..4a0127f72c41 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -370,6 +370,7 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl)
 	union nvme_result res;
 	struct nvmf_connect_data *data;
 	int ret;
+	u32 result;
 
 	cmd.connect.opcode = nvme_fabrics_command;
 	cmd.connect.fctype = nvme_fabrics_type_connect;
@@ -402,8 +403,25 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl)
 		goto out_free_data;
 	}
 
-	ctrl->cntlid = le16_to_cpu(res.u16);
-
+	result = le32_to_cpu(res.u32);
+	ctrl->cntlid = result & 0xFFFF;
+	if ((result >> 16) & 2) {
+		/* Authentication required */
+		ret = nvme_auth_negotiate(ctrl, NVME_QID_ANY);
+		if (ret) {
+			dev_warn(ctrl->device,
+				 "qid 0: authentication setup failed\n");
+			ret = NVME_SC_AUTH_REQUIRED;
+			goto out_free_data;
+		}
+		ret = nvme_auth_wait(ctrl, NVME_QID_ANY);
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
@@ -436,6 +454,7 @@ int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid)
 	struct nvmf_connect_data *data;
 	union nvme_result res;
 	int ret;
+	u32 result;
 
 	cmd.connect.opcode = nvme_fabrics_command;
 	cmd.connect.fctype = nvme_fabrics_type_connect;
@@ -461,6 +480,21 @@ int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid)
 		nvmf_log_connect_error(ctrl, ret, le32_to_cpu(res.u32),
 				       &cmd, data);
 	}
+	result = le32_to_cpu(res.u32);
+	if ((result >> 16) & 2) {
+		/* Authentication required */
+		ret = nvme_auth_negotiate(ctrl, qid);
+		if (ret) {
+			dev_warn(ctrl->device,
+				 "qid %d: authentication setup failed\n", qid);
+			ret = NVME_SC_AUTH_REQUIRED;
+		} else {
+			ret = nvme_auth_wait(ctrl, qid);
+			if (ret)
+				dev_warn(ctrl->device,
+					 "qid %u: authentication failed\n", qid);
+		}
+	}
 	kfree(data);
 	return ret;
 }
@@ -552,6 +586,8 @@ static const match_table_t opt_tokens = {
 	{ NVMF_OPT_NR_POLL_QUEUES,	"nr_poll_queues=%d"	},
 	{ NVMF_OPT_TOS,			"tos=%d"		},
 	{ NVMF_OPT_FAIL_FAST_TMO,	"fast_io_fail_tmo=%d"	},
+	{ NVMF_OPT_DHCHAP_SECRET,	"dhchap_secret=%s"	},
+	{ NVMF_OPT_DHCHAP_CTRL_SECRET,	"dhchap_ctrl_secret=%s"	},
 	{ NVMF_OPT_ERR,			NULL			}
 };
 
@@ -827,6 +863,34 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			}
 			opts->tos = token;
 			break;
+		case NVMF_OPT_DHCHAP_SECRET:
+			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
+				pr_err("Invalid DH-CHAP secret %s\n", p);
+				ret = -EINVAL;
+				goto out;
+			}
+			kfree(opts->dhchap_secret);
+			opts->dhchap_secret = p;
+			break;
+		case NVMF_OPT_DHCHAP_CTRL_SECRET:
+			p = match_strdup(args);
+			if (!p) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			if (strlen(p) < 11 || strncmp(p, "DHHC-1:", 7)) {
+				pr_err("Invalid DH-CHAP secret %s\n", p);
+				ret = -EINVAL;
+				goto out;
+			}
+			kfree(opts->dhchap_ctrl_secret);
+			opts->dhchap_ctrl_secret = p;
+			break;
 		default:
 			pr_warn("unknown parameter or missing value '%s' in ctrl creation request\n",
 				p);
@@ -945,6 +1009,7 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 	kfree(opts->subsysnqn);
 	kfree(opts->host_traddr);
 	kfree(opts->host_iface);
+	kfree(opts->dhchap_secret);
 	kfree(opts);
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
@@ -954,7 +1019,10 @@ EXPORT_SYMBOL_GPL(nvmf_free_options);
 				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
 				 NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT |\
 				 NVMF_OPT_DISABLE_SQFLOW |\
-				 NVMF_OPT_FAIL_FAST_TMO)
+				 NVMF_OPT_CTRL_LOSS_TMO |\
+				 NVMF_OPT_FAIL_FAST_TMO |\
+				 NVMF_OPT_DHCHAP_SECRET |\
+				 NVMF_OPT_DHCHAP_CTRL_SECRET)
 
 static struct nvme_ctrl *
 nvmf_create_ctrl(struct device *dev, const char *buf)
@@ -1171,7 +1239,14 @@ static void __exit nvmf_exit(void)
 	BUILD_BUG_ON(sizeof(struct nvmf_connect_command) != 64);
 	BUILD_BUG_ON(sizeof(struct nvmf_property_get_command) != 64);
 	BUILD_BUG_ON(sizeof(struct nvmf_property_set_command) != 64);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_send_command) != 64);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_receive_command) != 64);
 	BUILD_BUG_ON(sizeof(struct nvmf_connect_data) != 1024);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_negotiate_data) != 8);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_challenge_data) != 16);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_reply_data) != 16);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_success1_data) != 16);
+	BUILD_BUG_ON(sizeof(struct nvmf_auth_dhchap_success2_data) != 16);
 }
 
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index a146cb903869..d1cb61e5f8d4 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -67,6 +67,8 @@ enum {
 	NVMF_OPT_TOS		= 1 << 19,
 	NVMF_OPT_FAIL_FAST_TMO	= 1 << 20,
 	NVMF_OPT_HOST_IFACE	= 1 << 21,
+	NVMF_OPT_DHCHAP_SECRET	= 1 << 22,
+	NVMF_OPT_DHCHAP_CTRL_SECRET = 1 << 23,
 };
 
 /**
@@ -96,6 +98,9 @@ enum {
  * @max_reconnects: maximum number of allowed reconnect attempts before removing
  *              the controller, (-1) means reconnect forever, zero means remove
  *              immediately;
+ * @dhchap_secret: DH-HMAC-CHAP secret
+ * @dhchap_ctrl_secret: DH-HMAC-CHAP controller secret for bi-directional
+ *              authentication
  * @disable_sqflow: disable controller sq flow control
  * @hdr_digest: generate/verify header digest (TCP)
  * @data_digest: generate/verify data digest (TCP)
@@ -120,6 +125,8 @@ struct nvmf_ctrl_options {
 	unsigned int		kato;
 	struct nvmf_host	*host;
 	int			max_reconnects;
+	char			*dhchap_secret;
+	char			*dhchap_ctrl_secret;
 	bool			disable_sqflow;
 	bool			hdr_digest;
 	bool			data_digest;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9871c0c9374c..b67fdcd6b1fb 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -318,6 +318,17 @@ struct nvme_ctrl {
 	struct work_struct ana_work;
 #endif
 
+#ifdef CONFIG_NVME_AUTH
+	struct work_struct dhchap_auth_work;
+	struct list_head dhchap_auth_list;
+	struct mutex dhchap_auth_mutex;
+	unsigned char *dhchap_key;
+	unsigned char *dhchap_ctrl_key;
+	size_t dhchap_key_len;
+	size_t dhchap_ctrl_key_len;
+	u16 transaction;
+#endif
+
 	/* Power saving configuration */
 	u64 ps_max_latency_us;
 	bool apst_enabled;
@@ -885,6 +896,28 @@ static inline bool nvme_ctrl_sgl_supported(struct nvme_ctrl *ctrl)
 	return ctrl->sgls & ((1 << 0) | (1 << 1));
 }
 
+#ifdef CONFIG_NVME_AUTH
+void nvme_auth_init_ctrl(struct nvme_ctrl *ctrl);
+void nvme_auth_stop(struct nvme_ctrl *ctrl);
+int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid);
+int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid);
+void nvme_auth_free(struct nvme_ctrl *ctrl);
+int nvme_auth_generate_key(struct nvme_ctrl *ctrl);
+int nvme_auth_generate_ctrl_key(struct nvme_ctrl *ctrl);
+#else
+static inline void nvme_auth_init_ctrl(struct nvme_ctrl *ctrl) {};
+static inline void nvme_auth_stop(struct nvme_ctrl *ctrl) {};
+static inline int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid)
+{
+	return -EPROTONOSUPPORT;
+}
+static inline int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid)
+{
+	return NVME_SC_AUTH_REQUIRED;
+}
+static inline void nvme_auth_free(struct nvme_ctrl *ctrl) {};
+#endif
+
 u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 			 u8 opcode);
 int nvme_execute_passthru_rq(struct request *rq);
diff --git a/drivers/nvme/host/trace.c b/drivers/nvme/host/trace.c
index 2a89c5aa0790..1c36fcedea20 100644
--- a/drivers/nvme/host/trace.c
+++ b/drivers/nvme/host/trace.c
@@ -287,6 +287,34 @@ static const char *nvme_trace_fabrics_property_get(struct trace_seq *p, u8 *spc)
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
@@ -306,6 +334,10 @@ const char *nvme_trace_parse_fabrics_cmd(struct trace_seq *p,
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

