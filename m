Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA74C43219
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 06:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9D666109F
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Sep 2021 06:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhIJGo7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Sep 2021 02:44:59 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42296 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhIJGow (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Sep 2021 02:44:52 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 38F7622408;
        Fri, 10 Sep 2021 06:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631256219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XOJAIp0nfsdDvdwFxYB6RpmW/1SzjoIF6rav2F1ibJw=;
        b=ATV77AYICglC/E27hFmiA2hM8vT/E6cDMb7r0pjBnSb29IlQTddfD70Mm6hveCUsqnzX6s
        QPyJC+E714uIoq8qdOTuv7VN7trb1WJRWBbo7uQ+PpNMdj4nL9tLZcic08X1uhGtLa7Lig
        6ZpARzLqJZzsTVtF5EEO4rOl7uW1ay8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631256219;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XOJAIp0nfsdDvdwFxYB6RpmW/1SzjoIF6rav2F1ibJw=;
        b=HJmRFNr/xg4yN8uCItfUV6iDOYI2QKBWatRbo5CjtBOeFSUIE/0vmmkEs5mRM3wT3vM32Y
        +DTSfaUvAOS/KFDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 27B88A3BAE;
        Fri, 10 Sep 2021 06:43:39 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B158D518E328; Fri, 10 Sep 2021 08:43:36 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/12] nvme: Implement In-Band authentication
Date:   Fri, 10 Sep 2021 08:43:17 +0200
Message-Id: <20210910064322.67705-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210910064322.67705-1-hare@suse.de>
References: <20210910064322.67705-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement NVMe-oF In-Band authentication according to NVMe TPAR 8006.
This patch adds two new fabric options 'dhchap_secret' to specify the
pre-shared key (in ASCII respresentation according to NVMe 2.0 section
8.13.5.8 'Secret representation') and 'dhchap_bidi' to request bi-directional
authentication of both the host and the controller.
Re-authentication can be triggered by writing the PSK into the new
controller sysfs attribute 'dhchap_secret'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/Kconfig   |   12 +
 drivers/nvme/host/Makefile  |    1 +
 drivers/nvme/host/auth.c    | 1285 +++++++++++++++++++++++++++++++++++
 drivers/nvme/host/auth.h    |   25 +
 drivers/nvme/host/core.c    |   79 ++-
 drivers/nvme/host/fabrics.c |   73 +-
 drivers/nvme/host/fabrics.h |    6 +
 drivers/nvme/host/nvme.h    |   30 +
 drivers/nvme/host/trace.c   |   32 +
 9 files changed, 1537 insertions(+), 6 deletions(-)
 create mode 100644 drivers/nvme/host/auth.c
 create mode 100644 drivers/nvme/host/auth.h

diff --git a/drivers/nvme/host/Kconfig b/drivers/nvme/host/Kconfig
index dc0450ca23a3..97e8412dc42d 100644
--- a/drivers/nvme/host/Kconfig
+++ b/drivers/nvme/host/Kconfig
@@ -83,3 +83,15 @@ config NVME_TCP
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
+	  This provides support for NVMe over Fabrics In-Band Authentication
+	  for the NVMe over TCP transport.
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
index 000000000000..5393ac16a002
--- /dev/null
+++ b/drivers/nvme/host/auth.c
@@ -0,0 +1,1285 @@
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
+static u32 nvme_dhchap_seqnum;
+
+struct nvme_dhchap_queue_context {
+	struct list_head entry;
+	struct work_struct auth_work;
+	struct nvme_ctrl *ctrl;
+	struct crypto_shash *shash_tfm;
+	struct crypto_kpp *dh_tfm;
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
+	  .name = "NULL", .kpp = "NULL",
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
+	unsigned char *key;
+	u32 crc;
+	int key_len;
+	size_t allocated_len;
+
+	allocated_len = strlen(secret);
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
+		return 0;
+
+	hmac_name = nvme_auth_hmac_name(key_hash);
+	if (!hmac_name) {
+		pr_warn("Invalid key hash id %d\n", key_hash);
+		return ERR_PTR(-EKEYREJECTED);
+	}
+	key_tfm = crypto_alloc_shash(hmac_name, 0, 0);
+	if (IS_ERR(key_tfm))
+		return (u8 *)key_tfm;
+
+	shash = kmalloc(sizeof(struct shash_desc) +
+			crypto_shash_descsize(key_tfm),
+			GFP_KERNEL);
+	if (!shash) {
+		crypto_free_shash(key_tfm);
+		return ERR_PTR(-ENOMEM);
+	}
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
+	crypto_free_shash(key_tfm);
+	if (ret < 0) {
+		kfree_sensitive(transformed_key);
+		return ERR_PTR(ret);
+	}
+	return transformed_key;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_transform_key);
+
+static int nvme_auth_hash_skey(int hmac_id, u8 *skey, size_t skey_len, u8 *hkey)
+{
+	const char *digest_name;
+	struct crypto_shash *tfm;
+	int ret;
+
+	digest_name = nvme_auth_digest_name(hmac_id);
+	if (!digest_name) {
+		pr_debug("%s: failed to get digest for %d\n", __func__,
+			 hmac_id);
+		return -EINVAL;
+	}
+	tfm = crypto_alloc_shash(digest_name, 0, 0);
+	if (IS_ERR(tfm))
+		return -ENOMEM;
+
+	ret = crypto_shash_tfm_digest(tfm, skey, skey_len, hkey);
+	if (ret < 0)
+		pr_debug("%s: Failed to hash digest len %zu\n", __func__,
+			 skey_len);
+
+	crypto_free_shash(tfm);
+	return ret;
+}
+
+int nvme_auth_augmented_challenge(u8 hmac_id, u8 *skey, size_t skey_len,
+		u8 *challenge, u8 *aug, size_t hlen)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	u8 *hashed_key;
+	const char *hmac_name;
+	int ret;
+
+	hashed_key = kmalloc(hlen, GFP_KERNEL);
+	if (!hashed_key)
+		return -ENOMEM;
+
+	ret = nvme_auth_hash_skey(hmac_id, skey,
+				  skey_len, hashed_key);
+	if (ret < 0)
+		goto out_free_key;
+
+	hmac_name = nvme_auth_hmac_name(hmac_id);
+	if (!hmac_name) {
+		pr_warn("%s: invalid hash algoritm %d\n",
+			__func__, hmac_id);
+		ret = -EINVAL;
+		goto out_free_key;
+	}
+	tfm = crypto_alloc_shash(hmac_name, 0, 0);
+	if (IS_ERR(tfm)) {
+		ret = PTR_ERR(tfm);
+		goto out_free_key;
+	}
+	desc = kmalloc(sizeof(struct shash_desc) + crypto_shash_descsize(tfm),
+		       GFP_KERNEL);
+	if (!desc) {
+		ret = -ENOMEM;
+		goto out_free_hash;
+	}
+	desc->tfm = tfm;
+
+	ret = crypto_shash_setkey(tfm, hashed_key, hlen);
+	if (ret)
+		goto out_free_desc;
+
+	ret = crypto_shash_init(desc);
+	if (ret)
+		goto out_free_desc;
+
+	ret = crypto_shash_update(desc, challenge, hlen);
+	if (ret)
+		goto out_free_desc;
+
+	ret = crypto_shash_final(desc, aug);
+out_free_desc:
+	kfree_sensitive(desc);
+out_free_hash:
+	crypto_free_shash(tfm);
+out_free_key:
+	kfree_sensitive(hashed_key);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_augmented_challenge);
+
+int nvme_auth_gen_privkey(struct crypto_kpp *dh_tfm, int dh_gid)
+{
+	char *pkey;
+	int ret, pkey_len;
+
+	if (dh_gid == NVME_AUTH_DHCHAP_DHGROUP_2048 ||
+	    dh_gid == NVME_AUTH_DHCHAP_DHGROUP_3072 ||
+	    dh_gid == NVME_AUTH_DHCHAP_DHGROUP_4096 ||
+	    dh_gid == NVME_AUTH_DHCHAP_DHGROUP_6144 ||
+	    dh_gid == NVME_AUTH_DHCHAP_DHGROUP_8192) {
+		struct dh p = {0};
+		int bits = nvme_auth_dhgroup_pubkey_size(dh_gid) << 3;
+		int dh_secret_len = 64;
+		u8 *dh_secret = kzalloc(dh_secret_len, GFP_KERNEL);
+
+		if (!dh_secret)
+			return -ENOMEM;
+
+		/*
+		 * NVMe base spec v2.0: The DH value shall be set to the value
+		 * of g^x mod p, where 'x' is a random number selected by the
+		 * host that shall be at least 256 bits long.
+		 *
+		 * We will be using a 512 bit random number as private key.
+		 * This is large enough to provide adequate security, but
+		 * small enough such that we can trivially conform to
+		 * NIST SB800-56A section 5.6.1.1.4 if
+		 * we guarantee that the random number is not either
+		 * all 0xff or all 0x00. But that should be guaranteed
+		 * by the in-kernel RNG anyway.
+		 */
+		get_random_bytes(dh_secret, dh_secret_len);
+
+		ret = crypto_ffdhe_params(&p, bits);
+		if (ret) {
+			kfree_sensitive(dh_secret);
+			return ret;
+		}
+
+		p.key = dh_secret;
+		p.key_size = dh_secret_len;
+
+		pkey_len = crypto_dh_key_len(&p);
+		pkey = kmalloc(pkey_len, GFP_KERNEL);
+		if (!pkey) {
+			kfree_sensitive(dh_secret);
+			return -ENOMEM;
+		}
+
+		get_random_bytes(pkey, pkey_len);
+		ret = crypto_dh_encode_key(pkey, pkey_len, &p);
+		if (ret) {
+			pr_debug("failed to encode private key, error %d\n",
+				 ret);
+			kfree_sensitive(dh_secret);
+			goto out;
+		}
+	} else {
+		pr_warn("invalid dh group %d\n", dh_gid);
+		return -EINVAL;
+	}
+	ret = crypto_kpp_set_secret(dh_tfm, pkey, pkey_len);
+	if (ret)
+		pr_debug("failed to set private key, error %d\n", ret);
+out:
+	kfree_sensitive(pkey);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_gen_privkey);
+
+int nvme_auth_gen_pubkey(struct crypto_kpp *dh_tfm,
+		u8 *host_key, size_t host_key_len)
+{
+	struct kpp_request *req;
+	struct crypto_wait wait;
+	struct scatterlist dst;
+	int ret;
+
+	req = kpp_request_alloc(dh_tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	crypto_init_wait(&wait);
+	kpp_request_set_input(req, NULL, 0);
+	sg_init_one(&dst, host_key, host_key_len);
+	kpp_request_set_output(req, &dst, host_key_len);
+	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				 crypto_req_done, &wait);
+
+	ret = crypto_wait_req(crypto_kpp_generate_public_key(req), &wait);
+
+	kpp_request_free(req);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_gen_pubkey);
+
+int nvme_auth_gen_shared_secret(struct crypto_kpp *dh_tfm,
+		u8 *ctrl_key, size_t ctrl_key_len,
+		u8 *sess_key, size_t sess_key_len)
+{
+	struct kpp_request *req;
+	struct crypto_wait wait;
+	struct scatterlist src, dst;
+	int ret;
+
+	req = kpp_request_alloc(dh_tfm, GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	crypto_init_wait(&wait);
+	sg_init_one(&src, ctrl_key, ctrl_key_len);
+	kpp_request_set_input(req, &src, ctrl_key_len);
+	sg_init_one(&dst, sess_key, sess_key_len);
+	kpp_request_set_output(req, &dst, sess_key_len);
+	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				 crypto_req_done, &wait);
+
+	ret = crypto_wait_req(crypto_kpp_compute_shared_secret(req), &wait);
+
+	kpp_request_free(req);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_gen_shared_secret);
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
+	cmd.auth_send.tl = tl;
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
+	size_t size = sizeof(*data) + data->hl + data->dhvlen;
+	const char *hmac_name;
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
+		return -EPROTO;
+	}
+	if (chap->hash_id == data->hashid && chap->shash_tfm &&
+	    !strcmp(crypto_shash_alg_name(chap->shash_tfm), hmac_name) &&
+	    crypto_shash_digestsize(chap->shash_tfm) == data->hl) {
+		dev_dbg(ctrl->device,
+			"qid %d: reuse existing hash %s\n",
+			chap->qid, hmac_name);
+		goto select_kpp;
+	}
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
+	if (crypto_shash_digestsize(chap->shash_tfm) != data->hl) {
+		dev_warn(ctrl->device,
+			 "qid %d: invalid hash length %d\n",
+			 chap->qid, data->hl);
+		crypto_free_shash(chap->shash_tfm);
+		chap->shash_tfm = NULL;
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_HASH_UNUSABLE;
+		return NVME_SC_AUTH_REQUIRED;
+	}
+	if (chap->hash_id != data->hashid) {
+		kfree(chap->host_response);
+		chap->host_response = NULL;
+	}
+	chap->hash_id = data->hashid;
+	chap->hash_len = data->hl;
+	dev_dbg(ctrl->device, "qid %d: selected hash %s\n",
+		chap->qid, hmac_name);
+
+	gid_name = nvme_auth_dhgroup_kpp(data->dhgid);
+	if (!gid_name) {
+		dev_warn(ctrl->device,
+			 "qid %d: invalid DH group id %d\n",
+			 chap->qid, data->dhgid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
+		return -EPROTO;
+	}
+
+	if (data->dhgid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
+		if (data->dhvlen == 0) {
+			dev_warn(ctrl->device,
+				 "qid %d: empty DH value\n",
+				 chap->qid);
+			chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
+			return -EPROTO;
+		}
+		chap->dh_tfm = crypto_alloc_kpp(gid_name, 0, 0);
+		if (IS_ERR(chap->dh_tfm)) {
+			int ret = PTR_ERR(chap->dh_tfm);
+
+			dev_warn(ctrl->device,
+				 "qid %d: failed to initialize %s\n",
+				 chap->qid, gid_name);
+			chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
+			chap->dh_tfm = NULL;
+			return ret;
+		}
+		chap->dhgroup_id = data->dhgid;
+	} else if (data->dhvlen != 0) {
+		dev_warn(ctrl->device,
+			 "qid %d: invalid DH value for NULL DH\n",
+			chap->qid);
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
+		return -EPROTO;
+	}
+	dev_dbg(ctrl->device, "qid %d: selected DH group %s\n",
+		chap->qid, gid_name);
+
+select_kpp:
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
+	if (ctrl->opts->dhchap_bidi) {
+		get_random_bytes(chap->c2, chap->hash_len);
+		chap->s2 = nvme_dhchap_seqnum++;
+	} else
+		memset(chap->c2, 0, chap->hash_len);
+
+
+	if (chap->buf_size < size) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		return -EINVAL;
+	}
+	memset(chap->buf, 0, size);
+	data->auth_type = NVME_AUTH_DHCHAP_MESSAGES;
+	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_REPLY;
+	data->t_id = cpu_to_le16(chap->transaction);
+	data->hl = chap->hash_len;
+	data->dhvlen = 0;
+	data->seqnum = cpu_to_le32(chap->s2);
+	memcpy(data->rval, chap->response, chap->hash_len);
+	if (ctrl->opts->dhchap_bidi) {
+		dev_dbg(ctrl->device, "%s: qid %d ctrl challenge %*ph\n",
+			__func__, chap->qid,
+			chap->hash_len, chap->c2);
+		data->cvalid = 1;
+		memcpy(data->rval + chap->hash_len, chap->c2,
+		       chap->hash_len);
+	}
+	return size;
+}
+
+static int nvme_auth_process_dhchap_success1(struct nvme_ctrl *ctrl,
+		struct nvme_dhchap_queue_context *chap)
+{
+	struct nvmf_auth_dhchap_success1_data *data = chap->buf;
+	size_t size = sizeof(*data);
+
+	if (ctrl->opts->dhchap_bidi)
+		size += chap->hash_len;
+
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
+	dev_info(ctrl->device,
+		 "qid %d: controller authenticated\n",
+		chap->qid);
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
+	if (chap->dh_tfm) {
+		challenge = kmalloc(chap->hash_len, GFP_KERNEL);
+		if (!challenge) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = nvme_auth_augmented_challenge(chap->hash_id,
+						    chap->sess_key,
+						    chap->sess_key_len,
+						    chap->c1, challenge,
+						    chap->hash_len);
+		if (ret)
+			goto out;
+	}
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
+	if (chap->dh_tfm) {
+		challenge = kmalloc(chap->hash_len, GFP_KERNEL);
+		if (!challenge) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = nvme_auth_augmented_challenge(chap->hash_id,
+						    chap->sess_key,
+						    chap->sess_key_len,
+						    chap->c2, challenge,
+						    chap->hash_len);
+		if (ret)
+			goto out;
+	}
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
+	int ret;
+	u8 key_hash;
+
+	if (!ctrl->opts->dhchap_secret)
+		return 0;
+
+	if (ctrl->dhchap_key && ctrl->dhchap_key_len)
+		/* Key already set */
+		return 0;
+
+	if (sscanf(ctrl->opts->dhchap_secret, "DHHC-1:%hhd:%*s:",
+		   &key_hash) != 1)
+		return -EINVAL;
+
+	/* Pass in the secret without the 'DHHC-1:XX:' prefix */
+	ctrl->dhchap_key = nvme_auth_extract_secret(ctrl->opts->dhchap_secret + 10,
+					     &ctrl->dhchap_key_len);
+	if (IS_ERR(ctrl->dhchap_key)) {
+		ret = PTR_ERR(ctrl->dhchap_key);
+		ctrl->dhchap_key = NULL;
+		return ret;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_generate_key);
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
+	if (chap->ctrl_key_len) {
+		dev_dbg(ctrl->device,
+			"%s: qid %d DH exponential\n",
+			__func__, chap->qid);
+		ret = nvme_auth_dhchap_exponential(ctrl, chap);
+		if (ret)
+			goto fail2;
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
+	if (ctrl->opts->dhchap_bidi) {
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
+/* Assumes that the controller is in state RESETTING */
+static void nvme_dhchap_auth_work(struct work_struct *work)
+{
+	struct nvme_ctrl *ctrl =
+		container_of(work, struct nvme_ctrl, dhchap_auth_work);
+	int ret, q;
+
+	nvme_stop_queues(ctrl);
+	/* Authenticate admin queue first */
+	ret = nvme_auth_negotiate(ctrl, NVME_QID_ANY);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "qid 0: error %d setting up authentication\n", ret);
+		goto out;
+	}
+	ret = nvme_auth_wait(ctrl, NVME_QID_ANY);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "qid 0: authentication failed\n");
+		goto out;
+	}
+	dev_info(ctrl->device, "qid 0: authenticated\n");
+
+	for (q = 1; q < ctrl->queue_count; q++) {
+		ret = nvme_auth_negotiate(ctrl, q);
+		if (ret) {
+			dev_warn(ctrl->device,
+				 "qid %d: error %d setting up authentication\n",
+				 q, ret);
+			goto out;
+		}
+	}
+out:
+	/*
+	 * Failure is a soft-state; credentials remain valid until
+	 * the controller terminates the connection.
+	 */
+	if (nvme_change_ctrl_state(ctrl, NVME_CTRL_LIVE))
+		nvme_start_queues(ctrl);
+}
+
+void nvme_auth_init_ctrl(struct nvme_ctrl *ctrl)
+{
+	INIT_LIST_HEAD(&ctrl->dhchap_auth_list);
+	INIT_WORK(&ctrl->dhchap_auth_work, nvme_dhchap_auth_work);
+	mutex_init(&ctrl->dhchap_auth_mutex);
+	nvme_auth_generate_key(ctrl);
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
index 7efb31b87f37..f669b054790b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -24,6 +24,7 @@
 
 #include "nvme.h"
 #include "fabrics.h"
+#include "auth.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -322,6 +323,7 @@ enum nvme_disposition {
 	COMPLETE,
 	RETRY,
 	FAILOVER,
+	AUTHENTICATE,
 };
 
 static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
@@ -329,6 +331,9 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
 	if (likely(nvme_req(req)->status == 0))
 		return COMPLETE;
 
+	if ((nvme_req(req)->status & 0x7ff) == NVME_SC_AUTH_REQUIRED)
+		return AUTHENTICATE;
+
 	if (blk_noretry_request(req) ||
 	    (nvme_req(req)->status & NVME_SC_DNR) ||
 	    nvme_req(req)->retries >= nvme_max_retries)
@@ -361,11 +366,13 @@ static inline void nvme_end_req(struct request *req)
 
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
@@ -377,6 +384,15 @@ void nvme_complete_rq(struct request *req)
 	case FAILOVER:
 		nvme_failover_req(req);
 		return;
+	case AUTHENTICATE:
+#ifdef CONFIG_NVME_AUTH
+		if (nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
+			queue_work(nvme_wq, &ctrl->dhchap_auth_work);
+		nvme_retry_req(req);
+#else
+		nvme_end_req(req);
+#endif
+		return;
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_complete_rq);
@@ -707,7 +723,9 @@ bool __nvme_check_ready(struct nvme_ctrl *ctrl, struct request *rq,
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
@@ -3458,6 +3476,51 @@ static ssize_t nvme_ctrl_fast_io_fail_tmo_store(struct device *dev,
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
+		/* Key has changed; reset authentication data */
+		nvme_auth_free(ctrl);
+		nvme_auth_generate_key(ctrl);
+	}
+	if (nvme_change_ctrl_state(ctrl, NVME_CTRL_RESETTING))
+		queue_work(nvme_wq, &ctrl->dhchap_auth_work);
+	return count;
+}
+DEVICE_ATTR(dhchap_secret, S_IRUGO | S_IWUSR,
+	nvme_ctrl_dhchap_secret_show, nvme_ctrl_dhchap_secret_store);
+#endif
+
 static struct attribute *nvme_dev_attrs[] = {
 	&dev_attr_reset_controller.attr,
 	&dev_attr_rescan_controller.attr,
@@ -3479,6 +3542,9 @@ static struct attribute *nvme_dev_attrs[] = {
 	&dev_attr_reconnect_delay.attr,
 	&dev_attr_fast_io_fail_tmo.attr,
 	&dev_attr_kato.attr,
+#ifdef CONFIG_NVME_AUTH
+	&dev_attr_dhchap_secret.attr,
+#endif
 	NULL
 };
 
@@ -3502,6 +3568,10 @@ static umode_t nvme_dev_attrs_are_visible(struct kobject *kobj,
 		return 0;
 	if (a == &dev_attr_fast_io_fail_tmo.attr && !ctrl->opts)
 		return 0;
+#ifdef CONFIG_NVME_AUTH
+	if (a == &dev_attr_dhchap_secret.attr && !ctrl->opts)
+		return 0;
+#endif
 
 	return a->mode;
 }
@@ -4312,6 +4382,7 @@ EXPORT_SYMBOL_GPL(nvme_complete_async_event);
 void nvme_stop_ctrl(struct nvme_ctrl *ctrl)
 {
 	nvme_mpath_stop(ctrl);
+	nvme_auth_stop(ctrl);
 	nvme_stop_keep_alive(ctrl);
 	nvme_stop_failfast_work(ctrl);
 	flush_work(&ctrl->async_event_work);
@@ -4366,6 +4437,7 @@ static void nvme_free_ctrl(struct device *dev)
 
 	nvme_free_cels(ctrl);
 	nvme_mpath_uninit(ctrl);
+	nvme_auth_free(ctrl);
 	__free_page(ctrl->discard_page);
 
 	if (subsys) {
@@ -4456,6 +4528,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 
 	nvme_fault_inject_init(&ctrl->fault_inject, dev_name(ctrl->device));
 	nvme_mpath_init_ctrl(ctrl);
+	nvme_auth_init_ctrl(ctrl);
 
 	return 0;
 out_free_name:
diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 9a8eade7cd23..ee6058c24743 100644
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
+				 "qid 0: failed to setup authentication\n");
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
@@ -461,6 +480,24 @@ int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid)
 		nvmf_log_connect_error(ctrl, ret, le32_to_cpu(res.u32),
 				       &cmd, data);
 	}
+	result = le32_to_cpu(res.u32);
+	if ((result >> 16) & 2) {
+		/* Authentication required */
+		ret = nvme_auth_negotiate(ctrl, qid);
+		if (ret) {
+			dev_warn(ctrl->device,
+				 "qid %d: failed to setup authentication\n", qid);
+			ret = NVME_SC_AUTH_REQUIRED;
+		} else {
+			ret = nvme_auth_wait(ctrl, qid);
+			if (ret)
+				dev_warn(ctrl->device,
+					 "qid %u: authentication failed\n", qid);
+			else
+				dev_info(ctrl->device,
+					 "qid %u: authenticated\n", qid);
+		}
+	}
 	kfree(data);
 	return ret;
 }
@@ -552,6 +589,8 @@ static const match_table_t opt_tokens = {
 	{ NVMF_OPT_NR_POLL_QUEUES,	"nr_poll_queues=%d"	},
 	{ NVMF_OPT_TOS,			"tos=%d"		},
 	{ NVMF_OPT_FAIL_FAST_TMO,	"fast_io_fail_tmo=%d"	},
+	{ NVMF_OPT_DHCHAP_SECRET,	"dhchap_secret=%s"	},
+	{ NVMF_OPT_DHCHAP_BIDI,		"dhchap_bidi"		},
 	{ NVMF_OPT_ERR,			NULL			}
 };
 
@@ -827,6 +866,23 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
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
+		case NVMF_OPT_DHCHAP_BIDI:
+			opts->dhchap_bidi = true;
+			break;
 		default:
 			pr_warn("unknown parameter or missing value '%s' in ctrl creation request\n",
 				p);
@@ -945,6 +1001,7 @@ void nvmf_free_options(struct nvmf_ctrl_options *opts)
 	kfree(opts->subsysnqn);
 	kfree(opts->host_traddr);
 	kfree(opts->host_iface);
+	kfree(opts->dhchap_secret);
 	kfree(opts);
 }
 EXPORT_SYMBOL_GPL(nvmf_free_options);
@@ -954,7 +1011,10 @@ EXPORT_SYMBOL_GPL(nvmf_free_options);
 				 NVMF_OPT_KATO | NVMF_OPT_HOSTNQN | \
 				 NVMF_OPT_HOST_ID | NVMF_OPT_DUP_CONNECT |\
 				 NVMF_OPT_DISABLE_SQFLOW |\
-				 NVMF_OPT_FAIL_FAST_TMO)
+				 NVMF_OPT_CTRL_LOSS_TMO |\
+				 NVMF_OPT_FAIL_FAST_TMO |\
+				 NVMF_OPT_DHCHAP_SECRET |\
+				 NVMF_OPT_DHCHAP_BIDI)
 
 static struct nvme_ctrl *
 nvmf_create_ctrl(struct device *dev, const char *buf)
@@ -1171,7 +1231,14 @@ static void __exit nvmf_exit(void)
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
index a146cb903869..27df1aac5736 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -67,6 +67,8 @@ enum {
 	NVMF_OPT_TOS		= 1 << 19,
 	NVMF_OPT_FAIL_FAST_TMO	= 1 << 20,
 	NVMF_OPT_HOST_IFACE	= 1 << 21,
+	NVMF_OPT_DHCHAP_SECRET	= 1 << 22,
+	NVMF_OPT_DHCHAP_BIDI	= 1 << 23,
 };
 
 /**
@@ -96,6 +98,8 @@ enum {
  * @max_reconnects: maximum number of allowed reconnect attempts before removing
  *              the controller, (-1) means reconnect forever, zero means remove
  *              immediately;
+ * @dhchap_secret: DH-HMAC-CHAP secret
+ * @dhchap_bidi: enable DH-HMAC-CHAP bi-directional authentication
  * @disable_sqflow: disable controller sq flow control
  * @hdr_digest: generate/verify header digest (TCP)
  * @data_digest: generate/verify data digest (TCP)
@@ -120,6 +124,8 @@ struct nvmf_ctrl_options {
 	unsigned int		kato;
 	struct nvmf_host	*host;
 	int			max_reconnects;
+	char			*dhchap_secret;
+	bool			dhchap_bidi;
 	bool			disable_sqflow;
 	bool			hdr_digest;
 	bool			data_digest;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 9871c0c9374c..b0dcb7d79b9e 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -318,6 +318,15 @@ struct nvme_ctrl {
 	struct work_struct ana_work;
 #endif
 
+#ifdef CONFIG_NVME_AUTH
+	struct work_struct dhchap_auth_work;
+	struct list_head dhchap_auth_list;
+	struct mutex dhchap_auth_mutex;
+	unsigned char *dhchap_key;
+	size_t dhchap_key_len;
+	u16 transaction;
+#endif
+
 	/* Power saving configuration */
 	u64 ps_max_latency_us;
 	bool apst_enabled;
@@ -885,6 +894,27 @@ static inline bool nvme_ctrl_sgl_supported(struct nvme_ctrl *ctrl)
 	return ctrl->sgls & ((1 << 0) | (1 << 1));
 }
 
+#ifdef CONFIG_NVME_AUTH
+void nvme_auth_init_ctrl(struct nvme_ctrl *ctrl);
+void nvme_auth_stop(struct nvme_ctrl *ctrl);
+int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid);
+int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid);
+void nvme_auth_free(struct nvme_ctrl *ctrl);
+int nvme_auth_generate_key(struct nvme_ctrl *ctrl);
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

