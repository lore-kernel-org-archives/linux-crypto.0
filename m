From: Salvatore Benedetto <salvatore.benedetto-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] Bluetooth: convert smp module to crypto kpp API
Date: Thu,  5 May 2016 16:32:13 +0100
Message-ID: <1462462333-3798-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, gustavo-THi1TnShQwVAfugRpC6u6w@public.gmane.org,
	linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This patch has *not* been tested as I don't have the hardware.
It's purpose is to show how to use the kpp API.

Based on https://patchwork.kernel.org/patch/9022371/

Signed-off-by: Salvatore Benedetto <salvatore.benedetto-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
v2: Also convert ecc_make_key to kpp API

 net/bluetooth/smp.c | 184 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 181 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 50976a6..4d28704 100644
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
@@ -211,6 +213,182 @@ static int aes_cmac(struct crypto_shash *tfm, const u8 k[16], const u8 *m,
 	return 0;
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
+bool generate_ecdh_key_pair(u8 public_key[64], u8 private_key[32])
+{
+	struct crypto_kpp *tfm;
+	struct kpp_request *req;
+	struct ecdh_params p;
+	struct ecdh_completion result;
+	struct scatterlist dst;
+	u8 tmp[64];
+	int err = -ENOMEM;
+	const unsigned short max_tries = 16;
+	unsigned short tries = 0;
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
+	do {
+		if (tries++ >= max_tries)
+			goto free_all;
+
+		get_random_bytes(private_key, 32);
+
+		/* Set private Key */
+		err = crypto_kpp_set_secret(tfm, (void *)private_key, 32);
+		if (err)
+			goto free_all;
+
+		sg_init_one(&dst, tmp, 64);
+		kpp_request_set_output(req, &dst, 64);
+		kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					 ecdh_complete, &result);
+
+		err = crypto_kpp_generate_public_key(req);
+
+		if (err == -EINPROGRESS) {
+			wait_for_completion(&result.completion);
+			err = result.err;
+		}
+
+		/* Private key is not valid. Regenerate */
+		if (err == -EINVAL)
+			continue;
+
+		if (err < 0)
+			goto free_all;
+		else
+			break;
+
+	} while (true);
+
+	/* Keys are handed back in little endian as expected by Security
+	 * Manager Protocol
+	 */
+	swap_digits((u64 *)tmp, (u64 *)public_key, 4); /* x */
+	swap_digits((u64 *)&tmp[32], (u64 *)&public_key[32], 4); /* y */
+	swap_digits((u64 *)private_key, (u64 *)tmp, 4);
+	memcpy(private_key, tmp, 32);
+
+free_all:
+free_req:
+	kpp_request_free(req);
+free_kpp:
+	crypto_free_kpp(tfm);
+	return (err == 0);
+}
+
 static int smp_f4(struct crypto_shash *tfm_cmac, const u8 u[32],
 		  const u8 v[32], const u8 x[16], u8 z, u8 res[16])
 {
@@ -564,7 +742,7 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
 	} else {
 		while (true) {
 			/* Generate local key pair for Secure Connections */
-			if (!ecc_make_key(smp->local_pk, smp->local_sk))
+			if (!generate_ecdh_key_pair(smp->local_pk, smp->local_sk))
 				return -EIO;
 
 			/* This is unlikely, but we need to check that
@@ -1862,7 +2040,7 @@ static u8 sc_send_public_key(struct smp_chan *smp)
 	} else {
 		while (true) {
 			/* Generate local key pair for Secure Connections */
-			if (!ecc_make_key(smp->local_pk, smp->local_sk))
+			if (!generate_ecdh_key_pair(smp->local_pk, smp->local_sk))
 				return SMP_UNSPECIFIED;
 
 			/* This is unlikely, but we need to check that
@@ -2630,7 +2808,7 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 	SMP_DBG("Remote Public Key X: %32phN", smp->remote_pk);
 	SMP_DBG("Remote Public Key Y: %32phN", smp->remote_pk + 32);
 
-	if (!ecdh_shared_secret(smp->remote_pk, smp->local_sk, smp->dhkey))
+	if (!compute_ecdh_shared_secret(smp->remote_pk, smp->local_sk, smp->dhkey))
 		return SMP_UNSPECIFIED;
 
 	SMP_DBG("DHKey %32phN", smp->dhkey);
-- 
1.9.1
