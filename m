Return-Path: <SRS0=NTKo=2I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB79C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 03:34:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEFEC2146E
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 03:34:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c8NEa/YH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfLRDeh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Dec 2019 22:34:37 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33615 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfLRDeg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Dec 2019 22:34:36 -0500
Received: by mail-pf1-f194.google.com with SMTP id z16so430418pfk.0;
        Tue, 17 Dec 2019 19:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ONukCPo04MyQ0dGWDhkAJ7/bKcKlZKdzKOh3835rIc0=;
        b=c8NEa/YH1XpKu6xJWwXlnSnGB2WmMOfYCtydSz7iHpVwl+5eVGYsy8yH638ZoSv4Hq
         uUFfqstMcdMhs8fvd99tSUaqtn6jwayD/sCLAn/LlORkHPevuDXNBsjSx+CwtQ493F5W
         Wmt1wUEpC8tPQjlMlNdU9RkhsB8q4RhG4a3AHOSmK5wc2dxasePWOyxWKksBQLBOA7Rj
         lBoIij+vIpcvhJFQNcI7EEUmLgJp9R4ibhVXYaDfF7QLgq3RKdXCcOr0kV6GFFLlrS9n
         wfWA9RoZMsKBQfJQkEmo0rLmmBiw4rZ4r1L+Bva1r/y9xiECzY6Jc55eYcBxnoMpgDfi
         i2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ONukCPo04MyQ0dGWDhkAJ7/bKcKlZKdzKOh3835rIc0=;
        b=MFgAs6oZzZFhNUMu7QvkjnzsICbM6OaIgcrwRpvcljbXa5GAoJnDdWbbS4TfL93LOT
         ObD4wr4df7OoF7ZYlcAuVNinMlV8Ciesvkk46Ca5r9XJfHw/ZRoVn55d1gTQDede25kd
         BO1UoHyWo3P2nbFa6o3V24Pr5zPn6tuB5m+MZtESOyieZfCMa31C2vsOPj2S+Yu6A7o0
         hCVunPzU6S9LOZQbS+MgTdVIMYRCS2DcRHsqKeSfID9XKsoXJho9i0zSpzvjW/FNhiTl
         BCwLyP0JeksBX9N0cundOlyBiCM+YFb15oR/wmFOaSJ9OWj5z8kKx57nXyjZMSq6BaVQ
         r3YQ==
X-Gm-Message-State: APjAAAUhMYR66AvKZUl6VAxT3RYKXVdLEA0nBMA7G30vf4EUZwATD0cA
        BS+ZfwNGo/PoqCUJgaumZtCUFXihSth5Hg==
X-Google-Smtp-Source: APXvYqwMTguHHmmbQPNu/P12kClGPGCj5gkW0POPuZgnv1g9mEaXU1UpbCZ0ywj5EPJHW8UYz0xdrw==
X-Received: by 2002:a63:b141:: with SMTP id g1mr428607pgp.168.1576640075959;
        Tue, 17 Dec 2019 19:34:35 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.172])
        by smtp.gmail.com with ESMTPSA id b21sm634059pfp.0.2019.12.17.19.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:34:35 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     atul.gupta@chelsio.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, allison@lohutok.net,
        arjun@chelsio.com, kstewart@linuxfoundation.org,
        edumazet@google.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] crypto: chelsio: chtls: fix possible sleep-in-atomic-context bugs in abort_syn_rcv()
Date:   Wed, 18 Dec 2019 11:34:22 +0800
Message-Id: <20191218033422.18672-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

drivers/crypto/chelsio/chtls/chtls_cm.c, 1806: 
	alloc_skb(GFP_KERNEL) in send_abort_rpl
drivers/crypto/chelsio/chtls/chtls_cm.c, 1925: 
	send_abort_rpl in abort_syn_rcv
drivers/crypto/chelsio/chtls/chtls_cm.c, 1920: 
	spin_lock in abort_syn_rcv

drivers/crypto/chelsio/chtls/chtls_cm.c, 1787: 
	alloc_skb(GFP_KERNEL) in send_defer_abort_rpl
drivers/crypto/chelsio/chtls/chtls_cm.c, 1811: 
	send_defer_abort_rpl in send_abort_rpl
drivers/crypto/chelsio/chtls/chtls_cm.c, 1925: 
    send_abort_rpl in abort_syn_rcv
drivers/crypto/chelsio/chtls/chtls_cm.c, 1920: 
    spin_lock in abort_syn_rcv

alloc_skb(GFP_KERNEL) can sleep at runtime.

To fix these possible bugs, GFP_KERNEL is replaced with GFP_ATOMIC.
Besides, in send_defer_abort_rpl(), error handling code is added to 
handle the failure of alloc_skb().

These bugs are found by a static analysis tool STCheck written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index aca75237bbcf..e6e4c3ddc368 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1805,8 +1805,11 @@ static void send_defer_abort_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	struct cpl_abort_req_rss *req = cplhdr(skb);
 	struct sk_buff *reply_skb;
 
-	reply_skb = alloc_skb(sizeof(struct cpl_abort_rpl),
-			      GFP_KERNEL | __GFP_NOFAIL);
+	reply_skb = alloc_skb(sizeof(struct cpl_abort_rpl), GFP_ATOMIC);
+	if (!reply_skb) {
+		kfree_skb(skb);
+		return;
+	}
 	__skb_put(reply_skb, sizeof(struct cpl_abort_rpl));
 	set_abort_rpl_wr(reply_skb, GET_TID(req),
 			 (req->status & CPL_ABORT_NO_RST));
@@ -1825,7 +1828,7 @@ static void send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 	csk = rcu_dereference_sk_user_data(sk);
 
 	reply_skb = alloc_skb(sizeof(struct cpl_abort_rpl),
-			      GFP_KERNEL);
+			      GFP_ATOMIC);
 
 	if (!reply_skb) {
 		req->status = (queue << 1);
-- 
2.17.1

