Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D907FA3743
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Oct 2022 20:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbiJ0Usp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237082AbiJ0Ur1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Oct 2022 16:47:27 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C269895E7E
        for <linux-crypto@vger.kernel.org>; Thu, 27 Oct 2022 13:44:25 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id i5-20020a1c3b05000000b003cf47dcd316so5037168wma.4
        for <linux-crypto@vger.kernel.org>; Thu, 27 Oct 2022 13:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVCplO2RHnjfrC7RtgmpM1L5+zWhF42z97+0t0sfJN8=;
        b=QL6SzRszsclV++kFI3bieAAVbkGgC2T/1v4taDU6gePMi0RQi/NEtAR7EBP0VuvzFX
         laiQ8UKgVGa/jhuL3yrkzunNKcqpMhg8x/w0tkOX+GBCqM1CNsKtTAiCh8eWYouRGsey
         VbwOC8LiruovXfGGw3u2DgxDXh58qAGHskwp37i5DYqtfJIZw4LkIxDIObyYjECbuBbY
         xlAaWqi+XSynChBBRleFOE65Dqg8qUX/9rKMzmrNmRHYTU4jjI0gSUtrs1oTjV2Oxptm
         PCuBbVnACirSe1tRG7OpgftGKmSD/FNqrw3C/R3YUloHoRQjm6v3Kfcvf2HbAazSXzW6
         SuUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LVCplO2RHnjfrC7RtgmpM1L5+zWhF42z97+0t0sfJN8=;
        b=2A7Ch0rkXO9a3tlSUvN4LCXRLvD6Fou8mQ4Ppw4+1Y3105D5vvaNWUM5Vyltkcieay
         hBbqF7SgngXgNOK9MY/8tN6YKuoMd3Ef1K0+yVA/yHZtfv8PEzu4YBPFKKhg8KKrLcWk
         edGhQCttvq8ohxHQY049oMtIhYa2098J5YbSLJMQFVqYYUq1L34RHnSZnJfyTa5dBB5q
         rnbiIlysgto4g0mHmNx6Jj8z7/mlH/3UxjNEB7XrAR1G6ipy5tUax5XHerTrvB9Q+W7k
         eVNylAUWxqmLZvCwcShebymV+cpOjNDKWCxS1t4lh1C+aMZhpP7RdeBvkVm86U7Ucaeh
         4JTA==
X-Gm-Message-State: ACrzQf1sZG5tW43PMj7k9TZ0ToBRQYoP7w71bP2hEpiQo+K/225wRJZh
        jdT9sGfsISRdCrgiR/tgMq1xaQ==
X-Google-Smtp-Source: AMsMyM5Bkna4YGn0LvtL0EQZ6lzgKMDWqAV1GMSG6lQWuxQ0sfo5KsmMWIlF3iwOR1XtxMvZwI6ZXg==
X-Received: by 2002:a05:600c:3592:b0:3c6:f9db:a954 with SMTP id p18-20020a05600c359200b003c6f9dba954mr7176562wmq.170.1666903463838;
        Thu, 27 Oct 2022 13:44:23 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n3-20020a5d6b83000000b00236644228besm1968739wrx.40.2022.10.27.13.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 13:44:23 -0700 (PDT)
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
Subject: [PATCH v3 19/36] net/tcp: Add TCP-AO SNE support
Date:   Thu, 27 Oct 2022 21:43:30 +0100
Message-Id: <20221027204347.529913-20-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027204347.529913-1-dima@arista.com>
References: <20221027204347.529913-1-dima@arista.com>
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
index df3087c8179f..2ba46d5db421 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3528,9 +3528,21 @@ static inline bool tcp_may_update_window(const struct tcp_sock *tp,
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
 
@@ -3538,9 +3550,21 @@ static void tcp_snd_una_update(struct tcp_sock *tp, u32 ack)
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
 
@@ -6357,6 +6381,17 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
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
2.38.1

