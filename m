Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790773876D2;
	Tue, 21 Apr 2026 23:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776813065; cv=none; b=RkcDGxr8vble2KK20iIDfelgx1D6rp5qJQhL9HY6md4FQ0yz0RqB8cgiB34ju0PjoMwyUHee15i46qpBFmqlDhSzwD0n9bLZH4OMJQ7oanEoJL4+xne3xsOdfnnQvtsSddbdhun7mby5JnL7wVLY5LtuUE45xtae/WYL0B3agTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776813065; c=relaxed/simple;
	bh=a2FVRVnqWtVQwdYHOB2HZEALFb2M1hIZmJpDpbm0Bo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwEKRxdy/9lz2pUISwXU54CiO48SZu6jTTUfFiZfdew2qzDRyCg3O5C/0xPL72uvpYf/wmVy/ZnTZ+A6Zex5wuKh7nhOTexV1gLx0MnduO6RBe4XxwR3iNOItZWht3ohWr7kHliY5q2lNsnm8t+mct7/CpsbdG81SSm0IQtvY4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfW1Vfj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfW1Vfj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23161C2BCB8;
	Tue, 21 Apr 2026 23:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776813065;
	bh=a2FVRVnqWtVQwdYHOB2HZEALFb2M1hIZmJpDpbm0Bo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfW1Vfj1nVegB0JATnwSR+xrc3ER4/aYfISbyTrBIII5WbuI3UscmExVu+AjW5X7S
	 ngn2RccCbZoGgSS+sKzYb2egcdfORReUlptFWOiHrRkjbDswIal1tqxDRS/zHyqX83
	 Nh30ykdfBT1cdSI3SYBhowSaqkKtzrCWubnU57gN0gzhWMQc683lO/8XF3jkujZKWB
	 lOfg+vPG7jAP/lnoD3+anOuz1H1ruv3fseNFBBdnmE6U5SYhqkHM8MX8C3vAAjXwIc
	 woEw6hnLbffoMN9/XTopJ+PT8BUFutmiLEObbEJRJZtVM+Nvh7DLIpmcVV+OK1+IrG
	 CEIAyZLr2W0bA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-bluetooth@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2 2/2] Bluetooth: SMP: Use AES-CMAC library API
Date: Tue, 21 Apr 2026 16:09:17 -0700
Message-ID: <20260421230917.7057-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421230917.7057-1-ebiggers@kernel.org>
References: <20260421230917.7057-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that AES-CMAC has a library API, convert net/bluetooth/smp.c to use
it instead of the "cmac(aes)" crypto_shash.  Since the library API
doesn't require dynamic memory allocation, we no longer need to pass a
crypto_shash object down the call stack and can simply allocate the
aes_cmac_key on the stack in smp_aes_cmac() (renamed from aes_cmac()).

The result is simpler and faster code that no longer relies on the
error-prone loading of algorithms by name.

Note that the maximum stack usage actually decreases slightly, despite
the expanded AES key being moved to the stack.  This is because the old
code called crypto_shash_tfm_digest(), which allocates 384 bytes on the
stack for a maximally-sized hash descriptor for any algorithm.  The new
code instead declares a 288-byte aes_cmac_key, then calls aes_cmac()
which declares a 32-byte aes_cmac_ctx.  Since 288 + 32 < 384, the
maximum stack usage decreases.  I.e. the entire expanded AES key easily
fits in the space that the generic crypto API was wasting before.

I didn't add zeroization of the aes_cmac_key, since smp_aes_cmac()
already copies the raw key to the stack without zeroizing it.

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/bluetooth/Kconfig |   3 +-
 net/bluetooth/smp.c   | 180 +++++++++++++++---------------------------
 2 files changed, 65 insertions(+), 118 deletions(-)

diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
index 8bd0f2891161..884356938d74 100644
--- a/net/bluetooth/Kconfig
+++ b/net/bluetooth/Kconfig
@@ -8,12 +8,11 @@ menuconfig BT
 	depends on !S390
 	depends on RFKILL || !RFKILL
 	select CRC16
 	select CRYPTO
 	select CRYPTO_LIB_AES
-	imply CRYPTO_AES
-	select CRYPTO_CMAC
+	select CRYPTO_LIB_AES_CBC_MACS
 	select CRYPTO_ECDH
 	help
 	  Bluetooth is low-cost, low-power, short-range wireless technology.
 	  It was designed as a replacement for cables and other short-range
 	  technologies like IrDA.  Bluetooth operates in personal area range
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 98f1da4f5f55..1739c1989dbd 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -20,12 +20,12 @@
    SOFTWARE IS DISCLAIMED.
 */
 
 #include <linux/debugfs.h>
 #include <linux/scatterlist.h>
+#include <crypto/aes-cbc-macs.h>
 #include <crypto/aes.h>
-#include <crypto/hash.h>
 #include <crypto/kpp.h>
 #include <crypto/utils.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -61,11 +61,11 @@
 
 #define AUTH_REQ_MASK(dev)	(hci_dev_test_flag(dev, HCI_SC_ENABLED) ? \
 				 0x3f : 0x07)
 #define KEY_DIST_MASK		0x07
 
-/* Maximum message length that can be passed to aes_cmac */
+/* Maximum message length that can be passed to smp_aes_cmac */
 #define CMAC_MSG_MAX	80
 
 enum {
 	SMP_FLAG_TK_VALID,
 	SMP_FLAG_CFM_PENDING,
@@ -87,11 +87,10 @@ struct smp_dev {
 	bool			local_oob;
 	u8			local_pk[64];
 	u8			local_rand[16];
 	bool			debug_key;
 
-	struct crypto_shash	*tfm_cmac;
 	struct crypto_kpp	*tfm_ecdh;
 };
 
 struct smp_chan {
 	struct l2cap_conn	*conn;
@@ -125,11 +124,10 @@ struct smp_chan {
 	u8			local_pk[64];
 	u8			remote_pk[64];
 	u8			dhkey[32];
 	u8			mackey[16];
 
-	struct crypto_shash	*tfm_cmac;
 	struct crypto_kpp	*tfm_ecdh;
 };
 
 /* These debug key values are defined in the SMP section of the core
  * specification. debug_pk is the public debug key and debug_sk the
@@ -164,52 +162,40 @@ static inline void swap_buf(const u8 *src, u8 *dst, size_t len)
 
 /* The following functions map to the LE SC SMP crypto functions
  * AES-CMAC, f4, f5, f6, g2 and h6.
  */
 
-static int aes_cmac(struct crypto_shash *tfm, const u8 k[16], const u8 *m,
-		    size_t len, u8 mac[16])
+static int smp_aes_cmac(const u8 k[16], const u8 *m, size_t len, u8 mac[16])
 {
 	uint8_t tmp[16], mac_msb[16], msg_msb[CMAC_MSG_MAX];
+	struct aes_cmac_key key;
 	int err;
 
 	if (len > CMAC_MSG_MAX)
 		return -EFBIG;
 
-	if (!tfm) {
-		BT_ERR("tfm %p", tfm);
-		return -EINVAL;
-	}
-
 	/* Swap key and message from LSB to MSB */
 	swap_buf(k, tmp, 16);
 	swap_buf(m, msg_msb, len);
 
 	SMP_DBG("msg (len %zu) %*phN", len, (int) len, m);
 	SMP_DBG("key %16phN", k);
 
-	err = crypto_shash_setkey(tfm, tmp, 16);
-	if (err) {
-		BT_ERR("cipher setkey failed: %d", err);
+	err = aes_cmac_preparekey(&key, tmp, 16);
+	if (WARN_ON_ONCE(err)) /* Should never happen, as 16 is valid keylen */
 		return err;
-	}
-
-	err = crypto_shash_tfm_digest(tfm, msg_msb, len, mac_msb);
-	if (err) {
-		BT_ERR("Hash computation error %d", err);
-		return err;
-	}
+	aes_cmac(&key, msg_msb, len, mac_msb);
 
 	swap_buf(mac_msb, mac, 16);
 
 	SMP_DBG("mac %16phN", mac);
 
 	return 0;
 }
 
-static int smp_f4(struct crypto_shash *tfm_cmac, const u8 u[32],
-		  const u8 v[32], const u8 x[16], u8 z, u8 res[16])
+static int smp_f4(const u8 u[32], const u8 v[32], const u8 x[16], u8 z,
+		  u8 res[16])
 {
 	u8 m[65];
 	int err;
 
 	SMP_DBG("u %32phN", u);
@@ -218,22 +204,21 @@ static int smp_f4(struct crypto_shash *tfm_cmac, const u8 u[32],
 
 	m[0] = z;
 	memcpy(m + 1, v, 32);
 	memcpy(m + 33, u, 32);
 
-	err = aes_cmac(tfm_cmac, x, m, sizeof(m), res);
+	err = smp_aes_cmac(x, m, sizeof(m), res);
 	if (err)
 		return err;
 
 	SMP_DBG("res %16phN", res);
 
 	return err;
 }
 
-static int smp_f5(struct crypto_shash *tfm_cmac, const u8 w[32],
-		  const u8 n1[16], const u8 n2[16], const u8 a1[7],
-		  const u8 a2[7], u8 mackey[16], u8 ltk[16])
+static int smp_f5(const u8 w[32], const u8 n1[16], const u8 n2[16],
+		  const u8 a1[7], const u8 a2[7], u8 mackey[16], u8 ltk[16])
 {
 	/* The btle, salt and length "magic" values are as defined in
 	 * the SMP section of the Bluetooth core specification. In ASCII
 	 * the btle value ends up being 'btle'. The salt is just a
 	 * random number whereas length is the value 256 in little
@@ -248,11 +233,11 @@ static int smp_f5(struct crypto_shash *tfm_cmac, const u8 w[32],
 
 	SMP_DBG("w %32phN", w);
 	SMP_DBG("n1 %16phN n2 %16phN", n1, n2);
 	SMP_DBG("a1 %7phN a2 %7phN", a1, a2);
 
-	err = aes_cmac(tfm_cmac, salt, w, 32, t);
+	err = smp_aes_cmac(salt, w, 32, t);
 	if (err)
 		return err;
 
 	SMP_DBG("t %16phN", t);
 
@@ -263,31 +248,30 @@ static int smp_f5(struct crypto_shash *tfm_cmac, const u8 w[32],
 	memcpy(m + 32, n1, 16);
 	memcpy(m + 48, btle, 4);
 
 	m[52] = 0; /* Counter */
 
-	err = aes_cmac(tfm_cmac, t, m, sizeof(m), mackey);
+	err = smp_aes_cmac(t, m, sizeof(m), mackey);
 	if (err)
 		return err;
 
 	SMP_DBG("mackey %16phN", mackey);
 
 	m[52] = 1; /* Counter */
 
-	err = aes_cmac(tfm_cmac, t, m, sizeof(m), ltk);
+	err = smp_aes_cmac(t, m, sizeof(m), ltk);
 	if (err)
 		return err;
 
 	SMP_DBG("ltk %16phN", ltk);
 
 	return 0;
 }
 
-static int smp_f6(struct crypto_shash *tfm_cmac, const u8 w[16],
-		  const u8 n1[16], const u8 n2[16], const u8 r[16],
-		  const u8 io_cap[3], const u8 a1[7], const u8 a2[7],
-		  u8 res[16])
+static int smp_f6(const u8 w[16], const u8 n1[16], const u8 n2[16],
+		  const u8 r[16], const u8 io_cap[3], const u8 a1[7],
+		  const u8 a2[7], u8 res[16])
 {
 	u8 m[65];
 	int err;
 
 	SMP_DBG("w %16phN", w);
@@ -299,21 +283,21 @@ static int smp_f6(struct crypto_shash *tfm_cmac, const u8 w[16],
 	memcpy(m + 14, io_cap, 3);
 	memcpy(m + 17, r, 16);
 	memcpy(m + 33, n2, 16);
 	memcpy(m + 49, n1, 16);
 
-	err = aes_cmac(tfm_cmac, w, m, sizeof(m), res);
+	err = smp_aes_cmac(w, m, sizeof(m), res);
 	if (err)
 		return err;
 
 	SMP_DBG("res %16phN", res);
 
 	return err;
 }
 
-static int smp_g2(struct crypto_shash *tfm_cmac, const u8 u[32], const u8 v[32],
-		  const u8 x[16], const u8 y[16], u32 *val)
+static int smp_g2(const u8 u[32], const u8 v[32], const u8 x[16],
+		  const u8 y[16], u32 *val)
 {
 	u8 m[80], tmp[16];
 	int err;
 
 	SMP_DBG("u %32phN", u);
@@ -322,11 +306,11 @@ static int smp_g2(struct crypto_shash *tfm_cmac, const u8 u[32], const u8 v[32],
 
 	memcpy(m, y, 16);
 	memcpy(m + 16, v, 32);
 	memcpy(m + 48, u, 32);
 
-	err = aes_cmac(tfm_cmac, x, m, sizeof(m), tmp);
+	err = smp_aes_cmac(x, m, sizeof(m), tmp);
 	if (err)
 		return err;
 
 	*val = get_unaligned_le32(tmp);
 	*val %= 1000000;
@@ -334,34 +318,32 @@ static int smp_g2(struct crypto_shash *tfm_cmac, const u8 u[32], const u8 v[32],
 	SMP_DBG("val %06u", *val);
 
 	return 0;
 }
 
-static int smp_h6(struct crypto_shash *tfm_cmac, const u8 w[16],
-		  const u8 key_id[4], u8 res[16])
+static int smp_h6(const u8 w[16], const u8 key_id[4], u8 res[16])
 {
 	int err;
 
 	SMP_DBG("w %16phN key_id %4phN", w, key_id);
 
-	err = aes_cmac(tfm_cmac, w, key_id, 4, res);
+	err = smp_aes_cmac(w, key_id, 4, res);
 	if (err)
 		return err;
 
 	SMP_DBG("res %16phN", res);
 
 	return err;
 }
 
-static int smp_h7(struct crypto_shash *tfm_cmac, const u8 w[16],
-		  const u8 salt[16], u8 res[16])
+static int smp_h7(const u8 w[16], const u8 salt[16], u8 res[16])
 {
 	int err;
 
 	SMP_DBG("w %16phN salt %16phN", w, salt);
 
-	err = aes_cmac(tfm_cmac, salt, w, 16, res);
+	err = smp_aes_cmac(salt, w, 16, res);
 	if (err)
 		return err;
 
 	SMP_DBG("res %16phN", res);
 
@@ -572,12 +554,11 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
 	SMP_DBG("OOB Public Key X: %32phN", smp->local_pk);
 	SMP_DBG("OOB Public Key Y: %32phN", smp->local_pk + 32);
 
 	get_random_bytes(smp->local_rand, 16);
 
-	err = smp_f4(smp->tfm_cmac, smp->local_pk, smp->local_pk,
-		     smp->local_rand, 0, hash);
+	err = smp_f4(smp->local_pk, smp->local_pk, smp->local_rand, 0, hash);
 	if (err < 0)
 		return err;
 
 	memcpy(rand, smp->local_rand, 16);
 
@@ -755,11 +736,10 @@ static void smp_chan_destroy(struct l2cap_conn *conn)
 
 	kfree_sensitive(smp->csrk);
 	kfree_sensitive(smp->responder_csrk);
 	kfree_sensitive(smp->link_key);
 
-	crypto_free_shash(smp->tfm_cmac);
 	crypto_free_kpp(smp->tfm_ecdh);
 
 	/* Ensure that we don't leave any debug key around if debug key
 	 * support hasn't been explicitly enabled.
 	 */
@@ -1158,27 +1138,27 @@ static void sc_generate_link_key(struct smp_chan *smp)
 
 	if (test_bit(SMP_FLAG_CT2, &smp->flags)) {
 		/* SALT = 0x000000000000000000000000746D7031 */
 		const u8 salt[16] = { 0x31, 0x70, 0x6d, 0x74 };
 
-		if (smp_h7(smp->tfm_cmac, smp->tk, salt, smp->link_key)) {
+		if (smp_h7(smp->tk, salt, smp->link_key)) {
 			kfree_sensitive(smp->link_key);
 			smp->link_key = NULL;
 			return;
 		}
 	} else {
 		/* From core spec. Spells out in ASCII as 'tmp1'. */
 		const u8 tmp1[4] = { 0x31, 0x70, 0x6d, 0x74 };
 
-		if (smp_h6(smp->tfm_cmac, smp->tk, tmp1, smp->link_key)) {
+		if (smp_h6(smp->tk, tmp1, smp->link_key)) {
 			kfree_sensitive(smp->link_key);
 			smp->link_key = NULL;
 			return;
 		}
 	}
 
-	if (smp_h6(smp->tfm_cmac, smp->link_key, lebr, smp->link_key)) {
+	if (smp_h6(smp->link_key, lebr, smp->link_key)) {
 		kfree_sensitive(smp->link_key);
 		smp->link_key = NULL;
 		return;
 	}
 }
@@ -1216,21 +1196,21 @@ static void sc_generate_ltk(struct smp_chan *smp)
 
 	if (test_bit(SMP_FLAG_CT2, &smp->flags)) {
 		/* SALT = 0x000000000000000000000000746D7032 */
 		const u8 salt[16] = { 0x32, 0x70, 0x6d, 0x74 };
 
-		if (smp_h7(smp->tfm_cmac, key->val, salt, smp->tk))
+		if (smp_h7(key->val, salt, smp->tk))
 			return;
 	} else {
 		/* From core spec. Spells out in ASCII as 'tmp2'. */
 		const u8 tmp2[4] = { 0x32, 0x70, 0x6d, 0x74 };
 
-		if (smp_h6(smp->tfm_cmac, key->val, tmp2, smp->tk))
+		if (smp_h6(key->val, tmp2, smp->tk))
 			return;
 	}
 
-	if (smp_h6(smp->tfm_cmac, smp->tk, brle, smp->tk))
+	if (smp_h6(smp->tk, brle, smp->tk))
 		return;
 
 	sc_add_ltk(smp);
 }
 
@@ -1387,20 +1367,14 @@ static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
 
 	smp = kzalloc_obj(*smp, GFP_ATOMIC);
 	if (!smp)
 		return NULL;
 
-	smp->tfm_cmac = crypto_alloc_shash("cmac(aes)", 0, 0);
-	if (IS_ERR(smp->tfm_cmac)) {
-		bt_dev_err(hcon->hdev, "Unable to create CMAC crypto context");
-		goto zfree_smp;
-	}
-
 	smp->tfm_ecdh = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(smp->tfm_ecdh)) {
 		bt_dev_err(hcon->hdev, "Unable to create ECDH crypto context");
-		goto free_shash;
+		goto zfree_smp;
 	}
 
 	smp->conn = conn;
 	chan->data = smp;
 
@@ -1410,12 +1384,10 @@ static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
 
 	hci_conn_hold(hcon);
 
 	return smp;
 
-free_shash:
-	crypto_free_shash(smp->tfm_cmac);
 zfree_smp:
 	kfree_sensitive(smp);
 	return NULL;
 }
 
@@ -1435,11 +1407,11 @@ static int sc_mackey_and_ltk(struct smp_chan *smp, u8 mackey[16], u8 ltk[16])
 	memcpy(a, &hcon->init_addr, 6);
 	memcpy(b, &hcon->resp_addr, 6);
 	a[6] = hcon->init_addr_type;
 	b[6] = hcon->resp_addr_type;
 
-	return smp_f5(smp->tfm_cmac, smp->dhkey, na, nb, a, b, mackey, ltk);
+	return smp_f5(smp->dhkey, na, nb, a, b, mackey, ltk);
 }
 
 static void sc_dhkey_check(struct smp_chan *smp)
 {
 	struct hci_conn *hcon = smp->conn->hcon;
@@ -1468,12 +1440,12 @@ static void sc_dhkey_check(struct smp_chan *smp)
 		put_unaligned_le32(hcon->passkey_notify, r);
 
 	if (smp->method == REQ_OOB)
 		memcpy(r, smp->rr, 16);
 
-	smp_f6(smp->tfm_cmac, smp->mackey, smp->prnd, smp->rrnd, r, io_cap,
-	       local_addr, remote_addr, check.e);
+	smp_f6(smp->mackey, smp->prnd, smp->rrnd, r, io_cap, local_addr,
+	       remote_addr, check.e);
 
 	smp_send_cmd(smp->conn, SMP_CMD_DHKEY_CHECK, sizeof(check), &check);
 }
 
 static u8 sc_passkey_send_confirm(struct smp_chan *smp)
@@ -1486,11 +1458,11 @@ static u8 sc_passkey_send_confirm(struct smp_chan *smp)
 	r = ((hcon->passkey_notify >> smp->passkey_round) & 0x01);
 	r |= 0x80;
 
 	get_random_bytes(smp->prnd, sizeof(smp->prnd));
 
-	if (smp_f4(smp->tfm_cmac, smp->local_pk, smp->remote_pk, smp->prnd, r,
+	if (smp_f4(smp->local_pk, smp->remote_pk, smp->prnd, r,
 		   cfm.confirm_val))
 		return SMP_UNSPECIFIED;
 
 	smp_send_cmd(conn, SMP_CMD_PAIRING_CONFIRM, sizeof(cfm), &cfm);
 
@@ -1511,12 +1483,11 @@ static u8 sc_passkey_round(struct smp_chan *smp, u8 smp_op)
 	switch (smp_op) {
 	case SMP_CMD_PAIRING_RANDOM:
 		r = ((hcon->passkey_notify >> smp->passkey_round) & 0x01);
 		r |= 0x80;
 
-		if (smp_f4(smp->tfm_cmac, smp->remote_pk, smp->local_pk,
-			   smp->rrnd, r, cfm))
+		if (smp_f4(smp->remote_pk, smp->local_pk, smp->rrnd, r, cfm))
 			return SMP_UNSPECIFIED;
 
 		if (crypto_memneq(smp->pcnf, cfm, 16))
 			return SMP_CONFIRM_FAILED;
 
@@ -2176,12 +2147,11 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 		return sc_passkey_round(smp, SMP_CMD_PAIRING_RANDOM);
 
 	if (test_bit(SMP_FLAG_INITIATOR, &smp->flags)) {
 		u8 cfm[16];
 
-		err = smp_f4(smp->tfm_cmac, smp->remote_pk, smp->local_pk,
-			     smp->rrnd, 0, cfm);
+		err = smp_f4(smp->remote_pk, smp->local_pk, smp->rrnd, 0, cfm);
 		if (err)
 			return SMP_UNSPECIFIED;
 
 		if (crypto_memneq(smp->pcnf, cfm, 16))
 			return SMP_CONFIRM_FAILED;
@@ -2203,11 +2173,11 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 			SMP_ALLOW_CMD(smp, SMP_CMD_DHKEY_CHECK);
 		}
 		return 0;
 	}
 
-	err = smp_g2(smp->tfm_cmac, pkax, pkbx, na, nb, &passkey);
+	err = smp_g2(pkax, pkbx, na, nb, &passkey);
 	if (err)
 		return SMP_UNSPECIFIED;
 
 	/* Always require user confirmation for Just-Works pairing to prevent
 	 * impersonation attacks, or in case of a legitimate device that is
@@ -2748,12 +2718,12 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 	}
 
 	memcpy(smp->remote_pk, key, 64);
 
 	if (test_bit(SMP_FLAG_REMOTE_OOB, &smp->flags)) {
-		err = smp_f4(smp->tfm_cmac, smp->remote_pk, smp->remote_pk,
-			     smp->rr, 0, cfm.confirm_val);
+		err = smp_f4(smp->remote_pk, smp->remote_pk, smp->rr, 0,
+			     cfm.confirm_val);
 		if (err)
 			return SMP_UNSPECIFIED;
 
 		if (crypto_memneq(cfm.confirm_val, smp->pcnf, 16))
 			return SMP_CONFIRM_FAILED;
@@ -2849,12 +2819,12 @@ static int smp_cmd_public_key(struct l2cap_conn *conn, struct sk_buff *skb)
 	 * send the confirm value.
 	 */
 	if (test_bit(SMP_FLAG_INITIATOR, &smp->flags))
 		return 0;
 
-	err = smp_f4(smp->tfm_cmac, smp->local_pk, smp->remote_pk, smp->prnd,
-		     0, cfm.confirm_val);
+	err = smp_f4(smp->local_pk, smp->remote_pk, smp->prnd, 0,
+		     cfm.confirm_val);
 	if (err)
 		return SMP_UNSPECIFIED;
 
 	smp_send_cmd(conn, SMP_CMD_PAIRING_CONFIRM, sizeof(cfm), &cfm);
 	SMP_ALLOW_CMD(smp, SMP_CMD_PAIRING_RANDOM);
@@ -2897,12 +2867,12 @@ static int smp_cmd_dhkey_check(struct l2cap_conn *conn, struct sk_buff *skb)
 	if (smp->method == REQ_PASSKEY || smp->method == DSP_PASSKEY)
 		put_unaligned_le32(hcon->passkey_notify, r);
 	else if (smp->method == REQ_OOB)
 		memcpy(r, smp->lr, 16);
 
-	err = smp_f6(smp->tfm_cmac, smp->mackey, smp->rrnd, smp->prnd, r,
-		     io_cap, remote_addr, local_addr, e);
+	err = smp_f6(smp->mackey, smp->rrnd, smp->prnd, r, io_cap, remote_addr,
+		     local_addr, e);
 	if (err)
 		return SMP_UNSPECIFIED;
 
 	if (crypto_memneq(check->e, e, 16))
 		return SMP_DHKEY_CHECK_FAILED;
@@ -3284,11 +3254,10 @@ static const struct l2cap_ops smp_root_chan_ops = {
 
 static struct l2cap_chan *smp_add_cid(struct hci_dev *hdev, u16 cid)
 {
 	struct l2cap_chan *chan;
 	struct smp_dev *smp;
-	struct crypto_shash *tfm_cmac;
 	struct crypto_kpp *tfm_ecdh;
 
 	if (cid == L2CAP_CID_SMP_BREDR) {
 		smp = NULL;
 		goto create_chan;
@@ -3296,34 +3265,24 @@ static struct l2cap_chan *smp_add_cid(struct hci_dev *hdev, u16 cid)
 
 	smp = kzalloc_obj(*smp);
 	if (!smp)
 		return ERR_PTR(-ENOMEM);
 
-	tfm_cmac = crypto_alloc_shash("cmac(aes)", 0, 0);
-	if (IS_ERR(tfm_cmac)) {
-		bt_dev_err(hdev, "Unable to create CMAC crypto context");
-		kfree_sensitive(smp);
-		return ERR_CAST(tfm_cmac);
-	}
-
 	tfm_ecdh = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(tfm_ecdh)) {
 		bt_dev_err(hdev, "Unable to create ECDH crypto context");
-		crypto_free_shash(tfm_cmac);
 		kfree_sensitive(smp);
 		return ERR_CAST(tfm_ecdh);
 	}
 
 	smp->local_oob = false;
-	smp->tfm_cmac = tfm_cmac;
 	smp->tfm_ecdh = tfm_ecdh;
 
 create_chan:
 	chan = l2cap_chan_create();
 	if (!chan) {
 		if (smp) {
-			crypto_free_shash(smp->tfm_cmac);
 			crypto_free_kpp(smp->tfm_ecdh);
 			kfree_sensitive(smp);
 		}
 		return ERR_PTR(-ENOMEM);
 	}
@@ -3366,11 +3325,10 @@ static void smp_del_chan(struct l2cap_chan *chan)
 	BT_DBG("chan %p", chan);
 
 	smp = chan->data;
 	if (smp) {
 		chan->data = NULL;
-		crypto_free_shash(smp->tfm_cmac);
 		crypto_free_kpp(smp->tfm_ecdh);
 		kfree_sensitive(smp);
 	}
 
 	l2cap_chan_put(chan);
@@ -3563,11 +3521,11 @@ static int __init test_s1(void)
 		return -EINVAL;
 
 	return 0;
 }
 
-static int __init test_f4(struct crypto_shash *tfm_cmac)
+static int __init test_f4(void)
 {
 	const u8 u[32] = {
 			0xe6, 0x9d, 0x35, 0x0e, 0x48, 0x01, 0x03, 0xcc,
 			0xdb, 0xfd, 0xf4, 0xac, 0x11, 0x91, 0xf4, 0xef,
 			0xb9, 0xa5, 0xf9, 0xe9, 0xa7, 0x83, 0x2c, 0x5e,
@@ -3585,21 +3543,21 @@ static int __init test_f4(struct crypto_shash *tfm_cmac)
 			0x2d, 0x87, 0x74, 0xa9, 0xbe, 0xa1, 0xed, 0xf1,
 			0x1c, 0xbd, 0xa9, 0x07, 0xf1, 0x16, 0xc9, 0xf2 };
 	u8 res[16];
 	int err;
 
-	err = smp_f4(tfm_cmac, u, v, x, z, res);
+	err = smp_f4(u, v, x, z, res);
 	if (err)
 		return err;
 
 	if (crypto_memneq(res, exp, 16))
 		return -EINVAL;
 
 	return 0;
 }
 
-static int __init test_f5(struct crypto_shash *tfm_cmac)
+static int __init test_f5(void)
 {
 	const u8 w[32] = {
 			0x98, 0xa6, 0xbf, 0x73, 0xf3, 0x34, 0x8d, 0x86,
 			0xf1, 0x66, 0xf8, 0xb4, 0x13, 0x6b, 0x79, 0x99,
 			0x9b, 0x7d, 0x39, 0x0a, 0xa6, 0x10, 0x10, 0x34,
@@ -3619,11 +3577,11 @@ static int __init test_f5(struct crypto_shash *tfm_cmac)
 			0x20, 0x6e, 0x63, 0xce, 0x20, 0x6a, 0x3f, 0xfd,
 			0x02, 0x4a, 0x08, 0xa1, 0x76, 0xf1, 0x65, 0x29 };
 	u8 mackey[16], ltk[16];
 	int err;
 
-	err = smp_f5(tfm_cmac, w, n1, n2, a1, a2, mackey, ltk);
+	err = smp_f5(w, n1, n2, a1, a2, mackey, ltk);
 	if (err)
 		return err;
 
 	if (crypto_memneq(mackey, exp_mackey, 16))
 		return -EINVAL;
@@ -3632,11 +3590,11 @@ static int __init test_f5(struct crypto_shash *tfm_cmac)
 		return -EINVAL;
 
 	return 0;
 }
 
-static int __init test_f6(struct crypto_shash *tfm_cmac)
+static int __init test_f6(void)
 {
 	const u8 w[16] = {
 			0x20, 0x6e, 0x63, 0xce, 0x20, 0x6a, 0x3f, 0xfd,
 			0x02, 0x4a, 0x08, 0xa1, 0x76, 0xf1, 0x65, 0x29 };
 	const u8 n1[16] = {
@@ -3655,21 +3613,21 @@ static int __init test_f6(struct crypto_shash *tfm_cmac)
 			0x61, 0x8f, 0x95, 0xda, 0x09, 0x0b, 0x6c, 0xd2,
 			0xc5, 0xe8, 0xd0, 0x9c, 0x98, 0x73, 0xc4, 0xe3 };
 	u8 res[16];
 	int err;
 
-	err = smp_f6(tfm_cmac, w, n1, n2, r, io_cap, a1, a2, res);
+	err = smp_f6(w, n1, n2, r, io_cap, a1, a2, res);
 	if (err)
 		return err;
 
 	if (crypto_memneq(res, exp, 16))
 		return -EINVAL;
 
 	return 0;
 }
 
-static int __init test_g2(struct crypto_shash *tfm_cmac)
+static int __init test_g2(void)
 {
 	const u8 u[32] = {
 			0xe6, 0x9d, 0x35, 0x0e, 0x48, 0x01, 0x03, 0xcc,
 			0xdb, 0xfd, 0xf4, 0xac, 0x11, 0x91, 0xf4, 0xef,
 			0xb9, 0xa5, 0xf9, 0xe9, 0xa7, 0x83, 0x2c, 0x5e,
@@ -3687,21 +3645,21 @@ static int __init test_g2(struct crypto_shash *tfm_cmac)
 			0x6e, 0x5f, 0xa7, 0x25, 0xcc, 0xe7, 0xe8, 0xa6 };
 	const u32 exp_val = 0x2f9ed5ba % 1000000;
 	u32 val;
 	int err;
 
-	err = smp_g2(tfm_cmac, u, v, x, y, &val);
+	err = smp_g2(u, v, x, y, &val);
 	if (err)
 		return err;
 
 	if (val != exp_val)
 		return -EINVAL;
 
 	return 0;
 }
 
-static int __init test_h6(struct crypto_shash *tfm_cmac)
+static int __init test_h6(void)
 {
 	const u8 w[16] = {
 			0x9b, 0x7d, 0x39, 0x0a, 0xa6, 0x10, 0x10, 0x34,
 			0x05, 0xad, 0xc8, 0x57, 0xa3, 0x34, 0x02, 0xec };
 	const u8 key_id[4] = { 0x72, 0x62, 0x65, 0x6c };
@@ -3709,11 +3667,11 @@ static int __init test_h6(struct crypto_shash *tfm_cmac)
 			0x99, 0x63, 0xb1, 0x80, 0xe2, 0xa9, 0xd3, 0xe8,
 			0x1c, 0xc9, 0x6d, 0xe7, 0x02, 0xe1, 0x9a, 0x2d };
 	u8 res[16];
 	int err;
 
-	err = smp_h6(tfm_cmac, w, key_id, res);
+	err = smp_h6(w, key_id, res);
 	if (err)
 		return err;
 
 	if (crypto_memneq(res, exp, 16))
 		return -EINVAL;
@@ -3734,12 +3692,11 @@ static const struct file_operations test_smp_fops = {
 	.open		= simple_open,
 	.read		= test_smp_read,
 	.llseek		= default_llseek,
 };
 
-static int __init run_selftests(struct crypto_shash *tfm_cmac,
-				struct crypto_kpp *tfm_ecdh)
+static int __init run_selftests(struct crypto_kpp *tfm_ecdh)
 {
 	ktime_t calltime, delta, rettime;
 	unsigned long long duration;
 	int err;
 
@@ -3767,35 +3724,35 @@ static int __init run_selftests(struct crypto_shash *tfm_cmac,
 	if (err) {
 		BT_ERR("smp_s1 test failed");
 		goto done;
 	}
 
-	err = test_f4(tfm_cmac);
+	err = test_f4();
 	if (err) {
 		BT_ERR("smp_f4 test failed");
 		goto done;
 	}
 
-	err = test_f5(tfm_cmac);
+	err = test_f5();
 	if (err) {
 		BT_ERR("smp_f5 test failed");
 		goto done;
 	}
 
-	err = test_f6(tfm_cmac);
+	err = test_f6();
 	if (err) {
 		BT_ERR("smp_f6 test failed");
 		goto done;
 	}
 
-	err = test_g2(tfm_cmac);
+	err = test_g2();
 	if (err) {
 		BT_ERR("smp_g2 test failed");
 		goto done;
 	}
 
-	err = test_h6(tfm_cmac);
+	err = test_h6();
 	if (err) {
 		BT_ERR("smp_h6 test failed");
 		goto done;
 	}
 
@@ -3818,30 +3775,21 @@ static int __init run_selftests(struct crypto_shash *tfm_cmac,
 	return err;
 }
 
 int __init bt_selftest_smp(void)
 {
-	struct crypto_shash *tfm_cmac;
 	struct crypto_kpp *tfm_ecdh;
 	int err;
 
-	tfm_cmac = crypto_alloc_shash("cmac(aes)", 0, 0);
-	if (IS_ERR(tfm_cmac)) {
-		BT_ERR("Unable to create CMAC crypto context");
-		return PTR_ERR(tfm_cmac);
-	}
-
 	tfm_ecdh = crypto_alloc_kpp("ecdh-nist-p256", 0, 0);
 	if (IS_ERR(tfm_ecdh)) {
 		BT_ERR("Unable to create ECDH crypto context");
-		crypto_free_shash(tfm_cmac);
 		return PTR_ERR(tfm_ecdh);
 	}
 
-	err = run_selftests(tfm_cmac, tfm_ecdh);
+	err = run_selftests(tfm_ecdh);
 
-	crypto_free_shash(tfm_cmac);
 	crypto_free_kpp(tfm_ecdh);
 
 	return err;
 }
 
-- 
2.53.0

