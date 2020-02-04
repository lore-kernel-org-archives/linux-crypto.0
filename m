Return-Path: <SRS0=JC+L=3Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B215C2D0B1
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 12:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 294332166E
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Feb 2020 12:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgBDMPM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Feb 2020 07:15:12 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:45972 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbgBDMPM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Feb 2020 07:15:12 -0500
Received: from redhouse.blr.asicdesginers.com ([10.193.187.72])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 014CEpnt014269;
        Tue, 4 Feb 2020 04:14:52 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     ilyal@mellanox.com, jakub.kicinski@netronome.com,
        fwteam@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH] Invalid tls record found.
Date:   Tue,  4 Feb 2020 17:44:48 +0530
Message-Id: <1580818488-8297-1-git-send-email-rohitm@chelsio.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If tcp sequence number is even before the retransmit hint, then it starts
checking in the list, but if it is even before the first entry of the list,
then also it returns the first record of the list.
This issue can easily happen if tx takes some time to re-tarnsmit a packet
and by the time ack is received. Kernel will clear that record, but
tls_get_record will still give the 1st record from the list.

This fix checks if tcp sequence number is before the first record of the
list, return NULL.

Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 net/tls/tls_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cd91ad8..2898517 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -602,7 +602,8 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
 		 */
 		info = list_first_entry_or_null(&context->records_list,
 						struct tls_record_info, list);
-		if (!info)
+		/* return NULL if seq number even before the 1st entry. */
+		if (!info || before(seq, info->end_seq - info->len))
 			return NULL;
 		record_sn = context->unacked_record_sn;
 	}
-- 
1.8.3.1

