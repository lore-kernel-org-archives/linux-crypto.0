Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98283C433FF
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 10:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 799B6206BA
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 10:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387432AbfG2Kkg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 06:40:36 -0400
Received: from foss.arm.com ([217.140.110.172]:41736 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387428AbfG2Kkg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 06:40:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 561F7344;
        Mon, 29 Jul 2019 03:40:35 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF1643F694;
        Mon, 29 Jul 2019 03:40:33 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] crypto: ccree: use the full crypt length value
Date:   Mon, 29 Jul 2019 13:40:18 +0300
Message-Id: <20190729104020.3681-2-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190729104020.3681-1-gilad@benyossef.com>
References: <20190729104020.3681-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In case of AEAD decryption verifcation error we were using the
wrong value to zero out the plaintext buffer leaving the end of
the buffer with the false plaintext.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: ff27e85a85bb ("crypto: ccree - add AEAD support")
CC: stable@vger.kernel.org # v4.17+
---
 drivers/crypto/ccree/cc_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 19abb872329c..8a6c825d40e8 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -268,7 +268,7 @@ static void cc_aead_complete(struct device *dev, void *cc_req, int err)
 			/* In case of payload authentication failure, MUST NOT
 			 * revealed the decrypted message --> zero its memory.
 			 */
-			cc_zero_sgl(areq->dst, areq_ctx->cryptlen);
+			cc_zero_sgl(areq->dst, areq->cryptlen);
 			err = -EBADMSG;
 		}
 	/*ENCRYPT*/
-- 
2.21.0

