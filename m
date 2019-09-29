Return-Path: <SRS0=xDoY=XY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FEBC4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 982A121D7B
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x4ZcydWY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbfI2Rjy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:39:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40337 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730510AbfI2Rjx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Sep 2019 13:39:53 -0400
Received: by mail-wr1-f68.google.com with SMTP id l3so8430966wru.7
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2019 10:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SLF/nrrv8lSTZbt9Ku9vqPHHl4LDfRMHhQaxtVyBCHI=;
        b=x4ZcydWYB3tHAFOZtwnIIM2Qt3b1XqHyOXefAheahMcIaBY8ZSbFAVyugI5TiFi6NI
         d4XXcEVei8W+aSFKNbrUhDZV3eLOmKwfbCHV/nY4VairfUSErDBExRwZi09npacDar53
         FvT+QX08irIr5Og0AhBGn6WV4MzyRWYOqbPvDPa+HSRiuazkuJvLMe4loaykV5znhNmT
         udceqcnXzcWhLDMDykQUgjsmAyRK3+W3AwDM5qBObgUhltvMGO+NTCDIVDM8vm564CDi
         0xTqALX5nvruhXcs1xTmlj/b45bU8AmIoOlXOh3vu69Kn2SEVwUDbfbAv8S4zAOR07IN
         cKew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SLF/nrrv8lSTZbt9Ku9vqPHHl4LDfRMHhQaxtVyBCHI=;
        b=aXTBUligN/mDWP6iQfJbf1ZRuDH8HkbxPbT0G5x+ruLum9gIC1PVYl2TpR6BOSZZUV
         WK3drIccRNiSKRNa/qXztZbjUP9MRZh2q+rp2k57wXZvtqEx4Lz9BRnnJnk81HRPpTVG
         Q/K/40jsu8/8OusHj7XQknik5tfSUcc7AEsI9FtAX8Ml6OQw1xBysFdlmrk2QK8+sOKy
         NRGrGWmkTOQ04nBPvqDBC0yXuvnY1o8uxBrB68a+UmPN1pZiRKLj1a4TnPJPYftoDP3g
         mWkU7bdD4royfIjCEM3RACP/htNIIiNW4kQYRoC1wMKavlcYuYG84K3t+9903WWX3MFu
         JqmQ==
X-Gm-Message-State: APjAAAVpIEmNWJGiUgOlNzGVOWACNbN3BOJawP+Iklsw3tXAwuNf/85m
        BFUS19tHQ9SXJpAwnbyPTH9enIt7A49FfKOq
X-Google-Smtp-Source: APXvYqyPHeSGpgev+1nI40iZ1cjsgkzJ5WKd00li/OskZGl0W3Evd5imyvMPAa563N0GNXVwpbDjbA==
X-Received: by 2002:adf:bb0a:: with SMTP id r10mr10849753wrg.13.1569778790867;
        Sun, 29 Sep 2019 10:39:50 -0700 (PDT)
Received: from e123331-lin.nice.arm.com (bar06-5-82-246-156-241.fbx.proxad.net. [82.246.156.241])
        by smtp.gmail.com with ESMTPSA id q192sm17339779wme.23.2019.09.29.10.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 10:39:50 -0700 (PDT)
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
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>
Subject: [RFC PATCH 20/20] wg switch to lib/crypto algos
Date:   Sun, 29 Sep 2019 19:38:50 +0200
Message-Id: <20190929173850.26055-21-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This switches WireGuard to use lib/crypto libraries instead of the
Zinc ones.

This patch is intended to be squashed at merge time, or it will break
bisection.
---
 drivers/net/Kconfig              |  6 +++---
 drivers/net/wireguard/cookie.c   |  4 ++--
 drivers/net/wireguard/messages.h |  6 +++---
 drivers/net/wireguard/receive.c  | 17 ++++-------------
 drivers/net/wireguard/send.c     | 19 ++++++-------------
 5 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index c26aef673538..3bd4dc662392 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -77,9 +77,9 @@ config WIREGUARD
 	depends on IPV6 || !IPV6
 	select NET_UDP_TUNNEL
 	select DST_CACHE
-	select ZINC_CHACHA20POLY1305
-	select ZINC_BLAKE2S
-	select ZINC_CURVE25519
+	select CRYPTO_LIB_CHACHA20POLY1305
+	select CRYPTO_LIB_BLAKE2S
+	select CRYPTO_LIB_CURVE25519
 	help
 	  WireGuard is a secure, fast, and easy to use replacement for IPSec
 	  that uses modern cryptography and clever networking tricks. It's
diff --git a/drivers/net/wireguard/cookie.c b/drivers/net/wireguard/cookie.c
index bd23a14ff87f..104b739c327f 100644
--- a/drivers/net/wireguard/cookie.c
+++ b/drivers/net/wireguard/cookie.c
@@ -10,8 +10,8 @@
 #include "ratelimiter.h"
 #include "timers.h"
 
-#include <zinc/blake2s.h>
-#include <zinc/chacha20poly1305.h>
+#include <crypto/blake2s.h>
+#include <crypto/chacha20poly1305.h>
 
 #include <net/ipv6.h>
 #include <crypto/algapi.h>
diff --git a/drivers/net/wireguard/messages.h b/drivers/net/wireguard/messages.h
index 3cfd1c5e9b02..4bbb1f97af04 100644
--- a/drivers/net/wireguard/messages.h
+++ b/drivers/net/wireguard/messages.h
@@ -6,9 +6,9 @@
 #ifndef _WG_MESSAGES_H
 #define _WG_MESSAGES_H
 
-#include <zinc/curve25519.h>
-#include <zinc/chacha20poly1305.h>
-#include <zinc/blake2s.h>
+#include <crypto/blake2s.h>
+#include <crypto/chacha20poly1305.h>
+#include <crypto/curve25519.h>
 
 #include <linux/kernel.h>
 #include <linux/param.h>
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 900c76edb9d6..ae7ffba5fc48 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -11,7 +11,6 @@
 #include "cookie.h"
 #include "socket.h"
 
-#include <linux/simd.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/udp.h>
@@ -244,8 +243,7 @@ static void keep_key_fresh(struct wg_peer *peer)
 	}
 }
 
-static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key,
-			   simd_context_t *simd_context)
+static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key)
 {
 	struct scatterlist sg[MAX_SKB_FRAGS + 8];
 	struct sk_buff *trailer;
@@ -281,9 +279,8 @@ static bool decrypt_packet(struct sk_buff *skb, struct noise_symmetric_key *key,
 	if (skb_to_sgvec(skb, sg, 0, skb->len) <= 0)
 		return false;
 
-	if (!chacha20poly1305_decrypt_sg(sg, sg, skb->len, NULL, 0,
-					 PACKET_CB(skb)->nonce, key->key,
-					 simd_context))
+	if (!chacha20poly1305_decrypt_sg_inplace(sg, skb->len, NULL, 0,
+					 PACKET_CB(skb)->nonce, key->key))
 		return false;
 
 	/* Another ugly situation of pushing and pulling the header so as to
@@ -510,21 +507,15 @@ void wg_packet_decrypt_worker(struct work_struct *work)
 {
 	struct crypt_queue *queue = container_of(work, struct multicore_worker,
 						 work)->ptr;
-	simd_context_t simd_context;
 	struct sk_buff *skb;
 
-	simd_get(&simd_context);
 	while ((skb = ptr_ring_consume_bh(&queue->ring)) != NULL) {
 		enum packet_state state = likely(decrypt_packet(skb,
-					   &PACKET_CB(skb)->keypair->receiving,
-					   &simd_context)) ?
+					   &PACKET_CB(skb)->keypair->receiving)) ?
 				PACKET_STATE_CRYPTED : PACKET_STATE_DEAD;
 		wg_queue_enqueue_per_peer_napi(&PACKET_PEER(skb)->rx_queue, skb,
 					       state);
-		simd_relax(&simd_context);
 	}
-
-	simd_put(&simd_context);
 }
 
 static void wg_packet_consume_data(struct wg_device *wg, struct sk_buff *skb)
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index b0df5c717502..37bd2599ae44 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -11,7 +11,6 @@
 #include "messages.h"
 #include "cookie.h"
 
-#include <linux/simd.h>
 #include <linux/uio.h>
 #include <linux/inetdevice.h>
 #include <linux/socket.h>
@@ -157,8 +156,7 @@ static unsigned int calculate_skb_padding(struct sk_buff *skb)
 	return padded_size - last_unit;
 }
 
-static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair,
-			   simd_context_t *simd_context)
+static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 {
 	unsigned int padding_len, plaintext_len, trailer_len;
 	struct scatterlist sg[MAX_SKB_FRAGS + 8];
@@ -207,9 +205,10 @@ static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair,
 	if (skb_to_sgvec(skb, sg, sizeof(struct message_data),
 			 noise_encrypted_len(plaintext_len)) <= 0)
 		return false;
-	return chacha20poly1305_encrypt_sg(sg, sg, plaintext_len, NULL, 0,
-					   PACKET_CB(skb)->nonce,
-					   keypair->sending.key, simd_context);
+	chacha20poly1305_encrypt_sg_inplace(sg, plaintext_len, NULL, 0,
+					    PACKET_CB(skb)->nonce,
+					    keypair->sending.key);
+	return true;
 }
 
 void wg_packet_send_keepalive(struct wg_peer *peer)
@@ -296,16 +295,13 @@ void wg_packet_encrypt_worker(struct work_struct *work)
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
@@ -314,10 +310,7 @@ void wg_packet_encrypt_worker(struct work_struct *work)
 		}
 		wg_queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first,
 					  state);
-
-		simd_relax(&simd_context);
 	}
-	simd_put(&simd_context);
 }
 
 static void wg_packet_create_data(struct sk_buff *first)
-- 
2.17.1

