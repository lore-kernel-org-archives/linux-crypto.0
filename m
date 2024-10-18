Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5F515FD13
	for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 06:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729233249; cv=none; b=iwrQxgPgk+59Jhpj8DamKwc2d2+MumZdcLEv9C0ASzm16Edejz02ZBJXxWV/HsCfP39kBzRUVFvMjva0r8DnFdJshD006+XuUgWbiFdZGr5MIg2Fg8rM7Luc9SwipTVRBMYgoEunFKgz+LEH91+4Gs+Qp6L+nZeh5XjZGn+g4ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729233249; c=relaxed/simple;
	bh=dgKbj96msEtGdk52zkdfC4gB4DIBRJa0vZ0WNS5ZIiw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kMGyuh9CNRpoTaQ0mqWtmWt54X3yiIWNQZSnwpjvKk3WHTS2EV6yNCdSIOPqvGOK6hwr6Vda8vBRjUDm4KmsEB0ETWM4Y1AyxJ6ZIlt+Evs5oP+NlLHtLjjwl224fzTKMlLK2555CTUU3l9RC+Rji8l/tKMBsfjhW1o3e2ilyQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTzFGO4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTzFGO4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4578C4CED1;
	Fri, 18 Oct 2024 06:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729233249;
	bh=dgKbj96msEtGdk52zkdfC4gB4DIBRJa0vZ0WNS5ZIiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTzFGO4mzHnMI5vuLfYbJ6L1fGfi9CEg+OB4WN0l8EOWT+WBVHg+7kr7NpAhy/jFb
	 WHvNnV1tckO5GUCQlQ/ieEjsZ0tGfDu/s6PXstmr+6IRHhLwYM7bYsqk7a7NKCEjn5
	 FlnQZvHj/8Rg11r/pHorwGNb2OuB3NNTOkZeV5UyFv3I/2ZLHRztHECHZa5ZPaCmHc
	 T28ISOqZyuanwC62yWjrHZaWvgkGxtr93baQG0cRpxlPytoPC41bY8QSkAZqStfGf4
	 MrxOVTccHic8fLXAK2guaP/G5f038HNWVa41I5mu/B2njENebj5jGiINRUtEZn2vwd
	 I4evX2jXDuUpA==
From: Hannes Reinecke <hare@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	linux-nvme@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 6/9] nvme-tcp: request secure channel concatenation
Date: Fri, 18 Oct 2024 08:33:40 +0200
Message-Id: <20241018063343.39798-7-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20241018063343.39798-1-hare@kernel.org>
References: <20241018063343.39798-1-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a fabrics option 'concat' to request secure channel concatenation.
When secure channel concatenation is enabled a 'generated PSK' is inserted
into the keyring such that it's available after reset.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/nvme/host/auth.c    | 108 +++++++++++++++++++++++++++++++++++-
 drivers/nvme/host/fabrics.c |  34 +++++++++++-
 drivers/nvme/host/fabrics.h |   3 +
 drivers/nvme/host/nvme.h    |   2 +
 drivers/nvme/host/sysfs.c   |   4 +-
 drivers/nvme/host/tcp.c     |  47 ++++++++++++++--
 include/linux/nvme.h        |   7 +++
 7 files changed, 191 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 371e14f0a203..902c8ba59562 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -12,6 +12,7 @@
 #include "nvme.h"
 #include "fabrics.h"
 #include <linux/nvme-auth.h>
+#include <linux/nvme-keyring.h>
 
 #define CHAP_BUF_SIZE 4096
 static struct kmem_cache *nvme_chap_buf_cache;
@@ -131,7 +132,12 @@ static int nvme_auth_set_dhchap_negotiate_data(struct nvme_ctrl *ctrl,
 	data->auth_type = NVME_AUTH_COMMON_MESSAGES;
 	data->auth_id = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
 	data->t_id = cpu_to_le16(chap->transaction);
-	data->sc_c = 0; /* No secure channel concatenation */
+	if (!ctrl->opts->concat || chap->qid != 0)
+		data->sc_c = NVME_AUTH_SECP_NOSC;
+	else if (ctrl->opts->tls_key)
+		data->sc_c = NVME_AUTH_SECP_REPLACETLSPSK;
+	else
+		data->sc_c = NVME_AUTH_SECP_NEWTLSPSK;
 	data->napd = 1;
 	data->auth_protocol[0].dhchap.authid = NVME_AUTH_DHCHAP_AUTH_ID;
 	data->auth_protocol[0].dhchap.halen = 3;
@@ -311,8 +317,9 @@ static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
 	data->hl = chap->hash_len;
 	data->dhvlen = cpu_to_le16(chap->host_key_len);
 	memcpy(data->rval, chap->response, chap->hash_len);
-	if (ctrl->ctrl_key) {
+	if (ctrl->ctrl_key)
 		chap->bi_directional = true;
+	if (ctrl->ctrl_key || ctrl->opts->concat) {
 		get_random_bytes(chap->c2, chap->hash_len);
 		data->cvalid = 1;
 		memcpy(data->rval + chap->hash_len, chap->c2,
@@ -322,7 +329,10 @@ static int nvme_auth_set_dhchap_reply_data(struct nvme_ctrl *ctrl,
 	} else {
 		memset(chap->c2, 0, chap->hash_len);
 	}
-	chap->s2 = nvme_auth_get_seqnum();
+	if (ctrl->opts->concat)
+		chap->s2 = 0;
+	else
+		chap->s2 = nvme_auth_get_seqnum();
 	data->seqnum = cpu_to_le32(chap->s2);
 	if (chap->host_key_len) {
 		dev_dbg(ctrl->device, "%s: qid %d host public key %*ph\n",
@@ -677,6 +687,84 @@ static void nvme_auth_free_dhchap(struct nvme_dhchap_queue_context *chap)
 		crypto_free_kpp(chap->dh_tfm);
 }
 
+void nvme_auth_revoke_tls_key(struct nvme_ctrl *ctrl)
+{
+	dev_dbg(ctrl->device, "Wipe generated TLS PSK %08x\n",
+		key_serial(ctrl->opts->tls_key));
+	key_revoke(ctrl->opts->tls_key);
+	key_put(ctrl->opts->tls_key);
+	ctrl->opts->tls_key = NULL;
+}
+EXPORT_SYMBOL_GPL(nvme_auth_revoke_tls_key);
+
+static int nvme_auth_secure_concat(struct nvme_ctrl *ctrl,
+				   struct nvme_dhchap_queue_context *chap)
+{
+	u8 *psk, *digest, *tls_psk;
+	struct key *tls_key;
+	size_t psk_len;
+	int ret = 0;
+
+	if (!chap->sess_key) {
+		dev_warn(ctrl->device,
+			 "%s: qid %d no session key negotiated\n",
+			 __func__, chap->qid);
+		return -ENOKEY;
+	}
+
+	ret = nvme_auth_generate_psk(chap->hash_id, chap->sess_key,
+				     chap->sess_key_len,
+				     chap->c1, chap->c2,
+				     chap->hash_len, &psk, &psk_len);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "%s: qid %d failed to generate PSK, error %d\n",
+			 __func__, chap->qid, ret);
+		return ret;
+	}
+	dev_dbg(ctrl->device,
+		  "%s: generated psk %*ph\n", __func__, (int)psk_len, psk);
+
+	ret = nvme_auth_generate_digest(chap->hash_id, psk, psk_len,
+					ctrl->opts->subsysnqn,
+					ctrl->opts->host->nqn, &digest);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "%s: qid %d failed to generate digest, error %d\n",
+			 __func__, chap->qid, ret);
+		goto out_free_psk;
+	};
+	dev_dbg(ctrl->device, "%s: generated digest %s\n",
+		 __func__, digest);
+	ret = nvme_auth_derive_tls_psk(chap->hash_id, psk, psk_len, digest, &tls_psk);
+	if (ret) {
+		dev_warn(ctrl->device,
+			 "%s: qid %d failed to derive TLS psk, error %d\n",
+			 __func__, chap->qid, ret);
+		goto out_free_digest;
+	};
+
+	tls_key = nvme_tls_psk_refresh(ctrl->opts->keyring, ctrl->opts->host->nqn,
+				       ctrl->opts->subsysnqn, chap->hash_id,
+				       tls_psk, psk_len, digest);
+	if (IS_ERR(tls_key)) {
+		ret = PTR_ERR(tls_key);
+		dev_warn(ctrl->device,
+			 "%s: qid %d failed to insert generated key, error %d\n",
+			 __func__, chap->qid, ret);
+		tls_key = NULL;
+	}
+	kfree_sensitive(tls_psk);
+	if (ctrl->opts->tls_key)
+		nvme_auth_revoke_tls_key(ctrl);
+	ctrl->opts->tls_key = tls_key;
+out_free_digest:
+	kfree_sensitive(digest);
+out_free_psk:
+	kfree_sensitive(psk);
+	return ret;
+}
+
 static void nvme_queue_auth_work(struct work_struct *work)
 {
 	struct nvme_dhchap_queue_context *chap =
@@ -833,6 +921,14 @@ static void nvme_queue_auth_work(struct work_struct *work)
 	}
 	if (!ret) {
 		chap->error = 0;
+		/* Secure concatenation can only be enabled on the admin queue */
+		if (!chap->qid && ctrl->opts->concat &&
+		    (ret = nvme_auth_secure_concat(ctrl, chap))) {
+			dev_warn(ctrl->device,
+				 "%s: qid %d failed to enable secure concatenation\n",
+				 __func__, chap->qid);
+			chap->error = ret;
+		}
 		return;
 	}
 
@@ -912,6 +1008,12 @@ static void nvme_ctrl_auth_work(struct work_struct *work)
 			 "qid 0: authentication failed\n");
 		return;
 	}
+	/*
+	 * Only run authentication on the admin queue for
+	 * secure concatenation
+	 */
+	if (ctrl->opts->concat)
+		return;
 
 	for (q = 1; q < ctrl->queue_count; q++) {
 		ret = nvme_auth_negotiate(ctrl, q);
diff --git a/drivers/nvme/host/fabrics.c b/drivers/nvme/host/fabrics.c
index 432efcbf9e2f..93e9041b9657 100644
--- a/drivers/nvme/host/fabrics.c
+++ b/drivers/nvme/host/fabrics.c
@@ -472,8 +472,9 @@ int nvmf_connect_admin_queue(struct nvme_ctrl *ctrl)
 	result = le32_to_cpu(res.u32);
 	ctrl->cntlid = result & 0xFFFF;
 	if (result & (NVME_CONNECT_AUTHREQ_ATR | NVME_CONNECT_AUTHREQ_ASCR)) {
-		/* Secure concatenation is not implemented */
-		if (result & NVME_CONNECT_AUTHREQ_ASCR) {
+		/* Check for secure concatenation */
+		if ((result & NVME_CONNECT_AUTHREQ_ASCR) &&
+		    !ctrl->opts->concat) {
 			dev_warn(ctrl->device,
 				 "qid 0: secure concatenation is not supported\n");
 			ret = -EOPNOTSUPP;
@@ -550,7 +551,7 @@ int nvmf_connect_io_queue(struct nvme_ctrl *ctrl, u16 qid)
 		/* Secure concatenation is not implemented */
 		if (result & NVME_CONNECT_AUTHREQ_ASCR) {
 			dev_warn(ctrl->device,
-				 "qid 0: secure concatenation is not supported\n");
+				 "qid %d: secure concatenation is not supported\n", qid);
 			ret = -EOPNOTSUPP;
 			goto out_free_data;
 		}
@@ -706,6 +707,7 @@ static const match_table_t opt_tokens = {
 #endif
 #ifdef CONFIG_NVME_TCP_TLS
 	{ NVMF_OPT_TLS,			"tls"			},
+	{ NVMF_OPT_CONCAT,		"concat"		},
 #endif
 	{ NVMF_OPT_ERR,			NULL			}
 };
@@ -735,6 +737,7 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 	opts->tls = false;
 	opts->tls_key = NULL;
 	opts->keyring = NULL;
+	opts->concat = false;
 
 	options = o = kstrdup(buf, GFP_KERNEL);
 	if (!options)
@@ -1053,6 +1056,14 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			}
 			opts->tls = true;
 			break;
+		case NVMF_OPT_CONCAT:
+			if (!IS_ENABLED(CONFIG_NVME_TCP_TLS)) {
+				pr_err("TLS is not supported\n");
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->concat = true;
+			break;
 		default:
 			pr_warn("unknown parameter or missing value '%s' in ctrl creation request\n",
 				p);
@@ -1079,6 +1090,23 @@ static int nvmf_parse_options(struct nvmf_ctrl_options *opts,
 			pr_warn("failfast tmo (%d) larger than controller loss tmo (%d)\n",
 				opts->fast_io_fail_tmo, ctrl_loss_tmo);
 	}
+	if (opts->concat) {
+		if (opts->tls) {
+			pr_err("Secure concatenation over TLS is not supported\n");
+			ret = -EINVAL;
+			goto out;
+		}
+		if (opts->tls_key) {
+			pr_err("Cannot specify a TLS key for secure concatenation\n");
+			ret = -EINVAL;
+			goto out;
+		}
+		if (!opts->dhchap_secret) {
+			pr_err("Need to enable DH-CHAP for secure concatenation\n");
+			ret = -EINVAL;
+			goto out;
+		}
+	}
 
 	opts->host = nvmf_host_add(hostnqn, &hostid);
 	if (IS_ERR(opts->host)) {
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index 21d75dc4a3a0..9cf5b020adba 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -66,6 +66,7 @@ enum {
 	NVMF_OPT_TLS		= 1 << 25,
 	NVMF_OPT_KEYRING	= 1 << 26,
 	NVMF_OPT_TLS_KEY	= 1 << 27,
+	NVMF_OPT_CONCAT		= 1 << 28,
 };
 
 /**
@@ -101,6 +102,7 @@ enum {
  * @keyring:    Keyring to use for key lookups
  * @tls_key:    TLS key for encrypted connections (TCP)
  * @tls:        Start TLS encrypted connections (TCP)
+ * @concat:     Enabled Secure channel concatenation (TCP)
  * @disable_sqflow: disable controller sq flow control
  * @hdr_digest: generate/verify header digest (TCP)
  * @data_digest: generate/verify data digest (TCP)
@@ -130,6 +132,7 @@ struct nvmf_ctrl_options {
 	struct key		*keyring;
 	struct key		*tls_key;
 	bool			tls;
+	bool			concat;
 	bool			disable_sqflow;
 	bool			hdr_digest;
 	bool			data_digest;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 313a4f978a2c..4c735b88b434 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -1132,6 +1132,7 @@ void nvme_auth_stop(struct nvme_ctrl *ctrl);
 int nvme_auth_negotiate(struct nvme_ctrl *ctrl, int qid);
 int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid);
 void nvme_auth_free(struct nvme_ctrl *ctrl);
+void nvme_auth_revoke_tls_key(struct nvme_ctrl *ctrl);
 #else
 static inline int nvme_auth_init_ctrl(struct nvme_ctrl *ctrl)
 {
@@ -1154,6 +1155,7 @@ static inline int nvme_auth_wait(struct nvme_ctrl *ctrl, int qid)
 	return -EPROTONOSUPPORT;
 }
 static inline void nvme_auth_free(struct nvme_ctrl *ctrl) {};
+static void nvme_auth_revoke_tls_key(struct nvme_ctrl *ctrl) {};
 #endif
 
 u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index b68a9e5f1ea3..efb35eef1915 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -780,10 +780,10 @@ static umode_t nvme_tls_attrs_are_visible(struct kobject *kobj,
 		return 0;
 
 	if (a == &dev_attr_tls_key.attr &&
-	    !ctrl->opts->tls)
+	    !ctrl->opts->tls && !ctrl->opts->concat)
 		return 0;
 	if (a == &dev_attr_tls_configured_key.attr &&
-	    !ctrl->opts->tls_key)
+	    (!ctrl->opts->tls_key || ctrl->opts->concat))
 		return 0;
 	if (a == &dev_attr_tls_keyring.attr &&
 	    !ctrl->opts->keyring)
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 3e416af2659f..b8a3461b617c 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -233,7 +233,7 @@ static inline bool nvme_tcp_tls_configured(struct nvme_ctrl *ctrl)
 	if (!IS_ENABLED(CONFIG_NVME_TCP_TLS))
 		return 0;
 
-	return ctrl->opts->tls;
+	return ctrl->opts->tls || ctrl->opts->concat;
 }
 
 static inline struct blk_mq_tags *nvme_tcp_tagset(struct nvme_tcp_queue *queue)
@@ -1948,7 +1948,7 @@ static int nvme_tcp_alloc_admin_queue(struct nvme_ctrl *ctrl)
 	if (nvme_tcp_tls_configured(ctrl)) {
 		if (ctrl->opts->tls_key)
 			pskid = key_serial(ctrl->opts->tls_key);
-		else {
+		else if (ctrl->opts->tls) {
 			pskid = nvme_tls_psk_default(ctrl->opts->keyring,
 						      ctrl->opts->host->nqn,
 						      ctrl->opts->subsysnqn);
@@ -1978,9 +1978,25 @@ static int __nvme_tcp_alloc_io_queues(struct nvme_ctrl *ctrl)
 {
 	int i, ret;
 
-	if (nvme_tcp_tls_configured(ctrl) && !ctrl->tls_pskid) {
-		dev_err(ctrl->device, "no PSK negotiated\n");
-		return -ENOKEY;
+	if (nvme_tcp_tls_configured(ctrl)) {
+		if (ctrl->opts->concat) {
+			/*
+			 * The generated PSK is stored in the
+			 * fabric options
+			 */
+			if (!ctrl->opts->tls_key) {
+				dev_err(ctrl->device, "no PSK generated\n");
+				return -ENOKEY;
+			}
+			if (ctrl->tls_pskid &&
+			    ctrl->tls_pskid != key_serial(ctrl->opts->tls_key)) {
+				dev_err(ctrl->device, "Stale PSK id %08x\n", ctrl->tls_pskid);
+				ctrl->tls_pskid = 0;
+			}
+		} else if (!ctrl->tls_pskid) {
+			dev_err(ctrl->device, "no PSK negotiated\n");
+			return -ENOKEY;
+		}
 	}
 
 	for (i = 1; i < ctrl->queue_count; i++) {
@@ -2211,6 +2227,21 @@ static void nvme_tcp_reconnect_or_remove(struct nvme_ctrl *ctrl,
 	}
 }
 
+/*
+ * The TLS key needs to be revoked when:
+ * - concatenation is enabled and
+ *   -> This is a generated key and only valid for this session
+ * - the generated key is present in ctrl->tls_key and
+ *   -> authentication has completed and the key has been generated
+ * - tls has been enabled
+ *   -> otherwise we are about to reset the admin queue after authentication
+ *      to enable TLS with the generated key
+ */
+static bool nvme_tcp_key_revoke_needed(struct nvme_ctrl *ctrl)
+{
+	return ctrl->opts->concat && ctrl->opts->tls_key && ctrl->tls_pskid;
+}
+
 static int nvme_tcp_setup_ctrl(struct nvme_ctrl *ctrl, bool new)
 {
 	struct nvmf_ctrl_options *opts = ctrl->opts;
@@ -2314,6 +2345,8 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 				struct nvme_tcp_ctrl, err_work);
 	struct nvme_ctrl *ctrl = &tcp_ctrl->ctrl;
 
+	if (nvme_tcp_key_revoke_needed(ctrl))
+		nvme_auth_revoke_tls_key(ctrl);
 	nvme_stop_keep_alive(ctrl);
 	flush_work(&ctrl->async_event_work);
 	nvme_tcp_teardown_io_queues(ctrl, false);
@@ -2354,6 +2387,8 @@ static void nvme_reset_ctrl_work(struct work_struct *work)
 		container_of(work, struct nvme_ctrl, reset_work);
 	int ret;
 
+	if (nvme_tcp_key_revoke_needed(ctrl))
+		nvme_auth_revoke_tls_key(ctrl);
 	nvme_stop_ctrl(ctrl);
 	nvme_tcp_teardown_ctrl(ctrl, false);
 
@@ -2849,7 +2884,7 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
 			  NVMF_OPT_HDR_DIGEST | NVMF_OPT_DATA_DIGEST |
 			  NVMF_OPT_NR_WRITE_QUEUES | NVMF_OPT_NR_POLL_QUEUES |
 			  NVMF_OPT_TOS | NVMF_OPT_HOST_IFACE | NVMF_OPT_TLS |
-			  NVMF_OPT_KEYRING | NVMF_OPT_TLS_KEY,
+			  NVMF_OPT_KEYRING | NVMF_OPT_TLS_KEY | NVMF_OPT_CONCAT,
 	.create_ctrl	= nvme_tcp_create_ctrl,
 };
 
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index b58d9405d65e..fe8858d19813 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -1678,6 +1678,13 @@ enum {
 	NVME_AUTH_DHGROUP_INVALID	= 0xff,
 };
 
+enum {
+	NVME_AUTH_SECP_NOSC		= 0x00,
+	NVME_AUTH_SECP_SC		= 0x01,
+	NVME_AUTH_SECP_NEWTLSPSK	= 0x02,
+	NVME_AUTH_SECP_REPLACETLSPSK	= 0x03,
+};
+
 union nvmf_auth_protocol {
 	struct nvmf_auth_dhchap_protocol_descriptor dhchap;
 };
-- 
2.35.3

