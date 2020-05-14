Return-Path: <SRS0=peSz=64=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B7CC433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 07:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3FD820575
	for <linux-crypto@archiver.kernel.org>; Thu, 14 May 2020 07:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgENHyf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 May 2020 03:54:35 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:24679 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgENHye (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 May 2020 03:54:34 -0400
Received: from chumthang.blr.asicdesigners.com (chumthang.blr.asicdesigners.com [10.193.186.96])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04E7s1H3023047;
        Thu, 14 May 2020 00:54:26 -0700
From:   Ayush Sawal <ayush.sawal@chelsio.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        manojmalviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>
Subject: [PATCH net-next 2/2] Crypto/chcr: Fixes a cocci check error
Date:   Thu, 14 May 2020 13:23:30 +0530
Message-Id: <20200514075330.25542-3-ayush.sawal@chelsio.com>
X-Mailer: git-send-email 2.26.0.rc1.11.g30e9940
In-Reply-To: <20200514075330.25542-1-ayush.sawal@chelsio.com>
References: <20200514075330.25542-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This fixes an error observed after running coccinile
check.
drivers/crypto/chelsio/chcr_algo.c:1462:5-8: Unneeded variable:
"err". Return "0" on line 1480

This line is missed in the commit 567be3a5d227 ("crypto:
chelsio - Use multiple txq/rxq per tfm to process the requests").

Fixes: 567be3a5d227 ("crypto:
chelsio - Use multiple txq/rxq per tfm to process the requests").

Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 1aed0e8d6558..c90b68aebe65 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1462,6 +1462,7 @@ static int chcr_device_init(struct chcr_context *ctx)
 	int err = 0, rxq_perchan;
 
 	if (!ctx->dev) {
+		err = -ENXIO;
 		u_ctx = assign_chcr_device();
 		if (!u_ctx) {
 			pr_err("chcr device assignment fails\n");
-- 
2.26.0.rc1.11.g30e9940

