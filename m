Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A263FE7D0AB
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Sep 2023 21:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbjIUVYV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbjIUVYH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2023 17:24:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A2CE098
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2023 13:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695329639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=fGPKZrXt//Yq5gMCYOETARqtGaAshsB1GXsDehnSEAY=;
        b=EHHWXfeeO2+0YUNZNT78QSTuauDeVA+OukoL2i+9doDEkdc0U292SkzGbB8iwkDdtTRTSS
        3xDNzWLs8ikCFjS5kSF4RuLskxeuhSpH1ebAn4V67xUbptPg7Kw2cwAq6cSb9ISBX/AyYd
        BDCtRKXG6IJ2hMmM+4zDMqPtRqhd88A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-vIAPiOWSOGmX5UhEXrpHjw-1; Thu, 21 Sep 2023 16:53:56 -0400
X-MC-Unique: vIAPiOWSOGmX5UhEXrpHjw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A54D3814591;
        Thu, 21 Sep 2023 20:53:56 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 610872156701;
        Thu, 21 Sep 2023 20:53:55 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
        id 4926030C1C0A; Thu, 21 Sep 2023 20:53:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 406CF3FB77;
        Thu, 21 Sep 2023 22:53:55 +0200 (CEST)
Date:   Thu, 21 Sep 2023 22:53:55 +0200 (CEST)
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Hrivnak <mhrivnak@redhat.com>,
        Eric Garver <egarver@redhat.com>
cc:     qat-linux@intel.com, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com
Subject: [PATCH] qat: fix deadlock in backlog processing
Message-ID: <af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi

I was evaluating whether it is feasible to use QAT with dm-crypt (the 
answer is that it is not - QAT is slower than AES-NI for this type of 
workload; QAT starts to be benefical for encryption requests longer than 
64k). And I got some deadlocks.

The reason for the deadlocks is this: suppose that one of the "if"
conditions in "qat_alg_send_message_maybacklog" is true and we jump to the
"enqueue" label. At this point, an interrupt comes in and clears all
pending messages. Now, the interrupt returns, we grab backlog->lock, add
the message to the backlog, drop backlog->lock - and there is no one to
remove the backlogged message out of the list and submit it.

I fixed it with this patch - with this patch, the test passes and there
are no longer any deadlocks. I didn't want to add a spinlock to the hot
path, so I take it only if some of the condition suggests that queuing may
be required.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/crypto/intel/qat/qat_common/qat_algs_send.c |   31 ++++++++++++--------
 1 file changed, 20 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
===================================================================
--- linux-2.6.orig/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
+++ linux-2.6/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
@@ -40,16 +40,6 @@ void qat_alg_send_backlog(struct qat_ins
 	spin_unlock_bh(&backlog->lock);
 }
 
-static void qat_alg_backlog_req(struct qat_alg_req *req,
-				struct qat_instance_backlog *backlog)
-{
-	INIT_LIST_HEAD(&req->list);
-
-	spin_lock_bh(&backlog->lock);
-	list_add_tail(&req->list, &backlog->list);
-	spin_unlock_bh(&backlog->lock);
-}
-
 static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
 {
 	struct qat_instance_backlog *backlog = req->backlog;
@@ -71,8 +61,27 @@ static int qat_alg_send_message_maybackl
 	return -EINPROGRESS;
 
 enqueue:
-	qat_alg_backlog_req(req, backlog);
+	spin_lock_bh(&backlog->lock);
+
+	/* If any request is already backlogged, then add to backlog list */
+	if (!list_empty(&backlog->list))
+		goto enqueue2;
 
+	/* If ring is nearly full, then add to backlog list */
+	if (adf_ring_nearly_full(tx_ring))
+		goto enqueue2;
+
+	/* If adding request to HW ring fails, then add to backlog list */
+	if (adf_send_message(tx_ring, fw_req))
+		goto enqueue2;
+
+	spin_unlock_bh(&backlog->lock);
+	return -EINPROGRESS;
+
+enqueue2:
+	list_add_tail(&req->list, &backlog->list);
+
+	spin_unlock_bh(&backlog->lock);
 	return -EBUSY;
 }
 

