Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 227C6C4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Aug 2021 12:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04429604DC
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Aug 2021 12:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240684AbhHJMnR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:43:17 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43684 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240729AbhHJMnP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Aug 2021 08:43:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 263D5200B0;
        Tue, 10 Aug 2021 12:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628599372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGR3kHZXRvrIl/rlhfbPg09ac0h0tTPQFnH9s+OwD+U=;
        b=yX+FTyJYMFZm/+NCXjyM7Yw7hsxKSd93+EED+ZjUG1N9u22R8yCKX1eFhFu/G+npU+1Krb
        k5q7cdAzUvl7ra51YpxMv74V6t1pwxZJXoRGXTVtCCL6HlLScrYUreN8n3TQUt/9v29Pyg
        OPO38md4WjozshI1GRAAKbSNsXSXJcY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628599372;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGR3kHZXRvrIl/rlhfbPg09ac0h0tTPQFnH9s+OwD+U=;
        b=cGh3AJQyMag0YJDCQ9t+H5SgMNtnWcjiwAoIUyjJ+wLyNR0uJyk+jWc7+jneKCvC73e44M
        +OCFlUxI07WBOTDA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1894CA3B91;
        Tue, 10 Aug 2021 12:42:52 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 7B7C4518C550; Tue, 10 Aug 2021 14:42:50 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Keith Busch <keith.busch@wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/13] nvme-auth: Diffie-Hellman key exchange support
Date:   Tue, 10 Aug 2021 14:42:25 +0200
Message-Id: <20210810124230.12161-9-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210810124230.12161-1-hare@suse.de>
References: <20210810124230.12161-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement Diffie-Hellman key exchange using FFDHE groups
for NVMe In-Band Authentication.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/auth.c | 190 +++++++++++++++++++++++++++++++++++----
 drivers/nvme/host/auth.h |   8 ++
 2 files changed, 181 insertions(+), 17 deletions(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 8916755b6247..e73b5be4a4b0 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -36,6 +36,12 @@ struct nvme_dhchap_queue_context {
 	u8 c2[64];
 	u8 response[64];
 	u8 *host_response;
+	u8 *ctrl_key;
+	int ctrl_key_len;
+	u8 *host_key;
+	int host_key_len;
+	u8 *sess_key;
+	int sess_key_len;
 };
 
 static struct nvme_auth_dhgroup_map {
@@ -611,6 +617,7 @@ static int nvme_auth_process_dhchap_challenge(struct nvme_ctrl *ctrl,
 	struct nvmf_auth_dhchap_challenge_data *data = chap->buf;
 	size_t size = sizeof(*data) + data->hl + data->dhvlen;
 	const char *hmac_name;
+	const char *kpp_name;
 
 	if (chap->buf_size < size) {
 		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
@@ -665,9 +672,9 @@ static int nvme_auth_process_dhchap_challenge(struct nvme_ctrl *ctrl,
 	chap->hash_len = data->hl;
 	dev_dbg(ctrl->device, "qid %d: selected hash %s\n",
 		chap->qid, hmac_name);
-
-	gid_name = nvme_auth_dhgroup_kpp(data->dhgid);
-	if (!gid_name) {
+select_kpp:
+	kpp_name = nvme_auth_dhgroup_kpp(data->dhgid);
+	if (!kpp_name) {
 		dev_warn(ctrl->device,
 			 "qid %d: invalid DH group id %d\n",
 			 chap->qid, data->dhgid);
@@ -676,6 +683,8 @@ static int nvme_auth_process_dhchap_challenge(struct nvme_ctrl *ctrl,
 	}
 
 	if (data->dhgid != NVME_AUTH_DHCHAP_DHGROUP_NULL) {
+		const char *gid_name = nvme_auth_dhgroup_name(data->dhgid);
+
 		if (data->dhvlen == 0) {
 			dev_warn(ctrl->device,
 				 "qid %d: empty DH value\n",
@@ -683,31 +692,55 @@ static int nvme_auth_process_dhchap_challenge(struct nvme_ctrl *ctrl,
 			chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
 			return -EPROTO;
 		}
-		chap->dh_tfm = crypto_alloc_kpp(gid_name, 0, 0);
+		if (chap->dh_tfm && chap->dhgroup_id == data->dhgid) {
+			dev_dbg(ctrl->device,
+				"qid %d: reuse existing DH group %s\n",
+				chap->qid, gid_name);
+			goto skip_kpp;
+		}
+		chap->dh_tfm = crypto_alloc_kpp(kpp_name, 0, 0);
 		if (IS_ERR(chap->dh_tfm)) {
 			int ret = PTR_ERR(chap->dh_tfm);
 
 			dev_warn(ctrl->device,
-				 "qid %d: failed to initialize %s\n",
+				 "qid %d: failed to initialize DH group %s\n",
 				 chap->qid, gid_name);
 			chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
 			chap->dh_tfm = NULL;
 			return ret;
 		}
-		chap->dhgroup_id = data->dhgid;
-	} else if (data->dhvlen != 0) {
-		dev_warn(ctrl->device,
-			 "qid %d: invalid DH value for NULL DH\n",
-			chap->qid);
-		chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
-		return -EPROTO;
+		/* Clear host key to avoid accidental reuse */
+		kfree_sensitive(chap->host_key);
+		chap->host_key_len = 0;
+		dev_dbg(ctrl->device, "qid %d: selected DH group %s\n",
+			chap->qid, gid_name);
+	} else {
+		if (data->dhvlen != 0) {
+			dev_warn(ctrl->device,
+				 "qid %d: invalid DH value for NULL DH\n",
+				 chap->qid);
+			chap->status = NVME_AUTH_DHCHAP_FAILURE_DHGROUP_UNUSABLE;
+			return -EPROTO;
+		}
+		if (chap->dh_tfm) {
+			crypto_free_kpp(chap->dh_tfm);
+			chap->dh_tfm = NULL;
+		}
 	}
-	dev_dbg(ctrl->device, "qid %d: selected DH group %s\n",
-		chap->qid, gid_name);
-
-select_kpp:
+	chap->dhgroup_id = data->dhgid;
+skip_kpp:
 	chap->s1 = le32_to_cpu(data->seqnum);
 	memcpy(chap->c1, data->cval, chap->hash_len);
+	if (data->dhvlen) {
+		chap->ctrl_key = kmalloc(data->dhvlen, GFP_KERNEL);
+		if (!chap->ctrl_key)
+			return -ENOMEM;
+		chap->ctrl_key_len = data->dhvlen;
+		memcpy(chap->ctrl_key, data->cval + chap->hash_len,
+		       data->dhvlen);
+		dev_dbg(ctrl->device, "ctrl public key %*ph\n",
+			 (int)chap->ctrl_key_len, chap->ctrl_key);
+	}
 
 	return 0;
 }
@@ -725,6 +758,8 @@ static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
 	} else
 		memset(chap->c2, 0, chap->hash_len);
 
+	if (chap->host_key_len)
+		size += chap->host_key_len;
 
 	if (chap->buf_size < size) {
 		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
@@ -735,7 +770,7 @@ static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
 	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_REPLY;
 	data->t_id = cpu_to_le16(chap->transaction);
 	data->hl = chap->hash_len;
-	data->dhvlen = 0;
+	data->dhvlen = chap->host_key_len;
 	data->seqnum = cpu_to_le32(chap->s2);
 	memcpy(data->rval, chap->response, chap->hash_len);
 	if (ctrl->opts->dhchap_bidi) {
@@ -746,6 +781,13 @@ static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
 		memcpy(data->rval + chap->hash_len, chap->c2,
 		       chap->hash_len);
 	}
+	if (chap->host_key_len) {
+		dev_dbg(ctrl->device, "%s: qid %d host public key %*ph\n",
+			__func__, chap->qid,
+			chap->host_key_len, chap->host_key);
+		memcpy(data->rval + 2 * chap->hash_len, chap->host_key,
+		       chap->host_key_len);
+	}
 	return size;
 }
 
@@ -832,6 +874,27 @@ static int nvme_auth_dhchap_host_response(struct nvme_ctrl *ctrl,
 
 	dev_dbg(ctrl->device, "%s: qid %d host response seq %d transaction %d\n",
 		__func__, chap->qid, chap->s1, chap->transaction);
+
+	if (!chap->host_response) {
+		chap->host_response = nvme_auth_transform_key(ctrl->dhchap_key,
+					chap->hash_len, chap->hash_id,
+					ctrl->opts->host->nqn);
+		if (IS_ERR(chap->host_response)) {
+			ret = PTR_ERR(chap->host_response);
+			chap->host_response = NULL;
+			return ret;
+		}
+	}
+	ret = crypto_shash_setkey(chap->shash_tfm,
+			chap->host_response, chap->hash_len);
+	if (ret) {
+		dev_warn(ctrl->device, "qid %d: failed to set key, error %d\n",
+			 chap->qid, ret);
+		goto out;
+	}
+	dev_dbg(ctrl->device,
+		"%s: using key %*ph\n", __func__,
+		(int)chap->hash_len, chap->host_response);
 	if (chap->dh_tfm) {
 		challenge = kmalloc(chap->hash_len, GFP_KERNEL);
 		if (!challenge) {
@@ -890,9 +953,28 @@ static int nvme_auth_dhchap_ctrl_response(struct nvme_ctrl *ctrl,
 		struct nvme_dhchap_queue_context *chap)
 {
 	SHASH_DESC_ON_STACK(shash, chap->shash_tfm);
+	u8 *ctrl_response;
 	u8 buf[4], *challenge = chap->c2;
 	int ret;
 
+	ctrl_response = nvme_auth_transform_key(ctrl->dhchap_key,
+				chap->hash_len, chap->hash_id,
+				ctrl->opts->subsysnqn);
+	if (IS_ERR(ctrl_response)) {
+		ret = PTR_ERR(ctrl_response);
+		return ret;
+	}
+	ret = crypto_shash_setkey(chap->shash_tfm,
+			ctrl_response, ctrl->dhchap_key_len);
+	if (ret) {
+		dev_warn(ctrl->device, "qid %d: failed to set key, error %d\n",
+			 chap->qid, ret);
+		goto out;
+	}
+	dev_dbg(ctrl->device,
+		"%s: using key %*ph\n", __func__,
+		(int)ctrl->dhchap_key_len, ctrl_response);
+
 	if (chap->dh_tfm) {
 		challenge = kmalloc(chap->hash_len, GFP_KERNEL);
 		if (!challenge) {
@@ -980,8 +1062,77 @@ int nvme_auth_generate_key(struct nvme_ctrl *ctrl)
 }
 EXPORT_SYMBOL_GPL(nvme_auth_generate_key);
 
+static int nvme_auth_dhchap_exponential(struct nvme_ctrl *ctrl,
+		struct nvme_dhchap_queue_context *chap)
+{
+	int ret;
+
+	if (chap->host_key && chap->host_key_len) {
+		dev_dbg(ctrl->device,
+			"qid %d: reusing host key\n", chap->qid);
+		goto gen_sesskey;
+	}
+	ret = nvme_auth_gen_privkey(chap->dh_tfm, chap->dhgroup_id);
+	if (ret < 0) {
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		return ret;
+	}
+
+	chap->host_key_len =
+		nvme_auth_dhgroup_pubkey_size(chap->dhgroup_id);
+
+	chap->host_key = kzalloc(chap->host_key_len, GFP_KERNEL);
+	if (!chap->host_key) {
+		chap->host_key_len = 0;
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
+		return -ENOMEM;
+	}
+	ret = nvme_auth_gen_pubkey(chap->dh_tfm,
+				   chap->host_key, chap->host_key_len);
+	if (ret) {
+		dev_dbg(ctrl->device,
+			"failed to generate public key, error %d\n", ret);
+		kfree(chap->host_key);
+		chap->host_key = NULL;
+		chap->host_key_len = 0;
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		return ret;
+	}
+
+gen_sesskey:
+	chap->sess_key_len = chap->host_key_len;
+	chap->sess_key = kmalloc(chap->sess_key_len, GFP_KERNEL);
+	if (!chap->sess_key) {
+		chap->sess_key_len = 0;
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_FAILED;
+		return -ENOMEM;
+	}
+
+	ret = nvme_auth_gen_shared_secret(chap->dh_tfm,
+					  chap->ctrl_key, chap->ctrl_key_len,
+					  chap->sess_key, chap->sess_key_len);
+	if (ret) {
+		dev_dbg(ctrl->device,
+			"failed to generate shared secret, error %d\n", ret);
+		kfree_sensitive(chap->sess_key);
+		chap->sess_key = NULL;
+		chap->sess_key_len = 0;
+		chap->status = NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+		return ret;
+	}
+	dev_dbg(ctrl->device, "shared secret %*ph\n",
+		(int)chap->sess_key_len, chap->sess_key);
+	return 0;
+}
+
 static void nvme_auth_reset(struct nvme_dhchap_queue_context *chap)
 {
+	kfree_sensitive(chap->ctrl_key);
+	chap->ctrl_key = NULL;
+	chap->ctrl_key_len = 0;
+	kfree_sensitive(chap->sess_key);
+	chap->sess_key = NULL;
+	chap->sess_key_len = 0;
 	chap->status = 0;
 	chap->error = 0;
 	chap->s1 = 0;
@@ -995,6 +1146,11 @@ static void __nvme_auth_free(struct nvme_dhchap_queue_context *chap)
 {
 	if (chap->shash_tfm)
 		crypto_free_shash(chap->shash_tfm);
+	if (chap->dh_tfm)
+		crypto_free_kpp(chap->dh_tfm);
+	kfree_sensitive(chap->ctrl_key);
+	kfree_sensitive(chap->host_key);
+	kfree_sensitive(chap->sess_key);
 	kfree_sensitive(chap->host_response);
 	kfree(chap->buf);
 	kfree(chap);
diff --git a/drivers/nvme/host/auth.h b/drivers/nvme/host/auth.h
index cf1255f9db6d..aec954e9de1e 100644
--- a/drivers/nvme/host/auth.h
+++ b/drivers/nvme/host/auth.h
@@ -21,5 +21,13 @@ int nvme_auth_hmac_id(const char *hmac_name);
 unsigned char *nvme_auth_extract_secret(unsigned char *dhchap_secret,
 					size_t *dhchap_key_len);
 u8 *nvme_auth_transform_key(u8 *key, size_t key_len, u8 key_hash, char *nqn);
+int nvme_auth_augmented_challenge(u8 hmac_id, u8 *skey, size_t skey_len,
+				  u8 *challenge, u8 *aug, size_t hlen);
+int nvme_auth_gen_privkey(struct crypto_kpp *dh_tfm, int dh_gid);
+int nvme_auth_gen_pubkey(struct crypto_kpp *dh_tfm,
+			 u8 *host_key, size_t host_key_len);
+int nvme_auth_gen_shared_secret(struct crypto_kpp *dh_tfm,
+				u8 *ctrl_key, size_t ctrl_key_len,
+				u8 *sess_key, size_t sess_key_len);
 
 #endif /* _NVME_AUTH_H */
-- 
2.29.2

