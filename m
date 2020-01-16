Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2990EC33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C27206B7
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731455AbgAPKPI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 05:15:08 -0500
Received: from foss.arm.com ([217.140.110.172]:47464 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgAPKPI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 05:15:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F87431B;
        Thu, 16 Jan 2020 02:15:07 -0800 (PST)
Received: from e110176-lin.arm.com (unknown [10.50.4.173])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF1C43F534;
        Thu, 16 Jan 2020 02:15:05 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/11] crypto: ccree - fix AEAD decrypt auth fail
Date:   Thu, 16 Jan 2020 12:14:38 +0200
Message-Id: <20200116101447.20374-4-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200116101447.20374-1-gilad@benyossef.com>
References: <20200116101447.20374-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On AEAD decryption authentication failure we are suppose to
zero out the output plaintext buffer. However, we've missed
skipping the optional associated data that may prefix the
ciphertext. This commit fixes this issue.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: e88b27c8eaa8 ("crypto: ccree - use std api sg_zero_buffer")
Cc: stable@vger.kernel.org
---
 drivers/crypto/ccree/cc_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index d014c8e063a7..754de302a3b5 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -237,7 +237,7 @@ static void cc_aead_complete(struct device *dev, void *cc_req, int err)
 			 * revealed the decrypted message --> zero its memory.
 			 */
 			sg_zero_buffer(areq->dst, sg_nents(areq->dst),
-				       areq->cryptlen, 0);
+				       areq->cryptlen, areq->assoclen);
 			err = -EBADMSG;
 		}
 	/*ENCRYPT*/
-- 
2.23.0

