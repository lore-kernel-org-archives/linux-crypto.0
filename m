Return-Path: <SRS0=gkGi=XU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24787C4360D
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D613C21D7B
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Sep 2019 16:14:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RH6HBNEq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439563AbfIYQOV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Sep 2019 12:14:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51566 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439477AbfIYQOV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so6427123wme.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Sep 2019 09:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m3ulTEA/3BA67wNTxSZXJ33CnsNx57q64URFh48GI0c=;
        b=RH6HBNEqhY9LzPWnJDN+VkfzutAmKJiEYfrFXcT53blsHxoSt8XhsEPWedRVq8q4zk
         /HZWYXnp77Nk6H2pJ4fpH2NdHr2VnDsnMrx/vDU+zNUsbMBg7Gxl/hE1zNtCW3O3Mvqk
         g9ljunjvYU1SLGgYv/AEBz1CqRXTPEMv62Dk4Yu1rVPgiafUREqItXmoNLFbZYkrHB2D
         hvtHtpJ3fc/sGUMqJSu+TAEBiZxAegXNqJLDQg0mDOrI57LOzbBbGe0/Xu5f8c3yC+WQ
         zQ9umJj8ZZQJ8h+IeBEizzUGbfO2rjVkBaBZ+6qrqHRMgFMCqOdATCAQ+CEp8VPQpOW3
         dFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m3ulTEA/3BA67wNTxSZXJ33CnsNx57q64URFh48GI0c=;
        b=EDRTv6Nesum+20ac1KrfzPKyaPVojKry/KAM3kkMs93Ir0OysNzG1Hk/7paOk7zj8+
         yWI3RzbxOM0vRjheDtVQcacvYSGGVGrbmSQL421bEwD7i1aaE7cg7lfAsYi/betFd9PO
         ZJClu3mCS1XiR5xvVoaEk7N/BPPsZr8VRZpvp4n8giLMmwPFnJZJ88Ys8iKvK/aFVfDm
         v0Te75h/mRKh3igE6p9rS0/BINv6CvWNc+TtoMR3KnoCH5/w/uHBvGh4mp1X8aA0KvDr
         NMdrE/D7JD9BX7CcyXjR8kzP+HVhkC1gk9+lxSN5iOfgm2EnE1V/ABB6ggvv6CA9O3BD
         ZfHA==
X-Gm-Message-State: APjAAAUdec/SKLhQsEoVKPoseScgPzvcYa9iQ2fsDQzJBh64Pl4xVxdN
        7zbS1U03gC7wLaCBsBmuVX5dngaeOClENVH8
X-Google-Smtp-Source: APXvYqzMsBhNH5UNFZF1bzfPqeNCYYxO/juqm3X9vngxBz2Vy7X7aY24toGtRKqi2Vq0pqbMe1eaSA==
X-Received: by 2002:a1c:c5c3:: with SMTP id v186mr8453265wmf.125.1569428055951;
        Wed, 25 Sep 2019 09:14:15 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id o70sm4991085wme.29.2019.09.25.09.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 09:14:15 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [RFC PATCH 18/18] net: wireguard - switch to crypto API for packet encryption
Date:   Wed, 25 Sep 2019 18:12:55 +0200
Message-Id: <20190925161255.1871-19-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace the chacha20poly1305() library calls with invocations of the
RFC7539 AEAD, as implemented by the generic chacha20poly1305 template.

For now, only synchronous AEADs are supported, but looking at the code,
it does not look terribly complicated to add support for async versions
of rfc7539(chacha20,poly1305) as well, some of which already exist in
the drivers/crypto tree.

The nonce related changes are there to address the mismatch between the
96-bit nonce (aka IV) that the rfc7539() template expects, and the 64-bit
nonce that WireGuard uses.

Note that these changes take advantage of the fact that synchronous
instantiations of the generic rfc7539() template will use a zero reqsize
if possible, removing the need for heap allocations for the request
structures.

This code was tested using the included netns.sh script, and by connecting
to the WireGuard demo server
(https://www.wireguard.com/quickstart/#demo-server)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/net/wireguard/noise.c    | 34 ++++++++++++-
 drivers/net/wireguard/noise.h    |  3 +-
 drivers/net/wireguard/queueing.h |  5 +-
 drivers/net/wireguard/receive.c  | 51 ++++++++++++--------
 drivers/net/wireguard/send.c     | 45 ++++++++++-------
 5 files changed, 97 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index bf0b8c5ab298..0e7aab9f645d 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -109,16 +109,37 @@ static struct noise_keypair *keypair_create(struct wg_peer *peer)
 
 	if (unlikely(!keypair))
 		return NULL;
+
+	keypair->sending.tfm = crypto_alloc_aead("rfc7539(chacha20,poly1305)",
+						 0, CRYPTO_ALG_ASYNC);
+	if (unlikely(IS_ERR(keypair->sending.tfm)))
+		goto free_keypair;
+	keypair->receiving.tfm = crypto_alloc_aead("rfc7539(chacha20,poly1305)",
+						   0, CRYPTO_ALG_ASYNC);
+	if (unlikely(IS_ERR(keypair->receiving.tfm)))
+		goto free_sending_tfm;
+
 	keypair->internal_id = atomic64_inc_return(&keypair_counter);
 	keypair->entry.type = INDEX_HASHTABLE_KEYPAIR;
 	keypair->entry.peer = peer;
 	kref_init(&keypair->refcount);
 	return keypair;
+
+free_sending_tfm:
+	crypto_free_aead(keypair->sending.tfm);
+free_keypair:
+	kzfree(keypair);
+	return NULL;
 }
 
 static void keypair_free_rcu(struct rcu_head *rcu)
 {
-	kzfree(container_of(rcu, struct noise_keypair, rcu));
+	struct noise_keypair *keypair =
+		container_of(rcu, struct noise_keypair, rcu);
+
+	crypto_free_aead(keypair->sending.tfm);
+	crypto_free_aead(keypair->receiving.tfm);
+	kzfree(keypair);
 }
 
 static void keypair_free_kref(struct kref *kref)
@@ -360,11 +381,20 @@ static void derive_keys(struct noise_symmetric_key *first_dst,
 			struct noise_symmetric_key *second_dst,
 			const u8 chaining_key[NOISE_HASH_LEN])
 {
-	kdf(first_dst->key, second_dst->key, NULL, NULL,
+	u8 key[2][NOISE_SYMMETRIC_KEY_LEN];
+	int err;
+
+	kdf(key[0], key[1], NULL, NULL,
 	    NOISE_SYMMETRIC_KEY_LEN, NOISE_SYMMETRIC_KEY_LEN, 0, 0,
 	    chaining_key);
 	symmetric_key_init(first_dst);
 	symmetric_key_init(second_dst);
+
+	err = crypto_aead_setkey(first_dst->tfm, key[0], sizeof(key[0])) ?:
+	      crypto_aead_setkey(second_dst->tfm, key[1], sizeof(key[1]));
+	memzero_explicit(key, sizeof(key));
+	if (unlikely(err))
+		pr_warn_once("crypto_aead_setkey() failed (%d)\n", err);
 }
 
 static bool __must_check mix_dh(u8 chaining_key[NOISE_HASH_LEN],
diff --git a/drivers/net/wireguard/noise.h b/drivers/net/wireguard/noise.h
index 9c2cc62dc11e..6f033d2ea52c 100644
--- a/drivers/net/wireguard/noise.h
+++ b/drivers/net/wireguard/noise.h
@@ -8,6 +8,7 @@
 #include "messages.h"
 #include "peerlookup.h"
 
+#include <crypto/aead.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
@@ -26,7 +27,7 @@ union noise_counter {
 };
 
 struct noise_symmetric_key {
-	u8 key[NOISE_SYMMETRIC_KEY_LEN];
+	struct crypto_aead *tfm;
 	union noise_counter counter;
 	u64 birthdate;
 	bool is_valid;
diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index f8de703dff97..593971edf8a3 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -55,9 +55,10 @@ enum packet_state {
 };
 
 struct packet_cb {
-	u64 nonce;
-	struct noise_keypair *keypair;
 	atomic_t state;
+	__le32 ivpad;			/* pad 64-bit nonce to 96 bits */
+	__le64 nonce;
+	struct noise_keypair *keypair;
 	u32 mtu;
 	u8 ds;
 };
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 900c76edb9d6..395089e7e3a6 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -11,7 +11,7 @@
 #include "cookie.h"
 #include "socket.h"
 
-#include <linux/simd.h>
+#include <crypto/aead.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/udp.h>
@@ -244,13 +244,14 @@ static void keep_key_fresh(struct wg_peer *peer)
 	}
 }
 
-static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key,
-			   simd_context_t *simd_context)
+static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key)
 {
 	struct scatterlist sg[MAX_SKB_FRAGS + 8];
+	struct aead_request *req, stackreq;
 	struct sk_buff *trailer;
 	unsigned int offset;
 	int num_frags;
+	int err;
 
 	if (unlikely(!key))
 		return false;
@@ -262,8 +263,8 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key,
 		return false;
 	}
 
-	PACKET_CB(skb)->nonce =
-		le64_to_cpu(((struct message_data *)skb->data)->counter);
+	PACKET_CB(skb)->ivpad = 0;
+	PACKET_CB(skb)->nonce = ((struct message_data *)skb->data)->counter;
 
 	/* We ensure that the network header is part of the packet before we
 	 * call skb_cow_data, so that there's no chance that data is removed
@@ -281,9 +282,23 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key,
 	if (skb_to_sgvec(skb, sg, 0, skb->len) <= 0)
 		return false;
 
-	if (!chacha20poly1305_decrypt_sg(sg, sg, skb->len, NULL, 0,
-					 PACKET_CB(skb)->nonce, key->key,
-					 simd_context))
+	if (unlikely(crypto_aead_reqsize(key->tfm) > 0)) {
+		req = aead_request_alloc(key->tfm, GFP_ATOMIC);
+		if (!req)
+			return false;
+	} else {
+		req = &stackreq;
+		aead_request_set_tfm(req, key->tfm);
+	}
+
+	aead_request_set_ad(req, 0);
+	aead_request_set_callback(req, 0, NULL, NULL);
+	aead_request_set_crypt(req, sg, sg, skb->len,
+			       (u8 *)&PACKET_CB(skb)->ivpad);
+	err = crypto_aead_decrypt(req);
+	if (unlikely(req != &stackreq))
+		aead_request_free(req);
+	if (err)
 		return false;
 
 	/* Another ugly situation of pushing and pulling the header so as to
@@ -475,10 +490,10 @@ int wg_packet_rx_poll(struct napi_struct *napi, int budget)
 			goto next;
 
 		if (unlikely(!counter_validate(&keypair->receiving.counter,
-					       PACKET_CB(skb)->nonce))) {
+					       le64_to_cpu(PACKET_CB(skb)->nonce)))) {
 			net_dbg_ratelimited("%s: Packet has invalid nonce %llu (max %llu)\n",
 					    peer->device->dev->name,
-					    PACKET_CB(skb)->nonce,
+					    le64_to_cpu(PACKET_CB(skb)->nonce),
 					    keypair->receiving.counter.receive.counter);
 			goto next;
 		}
@@ -510,21 +525,19 @@ void wg_packet_decrypt_worker(struct work_struct *work)
 {
 	struct crypt_queue *queue = container_of(work, struct multicore_worker,
 						 work)->ptr;
-	simd_context_t simd_context;
 	struct sk_buff *skb;
 
-	simd_get(&simd_context);
 	while ((skb = ptr_ring_consume_bh(&queue->ring)) != NULL) {
-		enum packet_state state = likely(decrypt_packet(skb,
-					   &PACKET_CB(skb)->keypair->receiving,
-					   &simd_context)) ?
-				PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
+		enum packet_state state;
+
+		if (likely(decrypt_packet(skb,
+					  &PACKET_CB(skb)->keypair->receiving)))
+			state = PACKET_STATE_CRYPTED;
+		else
+			state = PACKET_STATE_DEAD;
 		wg_queue_enqueue_per_peer_napi(&PACKET_PEER(skb)->rx_queue, skb,
 					       state);
-		simd_relax(&simd_context);
 	}
-
-	simd_put(&simd_context);
 }
 
 static void wg_packet_consume_data(struct wg_device *wg, struct sk_buff *skb)
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index b0df5c717502..48d1fb02f575 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -11,7 +11,7 @@
 #include "messages.h"
 #include "cookie.h"
 
-#include <linux/simd.h>
+#include <crypto/aead.h>
 #include <linux/uio.h>
 #include <linux/inetdevice.h>
 #include <linux/socket.h>
@@ -157,11 +157,11 @@ static unsigned int calculate_skb_padding(struct sk_buff *skb)
 	return padded_size - last_unit;
 }
 
-static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair,
-			   simd_context_t *simd_context)
+static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 {
 	unsigned int padding_len, plaintext_len, trailer_len;
 	struct scatterlist sg[MAX_SKB_FRAGS + 8];
+	struct aead_request *req, stackreq;
 	struct message_data *header;
 	struct sk_buff *trailer;
 	int num_frags;
@@ -199,7 +199,7 @@ static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair,
 	header = (struct message_data *)skb_push(skb, sizeof(*header));
 	header->header.type = cpu_to_le32(MESSAGE_DATA);
 	header->key_idx = keypair->remote_index;
-	header->counter = cpu_to_le64(PACKET_CB(skb)->nonce);
+	header->counter = PACKET_CB(skb)->nonce;
 	pskb_put(skb, trailer, trailer_len);
 
 	/* Now we can encrypt the scattergather segments */
@@ -207,9 +207,24 @@ static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair,
 	if (skb_to_sgvec(skb, sg, sizeof(struct message_data),
 			 noise_encrypted_len(plaintext_len)) <= 0)
 		return false;
-	return chacha20poly1305_encrypt_sg(sg, sg, plaintext_len, NULL, 0,
-					   PACKET_CB(skb)->nonce,
-					   keypair->sending.key, simd_context);
+
+	if (unlikely(crypto_aead_reqsize(keypair->sending.tfm) > 0)) {
+		req = aead_request_alloc(keypair->sending.tfm, GFP_ATOMIC);
+		if (!req)
+			return false;
+	} else {
+		req = &stackreq;
+		aead_request_set_tfm(req, keypair->sending.tfm);
+	}
+
+	aead_request_set_ad(req, 0);
+	aead_request_set_callback(req, 0, NULL, NULL);
+	aead_request_set_crypt(req, sg, sg, plaintext_len,
+			       (u8 *)&PACKET_CB(skb)->ivpad);
+	crypto_aead_encrypt(req);
+	if (unlikely(req != &stackreq))
+		aead_request_free(req);
+	return true;
 }
 
 void wg_packet_send_keepalive(struct wg_peer *peer)
@@ -296,16 +311,13 @@ void wg_packet_encrypt_worker(struct work_struct *work)
 	struct crypt_queue *queue = container_of(work, struct multicore_worker,
 						 work)->ptr;
 	struct sk_buff *first, *skb, *next;
-	simd_context_t simd_context;
 
-	simd_get(&simd_context);
 	while ((first = ptr_ring_consume_bh(&queue->ring)) != NULL) {
 		enum packet_state state = PACKET_STATE_CRYPTED;
 
 		skb_walk_null_queue_safe(first, skb, next) {
 			if (likely(encrypt_packet(skb,
-						  PACKET_CB(first)->keypair,
-						  &simd_context))) {
+						  PACKET_CB(first)->keypair))) {
 				wg_reset_packet(skb);
 			} else {
 				state = PACKET_STATE_DEAD;
@@ -314,10 +326,7 @@ void wg_packet_encrypt_worker(struct work_struct *work)
 		}
 		wg_queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first,
 					  state);
-
-		simd_relax(&simd_context);
 	}
-	simd_put(&simd_context);
 }
 
 static void wg_packet_create_data(struct sk_buff *first)
@@ -389,13 +398,15 @@ void wg_packet_send_staged_packets(struct wg_peer *peer)
 	 * handshake.
 	 */
 	skb_queue_walk(&packets, skb) {
+		u64 counter = atomic64_inc_return(&key->counter.counter) - 1;
+
 		/* 0 for no outer TOS: no leak. TODO: at some later point, we
 		 * might consider using flowi->tos as outer instead.
 		 */
 		PACKET_CB(skb)->ds = ip_tunnel_ecn_encap(0, ip_hdr(skb), skb);
-		PACKET_CB(skb)->nonce =
-				atomic64_inc_return(&key->counter.counter) - 1;
-		if (unlikely(PACKET_CB(skb)->nonce >= REJECT_AFTER_MESSAGES))
+		PACKET_CB(skb)->ivpad = 0;
+		PACKET_CB(skb)->nonce = cpu_to_le64(counter);
+		if (unlikely(counter >= REJECT_AFTER_MESSAGES))
 			goto out_invalid;
 	}
 
-- 
2.20.1

