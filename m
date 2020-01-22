Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB1FC2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 17:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB4F524656
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 17:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="udoNc8+p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAVRDc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 12:03:32 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33794 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgAVRDc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 12:03:32 -0500
Received: by mail-pl1-f193.google.com with SMTP id c9so31195plo.1;
        Wed, 22 Jan 2020 09:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jqNBkbZMwy19kOHcx6NrygN9IcG823sl9KjLJVX13II=;
        b=udoNc8+pJuT1/uLXNiK/pdBWmz4h5ouYltOmOXxoesWun39QRITmN2aPCFYQurU1yr
         zANY36cnhereu90S2EOXl+gUtZOy/uMty/7j+ukXQlE1/Dfkwnieuw4opEpaux0Eos/k
         T3CaW1rdIFo/Fw6jMYE7xwFZwjJ6u3qoweN4+reZw3dJXhDfEgeJEWnwiNeWaINTr8Aq
         xA60sss57Rq+7/EHNVwlLB6VzhO3yhq5S4I/SXA8KZme5qbJqmBs7iN1TuaxF3/5qEd2
         ZQu0vOXzMgtcJdO55ITMCXUYlfa4byZjiRQiRMsKLl8kGBQTxb4kBzJ7Sl70QQLSMNjl
         EI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jqNBkbZMwy19kOHcx6NrygN9IcG823sl9KjLJVX13II=;
        b=C35DMxWpxphvIxABwD4OWFVDWbvMm5JbICxma4tulcV6zCmqTrViZM7L9181QvdH0t
         l3aDsurwzkqDr7FBz5rbb9rJxZYGGLcASqZ36U4bCZH9hXVxG5dn3hJ7t0Lx+P92tkxH
         zbX9NGFR/+6pcFrzwKI9jC5Zd2I0YSw5nk9viNermW8v6e/QQ64FMS7zMJScIkYEohny
         CjllTpdalV3PlZ6GXwJw839F3X76c2r3B8R0guNB24kLfaEOypulwWEM2pk3/0RSVQ/w
         crVk/72GgYNpHNXt0gvrstrACDNtJLtucs6g8OA80pEHDf6VSzbG94U1UJt3AFfjxAOE
         3YSg==
X-Gm-Message-State: APjAAAW5zLK/ci9cW4jR4FL9hASnyLmhGTV04eHGlVjzElTa2HW+wavm
        BAwP1Ajik580QCPSKUul2J4y85g=
X-Google-Smtp-Source: APXvYqy99bLz1JWoyph9iIgOzcLd/caqRGosXjDmnNy32D/Yy85xL9gRmYMlNuhEsnqM5Xbl3ZZ63g==
X-Received: by 2002:a17:90a:fa88:: with SMTP id cu8mr3848711pjb.141.1579712611677;
        Wed, 22 Jan 2020 09:03:31 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1eee:fc60:1df1:6c1a:3227:9ec0])
        by smtp.gmail.com with ESMTPSA id b8sm48682682pfr.64.2020.01.22.09.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 09:03:31 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     steffen.klassert@secunet.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@joelfernandes.org, frextrite@gmail.com, rcu@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] padata.h: Annotate parallel_data with __rcu
Date:   Wed, 22 Jan 2020 22:32:46 +0530
Message-Id: <20200122170246.20177-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

This patch fixes the following sparse errors:
kernel/padata.c:110:14: error: incompatible types in comparison expression
kernel/padata.c:520:9: error: incompatible types in comparison expression
kernel/padata.c:1000:9: error: incompatible types in comparison expression

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 include/linux/padata.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 23717eeaad23..72a081dd2b73 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -143,7 +143,7 @@ struct padata_instance {
 	struct hlist_node		 node;
 	struct workqueue_struct		*parallel_wq;
 	struct workqueue_struct		*serial_wq;
-	struct parallel_data		*pd;
+	struct parallel_data __rcu		*pd;
 	struct padata_cpumask		cpumask;
 	struct blocking_notifier_head	 cpumask_change_notifier;
 	struct kobject                   kobj;
-- 
2.17.1

