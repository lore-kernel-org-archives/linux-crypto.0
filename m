Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98ECEC6FA86
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 20:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiIWUP3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiIWUOf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 16:14:35 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302361323D6
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 13:13:57 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id bq9so1582288wrb.4
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 13:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=OHrxc4bntFSki8zhPti06M9c4+4m2HqWxgJPtl7/Gak=;
        b=iJAkQWjKj8ssxVPR0vbysYxxORn3zWtcfjdnpECk1Hlr2vw8Jn9Kj8bdCNuGzGtJsW
         tuItNJPq96awhVV9DzYJcl+ALOJr5XBwvKM6aPVRkC6JGXUPSi9ouOzfdWmQL5jeDiRI
         UHFDLb17ea0K3+VijtCtP8j6kmdLNs51n2lgIjYu5vYNECVhgEU1hES8xjUebPB70ed4
         +vIZRMAnNG4GqxPb9cNaC+R80d29Iy/qRhF5gPaSslWQiaguGLUqweHjgCp0CgV5PH/I
         OOf58ouAQQ5Lmva75X4cEml4hzsp+Yo67/ROi6rEhvEvKcQfBs2Oze+kDh+G9HgxWBr3
         42Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=OHrxc4bntFSki8zhPti06M9c4+4m2HqWxgJPtl7/Gak=;
        b=H2wSZQ03RCl1dnxJ8pajkArdyoVq/EbfRZMsWI13swCGaqnk0T+pWEoRLBL32ftRld
         e5As+a5GzXO33vvZ3WZxmXocbxdVw7jgbyG9Srglc4/sr7A7MHYVFOXFuk+XAeIErnqV
         T8PvpmWE6MsH/aMWNcNBmVcih905aA8ombz+tuEMMglVgUJT9iZIv/nP098UnDsC2KVz
         U/S/X/4n7Vhly17cTxxgRl+ybjH9Fk7FPsf9MjJumFPnKDj5ou8ZW0iqfMRr5r/ksZmr
         Tb1QjOKwBNSvZBvRIBhGO44qhAv8XUAAsaeQYk+M5T/CqvaIH83v9uFExdyNOWD3woyB
         5UuQ==
X-Gm-Message-State: ACrzQf0x2z6cBtPj67p203buSfGzejStZw4X/SpAktqnpef2S7TYI92/
        Mt3+ymmgOagNWKcD21oVyYF/nQ==
X-Google-Smtp-Source: AMsMyM41PZJl42CI3cwhCkU77nhS6xwJrP0bdXfTupyfMZ0zSInEBUQkXr66MmArZrhpc7jkxZYT2Q==
X-Received: by 2002:a5d:654d:0:b0:22a:ff55:e9c9 with SMTP id z13-20020a5d654d000000b0022aff55e9c9mr6069389wrv.14.1663964036516;
        Fri, 23 Sep 2022 13:13:56 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:56 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 19/35] net/tcp: Add TCP-AO SNE support
Date:   Fri, 23 Sep 2022 21:13:03 +0100
Message-Id: <20220923201319.493208-20-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add Sequence Number Extension (SNE) extension for TCP-AO.
This is needed to protect long-living TCP-AO connections from replaying
attacks after sequence number roll-over, see RFC5925 (6.2).

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_input.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 59d4e7b246a9..9727fef9f869 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3527,9 +3527,21 @@ static inline bool tcp_may_update_window(const struct tcp_sock *tp,
 static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 {
 	u32 delta = ack - tp->snd_una;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao;
+#endif
 
 	sock_owned_by_me((struct sock *)tp);
 	tp->bytes_acked += delta;
+#ifdef CONFIG_TCP_AO
+	ao = rcu_dereference_protected(tp->ao_info,
+				       lockdep_sock_is_held((struct sock *)tp));
+	if (ao) {
+		if (ack < ao->snd_sne_seq)
+			ao->snd_sne++;
+		ao->snd_sne_seq = ack;
+	}
+#endif
 	tp->snd_una = ack;
 }
 
@@ -3537,9 +3549,21 @@ static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
 static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
 {
 	u32 delta = seq - tp->rcv_nxt;
+#ifdef CONFIG_TCP_AO
+	struct tcp_ao_info *ao;
+#endif
 
 	sock_owned_by_me((struct sock *)tp);
 	tp->bytes_received += delta;
+#ifdef CONFIG_TCP_AO
+	ao = rcu_dereference_protected(tp->ao_info,
+				       lockdep_sock_is_held((struct sock *)tp));
+	if (ao) {
+		if (seq < ao->rcv_sne_seq)
+			ao->rcv_sne++;
+		ao->rcv_sne_seq = seq;
+	}
+#endif
 	WRITE_ONCE(tp->rcv_nxt, seq);
 }
 
@@ -6356,6 +6380,17 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		 * simultaneous connect with crossed SYNs.
 		 * Particularly, it can be connect to self.
 		 */
+#ifdef CONFIG_TCP_AO
+		struct tcp_ao_info *ao;
+
+		ao = rcu_dereference_protected(tp->ao_info,
+					       lockdep_sock_is_held(sk));
+		if (ao) {
+			ao->risn = th->seq;
+			ao->rcv_sne = 0;
+			ao->rcv_sne_seq = ntohl(th->seq);
+		}
+#endif
 		tcp_set_state(sk, TCP_SYN_RECV);
 
 		if (tp->rx_opt.saw_tstamp) {
-- 
2.37.2

