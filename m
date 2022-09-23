Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D2FC07E9D
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 20:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiIWUR0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiIWUPY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 16:15:24 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00FA13506B
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 13:14:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id c11so1519263wrp.11
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 13:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=QSlxelZmZQkauh748b/7aNwlVR4EaKtqFDpMBsT7q2s=;
        b=U6NipO/WIQWxS/+Jj3d/rVPxFAUKikH5/3i+w/aOIgkOpIBtgKhtkrV3ClKF7MyDGa
         MxEWLc2NhU4QPjlJxtZO4qziF0EFHJLKqGcuAzHAfyYYazgxLCJIm1oq3ee9oLKqcM1E
         1d1fBFIMAtmLQYGJwlus2jofkrfEGouUvI0g8hAWL4ojN1v6JxLErDYCoHPX030i48FA
         B3pgPR6DYKK4dkwNqmAhsrFnrGQY5jsR+LVEwwDiCD3CS7JEZ/DoXuk8Y1L24RspQR1e
         +HTd+azien7FwppHeI+V/vzKOt7oV8kZHmVgHSaqqbFPSnLx6+XfWG/fBXnF4Wn1rkIy
         FDFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=QSlxelZmZQkauh748b/7aNwlVR4EaKtqFDpMBsT7q2s=;
        b=bnlX83u7T4KUiGRxWe7/OmIdX1m6Kj25r8rj7xh/R24VYwy0iN1E4h1jYSChxD+XOL
         kZri5o+DlcxfYb7wPdwOVuVG8cKRs2ZFhE9dlxhL2+R5hlQjxXnYjIc2e5qVvVFOvDtt
         z5yeipZLqXYsLjqfM18RuxIlaxGDeS/vpBUUiE6sfhSHuWofMXTPBHtXHXI7UzDNwp2H
         5cDuhAU+fiSuX0fBx8yRsNXX/RI2eKy0oDEHovGaV/A4GSE/rWkI3WTcwyXq0egNd0R8
         U6ng0DdhpzxEaXi9C9L9ktvgmLwQ4s7AIkTq0RamEMlm7lxeP3oDJS4nvl1NcolYJ2l5
         +G0g==
X-Gm-Message-State: ACrzQf3oCw/b2s5qFHQRM9F2qwLdj5UZGjBIrKGbD0aJnFjOxOHAlkTw
        gW6VvOBdu5ghv0C7LBtKzWSnDw==
X-Google-Smtp-Source: AMsMyM4Mco6j50zScn0pA1uSr0W0RCMLK0MagZMF94m1Efp9WHSd2cOmkVjbX1l1RMC/fTgjGZzsJw==
X-Received: by 2002:a5d:6808:0:b0:22a:c437:5b36 with SMTP id w8-20020a5d6808000000b0022ac4375b36mr6285460wru.459.1663964044375;
        Fri, 23 Sep 2022 13:14:04 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id k11-20020a05600c0b4b00b003b492753826sm3281056wmr.43.2022.09.23.13.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:14:03 -0700 (PDT)
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
Subject: [PATCH v2 24/35] net/tcp: Allow asynchronous delete for TCP-AO keys (MKTs)
Date:   Fri, 23 Sep 2022 21:13:08 +0100
Message-Id: <20220923201319.493208-25-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
References: <20220923201319.493208-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Delete becomes very, very fast - almost free, but after setsockopt()
syscall returns, the key is still alive until next RCU grace period.
Which is fine for listen sockets as userspace needs to be aware of
setsockopt(TCP_AO) and accept() race and resolve it with verification
by getsockopt() after TCP connection was accepted.

The benchmark results (on non-loaded box, worse with more RCU work pending):
> ok 33    Worst case delete    16384 keys: min=5ms max=10ms mean=6.93904ms stddev=0.263421
> ok 34        Add a new key    16384 keys: min=1ms max=4ms mean=2.17751ms stddev=0.147564
> ok 35 Remove random-search    16384 keys: min=5ms max=10ms mean=6.50243ms stddev=0.254999
> ok 36         Remove async    16384 keys: min=0ms max=0ms mean=0.0296107ms stddev=0.0172078

Co-developed-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Co-developed-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Salam Noureddine <noureddine@arista.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/uapi/linux/tcp.h |  3 +++
 net/ipv4/tcp_ao.c        | 17 ++++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 453187d21da8..42850ae6e99d 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -353,6 +353,9 @@ struct tcp_diag_md5sig {
 #define TCP_AO_CMDF_CURR	(1 << 0)	/* Only checks field sndid */
 #define TCP_AO_CMDF_NEXT	(1 << 1)	/* Only checks field rcvid */
 #define TCP_AO_CMDF_ACCEPT_ICMP	(1 << 2)	/* Accept incoming ICMPs */
+#define TCP_AO_CMDF_DEL_ASYNC	(1 << 3)	/* Asynchronious delete, valid
+						 * only for listen sockets
+						 */
 
 #define TCP_AO_GET_CURR		TCP_AO_CMDF_CURR
 #define TCP_AO_GET_NEXT		TCP_AO_CMDF_NEXT
diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
index 8f569f43e9c2..ed8cacb61694 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1461,7 +1461,7 @@ static inline bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 #define TCP_AO_CMDF_ADDMOD_VALID					\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
-	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
+	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_DEL_ASYNC)
 #define TCP_AO_GETF_VALID						\
 	(TCP_AO_GET_ALL | TCP_AO_GET_CURR | TCP_AO_GET_NEXT)
 
@@ -1586,11 +1586,26 @@ static int tcp_ao_delete_key(struct sock *sk, struct tcp_ao_key *key,
 
 	hlist_del_rcu(&key->node);
 
+	/* Support for async delete on listening sockets: as they don't
+	 * need current_key/rnext_key maintaining, we don't need to check
+	 * them and we can just free all resources in RCU fashion.
+	 */
+	if (cmd->tcpa_flags & TCP_AO_CMDF_DEL_ASYNC) {
+		if (sk->sk_state != TCP_LISTEN)
+			return -EINVAL;
+		atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
+		call_rcu(&key->rcu, tcp_ao_key_free_rcu);
+		return 0;
+	}
+
 	/* At this moment another CPU could have looked this key up
 	 * while it was unlinked from the list. Wait for RCU grace period,
 	 * after which the key is off-list and can't be looked up again;
 	 * the rx path [just before RCU came] might have used it and set it
 	 * as current_key (very unlikely).
+	 * Free the key with next RCU grace period (in case it was
+	 * current_key before tcp_ao_current_rnext() might have
+	 * changed it in forced-delete).
 	 */
 	synchronize_rcu();
 	err = tcp_ao_current_rnext(sk, cmd->tcpa_flags,
-- 
2.37.2

