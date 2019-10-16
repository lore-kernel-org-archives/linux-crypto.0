Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B603FA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 11:49:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E54D320854
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 11:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390343AbfJPLtz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 07:49:55 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:49758 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390103AbfJPLtz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 07:49:55 -0400
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iKhoJ-0006AG-Bf; Wed, 16 Oct 2019 12:49:47 +0100
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.2)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1iKhoI-0007vy-ST; Wed, 16 Oct 2019 12:49:46 +0100
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     linux-kernel@lists.codethink.co.uk
Cc:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: inside-secure - fix type of buffer in eip197_write_firmware
Date:   Wed, 16 Oct 2019 12:49:45 +0100
Message-Id: <20191016114945.30451-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In eip197_write_firmware() the firmware buffer is sent using
writel(be32_to_cpu(),,,) this produces a number of warnings.

Note, should this really be cpu_to_be32()  ?

drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restricted __be32
drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restricted __be32
drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restricted __be32
drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restricted __be32
drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restricted __be32
drivers/crypto/inside-secure/safexcel.c:306:17: warning: cast to restricted __be32

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: Antoine Tenart <antoine.tenart@bootlin.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/inside-secure/safexcel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 223d1bfdc7e6..dd33f6dda295 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -298,13 +298,13 @@ static void eip197_init_firmware(struct safexcel_crypto_priv *priv)
 static int eip197_write_firmware(struct safexcel_crypto_priv *priv,
 				  const struct firmware *fw)
 {
-	const u32 *data = (const u32 *)fw->data;
+	const __be32 *data = (const __be32 *)fw->data;
 	int i;
 
 	/* Write the firmware */
-	for (i = 0; i < fw->size / sizeof(u32); i++)
+	for (i = 0; i < fw->size / sizeof(__be32); i++)
 		writel(be32_to_cpu(data[i]),
-		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(u32));
+		       priv->base + EIP197_CLASSIFICATION_RAMS + i * sizeof(__be32));
 
 	/* Exclude final 2 NOPs from size */
 	return i - EIP197_FW_TERMINAL_NOPS;
-- 
2.23.0

