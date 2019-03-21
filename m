Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 124F9C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 22:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB07D218D3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 22:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfCUW7t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 18:59:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38179 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfCUW7t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 18:59:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id g12so344382wrm.5
        for <linux-crypto@vger.kernel.org>; Thu, 21 Mar 2019 15:59:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=4H4cSRmG0KbWq4rrwNVrs7BVba10vKA2iOkxa0+3kOc=;
        b=sU1nTmqu+vBR6/iT7AshfmukxxCV276GGEMcv3RvfbCMa/1iOlEvzu87FpqA9gHWW6
         5q+BPjPG2RIsdb1JKLkwMNj/ardxw8Ca/bSTaVH9ON9/cKcWu7VxqJCjF8QYKeZ52TiG
         ykLQw81wueOw4jBXGby2e6ZsU9bzBE/1+KM2x69BBG1xqOAP7zB8a7y3pnuP1cHJ5jzy
         JYPQTnwYWZ2iPZE9S8zNK+x2YJUSic22/cXtzpFGXChczAGXdT6sqbPM5RU4Mk2AikDw
         Z9Y4F7eg67gSivN66gzBbhSpeXU1wUqXGqQ/EIHrIkxUK4DGlbTFQD/lL0J9PUIN7Vxf
         vR9g==
X-Gm-Message-State: APjAAAVmer/olTQZcWRkiUl+S4AUGmZBHaNwxC5IZ++9nDvR8M59p3CL
        bXmJu4ApWlli9SNCR3vnDMlbb0maEY0=
X-Google-Smtp-Source: APXvYqzwCZmNEVgJpu5r4jbWQkZVDVd8IKAlOhpeZIpd+bsoEHaKCQ6/7fsTEKN/RuiNIzoYJYU5Xw==
X-Received: by 2002:a5d:644a:: with SMTP id d10mr3997934wrw.308.1553209187498;
        Thu, 21 Mar 2019 15:59:47 -0700 (PDT)
Received: from pc-2.home (2a01cb05850ddf00045dd60e6368f84b.ipv6.abo.wanadoo.fr. [2a01:cb05:850d:df00:45d:d60e:6368:f84b])
        by smtp.gmail.com with ESMTPSA id o20sm7681544wmh.21.2019.03.21.15.59.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Mar 2019 15:59:46 -0700 (PDT)
Date:   Thu, 21 Mar 2019 23:59:45 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     linux-crypto@vger.kernel.org
Cc:     Atul Gupta <atul.gupta@chelsio.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [RFC PATCH] crypto: chtls - handle inet_csk_reqsk_queue_add()
 failures
Message-ID: <c96b622f873160880843766d62f4ccac08abd302.1553208186.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

While working on 9d3e1368bb45 ("tcp: handle inet_csk_reqsk_queue_add()
failures"), I missed this usage of inet_csk_reqsk_queue_add().

inet_csk_reqsk_queue_add() can fail. In that case, the operation is
aborted and inet_csk_destroy_sock() is called automatically, but we
need to free the request socket manually.

RFC:
Sending as RFC because I'm unsure about how to handle 'child' in that
case. I don't call add_to_reap_list(child) here, because
inet_csk_destroy_sock() has already run. Therefore, most of the
operations performed by add_to_reap_list()/process_reap_list() would be
redundant (but harmless). Except for two things:

  * process_reap_list() calls inet_csk_destroy_sock() if ->sk_state is
    TCP_CLOSE. We have to avoid that. Socket's state should be
    TCP_ESTABLISHED at the time of the call, but process_reap_list() is
    run asynchronously and I couldn't find anything that would
    prevent the rest of the system from accessing the socket before
    process_reap_list() picks it up (the socket is still accessible
    from cdev->tids). So I fear that calling add_to_reap_list() in the
    error path would let process_reap_list() call
    inet_csk_reqsk_queue_add() a second time if ->sk_state was
    concurrently set to TCP_CLOSE. That looks like a good reason not to
    call add_to_reap_list().

  * The only operation that process_reap_list() does and isn't already
    done by inet_csk_destroy_sock() is chtls_abort_conn(). This
    function has no effect if its sk_buff allocation fails. So it might
    be a no-op. That looks like another reason for not calling
    add_to_reap_list()...
    But what chtls_abort_conn() does when sk_buff allocation succeeds
    looks actually important. IIUC, it sends a message to trigger the
    removal of the socket (how would the socket be removed from ->tids
    otherwise?). That would make chtls_abort_conn() quite important.
    But then how do we avoid losing track of those defunct sockets when
    sk_buff allocation fails?

Compile-tested only.

Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 59b75299fcbc..4bf1e3f65400 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1384,11 +1384,16 @@ static void add_pass_open_to_parent(struct sock *child, struct sock *lsk,
 	if (sk_acceptq_is_full(lsk)) {
 		chtls_reqsk_free(oreq);
 		add_to_reap_list(child);
-	} else {
-		refcount_set(&oreq->rsk_refcnt, 1);
-		inet_csk_reqsk_queue_add(lsk, oreq, child);
-		lsk->sk_data_ready(lsk);
+		return;
+	}
+
+	refcount_set(&oreq->rsk_refcnt, 1);
+	if (!inet_csk_reqsk_queue_add(lsk, oreq, child)) {
+		chtls_reqsk_free(oreq);
+		/* child already dropped by inet_csk_destroy_sock() */
+		return;
 	}
+	lsk->sk_data_ready(lsk);
 }
 
 static void bl_add_pass_open_to_parent(struct sock *lsk, struct sk_buff *skb)
-- 
2.20.1

