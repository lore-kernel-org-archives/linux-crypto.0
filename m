Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B42C433F5
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 01:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7827C6120E
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Nov 2021 01:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhKEBwh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Nov 2021 21:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhKEBwg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Nov 2021 21:52:36 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1865C061714
        for <linux-crypto@vger.kernel.org>; Thu,  4 Nov 2021 18:49:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id d27so11388046wrb.6
        for <linux-crypto@vger.kernel.org>; Thu, 04 Nov 2021 18:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rQaR7pp39Z0B6hBnX5gFqMWGoIyCNaiLBW5E59MvVPU=;
        b=HpKBBKdcwfPb3BMYNPFePf+BzaC0GDFahXGNk6Xf3M1UObOb5421v7FFc07VdVU1WC
         J1/772b1SSlAjfPajdR2V345GHLG07oHXjOpjrNG9cCKsPCpANeP0PkuM/zcErR0oM0g
         Dc79B3CVgKl8USygfoQVaNZfvertwqBr2p7yFq1c+z4f7YKLMEsXEAnpn4GZVOBYhghM
         3JHacOGOA2OQN5WjvHNOhualZnF72yExBCkAjzZFdMgUdeE7b6CGhHMvMMKCS8esz/bt
         Ux9z52Qpt9kOdySlK08zeRih87wA8bgyYpdEptTrw5NOVHLDy9j0SY2lJn75SYlj7CMW
         BrAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rQaR7pp39Z0B6hBnX5gFqMWGoIyCNaiLBW5E59MvVPU=;
        b=FQfrE4nk688RNWvVZgSP5Dvr2DJYd0d2r2tI2JlkN7qZh10xssO7YuZ+kH77L6pJEM
         250lW8PqzchsbFnHqRnBtwWmp8eSDRowICULH89GXm/SaEbBbKv+5TE7Fv6ESI9fIZlE
         tZktrBFnxLJ0xVY5cdx2oYgALuJx78l1rS92YnwLds12ba3kq/T6pD8cWokq+OMu9Gn5
         f6sYeS/llPFUfPIIf0nm9PU24dTF6J9Pfisp3MdRG8QDuhi9TiRPAInET9DJJjPayKsQ
         zvQe0Nf8u1EScQwY3NnZAhIcgP+IGV37sIL9zRUhvkXySN8MV7tG13wnXSWfgJ+DQzaS
         4lTA==
X-Gm-Message-State: AOAM5310qLx4z0juyHWeTSCCK3+94fbuOfwoRzdeiJVcp9j8NlwLepal
        cy4wC7DBpLVq6SEDSHo+hVI+OA==
X-Google-Smtp-Source: ABdhPJxood27uGNuAJy89dbUs4q1LVV544g8s4ei9ZS6BOn6gHSZyEs/iyJSjCj57SDkdUgfgcoRdg==
X-Received: by 2002:adf:a389:: with SMTP id l9mr58721497wrb.121.1636076996488;
        Thu, 04 Nov 2021 18:49:56 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c6sm7202421wmq.46.2021.11.04.18.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:49:56 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/5] tcp/md5: Don't BUG_ON() failed kmemdup()
Date:   Fri,  5 Nov 2021 01:49:49 +0000
Message-Id: <20211105014953.972946-2-dima@arista.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211105014953.972946-1-dima@arista.com>
References: <20211105014953.972946-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

static_branch_unlikely(&tcp_md5_needed) is enabled by
tcp_alloc_md5sig_pool(), so as long as the code doesn't change
tcp_md5sig_pool has been already populated if this code is being
executed.

In case tcptw->tw_md5_key allocaion failed - no reason to crash kernel:
tcp_{v4,v6}_send_ack() will send unsigned segment, the connection won't be
established, which is bad enough, but in OOM situation totally
acceptable and better than kernel crash.

Introduce tcp_md5sig_pool_ready() helper.
tcp_alloc_md5sig_pool() usage is intentionally avoided here as it's
fast-path here and it's check for sanity rather than point of actual
pool allocation. That will allow to have generic slow-path allocator
for tcp crypto pool.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/tcp.h        | 1 +
 net/ipv4/tcp.c           | 5 +++++
 net/ipv4/tcp_minisocks.c | 5 +++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4da22b41bde6..3e5423a10a74 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1672,6 +1672,7 @@ tcp_md5_do_lookup(const struct sock *sk, int l3index,
 #endif
 
 bool tcp_alloc_md5sig_pool(void);
+bool tcp_md5sig_pool_ready(void);
 
 struct tcp_md5sig_pool *tcp_get_md5sig_pool(void);
 static inline void tcp_put_md5sig_pool(void)
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b7796b4cf0a0..c0856a6af9f5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4314,6 +4314,11 @@ bool tcp_alloc_md5sig_pool(void)
 }
 EXPORT_SYMBOL(tcp_alloc_md5sig_pool);
 
+bool tcp_md5sig_pool_ready(void)
+{
+	return tcp_md5sig_pool_populated;
+}
+EXPORT_SYMBOL(tcp_md5sig_pool_ready);
 
 /**
  *	tcp_get_md5sig_pool - get md5sig_pool for this user
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index cf913a66df17..c99cdb529902 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -293,11 +293,12 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)
 			tcptw->tw_md5_key = NULL;
 			if (static_branch_unlikely(&tcp_md5_needed)) {
 				struct tcp_md5sig_key *key;
+				bool err = WARN_ON(!tcp_md5sig_pool_ready());
 
 				key = tp->af_specific->md5_lookup(sk, sk);
-				if (key) {
+				if (key && !err) {
 					tcptw->tw_md5_key = kmemdup(key, sizeof(*key), GFP_ATOMIC);
-					BUG_ON(tcptw->tw_md5_key && !tcp_alloc_md5sig_pool());
+					WARN_ON_ONCE(tcptw->tw_md5_key == NULL);
 				}
 			}
 		} while (0);
-- 
2.33.1

