Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D83C31E49
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 06:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C88BB20679
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 06:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uEobiQ01"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730979AbfFSGza (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 02:55:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34469 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfFSGz3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 02:55:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id k11so2074183wrl.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 23:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nhxfbMfaIoj5v1OpoNNqZ4rGVQ+ZNbSxJ/1xXcmdFR4=;
        b=uEobiQ01syIF0hYqrwzhxTyoiBObeOEog7egkdr9S/ipYT3Xe/iMdNVnB1z8xZqK1s
         4TKzafJB9mmB1M06lYTR2CYY4xg3LS5uyomq+nGhyNTLnp11yU3v59gxb39dY9IZPaeU
         cN4djZT2dRIBeA84lgsTYhdvYdRDq4G6w+Fp8oqM+bghe2Jetxn/BqCWU+tz/q6f8Ari
         r4ZHP3q+2/tFhsWI+eDdtqZk38j5v59XvscntyCwS7Vs4QcbDopGTmQsE7jwxIX9HPJr
         IAG3mLTjTMegT1vKlJ5QdiyU6yx36h/DSNj48MzJatHofEYluTJlNkkHvVBpdA6SJEXA
         biEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nhxfbMfaIoj5v1OpoNNqZ4rGVQ+ZNbSxJ/1xXcmdFR4=;
        b=sWNDAbG1N+d3eGpb85WaTqUdfAS7bjOB38bAPPX582V4DlfLKx5xnWeVNrMD4Ke+S3
         QvbIq0bRVxqRXDpnq8Y4WPMg0sq9Z8RYHrIyZ6n+ZdAsTPR++Wd2AvCKiLrztIW6v0t4
         d+hNuT5S5RaHxolomqgu+how2PficYA2LG3KutPzkpp5IoU5PvHUj+Fj4rOc4lp64Zu2
         fNfubEIAS/3GrqpXhmkdz/ZULf+UZfZi2rj7nkHN/tiz6STXC+3ajkgV5o8EfrmRoHJt
         GhjzFob5i9ScVE+qYQ2UbUoAm+PvJRTsY6MmZjoyOujM16MADww19C0svcnTEDi+sw8g
         iapQ==
X-Gm-Message-State: APjAAAVtImXKsUnqxjbbLbYERaaP5JUJKSuNFszWdRI/zn/WSOjUp7u4
        AmtPoscs+LvA9DCS+TymYF6dIw==
X-Google-Smtp-Source: APXvYqwVMgM7Z2MQJnsBqkrFTi2Ao1gekA35ct2D6ETzrJmKQK3zeS/ciULBpZE2WMwya99r1hTCgg==
X-Received: by 2002:adf:f442:: with SMTP id f2mr17952391wrp.275.1560927326868;
        Tue, 18 Jun 2019 23:55:26 -0700 (PDT)
Received: from e111045-lin.arm.com (lfbn-nic-1-216-10.w2-15.abo.wanadoo.fr. [2.15.62.10])
        by smtp.gmail.com with ESMTPSA id a2sm583462wmj.9.2019.06.18.23.55.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 23:55:26 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jbaron@akamai.com, cpaasch@apple.com,
        David.Laight@aculab.com, ycheng@google.com
Subject: [PATCH net-next v2 1/1] net: fastopen: robustness and endianness fixes for SipHash
Date:   Wed, 19 Jun 2019 08:55:10 +0200
Message-Id: <20190619065510.23514-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190619065510.23514-1-ard.biesheuvel@linaro.org>
References: <20190619065510.23514-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some changes to the TCP fastopen code to make it more robust
against future changes in the choice of key/cookie size, etc.

- Instead of keeping the SipHash key in an untyped u8[] buffer
  and casting it to the right type upon use, use the correct
  type directly. This ensures that the key will appear at the
  correct alignment if we ever change the way these data
  structures are allocated. (Currently, they are only allocated
  via kmalloc so they always appear at the correct alignment)

- Use DIV_ROUND_UP when sizing the u64[] array to hold the
  cookie, so it is always of sufficient size, even if
  TCP_FASTOPEN_COOKIE_MAX is no longer a multiple of 8.

- Drop the 'len' parameter from the tcp_fastopen_reset_cipher()
  function, which is no longer used.

- Add endian swabbing when setting the keys and calculating the hash,
  to ensure that cookie values are the same for a given key and
  source/destination address pair regardless of the endianness of
  the server.

Note that none of these are functional changes wrt the current
state of the code, with the exception of the swabbing, which only
affects big endian systems.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/tcp.h        |  2 +-
 include/net/tcp.h          |  8 ++--
 net/ipv4/sysctl_net_ipv4.c |  3 +-
 net/ipv4/tcp.c             |  3 +-
 net/ipv4/tcp_fastopen.c    | 39 +++++++++++---------
 5 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 2689b0b0b68a..f3a85a7fb4b1 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -58,7 +58,7 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
 
 /* TCP Fast Open Cookie as stored in memory */
 struct tcp_fastopen_cookie {
-	u64	val[TCP_FASTOPEN_COOKIE_MAX / sizeof(u64)];
+	__le64	val[DIV_ROUND_UP(TCP_FASTOPEN_COOKIE_MAX, sizeof(u64))];
 	s8	len;
 	bool	exp;	/* In RFC6994 experimental option format */
 };
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 573c9e9b0d72..9d36cc88d043 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/siphash.h>
 
 extern struct inet_hashinfo tcp_hashinfo;
 
@@ -1612,8 +1613,7 @@ void tcp_free_fastopen_req(struct tcp_sock *tp);
 void tcp_fastopen_destroy_cipher(struct sock *sk);
 void tcp_fastopen_ctx_destroy(struct net *net);
 int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
-			      void *primary_key, void *backup_key,
-			      unsigned int len);
+			      void *primary_key, void *backup_key);
 void tcp_fastopen_add_skb(struct sock *sk, struct sk_buff *skb);
 struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 			      struct request_sock *req,
@@ -1623,14 +1623,14 @@ void tcp_fastopen_init_key_once(struct net *net);
 bool tcp_fastopen_cookie_check(struct sock *sk, u16 *mss,
 			     struct tcp_fastopen_cookie *cookie);
 bool tcp_fastopen_defer_connect(struct sock *sk, int *err);
-#define TCP_FASTOPEN_KEY_LENGTH 16
+#define TCP_FASTOPEN_KEY_LENGTH sizeof(siphash_key_t)
 #define TCP_FASTOPEN_KEY_MAX 2
 #define TCP_FASTOPEN_KEY_BUF_LENGTH \
 	(TCP_FASTOPEN_KEY_LENGTH * TCP_FASTOPEN_KEY_MAX)
 
 /* Fastopen key context */
 struct tcp_fastopen_context {
-	__u8		key[TCP_FASTOPEN_KEY_MAX][TCP_FASTOPEN_KEY_LENGTH];
+	siphash_key_t	key[TCP_FASTOPEN_KEY_MAX];
 	int		num;
 	struct rcu_head	rcu;
 };
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 7d802acde040..7d66306b5f39 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -365,8 +365,7 @@ static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
 			}
 		}
 		tcp_fastopen_reset_cipher(net, NULL, key,
-					  backup_data ? key + 4 : NULL,
-					  TCP_FASTOPEN_KEY_LENGTH);
+					  backup_data ? key + 4 : NULL);
 	}
 
 bad_key:
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index efd7f2b1d1f0..47c217905864 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2822,8 +2822,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		if (optlen == TCP_FASTOPEN_KEY_BUF_LENGTH)
 			backup_key = key + TCP_FASTOPEN_KEY_LENGTH;
 
-		return tcp_fastopen_reset_cipher(net, sk, key, backup_key,
-						 TCP_FASTOPEN_KEY_LENGTH);
+		return tcp_fastopen_reset_cipher(net, sk, key, backup_key);
 	}
 	default:
 		/* fallthru */
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 46b67128e1ca..2f5e7b62ffe4 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -7,7 +7,6 @@
 #include <linux/tcp.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
-#include <linux/siphash.h>
 #include <net/inetpeer.h>
 #include <net/tcp.h>
 
@@ -31,7 +30,7 @@ void tcp_fastopen_init_key_once(struct net *net)
 	 * for a valid cookie, so this is an acceptable risk.
 	 */
 	get_random_bytes(key, sizeof(key));
-	tcp_fastopen_reset_cipher(net, NULL, key, NULL, sizeof(key));
+	tcp_fastopen_reset_cipher(net, NULL, key, NULL);
 }
 
 static void tcp_fastopen_ctx_free(struct rcu_head *head)
@@ -68,8 +67,7 @@ void tcp_fastopen_ctx_destroy(struct net *net)
 }
 
 int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
-			      void *primary_key, void *backup_key,
-			      unsigned int len)
+			      void *primary_key, void *backup_key)
 {
 	struct tcp_fastopen_context *ctx, *octx;
 	struct fastopen_queue *q;
@@ -81,9 +79,15 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 		goto out;
 	}
 
-	memcpy(ctx->key[0], primary_key, len);
+	ctx->key[0] = (siphash_key_t){
+		get_unaligned_le64(primary_key),
+		get_unaligned_le64(primary_key + 8)
+	};
 	if (backup_key) {
-		memcpy(ctx->key[1], backup_key, len);
+		ctx->key[1] = (siphash_key_t){
+			get_unaligned_le64(backup_key),
+			get_unaligned_le64(backup_key + 8)
+		};
 		ctx->num = 2;
 	} else {
 		ctx->num = 1;
@@ -110,19 +114,18 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 
 static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 					     struct sk_buff *syn,
-					     const u8 *key,
+					     const siphash_key_t *key,
 					     struct tcp_fastopen_cookie *foc)
 {
-	BUILD_BUG_ON(TCP_FASTOPEN_KEY_LENGTH != sizeof(siphash_key_t));
 	BUILD_BUG_ON(TCP_FASTOPEN_COOKIE_SIZE != sizeof(u64));
 
 	if (req->rsk_ops->family == AF_INET) {
 		const struct iphdr *iph = ip_hdr(syn);
 
-		foc->val[0] = siphash(&iph->saddr,
-				      sizeof(iph->saddr) +
-				      sizeof(iph->daddr),
-				      (const siphash_key_t *)key);
+		foc->val[0] = cpu_to_le64(siphash(&iph->saddr,
+					  sizeof(iph->saddr) +
+					  sizeof(iph->daddr),
+					  key));
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		return true;
 	}
@@ -130,10 +133,10 @@ static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 	if (req->rsk_ops->family == AF_INET6) {
 		const struct ipv6hdr *ip6h = ipv6_hdr(syn);
 
-		foc->val[0] = siphash(&ip6h->saddr,
-				      sizeof(ip6h->saddr) +
-				      sizeof(ip6h->daddr),
-				      (const siphash_key_t *)key);
+		foc->val[0] = cpu_to_le64(siphash(&ip6h->saddr,
+					  sizeof(ip6h->saddr) +
+					  sizeof(ip6h->daddr),
+					  key));
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		return true;
 	}
@@ -154,7 +157,7 @@ static void tcp_fastopen_cookie_gen(struct sock *sk,
 	rcu_read_lock();
 	ctx = tcp_fastopen_get_ctx(sk);
 	if (ctx)
-		__tcp_fastopen_cookie_gen_cipher(req, syn, ctx->key[0], foc);
+		__tcp_fastopen_cookie_gen_cipher(req, syn, &ctx->key[0], foc);
 	rcu_read_unlock();
 }
 
@@ -218,7 +221,7 @@ static int tcp_fastopen_cookie_gen_check(struct sock *sk,
 	if (!ctx)
 		goto out;
 	for (i = 0; i < tcp_fastopen_context_len(ctx); i++) {
-		__tcp_fastopen_cookie_gen_cipher(req, syn, ctx->key[i], foc);
+		__tcp_fastopen_cookie_gen_cipher(req, syn, &ctx->key[i], foc);
 		if (tcp_fastopen_cookie_match(foc, orig)) {
 			ret = i + 1;
 			goto out;
-- 
2.17.1

