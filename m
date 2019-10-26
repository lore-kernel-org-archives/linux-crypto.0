Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA97CCA9EBD
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 14:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86F942070B
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 14:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572101631;
	bh=8sAyKk8mt7SfTyUDT5mY7Ohm9Bw9dXaUue3oAQpCcn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TGamSEVX0M2VwHHzd64oRs/nLywwCjsIwRvQ2JMQp5ZTQxP2hRwM/p0w8gmUwh5gJ
	 5VJWXJLDlkliOvPuTz/MNqFXUIT6IewZgowxehkxWNKNqBD21NLBpOIrtAhr8U63fJ
	 Ae2P3dxJOrgkXKU/4KUm72afVGi/2151gdhi30Ps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfJZOxu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Oct 2019 10:53:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbfJZOxu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Oct 2019 10:53:50 -0400
Received: from e123331-lin.home (lfbn-mar-1-643-104.w90-118.abo.wanadoo.fr [90.118.215.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6285B21655;
        Sat, 26 Oct 2019 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572101629;
        bh=8sAyKk8mt7SfTyUDT5mY7Ohm9Bw9dXaUue3oAQpCcn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3RCdZvD8eCd9S97bhOgYSFCNTMqmdGH4PPrcqdk30i+EcTnfEiLS/Z4GzF0pr6WD
         4T/84YzYVcEuOjuLCYWcobXCwMrRa56KhuUervq4XhdjawWueKmrqiBX7C09+fQt4E
         jWD6oJflb3Icjc4bCmV+UjRgxGb7d2w0UVljnQp4=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        linux-omap@vger.kernel.org, Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 1/6] crypto: omap-aes - reject invalid input sizes for block modes
Date:   Sat, 26 Oct 2019 16:52:54 +0200
Message-Id: <20191026145259.16040-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191026145259.16040-1-ardb@kernel.org>
References: <20191026145259.16040-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Block modes such as ECB and CBC only support input sizes that are
a round multiple of the block size, so align with the generic code
which returns -EINVAL when encountering inputs that violate this
rule.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/crypto/omap-aes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index de05b35283bf..067f4cd7c005 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -525,6 +525,9 @@ static int omap_aes_crypt(struct skcipher_request *req, unsigned long mode)
 	struct omap_aes_dev *dd;
 	int ret;
 
+	if ((req->cryptlen % AES_BLOCK_SIZE) && !(mode & FLAGS_CTR))
+		return -EINVAL;
+
 	pr_debug("nbytes: %d, enc: %d, cbc: %d\n", req->cryptlen,
 		  !!(mode & FLAGS_ENCRYPT),
 		  !!(mode & FLAGS_CBC));
-- 
2.17.1

