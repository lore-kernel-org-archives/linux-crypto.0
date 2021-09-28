Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1C6C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B6B861159
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239177AbhI1GHc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:07:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51950 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239213AbhI1GGk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 02:06:40 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out1.suse.de (Postfix) with ESMTP id DCE5522311;
        Tue, 28 Sep 2021 06:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632809047; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sAU6dru1b45jW7Fpqj04MOVVKrC6l2/QEBJ8XGBRSUc=;
        b=FJuRDdVweeb5JNMwCoH/fI9Trhe1rTsVJw8F3QEFiA/HrijVwZN3j1AWoWfsZZ9H094Jze
        FoadfiA4P/AvZ5sSY0jtItzUrFtTRyU6FZCIVI19J9sSn+TeYWRkpQRkJzIbY2Rz3tBfhL
        f4tCo0CidxtDAxg3PvhAuL3hNp0HEaU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632809047;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sAU6dru1b45jW7Fpqj04MOVVKrC6l2/QEBJ8XGBRSUc=;
        b=GTqAu+is9VJnSBd32sMkfT8frbKssqDdEmJIl76cOEoR+M4gPaCKDt3s+PegeAmYzeGk/B
        ffKLjo7tMCbgBsCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay1.suse.de (Postfix) with ESMTP id C732125E6E;
        Tue, 28 Sep 2021 06:04:07 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 767F6518EE34; Tue, 28 Sep 2021 08:04:06 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/12] nvmet-auth: Diffie-Hellman key exchange support
Date:   Tue, 28 Sep 2021 08:03:55 +0200
Message-Id: <20210928060356.27338-12-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210928060356.27338-1-hare@suse.de>
References: <20210928060356.27338-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement Diffie-Hellman key exchange using FFDHE groups for NVMe
In-Band Authentication.
This patch adds a new host configfs attribute 'dhchap_dhgroup' to
select the FFDHE group to use.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/target/Kconfig            |   1 +
 drivers/nvme/target/auth.c             | 148 ++++++++++++++++++++++++-
 drivers/nvme/target/configfs.c         |  31 ++++++
 drivers/nvme/target/fabrics-cmd-auth.c |  31 +++++-
 drivers/nvme/target/nvmet.h            |   6 +
 5 files changed, 209 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/Kconfig b/drivers/nvme/target/Kconfig
index 70f3c385fc9f..2e41d70fd881 100644
--- a/drivers/nvme/target/Kconfig
+++ b/drivers/nvme/target/Kconfig
@@ -90,6 +90,7 @@ config NVME_TARGET_AUTH
 	select CRYPTO_HMAC
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_FFDHE
 	help
 	  This enables support for NVMe over Fabrics In-band Authentication
 
diff --git a/drivers/nvme/target/auth.c b/drivers/nvme/target/auth.c
index 7247a7b97644..274b199bb6d7 100644
--- a/drivers/nvme/target/auth.c
+++ b/drivers/nvme/target/auth.c
@@ -77,6 +77,71 @@ int nvmet_auth_set_ctrl_key(struct nvmet_host *host, const char *secret)
 	return host->dhchap_ctrl_secret ? 0 : -ENOMEM;
 }
 
+int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, int dhgroup_id)
+{
+	struct nvmet_host_link *p;
+	struct nvmet_host *host = NULL;
+	const char *dhgroup_kpp;
+	int ret = -ENOTSUPP;
+
+	if (dhgroup_id == NVME_AUTH_DHCHAP_DHGROUP_NULL)
+		return 0;
+
+	down_read(&nvmet_config_sem);
+	if (ctrl->subsys->type == NVME_NQN_DISC)
+		goto out_unlock;
+
+	list_for_each_entry(p, &ctrl->subsys->hosts, entry) {
+		if (strcmp(nvmet_host_name(p->host), ctrl->hostnqn))
+			continue;
+		host = p->host;
+		break;
+	}
+	if (!host) {
+		pr_debug("host %s not found\n", ctrl->hostnqn);
+		ret = -ENXIO;
+		goto out_unlock;
+	}
+
+	if (host->dhchap_dhgroup_id != dhgroup_id) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	if (ctrl->dh_tfm) {
+		if (ctrl->dh_gid == dhgroup_id) {
+			pr_debug("reuse existing DH group %d\n", dhgroup_id);
+			ret = 0;
+		} else {
+			pr_debug("DH group mismatch (selected %d, requested %d)\n",
+				 ctrl->dh_gid, dhgroup_id);
+			ret = -EINVAL;
+		}
+		goto out_unlock;
+	}
+
+	dhgroup_kpp = nvme_auth_dhgroup_kpp(dhgroup_id);
+	if (!dhgroup_kpp) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	ctrl->dh_tfm = crypto_alloc_kpp(dhgroup_kpp, 0, 0);
+	if (IS_ERR(ctrl->dh_tfm)) {
+		pr_debug("failed to setup DH group %d, err %ld\n",
+			 dhgroup_id, PTR_ERR(ctrl->dh_tfm));
+		ret = PTR_ERR(ctrl->dh_tfm);
+		ctrl->dh_tfm = NULL;
+	} else {
+		ctrl->dh_gid = dhgroup_id;
+		ctrl->dh_keysize = nvme_auth_dhgroup_pubkey_size(dhgroup_id);
+		ret = 0;
+	}
+
+out_unlock:
+	up_read(&nvmet_config_sem);
+
+	return ret;
+}
+
 int nvmet_setup_auth(struct nvmet_ctrl *ctrl)
 {
 	int ret = 0;
@@ -190,6 +255,11 @@ void nvmet_destroy_auth(struct nvmet_ctrl *ctrl)
 		ctrl->shash_tfm = NULL;
 		ctrl->shash_id = 0;
 	}
+	if (ctrl->dh_tfm) {
+		crypto_free_kpp(ctrl->dh_tfm);
+		ctrl->dh_tfm = NULL;
+		ctrl->dh_gid = 0;
+	}
 	if (ctrl->dhchap_key) {
 		kfree_sensitive(ctrl->dhchap_key);
 		ctrl->dhchap_key = NULL;
@@ -232,8 +302,18 @@ int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 		return ret;
 	}
 	if (ctrl->dh_gid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
-		ret = -ENOTSUPP;
-		goto out;
+		challenge = kmalloc(shash_len, GFP_KERNEL);
+		if (!challenge) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = nvme_auth_augmented_challenge(ctrl->shash_id,
+						    req->sq->dhchap_skey,
+						    req->sq->dhchap_skey_len,
+						    req->sq->dhchap_c1,
+						    challenge, shash_len);
+		if (ret)
+			goto out;
 	}
 
 	shash->tfm = ctrl->shash_tfm;
@@ -300,8 +380,18 @@ int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
 		return ret;
 	}
 	if (ctrl->dh_gid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
-		ret = -ENOTSUPP;
-		goto out;
+		challenge = kmalloc(shash_len, GFP_KERNEL);
+		if (!challenge) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = nvme_auth_augmented_challenge(ctrl->shash_id,
+						    req->sq->dhchap_skey,
+						    req->sq->dhchap_skey_len,
+						    req->sq->dhchap_c2,
+						    challenge, shash_len);
+		if (ret)
+			goto out;
 	}
 
 	shash->tfm = ctrl->shash_tfm;
@@ -343,3 +433,53 @@ int nvmet_auth_ctrl_hash(struct nvmet_req *req, u8 *response,
 	kfree_sensitive(ctrl_response);
 	return 0;
 }
+
+int nvmet_auth_ctrl_exponential(struct nvmet_req *req,
+				u8 *buf, int buf_size)
+{
+	struct nvmet_ctrl *ctrl = req->sq->ctrl;
+	int ret;
+
+	if (!ctrl->dh_tfm) {
+		pr_warn("No DH algorithm!\n");
+		return -ENOKEY;
+	}
+	ret = nvme_auth_gen_pubkey(ctrl->dh_tfm, buf, buf_size);
+	if (ret == -EOVERFLOW) {
+		pr_debug("public key buffer too small, need %d is %d\n",
+			 crypto_kpp_maxsize(ctrl->dh_tfm), buf_size);
+		ret = -ENOKEY;
+	} else if (ret) {
+		pr_debug("failed to generate public key, err %d\n", ret);
+		ret = -ENOKEY;
+	} else
+		pr_debug("%s: ctrl public key %*ph\n", __func__,
+			 (int)buf_size, buf);
+
+	return ret;
+}
+
+int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
+			    u8 *pkey, int pkey_size)
+{
+	struct nvmet_ctrl *ctrl = req->sq->ctrl;
+	int ret;
+
+	req->sq->dhchap_skey_len =
+		nvme_auth_dhgroup_privkey_size(ctrl->dh_gid);
+	req->sq->dhchap_skey = kzalloc(req->sq->dhchap_skey_len, GFP_KERNEL);
+	if (!req->sq->dhchap_skey)
+		return -ENOMEM;
+	ret = nvme_auth_gen_shared_secret(ctrl->dh_tfm,
+					  pkey, pkey_size,
+					  req->sq->dhchap_skey,
+					  req->sq->dhchap_skey_len);
+	if (ret)
+		pr_debug("failed to compute shared secred, err %d\n", ret);
+	else
+		pr_debug("%s: shared secret %*ph\n", __func__,
+			 (int)req->sq->dhchap_skey_len,
+			 req->sq->dhchap_skey);
+
+	return ret;
+}
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index d1f749ecbe4a..0414ff7f4873 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1743,10 +1743,41 @@ static ssize_t nvmet_host_dhchap_hash_store(struct config_item *item,
 
 CONFIGFS_ATTR(nvmet_host_, dhchap_hash);
 
+static ssize_t nvmet_host_dhchap_dhgroup_show(struct config_item *item,
+		char *page)
+{
+	struct nvmet_host *host = to_host(item);
+	const char *dhgroup = nvme_auth_dhgroup_name(host->dhchap_dhgroup_id);
+
+	return sprintf(page, "%s\n", dhgroup ? dhgroup : "none");
+}
+
+static ssize_t nvmet_host_dhchap_dhgroup_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_host *host = to_host(item);
+	int dhgroup_id;
+
+	dhgroup_id = nvme_auth_dhgroup_id(page);
+	if (dhgroup_id < 0)
+		return -EINVAL;
+	if (dhgroup_id != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
+		const char *kpp = nvme_auth_dhgroup_kpp(dhgroup_id);
+
+		if (!crypto_has_kpp(kpp, 0, 0))
+			return -EINVAL;
+	}
+	host->dhchap_dhgroup_id = dhgroup_id;
+	return count;
+}
+
+CONFIGFS_ATTR(nvmet_host_, dhchap_dhgroup);
+
 static struct configfs_attribute *nvmet_host_attrs[] = {
 	&nvmet_host_attr_dhchap_key,
 	&nvmet_host_attr_dhchap_ctrl_key,
 	&nvmet_host_attr_dhchap_hash,
+	&nvmet_host_attr_dhchap_dhgroup,
 	NULL,
 };
 #endif /* CONFIG_NVME_TARGET_AUTH */
diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 10ab646e85e5..a11de590a5a4 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -64,13 +64,24 @@ static u16 nvmet_auth_negotiate(struct nvmet_req *req, void *d)
 			null_dh = dhgid;
 			continue;
 		}
+		if (ctrl->dh_tfm && ctrl->dh_gid == dhgid) {
+			pr_debug("%s: ctrl %d qid %d: reusing existing DH group %d\n",
+				 __func__, ctrl->cntlid, req->sq->qid, dhgid);
+			break;
+		}
+		if (nvmet_setup_dhgroup(ctrl, dhgid) < 0)
+			continue;
+		if (nvme_auth_gen_privkey(ctrl->dh_tfm, dhgid) == 0)
+			break;
+		crypto_free_kpp(ctrl->dh_tfm);
+		ctrl->dh_tfm = NULL;
+		ctrl->dh_gid = 0;
 	}
-	if (null_dh < 0) {
+	if (!ctrl->dh_tfm && null_dh < 0) {
 		pr_debug("%s: ctrl %d qid %d: no DH group selected\n",
 			 __func__, ctrl->cntlid, req->sq->qid);
 		return NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
 	}
-	ctrl->dh_gid = null_dh;
 	pr_debug("%s: ctrl %d qid %d: DH group %s (%d)\n",
 		 __func__, ctrl->cntlid, req->sq->qid,
 		 nvme_auth_dhgroup_name(ctrl->dh_gid), ctrl->dh_gid);
@@ -92,7 +103,11 @@ static u16 nvmet_auth_reply(struct nvmet_req *req, void *d)
 		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
 
 	if (dhvlen) {
-		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		if (!ctrl->dh_tfm)
+			return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		if (nvmet_auth_ctrl_sesskey(req, data->rval + 2 * data->hl,
+					    dhvlen) < 0)
+			return NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
 	}
 
 	response = kmalloc(data->hl, GFP_KERNEL);
@@ -305,6 +320,8 @@ static int nvmet_auth_challenge(struct nvmet_req *req, void *d, int al)
 	int hash_len = crypto_shash_digestsize(ctrl->shash_tfm);
 	int data_size = sizeof(*d) + hash_len;
 
+	if (ctrl->dh_tfm)
+		data_size += ctrl->dh_keysize;
 	if (al < data_size) {
 		pr_debug("%s: buffer too small (al %d need %d)\n", __func__,
 			 al, data_size);
@@ -323,9 +340,15 @@ static int nvmet_auth_challenge(struct nvmet_req *req, void *d, int al)
 		return -ENOMEM;
 	get_random_bytes(req->sq->dhchap_c1, data->hl);
 	memcpy(data->cval, req->sq->dhchap_c1, data->hl);
+	if (ctrl->dh_tfm) {
+		data->dhgid = ctrl->dh_gid;
+		data->dhvlen = cpu_to_le32(ctrl->dh_keysize);
+		ret = nvmet_auth_ctrl_exponential(req, data->cval + data->hl,
+						  ctrl->dh_keysize);
+	}
 	pr_debug("%s: ctrl %d qid %d seq %d transaction %d hl %d dhvlen %d\n",
 		 __func__, ctrl->cntlid, req->sq->qid, req->sq->dhchap_s1,
-		 req->sq->dhchap_tid, data->hl, 0);
+		 req->sq->dhchap_tid, data->hl, ctrl->dh_keysize);
 	return ret;
 }
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 7fdd48193f83..4e34ee0e51ec 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -229,6 +229,7 @@ struct nvmet_ctrl {
 	size_t			dhchap_ctrl_key_len;
 	struct crypto_shash	*shash_tfm;
 	u8			shash_id;
+	struct crypto_kpp	*dh_tfm;
 	u32			dh_gid;
 	u32			dh_keysize;
 #endif
@@ -698,6 +699,7 @@ int nvmet_setup_auth(struct nvmet_ctrl *ctrl);
 void nvmet_init_auth(struct nvmet_ctrl *ctrl, struct nvmet_req *req);
 void nvmet_destroy_auth(struct nvmet_ctrl *ctrl);
 void nvmet_auth_sq_free(struct nvmet_sq *sq);
+int nvmet_setup_dhgroup(struct nvmet_ctrl *ctrl, int dhgroup_id);
 bool nvmet_check_auth_status(struct nvmet_req *req);
 int nvmet_auth_host_hash(struct nvmet_req *req, u8 *response,
 			 unsigned int hash_len);
@@ -707,6 +709,10 @@ static inline bool nvmet_has_auth(struct nvmet_ctrl *ctrl)
 {
 	return ctrl->shash_tfm != NULL;
 }
+int nvmet_auth_ctrl_exponential(struct nvmet_req *req,
+				u8 *buf, int buf_size);
+int nvmet_auth_ctrl_sesskey(struct nvmet_req *req,
+			    u8 *buf, int buf_size);
 #else
 static inline int nvmet_setup_auth(struct nvmet_ctrl *ctrl)
 {
-- 
2.29.2

