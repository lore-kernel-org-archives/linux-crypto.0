Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41A8C3F6B0
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 20:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239881AbiGZUQX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 16:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239853AbiGZUQV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 16:16:21 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8F832B81
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 13:16:12 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v13so13833754wru.12
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 13:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=pdEmRQDkktxyj133IoEXqOneVb48tak5Ed7jC2tmPss=;
        b=NoSqp+M8tdLz1sYdFPgF7sEQXLSNybM3qMMiMI+8XdUdNnT/1ziUDTfJOPtzM2pf7B
         60eDbGh5QPE2+3VRM5/liw90GlJa4dRAWD35fnQU46tW6uTxxrgvQzAkvdyK7YDJ2BLL
         S3yc9XpH15mLCEnOqP5tHgO4eztj0vRCO/Lc/AY/QTEDwvOWN66UwOj7wv9/l0cdHWwH
         Z1elrL0lZEiHkoxXg3msEDCkqQxfTT0XD+8ar1CJzEgclE0dYP0wH9K0jeeflUXT27Ct
         S51HGosABXnq1obGhEZfcrAIwK2QXaf24/I71b2B99nO+tCN3RNfD/A+47RYIDlq+xYO
         I1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=pdEmRQDkktxyj133IoEXqOneVb48tak5Ed7jC2tmPss=;
        b=VcPFGyfxKhsAcRNiAsY8Zom+KBdzinbrXYvY7ngB3EcPtzcKdupAD2KACYwZTvTQ3B
         +IKGAK6lM/XmPkDkQymlAMZCKCpm1urE8ziuvCPDJ16D4IoSFS2tp1lB3VEawru8PeeC
         wlB0WGqW+Jsb8Noo/6BLOHPva8kvos9KEAVkf8TDAJqkAHP/QPMxkXpP0LcsmKIO12Ih
         yVKHwAqTfUsL+0Pi9B+EH7agjDbr06cVQfPofdUmqVLJL46b6+MK9z5IlqMUOD/XAU+h
         YiGDgdPL3caUyh0mEYQRczjF36RqKqPUN3hLkZKixqZNrO4eVeFr/UzrQaB99Aib1hwL
         5/7A==
X-Gm-Message-State: AJIora821JFQ1Bc8n6RnS7f1s4TFKGX4nNmWaTqd2ledujR9JO/CpPgF
        MrsM9dggDV9tFT98+OIomLVTcw==
X-Google-Smtp-Source: AGRyM1uQRBcHLiZ1Y9LPpdW7z50O+MQLPM9/unZYKIWc040bRCMVRnpd/+MrBgLnu3o3KKE4D15qKg==
X-Received: by 2002:a5d:5581:0:b0:20f:fc51:7754 with SMTP id i1-20020a5d5581000000b0020ffc517754mr12412279wrv.413.1658866571059;
        Tue, 26 Jul 2022 13:16:11 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c3b0600b003a320e6f011sm28073wms.1.2022.07.26.13.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 13:16:10 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 3/6] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Tue, 26 Jul 2022 21:15:57 +0100
Message-Id: <20220726201600.1715505-4-dima@arista.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220726201600.1715505-1-dima@arista.com>
References: <20220726201600.1715505-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a helper to allocate tcp_md5sig_info, that will help later to
do/allocate things when info allocated, once per socket.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_ipv4.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 0c83780dc9bf..55e4092209a5 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1152,6 +1152,24 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 }
 EXPORT_SYMBOL(tcp_v4_md5_lookup);
 
+static int tcp_md5sig_info_add(struct sock *sk, gfp_t gfp)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_md5sig_info *md5sig;
+
+	if (rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk)))
+		return 0;
+
+	md5sig = kmalloc(sizeof(*md5sig), gfp);
+	if (!md5sig)
+		return -ENOMEM;
+
+	sk_gso_disable(sk);
+	INIT_HLIST_HEAD(&md5sig->head);
+	rcu_assign_pointer(tp->md5sig_info, md5sig);
+	return 0;
+}
+
 /* This can be called on a newly created socket, from other files */
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags,
@@ -1182,17 +1200,11 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		return 0;
 	}
 
+	if (tcp_md5sig_info_add(sk, gfp))
+		return -ENOMEM;
+
 	md5sig = rcu_dereference_protected(tp->md5sig_info,
 					   lockdep_sock_is_held(sk));
-	if (!md5sig) {
-		md5sig = kmalloc(sizeof(*md5sig), gfp);
-		if (!md5sig)
-			return -ENOMEM;
-
-		sk_gso_disable(sk);
-		INIT_HLIST_HEAD(&md5sig->head);
-		rcu_assign_pointer(tp->md5sig_info, md5sig);
-	}
 
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
-- 
2.36.1

