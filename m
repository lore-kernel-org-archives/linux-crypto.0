Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDA6C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 11:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29C2E21726
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 11:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfAWL75 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 06:59:57 -0500
Received: from bastet.se.axis.com ([195.60.68.11]:40651 "EHLO
        bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfAWL75 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 06:59:57 -0500
Received: from localhost (localhost [127.0.0.1])
        by bastet.se.axis.com (Postfix) with ESMTP id E4A2C18522;
        Wed, 23 Jan 2019 12:59:53 +0100 (CET)
X-Axis-User: NO
X-Axis-NonUser: YES
X-Virus-Scanned: Debian amavisd-new at bastet.se.axis.com
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
Received: from bastet.se.axis.com ([IPv6:::ffff:127.0.0.1])
        by localhost (bastet.se.axis.com [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id VnkW3CcqVmfy; Wed, 23 Jan 2019 12:59:51 +0100 (CET)
Received: from boulder02.se.axis.com (boulder02.se.axis.com [10.0.8.16])
        by bastet.se.axis.com (Postfix) with ESMTPS id 433E318530;
        Wed, 23 Jan 2019 12:59:51 +0100 (CET)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11C771A077;
        Wed, 23 Jan 2019 12:59:51 +0100 (CET)
Received: from boulder02.se.axis.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 068EB1A075;
        Wed, 23 Jan 2019 12:59:51 +0100 (CET)
Received: from seth.se.axis.com (unknown [10.0.2.172])
        by boulder02.se.axis.com (Postfix) with ESMTP;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: from pc32929-1845.se.axis.com (pc32929-1845.se.axis.com [10.88.129.17])
        by seth.se.axis.com (Postfix) with ESMTP id EEB0D1CA2;
        Wed, 23 Jan 2019 12:59:50 +0100 (CET)
Received: by pc32929-1845.se.axis.com (Postfix, from userid 20456)
        id EBC9B409B9; Wed, 23 Jan 2019 12:59:50 +0100 (CET)
From:   Lars Persson <lars.persson@axis.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Lars Persson <larper@axis.com>
Subject: [PATCH 3/7] crypto: axis - fix for recursive locking from bottom half
Date:   Wed, 23 Jan 2019 12:59:42 +0100
Message-Id: <21911b0fd07f478260e166a2e910fd4074ffcefb.1548243646.git.larper@axis.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
In-Reply-To: <cover.1548243646.git.larper@axis.com>
References: <cover.1548243646.git.larper@axis.com>
X-TM-AS-GCONF: 00
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clients may submit a new requests from the completion callback
context. The driver was not prepared to receive a request in this
state because it already held the request queue lock and a recursive
lock error is triggered.

Now all completions are queued up until we are ready to drop the queue
lock and then delivered.

The fault was triggered by TCP over an IPsec connection in the LTP
test suite:
  LTP: starting tcp4_ipsec02 (tcp_ipsec.sh -p ah -m transport -s "100 1000 65535")
  BUG: spinlock recursion on CPU#1, genload/943
   lock: 0xbf3c3094, .magic: dead4ead, .owner: genload/943, .owner_cpu: 1
  CPU: 1 PID: 943 Comm: genload Tainted: G           O    4.9.62-axis5-devel #6
  Hardware name: Axis ARTPEC-6 Platform
   (unwind_backtrace) from [<8010d134>] (show_stack+0x18/0x1c)
   (show_stack) from [<803a289c>] (dump_stack+0x84/0x98)
   (dump_stack) from [<8016e164>] (do_raw_spin_lock+0x124/0x128)
   (do_raw_spin_lock) from [<804de1a4>] (artpec6_crypto_submit+0x2c/0xa0)
   (artpec6_crypto_submit) from [<804def38>] (artpec6_crypto_prepare_submit_hash+0xd0/0x54c)
   (artpec6_crypto_prepare_submit_hash) from [<7f3165f0>] (ah_output+0x2a4/0x3dc [ah4])
   (ah_output [ah4]) from [<805df9bc>] (xfrm_output_resume+0x178/0x4a4)
   (xfrm_output_resume) from [<805d283c>] (xfrm4_output+0xac/0xbc)
   (xfrm4_output) from [<80587928>] (ip_queue_xmit+0x140/0x3b4)
   (ip_queue_xmit) from [<805a13b4>] (tcp_transmit_skb+0x4c4/0x95c)
   (tcp_transmit_skb) from [<8059f218>] (tcp_rcv_state_process+0xdf4/0xdfc)
   (tcp_rcv_state_process) from [<805a7530>] (tcp_v4_do_rcv+0x64/0x1ac)
   (tcp_v4_do_rcv) from [<805a9724>] (tcp_v4_rcv+0xa34/0xb74)
   (tcp_v4_rcv) from [<80581d34>] (ip_local_deliver_finish+0x78/0x2b0)
   (ip_local_deliver_finish) from [<8058259c>] (ip_local_deliver+0xe4/0x104)
   (ip_local_deliver) from [<805d23ec>] (xfrm4_transport_finish+0xf4/0x144)
   (xfrm4_transport_finish) from [<805df564>] (xfrm_input+0x4f4/0x74c)
   (xfrm_input) from [<804de420>] (artpec6_crypto_task+0x208/0x38c)
   (artpec6_crypto_task) from [<801271b0>] (tasklet_action+0x60/0xec)
   (tasklet_action) from [<801266d4>] (__do_softirq+0xcc/0x3a4)
   (__do_softirq) from [<80126d20>] (irq_exit+0xf4/0x15c)
   (irq_exit) from [<801741e8>] (__handle_domain_irq+0x68/0xbc)
   (__handle_domain_irq) from [<801014f0>] (gic_handle_irq+0x50/0x94)
   (gic_handle_irq) from [<80657370>] (__irq_usr+0x50/0x80)

Signed-off-by: Lars Persson <larper@axis.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index 43da19566a36..675741067166 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -278,6 +278,7 @@ enum artpec6_crypto_hash_flags {
 
 struct artpec6_crypto_req_common {
 	struct list_head list;
+	struct list_head complete_in_progress;
 	struct artpec6_crypto_dma_descriptors *dma;
 	struct crypto_async_request *req;
 	void (*complete)(struct crypto_async_request *req);
@@ -2028,7 +2029,8 @@ static int artpec6_crypto_prepare_aead(struct aead_request *areq)
 	return artpec6_crypto_dma_map_descs(common);
 }
 
-static void artpec6_crypto_process_queue(struct artpec6_crypto *ac)
+static void artpec6_crypto_process_queue(struct artpec6_crypto *ac,
+	    struct list_head *completions)
 {
 	struct artpec6_crypto_req_common *req;
 
@@ -2039,7 +2041,7 @@ static void artpec6_crypto_process_queue(struct artpec6_crypto *ac)
 		list_move_tail(&req->list, &ac->pending);
 		artpec6_crypto_start_dma(req);
 
-		req->req->complete(req->req, -EINPROGRESS);
+		list_add_tail(&req->complete_in_progress, completions);
 	}
 
 	/*
@@ -2069,6 +2071,11 @@ static void artpec6_crypto_task(unsigned long data)
 	struct artpec6_crypto *ac = (struct artpec6_crypto *)data;
 	struct artpec6_crypto_req_common *req;
 	struct artpec6_crypto_req_common *n;
+	struct list_head complete_done;
+	struct list_head complete_in_progress;
+
+	INIT_LIST_HEAD(&complete_done);
+	INIT_LIST_HEAD(&complete_in_progress);
 
 	if (list_empty(&ac->pending)) {
 		pr_debug("Spurious IRQ\n");
@@ -2102,19 +2109,30 @@ static void artpec6_crypto_task(unsigned long data)
 
 		pr_debug("Completing request %p\n", req);
 
-		list_del(&req->list);
+		list_move_tail(&req->list, &complete_done);
 
 		artpec6_crypto_dma_unmap_all(req);
 		artpec6_crypto_copy_bounce_buffers(req);
 
 		ac->pending_count--;
 		artpec6_crypto_common_destroy(req);
-		req->complete(req->req);
 	}
 
-	artpec6_crypto_process_queue(ac);
+	artpec6_crypto_process_queue(ac, &complete_in_progress);
 
 	spin_unlock_bh(&ac->queue_lock);
+
+	/* Perform the completion callbacks without holding the queue lock
+	 * to allow new request submissions from the callbacks.
+	 */
+	list_for_each_entry_safe(req, n, &complete_done, list) {
+		req->complete(req->req);
+	}
+
+	list_for_each_entry_safe(req, n, &complete_in_progress,
+				 complete_in_progress) {
+		req->req->complete(req->req, -EINPROGRESS);
+	}
 }
 
 static void artpec6_crypto_complete_crypto(struct crypto_async_request *req)
-- 
2.11.0

