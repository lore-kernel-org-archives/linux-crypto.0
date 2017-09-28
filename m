From: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Subject: [v2 PATCH 2/5] Bluetooth: ecdh_helper - reveal error codes
Date: Thu, 28 Sep 2017 17:14:52 +0300
Message-ID: <20170928141455.15336-3-tudor.ambarus@microchip.com>
References: <20170928141455.15336-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
To: <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170928141455.15336-1-tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

ecdh_helper functions were hiding the error codes and chose to return
the return value of an relational operator, "==". Remove the unnecessary
query and reveal the error codes.

While updating the return values, code in a way that compilers will
warn in case of uninitialized err.

Signed-off-by: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
---
 net/bluetooth/ecdh_helper.c | 32 +++++++++++++++++++-------------
 net/bluetooth/ecdh_helper.h |  8 ++++----
 net/bluetooth/smp.c         | 17 ++++++++++-------
 3 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
index ac2c708..22c8daa 100644
--- a/net/bluetooth/ecdh_helper.c
+++ b/net/bluetooth/ecdh_helper.c
@@ -49,8 +49,8 @@ static inline void swap_digits(u64 *in, u64 *out, unsigned int ndigits)
 		out[i] = __swab64(in[ndigits - 1 - i]);
 }
 
-bool compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
-			 const u8 private_key[32], u8 secret[32])
+int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
+			const u8 private_key[32], u8 secret[32])
 {
 	struct kpp_request *req;
 	struct ecdh p;
@@ -58,15 +58,17 @@ bool compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 	struct scatterlist src, dst;
 	u8 *tmp, *buf;
 	unsigned int buf_len;
-	int err = -ENOMEM;
+	int err;
 
 	tmp = kmalloc(64, GFP_KERNEL);
 	if (!tmp)
-		return false;
+		return -ENOMEM;
 
 	req = kpp_request_alloc(tfm, GFP_KERNEL);
-	if (!req)
+	if (!req) {
+		err = -ENOMEM;
 		goto free_tmp;
+	}
 
 	init_completion(&result.completion);
 
@@ -80,8 +82,10 @@ bool compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 	p.curve_id = ECC_CURVE_NIST_P256;
 	buf_len = crypto_ecdh_key_len(&p);
 	buf = kmalloc(buf_len, GFP_KERNEL);
-	if (!buf)
+	if (!buf) {
+		err = -ENOMEM;
 		goto free_req;
+	}
 
 	crypto_ecdh_encode_key(buf, buf_len, &p);
 
@@ -119,11 +123,11 @@ bool compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 	kpp_request_free(req);
 free_tmp:
 	kfree(tmp);
-	return (err == 0);
+	return err;
 }
 
-bool generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
-			u8 private_key[32])
+int generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
+		       u8 private_key[32])
 {
 	struct kpp_request *req;
 	struct ecdh p;
@@ -131,17 +135,19 @@ bool generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
 	struct scatterlist dst;
 	u8 *tmp, *buf;
 	unsigned int buf_len;
-	int err = -ENOMEM;
+	int err;
 	const unsigned short max_tries = 16;
 	unsigned short tries = 0;
 
 	tmp = kmalloc(64, GFP_KERNEL);
 	if (!tmp)
-		return false;
+		return -ENOMEM;
 
 	req = kpp_request_alloc(tfm, GFP_KERNEL);
-	if (!req)
+	if (!req) {
+		err = -ENOMEM;
 		goto free_tmp;
+	}
 
 	init_completion(&result.completion);
 
@@ -202,5 +208,5 @@ bool generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
 	kpp_request_free(req);
 free_tmp:
 	kfree(tmp);
-	return (err == 0);
+	return err;
 }
diff --git a/net/bluetooth/ecdh_helper.h b/net/bluetooth/ecdh_helper.h
index 5cde37d..50e6676 100644
--- a/net/bluetooth/ecdh_helper.h
+++ b/net/bluetooth/ecdh_helper.h
@@ -23,7 +23,7 @@
 #include <crypto/kpp.h>
 #include <linux/types.h>
 
-bool compute_ecdh_secret(struct crypto_kpp *tfm, const u8 pub_a[64],
-			 const u8 priv_b[32], u8 secret[32]);
-bool generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
-			u8 private_key[32]);
+int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 pub_a[64],
+			const u8 priv_b[32], u8 secret[32]);
+int generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64],
+		       u8 private_key[32]);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 31b64bc..af7e610 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -577,9 +577,10 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
 			get_random_bytes(smp->local_sk, 32);
 
 			/* Generate local key pair for Secure Connections */
-			if (!generate_ecdh_keys(smp->tfm_ecdh, smp->local_pk,
-						smp->local_sk))
-				return -EIO;
+			err = generate_ecdh_keys(smp->tfm_ecdh, smp->local_pk,
+						 smp->local_sk);
+			if (err)
+				return err;
 
 			/* This is unlikely, but we need to check that
 			 * we didn't accidentially generate a debug key.
@@ -1919,8 +1920,8 @@ static u8 sc_send_public_key(struct smp_chan *smp)
 			get_random_bytes(smp->local_sk, 32);
 
 			/* Generate local key pair for Secure Connections */
-			if (!generate_ecdh_keys(smp->tfm_ecdh, smp->local_pk,
-						smp->local_sk))
+			if (generate_ecdh_keys(smp->tfm_ecdh, smp->local_pk,
+					       smp->local_sk))
 				return SMP_UNSPECIFIED;
 
 			/* This is unlikely, but we need to check that
@@ -3532,11 +3533,13 @@ static inline void swap_digits(u64 *in, u64 *out, unsigned int ndigits)
 static int __init test_debug_key(struct crypto_kpp *tfm_ecdh)
 {
 	u8 pk[64], sk[32];
+	int err;
 
 	swap_digits((u64 *)debug_sk, (u64 *)sk, 4);
 
-	if (!generate_ecdh_keys(tfm_ecdh, pk, sk))
-		return -EINVAL;
+	err = generate_ecdh_keys(tfm_ecdh, pk, sk);
+	if (err)
+		return err;
 
 	if (crypto_memneq(sk, debug_sk, 32))
 		return -EINVAL;
-- 
2.9.4
