Return-Path: <SRS0=ZPJC=3D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 205F7C33CB1
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 12:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2B6824676
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jan 2020 12:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgANM3m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jan 2020 07:29:42 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:43772 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgANM3m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jan 2020 07:29:42 -0500
Received: from localhost.localdomain (cyclone.blr.asicdesigners.com [10.193.186.206])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 00ECTEfi031366;
        Tue, 14 Jan 2020 04:29:34 -0800
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH 3/3] chelsio/cxgb4: Added tls stats prints
Date:   Tue, 14 Jan 2020 17:58:49 +0530
Message-Id: <20200114122849.133085-4-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114122849.133085-1-vinay.yadav@chelsio.com>
References: <20200114122849.133085-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 93868dca186a..c41b72c879c1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3399,6 +3399,13 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&adap->chcr_stats.fallback));
 	seq_printf(seq, "IPSec PDU: %10u\n",
 		   atomic_read(&adap->chcr_stats.ipsec_cnt));
+	seq_printf(seq, "TLS PDU Tx: %10u\n",
+		   atomic_read(&adap->chcr_stats.tls_pdu_tx));
+	seq_printf(seq, "TLS PDU Rx: %10u\n",
+		   atomic_read(&adap->chcr_stats.tls_pdu_rx));
+	seq_printf(seq, "TLS Keys (DDR) Count: %10u\n",
+		   atomic_read(&adap->chcr_stats.tls_key));
+
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(chcr_stats);
-- 
2.24.1

