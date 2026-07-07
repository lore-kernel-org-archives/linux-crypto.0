Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98C63A1690;
	Tue,  7 Jul 2026 05:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783402650; cv=none; b=S/DyAc4Ybr456exEVJQagxFIBvd5GZM/YWohjljirX50vW/1TmNYsROHnbu63Nwp1ID3MlR8zSpWo73yn6ojpZOImdzoVmBO0ExlS/WfASF7CIIpjMAHb8sG1EZF0RDtgvutP29CS1/feLsSY0zL9cNT1Auo1C/KHHPhbAUgtvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783402650; c=relaxed/simple;
	bh=COaolMznU2vbzPB6UKUrk5NU/whlh1FCxP9okMXHrIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kr5BVjgNRhIHJKKqp3bWR+92zOuJNhRBe2sKMf2ZBZz/JdF8iWRpC+rPDEHdVIhnuJkC16P2RLRy9zfJ5x6i2TUdWb1bUzG8V5Z8L01fRIuMFaku0c7NCmm9Nyrh1sPNQErdIFx9pYlVLmCXJiqwmoQHhVuw9JaREozwu+1vCbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ht7V4LjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ht7V4LjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7381E1F00ACF;
	Tue,  7 Jul 2026 05:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783402643;
	bh=pjGerO/6BxsMVvbq3oOqOH0MT/qj9ZRiXYE5JrzdFvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ht7V4LjLQOpx0mj9bqcDS7AO3fNZLwTE2dsLVXW9NQoJIRf5oaw6ehkCNC67yBiPL
	 NuhPtmFzr2NrkXPc5VmOguQINw5+g2uBR0D0hdt/ONg8Nxn2Ovsw0ImtaFHG0cRlEt
	 91T63pzGNDPPhIt+6EgtdD6YwGfNMAXvAVremES9jK+3KWQzblCpV+0JqfDxc5Emg3
	 U3UEN+ubaQ0ZGr1IFHThoZZ4XM2OlVrtNZutvHJsTIRd0HrmkhXGKDTuEUN3uk5L5Z
	 lvj+4DbmA3GUyQhbieGFCeqP1rqxE+tT5FPKhmJq7hswRa544aGEMFBEedXvWMkytJ
	 wZXr3l0lJzzRw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 28/33] mac802154: Use AES-CCM and AES-CTR libraries
Date: Mon,  6 Jul 2026 22:34:58 -0700
Message-ID: <20260707053503.209874-29-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260707053503.209874-1-ebiggers@kernel.org>
References: <20260707053503.209874-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that there are library APIs for AES-CCM and AES-CTR, use these
instead of "ccm(aes)" crypto_aeads and a "ctr(aes)" crypto_skcipher.

This significantly simplifies the code, especially considering that the
existing code already supported only linear skbs anyway.

Note that as before, 'struct mac802154_llsec_key' contains four copies
of the same key prepared in different ways: one for AES-CTR, and one for
each AES-CCM authentication tag length 4, 8, and 16 bytes.  That
continues to be wasteful; however, the crypto APIs are very much working
as intended in tying the key to the algorithm and authentication tag
length.  It shows this driver is doing something wrong by reusing the
same key for multiple purposes.  At some point this driver will need to
be fixed to allow keys with only one algorithm and tag length at a time,
but that's outside the scope of this cleanup.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 net/mac802154/Kconfig |   6 +-
 net/mac802154/llsec.c | 158 +++++++++++++-----------------------------
 net/mac802154/llsec.h |   8 ++-
 3 files changed, 55 insertions(+), 117 deletions(-)

diff --git a/net/mac802154/Kconfig b/net/mac802154/Kconfig
index 901167b1e6f5..5195556670fa 100644
--- a/net/mac802154/Kconfig
+++ b/net/mac802154/Kconfig
@@ -3,11 +3,7 @@ config MAC802154
 	tristate "Generic IEEE 802.15.4 Soft Networking Stack (mac802154)"
 	depends on IEEE802154
 	select CRC_CCITT
-	select CRYPTO
-	select CRYPTO_AUTHENC
-	select CRYPTO_CCM
-	select CRYPTO_CTR
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES_CCM
 	help
 	  This option enables the hardware independent IEEE 802.15.4
 	  networking stack for SoftMAC devices (the ones implementing
diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
index 5e7cc11fab3a..367e98c48864 100644
--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -6,14 +6,12 @@
  * Phoebe Buckheister <phoebe.buckheister@itwm.fraunhofer.de>
  */
 
-#include <linux/err.h>
 #include <linux/bug.h>
-#include <linux/completion.h>
 #include <linux/ieee802154.h>
 #include <linux/rculist.h>
 
-#include <crypto/aead.h>
-#include <crypto/skcipher.h>
+#include <crypto/aes-ccm.h>
+#include <crypto/aes-ctr.h>
 
 #include "ieee802154_i.h"
 #include "llsec.h"
@@ -110,11 +108,13 @@ int mac802154_llsec_set_params(struct mac802154_llsec *sec,
 	return 0;
 }
 
+static const int authsizes[3] = { 4, 8, 16 };
+
 static struct mac802154_llsec_key*
 llsec_key_alloc(const struct ieee802154_llsec_key *template)
 {
-	const int authsizes[3] = { 4, 8, 16 };
 	struct mac802154_llsec_key *key;
+	int err;
 	int i;
 
 	key = kzalloc_obj(*key);
@@ -124,37 +124,21 @@ llsec_key_alloc(const struct ieee802154_llsec_key *template)
 	kref_init(&key->ref);
 	key->key = *template;
 
-	BUILD_BUG_ON(ARRAY_SIZE(authsizes) != ARRAY_SIZE(key->tfm));
-
-	for (i = 0; i < ARRAY_SIZE(key->tfm); i++) {
-		key->tfm[i] = crypto_alloc_aead("ccm(aes)", 0,
-						CRYPTO_ALG_ASYNC);
-		if (IS_ERR(key->tfm[i]))
-			goto err_tfm;
-		if (crypto_aead_setkey(key->tfm[i], template->key,
-				       IEEE802154_LLSEC_KEY_SIZE))
-			goto err_tfm;
-		if (crypto_aead_setauthsize(key->tfm[i], authsizes[i]))
-			goto err_tfm;
+	BUILD_BUG_ON(ARRAY_SIZE(authsizes) != ARRAY_SIZE(key->ccm_keys));
+	for (i = 0; i < ARRAY_SIZE(key->ccm_keys); i++) {
+		err = aes_ccm_preparekey(&key->ccm_keys[i], template->key,
+					 IEEE802154_LLSEC_KEY_SIZE,
+					 authsizes[i]);
+		if (err)
+			goto err_free;
 	}
-
-	key->tfm0 = crypto_alloc_sync_skcipher("ctr(aes)", 0, 0);
-	if (IS_ERR(key->tfm0))
-		goto err_tfm;
-
-	if (crypto_sync_skcipher_setkey(key->tfm0, template->key,
-				   IEEE802154_LLSEC_KEY_SIZE))
-		goto err_tfm0;
-
+	err = aes_prepareenckey(&key->ctr_key, template->key,
+				IEEE802154_LLSEC_KEY_SIZE);
+	if (err)
+		goto err_free;
 	return key;
 
-err_tfm0:
-	crypto_free_sync_skcipher(key->tfm0);
-err_tfm:
-	for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
-		if (!IS_ERR_OR_NULL(key->tfm[i]))
-			crypto_free_aead(key->tfm[i]);
-
+err_free:
 	kfree_sensitive(key);
 	return NULL;
 }
@@ -162,14 +146,8 @@ llsec_key_alloc(const struct ieee802154_llsec_key *template)
 static void llsec_key_release(struct kref *ref)
 {
 	struct mac802154_llsec_key *key;
-	int i;
 
 	key = container_of(ref, struct mac802154_llsec_key, ref);
-
-	for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
-		crypto_free_aead(key->tfm[i]);
-
-	crypto_free_sync_skcipher(key->tfm0);
 	kfree_sensitive(key);
 }
 
@@ -621,34 +599,24 @@ llsec_do_encrypt_unauth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 			struct mac802154_llsec_key *key)
 {
 	u8 iv[16];
-	struct scatterlist src;
-	SYNC_SKCIPHER_REQUEST_ON_STACK(req, key->tfm0);
-	int err, datalen;
+	int datalen;
 	unsigned char *data;
 
 	llsec_geniv(iv, sec->params.hwaddr, &hdr->sec);
 	/* Compute data payload offset and data length */
 	data = skb_mac_header(skb) + skb->mac_len;
 	datalen = skb_tail_pointer(skb) - data;
-	sg_init_one(&src, data, datalen);
 
-	skcipher_request_set_sync_tfm(req, key->tfm0);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &src, &src, datalen, iv);
-	err = crypto_skcipher_encrypt(req);
-	skcipher_request_zero(req);
-	return err;
+	aes_ctr(data, data, datalen, iv, &key->ctr_key);
+	return 0;
 }
 
-static struct crypto_aead*
-llsec_tfm_by_len(struct mac802154_llsec_key *key, int authlen)
+static const struct aes_ccm_key *
+llsec_ccm_key_by_authlen(const struct mac802154_llsec_key *key, int authlen)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
-		if (crypto_aead_authsize(key->tfm[i]) == authlen)
-			return key->tfm[i];
-
+	for (int i = 0; i < ARRAY_SIZE(authsizes); i++)
+		if (authsizes[i] == authlen)
+			return &key->ccm_keys[i];
 	BUG();
 }
 
@@ -658,41 +626,29 @@ llsec_do_encrypt_auth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 		      struct mac802154_llsec_key *key)
 {
 	u8 iv[16];
-	unsigned char *data;
-	int authlen, assoclen, datalen, rc;
-	struct scatterlist sg;
-	struct aead_request *req;
+	u8 *authtag, *assoc, *data;
+	int authlen, assoclen, datalen;
 
 	authlen = ieee802154_sechdr_authtag_len(&hdr->sec);
 	llsec_geniv(iv, sec->params.hwaddr, &hdr->sec);
 
-	req = aead_request_alloc(llsec_tfm_by_len(key, authlen), GFP_ATOMIC);
-	if (!req)
-		return -ENOMEM;
-
+	assoc = skb_mac_header(skb);
 	assoclen = skb->mac_len;
-
-	data = skb_mac_header(skb) + skb->mac_len;
+	data = assoc + assoclen;
 	datalen = skb_tail_pointer(skb) - data;
+	authtag = &data[datalen];
 
 	skb_put(skb, authlen);
 
-	sg_init_one(&sg, skb_mac_header(skb), assoclen + datalen + authlen);
-
 	if (!(hdr->sec.level & IEEE802154_SCF_SECLEVEL_ENC)) {
 		assoclen += datalen;
 		datalen = 0;
 	}
 
-	aead_request_set_callback(req, 0, NULL, NULL);
-	aead_request_set_crypt(req, &sg, &sg, datalen, iv);
-	aead_request_set_ad(req, assoclen);
-
-	rc = crypto_aead_encrypt(req);
-
-	kfree_sensitive(req);
-
-	return rc;
+	return aes_ccm_encrypt(data, authtag, data, datalen, assoc, assoclen,
+			       /* This just takes the nonce directly. */
+			       &iv[1], 13,
+			       llsec_ccm_key_by_authlen(key, authlen));
 }
 
 static int llsec_do_encrypt(struct sk_buff *skb,
@@ -849,23 +805,13 @@ llsec_do_decrypt_unauth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 	u8 iv[16];
 	unsigned char *data;
 	int datalen;
-	struct scatterlist src;
-	SYNC_SKCIPHER_REQUEST_ON_STACK(req, key->tfm0);
-	int err;
 
 	llsec_geniv(iv, dev_addr, &hdr->sec);
 	data = skb_mac_header(skb) + skb->mac_len;
 	datalen = skb_tail_pointer(skb) - data;
 
-	sg_init_one(&src, data, datalen);
-
-	skcipher_request_set_sync_tfm(req, key->tfm0);
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &src, &src, datalen, iv);
-
-	err = crypto_skcipher_decrypt(req);
-	skcipher_request_zero(req);
-	return err;
+	aes_ctr(data, data, datalen, iv, &key->ctr_key);
+	return 0;
 }
 
 static int
@@ -874,37 +820,31 @@ llsec_do_decrypt_auth(struct sk_buff *skb, const struct mac802154_llsec *sec,
 		      struct mac802154_llsec_key *key, __le64 dev_addr)
 {
 	u8 iv[16];
-	unsigned char *data;
+	u8 *authtag, *assoc, *data;
 	int authlen, datalen, assoclen, rc;
-	struct scatterlist sg;
-	struct aead_request *req;
 
 	authlen = ieee802154_sechdr_authtag_len(&hdr->sec);
 	llsec_geniv(iv, dev_addr, &hdr->sec);
 
-	req = aead_request_alloc(llsec_tfm_by_len(key, authlen), GFP_ATOMIC);
-	if (!req)
-		return -ENOMEM;
-
+	assoc = skb_mac_header(skb);
 	assoclen = skb->mac_len;
-
-	data = skb_mac_header(skb) + skb->mac_len;
+	data = assoc + assoclen;
 	datalen = skb_tail_pointer(skb) - data;
 
-	sg_init_one(&sg, skb_mac_header(skb), assoclen + datalen);
+	if (datalen < authlen)
+		return -EBADMSG;
+	datalen -= authlen;
+	authtag = &data[datalen];
 
 	if (!(hdr->sec.level & IEEE802154_SCF_SECLEVEL_ENC)) {
-		assoclen += datalen - authlen;
-		datalen = authlen;
+		assoclen += datalen;
+		datalen = 0;
 	}
 
-	aead_request_set_callback(req, 0, NULL, NULL);
-	aead_request_set_crypt(req, &sg, &sg, datalen, iv);
-	aead_request_set_ad(req, assoclen);
-
-	rc = crypto_aead_decrypt(req);
-
-	kfree_sensitive(req);
+	rc = aes_ccm_decrypt(data, data, authtag, datalen, assoc, assoclen,
+			     /* This just takes the nonce directly. */
+			     &iv[1], 13,
+			     llsec_ccm_key_by_authlen(key, authlen));
 	skb_trim(skb, skb->len - authlen);
 
 	return rc;
diff --git a/net/mac802154/llsec.h b/net/mac802154/llsec.h
index ddeb79228204..2b9815dbe38f 100644
--- a/net/mac802154/llsec.h
+++ b/net/mac802154/llsec.h
@@ -9,6 +9,8 @@
 #ifndef MAC802154_LLSEC_H
 #define MAC802154_LLSEC_H
 
+#include <crypto/aes-ccm.h>
+#include <crypto/aes-ctr.h>
 #include <linux/slab.h>
 #include <linux/hashtable.h>
 #include <linux/kref.h>
@@ -19,9 +21,9 @@
 struct mac802154_llsec_key {
 	struct ieee802154_llsec_key key;
 
-	/* one tfm for each authsize (4/8/16) */
-	struct crypto_aead *tfm[3];
-	struct crypto_sync_skcipher *tfm0;
+	/* one for each authsize (4/8/16) */
+	struct aes_ccm_key ccm_keys[3];
+	struct aes_enckey ctr_key;
 
 	struct kref ref;
 };
-- 
2.54.0

