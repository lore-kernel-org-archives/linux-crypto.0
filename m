Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9078DC47258
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 03:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76EF120757
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 03:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgEEDOO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 May 2020 23:14:14 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:54651 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbgEEDON (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 May 2020 23:14:13 -0400
Received: from beagle7.blr.asicdesigners.com (beagle7.blr.asicdesigners.com [10.193.80.123])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0453Dqux019487;
        Mon, 4 May 2020 20:14:03 -0700
From:   Devulapally Shiva Krishna <shiva@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        secdev@chelsio.com, Devulapally Shiva Krishna <shiva@chelsio.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 3/5] Crypto/chcr: fix for ccm(aes) failed test
Date:   Tue,  5 May 2020 08:42:55 +0530
Message-Id: <20200505031257.9153-4-shiva@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200505031257.9153-1-shiva@chelsio.com>
References: <20200505031257.9153-1-shiva@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ccm(aes) test fails when req->assoclen > ~240bytes.

The problem is the value assigned to auth_offset is wrong.
As auth_offset is unsigned char, it can take max value as 255.
So fix it by making it unsigned int.

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: Devulapally Shiva Krishna <shiva@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 51adba5685a4..6b1a656e0a89 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2925,7 +2925,7 @@ static void fill_sec_cpl_for_aead(struct cpl_tx_sec_pdu *sec_cpl,
 	unsigned int mac_mode = CHCR_SCMD_AUTH_MODE_CBCMAC;
 	unsigned int rx_channel_id = reqctx->rxqidx / ctx->rxq_perchan;
 	unsigned int ccm_xtra;
-	unsigned char tag_offset = 0, auth_offset = 0;
+	unsigned int tag_offset = 0, auth_offset = 0;
 	unsigned int assoclen;
 
 	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309)
-- 
2.18.1

