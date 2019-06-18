Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9279BC31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F4AD206B7
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:32:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zJgR9uTj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfFRJcY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:32:24 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54222 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729240AbfFRJcX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 05:32:23 -0400
Received: by mail-wm1-f68.google.com with SMTP id x15so2414403wmj.3
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 02:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IaO+vTQTsPY/H5xLgTKKrikmgngyQyXz4XyxFknbzCQ=;
        b=zJgR9uTjMclxdUR8+UVLk0Qt9Gv8MRzXiDD8R8vEl0Zhpr7fPsWkoQUHfk7TkLnjnA
         czHVo7gpnAW4Qz5SXtBdYk9yTjTwBlEmqJTPpBHvBokYHVBjov49C+9t0J1P7PPYYqZD
         tHv4L0yiVJ4ijt185nQsld78oChxLOzIlgmRWCX3Xu2rsXhodSH8B2cFNKRnQGhmu+3T
         m1D8MdiKBZO5GlLd0Mpct6j2VNDlx0vY5z4p+kaf4ekdzyr1gpogNkiNnIn1pM81ElpK
         LvGBhOPx68vfEdnSzCEmDtEOOdAqbROXalZVZrL5a29yx52J6CZAWaw3rz7hRUPfRwGW
         q9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IaO+vTQTsPY/H5xLgTKKrikmgngyQyXz4XyxFknbzCQ=;
        b=G+V56kwi144us0GUa0pLbfaQih6s6A/lPrAo0kHvUjB8tGcXPSQgPKDyUzlpvHklfx
         ZcGuaPQG8SyIFp3iQGW5aD22PAocFaHPQsKe+qsMLDdO4XFwqFBe31+xjUGx63CPaC1c
         SD/DvSZOvrFeIL3DA2Kbm+ic/iDkwQEL0SfjD6rtidXrczv+pPBeLECUjJ7+DhStO80y
         pjl6+y1HkWCr6HE28BvzbYIedM5x/OnSznzQnl/Az1Jb6pjXLjbPoFS2+a+PBgWe76NC
         YCYoerP+pTIWP5oalDUGewXUW9Xo6Xl0yq6jk0Okoi+klRqMQFH26yJdzxKuHiVRMpto
         M1kw==
X-Gm-Message-State: APjAAAUMeFydNgZ+BAhkifT0t/hmvJs+M1md8lk4UZoEMEQ8+lji4mxY
        gCCbX+VYXXrUHZn1LdgYMOc9AQ==
X-Google-Smtp-Source: APXvYqzXWyH26znJ7dSVe9yLYbYo2f2FvrKXbSuLtXEL/ZMWGHFrWtr3xnhfZNSbW9JLRJ4X1cneXg==
X-Received: by 2002:a05:600c:118a:: with SMTP id i10mr2581657wmf.162.1560850341034;
        Tue, 18 Jun 2019 02:32:21 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:c97b:2293:609c:ae03])
        by smtp.gmail.com with ESMTPSA id y1sm1517104wma.32.2019.06.18.02.32.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 02:32:20 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     netdev@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jbaron@akamai.com, cpaasch@apple.com,
        David.Laight@aculab.com, ycheng@google.com
Subject: [PATCH 1/2] net: fastopen: make key handling more robust against future changes
Date:   Tue, 18 Jun 2019 11:32:06 +0200
Message-Id: <20190618093207.13436-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some changes to the TCP fastopen code to make it more robust
against future changes in the choice of key/cookie size, etc.

- Instead of keeping the SipHash key in an untyped u8[] buffer
  and casting it to the right type upon use, use the correct
  siphash_key_t type directly. This ensures that the key will
  appear at the correct alignment if we ever change the way
  these data structures are allocated. (Currently, they are
  only allocated via kmalloc so they always appear at the
  correct alignment)

- Use DIV_ROUND_UP when sizing the u64[] array to hold the
  cookie, so it is always of sufficient size, even when
  TCP_FASTOPEN_COOKIE_MAX is no longer a multiple of 8.

- Add a key length check to tcp_fastopen_reset_cipher(). No
  callers exist currently that fail this check (they all pass
  compile constant values that equal TCP_FASTOPEN_KEY_LENGTH),
  but future changes might create problems, e.g., by leaving part
  of the key uninitialized, or overflowing the key buffers.

Note that none of these are functional changes wrt the current
state of the code.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/tcp.h     |  2 +-
 include/net/tcp.h       |  5 +++--
 net/ipv4/tcp_fastopen.c | 22 ++++++++++++--------
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 2689b0b0b68a..3d3659c638a6 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -58,7 +58,7 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
 
 /* TCP Fast Open Cookie as stored in memory */
 struct tcp_fastopen_cookie {
-	u64	val[TCP_FASTOPEN_COOKIE_MAX / sizeof(u64)];
+	u64	val[DIV_ROUND_UP(TCP_FASTOPEN_COOKIE_MAX, sizeof(u64))];
 	s8	len;
 	bool	exp;	/* In RFC6994 experimental option format */
 };
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 573c9e9b0d72..9456b0834e21 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
 #include <linux/bpf-cgroup.h>
+#include <linux/siphash.h>
 
 extern struct inet_hashinfo tcp_hashinfo;
 
@@ -1623,14 +1624,14 @@ void tcp_fastopen_init_key_once(struct net *net);
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
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 46b67128e1ca..61c15c3d3584 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -7,7 +7,6 @@
 #include <linux/tcp.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
-#include <linux/siphash.h>
 #include <net/inetpeer.h>
 #include <net/tcp.h>
 
@@ -81,9 +80,15 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 		goto out;
 	}
 
-	memcpy(ctx->key[0], primary_key, len);
+	if (unlikely(len != TCP_FASTOPEN_KEY_LENGTH)) {
+		pr_err("TCP: TFO key length %u invalid\n", len);
+		err = -EINVAL;
+		goto out;
+	}
+
+	memcpy(&ctx->key[0], primary_key, len);
 	if (backup_key) {
-		memcpy(ctx->key[1], backup_key, len);
+		memcpy(&ctx->key[1], backup_key, len);
 		ctx->num = 2;
 	} else {
 		ctx->num = 1;
@@ -110,10 +115,9 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 
 static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 					     struct sk_buff *syn,
-					     const u8 *key,
+					     const siphash_key_t *key,
 					     struct tcp_fastopen_cookie *foc)
 {
-	BUILD_BUG_ON(TCP_FASTOPEN_KEY_LENGTH != sizeof(siphash_key_t));
 	BUILD_BUG_ON(TCP_FASTOPEN_COOKIE_SIZE != sizeof(u64));
 
 	if (req->rsk_ops->family == AF_INET) {
@@ -122,7 +126,7 @@ static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 		foc->val[0] = siphash(&iph->saddr,
 				      sizeof(iph->saddr) +
 				      sizeof(iph->daddr),
-				      (const siphash_key_t *)key);
+				      key);
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		return true;
 	}
@@ -133,7 +137,7 @@ static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 		foc->val[0] = siphash(&ip6h->saddr,
 				      sizeof(ip6h->saddr) +
 				      sizeof(ip6h->daddr),
-				      (const siphash_key_t *)key);
+				      key);
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
 		return true;
 	}
@@ -154,7 +158,7 @@ static void tcp_fastopen_cookie_gen(struct sock *sk,
 	rcu_read_lock();
 	ctx = tcp_fastopen_get_ctx(sk);
 	if (ctx)
-		__tcp_fastopen_cookie_gen_cipher(req, syn, ctx->key[0], foc);
+		__tcp_fastopen_cookie_gen_cipher(req, syn, &ctx->key[0], foc);
 	rcu_read_unlock();
 }
 
@@ -218,7 +222,7 @@ static int tcp_fastopen_cookie_gen_check(struct sock *sk,
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

