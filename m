Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32129C4360F
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 00:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A6B218CD
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 00:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553128071;
	bh=8taTTa6vo9RZyKN+8fe6n3BXiH9nYuHEY0LC2qdDy2A=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ZP2MHamxsm20Jx/ntEXmJ4uRPjHNC8i2q/o3S/DWXm+oXOvD42juWBlmrEfLTnxu0
	 pqjvWahZHTZ65pMvIMeg0uhR9x3MhBLfbnqVtzmNfitBuUZZYeCGQKwCdA6AyseoLS
	 qnrEcMqu+uJnN6SN50S4rKcO3lXH1r7vR2jFn434=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfCUA1u (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Mar 2019 20:27:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726914AbfCUA1t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Mar 2019 20:27:49 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1319C20835;
        Thu, 21 Mar 2019 00:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553128069;
        bh=8taTTa6vo9RZyKN+8fe6n3BXiH9nYuHEY0LC2qdDy2A=;
        h=From:To:Cc:Subject:Date:From;
        b=0nvuu3HlKx1AtOEuhz1/PlTWbK1Ry5ziAJuAgdxQTy8kzXvzUIwNDQaKWmI+YFnhj
         pqm4YfZlDZK8DPlPyYMIIDkbuT5mTnsRenQiuZdr9ChsDsWnjpCE10WvP4bYOkRv/s
         89gGRyytbAKr9e136Cw6FCz++u4mw4wFvZVO+9Ek=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.14] crypto: arm64/aes-neonbs - fix returning final keystream block
Date:   Wed, 20 Mar 2019 17:27:25 -0700
Message-Id: <20190321002725.31056-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 12455e320e19e9cc7ad97f4ab89c280fe297387c upstream.

The arm64 NEON bit-sliced implementation of AES-CTR fails the improved
skcipher tests because it sometimes produces the wrong ciphertext.  The
bug is that the final keystream block isn't returned from the assembly
code when the number of non-final blocks is zero.  This can happen if
the input data ends a few bytes after a page boundary.  In this case the
last bytes get "encrypted" by XOR'ing them with uninitialized memory.

Fix the assembly code to return the final keystream block when needed.

Fixes: 88a3f582bea9 ("crypto: arm64/aes - don't use IV buffer to return final keystream block")
Cc: <stable@vger.kernel.org> # v4.11+
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

Please apply to 4.14-stable.  This resolves conflicts due to
"crypto: arm64/aes-bs - yield NEON after every block of input"
not being present in 4.14, but that has other dependencies.

Tested using the crypto self-tests from v5.1-rc1 backported to 4.14.
"rfc3686(ctr-aes-neonbs)" now passes the tests.

 arch/arm64/crypto/aes-neonbs-core.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index ca0472500433..3b18e3e79531 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -940,7 +940,7 @@ CPU_LE(	rev		x8, x8		)
 8:	next_ctr	v0
 	cbnz		x4, 99b
 
-0:	st1		{v0.16b}, [x5]
+	st1		{v0.16b}, [x5]
 	ldp		x29, x30, [sp], #16
 	ret
 
@@ -948,6 +948,9 @@ CPU_LE(	rev		x8, x8		)
 	 * If we are handling the tail of the input (x6 != NULL), return the
 	 * final keystream block back to the caller.
 	 */
+0:	cbz		x6, 8b
+	st1		{v0.16b}, [x6]
+	b		8b
 1:	cbz		x6, 8b
 	st1		{v1.16b}, [x6]
 	b		8b
-- 
2.21.0

