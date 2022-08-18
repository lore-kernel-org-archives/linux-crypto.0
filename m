Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F66C00140
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Aug 2022 17:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345244AbiHRRC6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Aug 2022 13:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345239AbiHRRA5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2022 13:00:57 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D15CAC75
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 10:00:49 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n7so2431430wrv.4
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 10:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=F0lkibhqVPCxvm3Ppub1hqnowC+kOn1prFBSdpysGnA=;
        b=OrGuEHr2A8fKjpufJq6HnT8hr0ZAUvIjJ6CLyZhObIJiALHKPBXE9v63L0D4vbjpYs
         N19JEohxVQ/z1fkpCUt0gjpYskJuig0glIXMEI93daJ97YKRS6C4zZyFy0uLw/kLkxTV
         CmuCiw+SLLiXW4ieAyQ159nfR+LgPVM2uRTJkAoQKCwLw4L0jmVTAdV0Mknlkj2CQpQo
         fCs46WTa3RNnl1YgOiJ+svgbCDdze5Q1GIe2Kzw/EDFs+HRBV+8WljTagZ0YSKC7m3y3
         kjbsf4DWo2mJkqMAK/QBwNtuvP7x0b5KTlOgPXxhDflkpbZ+9nZS3216GYbw/2Pv/0p3
         D14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=F0lkibhqVPCxvm3Ppub1hqnowC+kOn1prFBSdpysGnA=;
        b=GhnbK7Arpm/YnnDZuDkOt+Sq29rDSKigRQfi5VJAh1WaxbB4jkhjTLzDHXpiLvYxHY
         jLgU95B0TKgl7NQ0fgWhH1KLgvT29/AMikEriO6QD9i5E2CmiLKRTA4GRrA4vayh8mng
         vApMUsuUTmd/vR81aJD+Z6sI4HxQg2QjYTZEPrGoIHA3ou9qVlwMU39ZIXsN3qPaBA51
         VfWe5NChFvxPU1NqITwtNQJO2HCSEGTP0PH4FOPrYXl52amIt89X2LamVt5xAfZDVZ4o
         2WqRjOcwdMB/MDd7izI9dYHg/ohSnlZ7LQtMiZKrDCQsVdB3CZgQvViyuCW9ilswMLYo
         Qrlw==
X-Gm-Message-State: ACgBeo0qqqQ9P6XLPMd7No13Np4rx28BZF2iplmhu8ovgthXw99YMvT1
        DczIt1Pf36kqGpjSLww/iFikBA==
X-Google-Smtp-Source: AA6agR7aVywVC+hUyPavX61ThpyiJr5HTVXdX9EC4bZKCl94tWP2/qyrT4+wqKRzmQysAKCtbIF1Bg==
X-Received: by 2002:a5d:5c12:0:b0:225:2993:2b63 with SMTP id cc18-20020a5d5c12000000b0022529932b63mr2232886wrb.294.1660842049011;
        Thu, 18 Aug 2022 10:00:49 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:48 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
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
Subject: [PATCH 24/31] net/tcp: Allow asynchronous delete for TCP-AO keys (MKTs)
Date:   Thu, 18 Aug 2022 17:59:58 +0100
Message-Id: <20220818170005.747015-25-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
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
index 5ab16b857c29..8e75432c0cc8 100644
--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1422,7 +1422,7 @@ static bool tcp_ao_mkt_overlap_v6(struct tcp_ao *cmd,
 #define TCP_AO_CMDF_ADDMOD_VALID					\
 	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_ACCEPT_ICMP)
 #define TCP_AO_CMDF_DEL_VALID						\
-	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT)
+	(TCP_AO_CMDF_CURR | TCP_AO_CMDF_NEXT | TCP_AO_CMDF_DEL_ASYNC)
 #define TCP_AO_GETF_VALID						\
 	(TCP_AO_GET_ALL | TCP_AO_GET_CURR | TCP_AO_GET_NEXT)
 
@@ -1547,11 +1547,26 @@ static int tcp_ao_delete_key(struct sock *sk, struct tcp_ao_key *key,
 
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

