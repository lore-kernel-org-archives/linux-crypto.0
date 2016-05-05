From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH] Bluetooth: convert smp module to crypto kpp API
Date: Thu,  5 May 2016 10:22:46 +0100
Message-ID: <1462440166-94042-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org,
	marcel@holtmann.org, johan.hedberg@gmail.com
To: herbert@gondor.apana.org.au, gustavo@padovan.org,
	linux-bluetooth@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:59343 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977AbcEEJWw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 05:22:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch has *not* been tested as I don't have the hardware.
It's purpose is to show how to use the kpp API.

Based on https://patchwork.kernel.org/patch/9022371/

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 net/bluetooth/smp.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 50976a6..25844a2 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -25,6 +25,8 @@
 #include <crypto/b128ops.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
+#include <crypto/kpp.h>
+#include <crypto/ecdh.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -2591,6 +2593,101 @@ static u8 sc_select_method(struct smp_chan *smp)
 	return method;
 }
 
+struct ecdh_completion {
+	struct completion completion;
+	int err;
+};
+
+static void ecdh_complete(struct crypto_async_request *req, int err)
+{
+	struct ecdh_completion *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	res->err = err;
+	complete(&res->completion);
+}
+
+static inline void swap_digits(u64 *in, u64 *out, unsigned int ndigits)
+{
+	int i;
+
+	for (i = 0; i < ndigits; i++)
+		out[i] = __swab64(in[ndigits - 1 - i]);
+}
+
+static bool compute_ecdh_shared_secret(const u8 public_key[64],
+				       const u8 private_key[32], u8 secret[32])
+{
+	struct crypto_kpp *tfm;
+	struct kpp_request *req;
+	struct ecdh_params p;
+	struct ecdh_completion result;
+	struct scatterlist src, dst;
+	u8 tmp[64];
+	int err = -ENOMEM;
+
+	tfm = crypto_alloc_kpp("ecdh", CRYPTO_ALG_INTERNAL, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("alg: kpp: Failed to load tfm for kpp: %ld\n",
+		       PTR_ERR(tfm));
+		return false;
+	}
+
+	req = kpp_request_alloc(tfm, GFP_KERNEL);
+	if (!req)
+		goto free_kpp;
+
+	init_completion(&result.completion);
+
+	/* Set curve_id */
+	p.curve_id = ECC_CURVE_NIST_P256;
+	err = crypto_kpp_set_params(tfm, (void *)&p, sizeof(p));
+	if (err)
+		goto free_req;
+
+	/* Security Manager Protocol holds digits in litte-endian order
+	 * while ECC API expect big-endian data
+	 */
+	swap_digits((u64 *)private_key, (u64 *)tmp, 4);
+
+	/* Set A private Key */
+	err = crypto_kpp_set_secret(tfm, (void *)tmp, 32);
+	if (err)
+		goto free_all;
+
+	swap_digits((u64 *)public_key, (u64 *)tmp, 4); /* x */
+	swap_digits((u64 *)&public_key[32], (u64 *)&tmp[32], 4); /* y */
+
+	sg_init_one(&src, tmp, 64);
+	sg_init_one(&dst, secret, 32);
+	kpp_request_set_input(req, &src, 64);
+	kpp_request_set_output(req, &dst, 32);
+	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				 ecdh_complete, &result);
+	err = crypto_kpp_compute_shared_secret(req);
+	if (err == -EINPROGRESS) {
+		wait_for_completion(&result.completion);
+		err = result.err;
+	}
+	if (err < 0) {
+		pr_err("alg: ecdh: compute shard secret test failed. err %d\n",
+		       err);
+		goto free_all;
+	}
+
+	swap_digits((u64 *)secret, (u64 *)tmp, 4);
+	memcpy(secret, tmp, 32);
+
+free_all:
+free_req:
+	kpp_request_free(req);
+free_kpp:
+	crypto_free_kpp(tfm);
+	return (err == 0);
+}
+
 static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 {
 	struct smp_cmd_public_key *key = (void *) skb->data;
@@ -2630,7 +2727,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 	SMP_DBG("Remote Public Key X: %32phN", smp->remote_pk);
 	SMP_DBG("Remote Public Key Y: %32phN", smp->remote_pk + 32);
 
-	if (!ecdh_shared_secret(smp->remote_pk, smp->local_sk, smp->dhkey))
+	if (!compute_ecdh_shared_secret(smp->remote_pk, smp->local_sk, smp->dhkey))
 		return SMP_UNSPECIFIED;
 
 	SMP_DBG("DHKey %32phN", smp->dhkey);
-- 
1.9.1
