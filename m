Return-Path: <SRS0=RoNa=TC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22905C43219
	for <linux-crypto@archiver.kernel.org>; Thu,  2 May 2019 10:47:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E98522075E
	for <linux-crypto@archiver.kernel.org>; Thu,  2 May 2019 10:47:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbfEBKr2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 May 2019 06:47:28 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:33533 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfEBKr2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 May 2019 06:47:28 -0400
Received: from beagle7.asicdesigners.com (beagle7.asicdesigners.com [10.192.192.157])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x42AlDMh028166;
        Thu, 2 May 2019 03:47:13 -0700
From:   Atul Gupta <atul.gupta@chelsio.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, davem@davemloft.net, dt@chelsio.com,
        atul.gupta@chelsio.com
Subject: [PATCH 1/4] crypto:chelsio Fix NULL pointer dereference
Date:   Thu,  2 May 2019 03:46:55 -0700
Message-Id: <20190502104655.21690-1-atul.gupta@chelsio.com>
X-Mailer: git-send-email 2.20.0.rc2.7.g965798d
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Do not request FW to generate cidx update if there is less
space in tx queue to post new request.
SGE DBP 1 pidx increment too large
BUG: unable to handle kernel NULL pointer dereference at
0000000000000124
SGE error for queue 101

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ipsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 2f60049..f429aae 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -575,7 +575,8 @@ inline void *chcr_crypto_wreq(struct sk_buff *skb,
 	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
 		netif_tx_stop_queue(q->txq);
 		q->q.stops++;
-		wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
+		if (!q->dbqt)
+			wr_mid |= FW_WR_EQUEQ_F | FW_WR_EQUIQ_F;
 	}
 	wr_mid |= FW_ULPTX_WR_DATA_F;
 	wr->wreq.flowid_len16 = htonl(wr_mid);
-- 
1.8.3.1

