Return-Path: <SRS0=W691=QV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB53C4360F
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A75222A1
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Feb 2019 08:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550131462;
	bh=NF+oXy1mvglJG24dIdJwF2qQ16vdVHvupADOWEBVPp0=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VrVFu/PIXnwZUgA+gbNU16fNVbkSkHN8+pH3qHUQAdinuQpyvzxyabALFW5fijsit
	 8+9UpidrsJMb3iuOTB4wuBkNi3PxI8cmUTiP5t/f1ZLsgepoE9qU46ma2e2Hp7LnF3
	 Ucqlx9/MKbGVQdg5O9th/h74L5Qq8UGr5wPal7fo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394097AbfBNIEV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392357AbfBNIES (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Feb 2019 03:04:18 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6E04222D7;
        Thu, 14 Feb 2019 08:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550131458;
        bh=NF+oXy1mvglJG24dIdJwF2qQ16vdVHvupADOWEBVPp0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=1jv9L8H1GTxvD47kFq9H1sHZRaM7VJkxx95AVSx0FvFBChwcnB7pIx2M+4Ko+NiBX
         efPLwPd9BWuhPiAvrBbRzLpt4vls0zeDsq7ofvMAhuJDtpz03meqIC3tl4eucX6+r8
         eKET/lurawzO9eC12cw8hkkmL07XZjkm5PcRYC8s=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/6] crypto: arm64/aes-blk - update IV after partial final CTR block
Date:   Thu, 14 Feb 2019 00:03:54 -0800
Message-Id: <20190214080355.8112-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214080355.8112-1-ebiggers@kernel.org>
References: <20190214080355.8112-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make the arm64 ctr-aes-neon and ctr-aes-ce algorithms update the IV
buffer to contain the next counter after processing a partial final
block, rather than leave it as the last counter.  This makes these
algorithms pass the updated AES-CTR tests.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/aes-modes.S | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index 67700045a0e0..4c7ce231963c 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -320,8 +320,7 @@ AES_ENTRY(aes_ctr_encrypt)
 
 .Lctrtailblock:
 	st1		{v0.16b}, [x0]
-	ldp		x29, x30, [sp], #16
-	ret
+	b		.Lctrout
 
 .Lctrcarry:
 	umov		x7, v4.d[0]		/* load upper word of ctr  */
-- 
2.20.1

