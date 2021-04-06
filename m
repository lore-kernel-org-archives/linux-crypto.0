Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B14C433B4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 14:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB3A3613C4
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Apr 2021 14:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbhDFOZg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Apr 2021 10:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhDFOZg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Apr 2021 10:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCB3C613B3;
        Tue,  6 Apr 2021 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617719128;
        bh=vNtEwGcZISehAqNRkZmr9T8agA6B1FBpji1ztURbj9c=;
        h=From:To:Cc:Subject:Date:From;
        b=fPEL+PrNq2Wo+kYIIz6T6zMJsLUuM0TNd1mTNhczorVRv/aBiuzw6a14Bx6XvaC78
         xSSPcQD06GHTLq6PBybPWnzlNRSms/MtZPniIb9iwqfD6S15CK4PnODlxS51ZZ+tpd
         LP5uStXqLWHG6tbYBIfJcvRr256xlEzXYA6u+iU2ltOKjcFQs+Aa840yS0JJkVNQoW
         vc3gWUtcz374LgQ2Me/Iw/FYubwmbrv1foN0gRctguQa3G7WPRxUz8lfaRA83u9mHe
         EyDg+eTwK+Ijh+/K8jdVuKw60CGrBRb6C2qNuOi9SGBV1IucF6Ypmc5R4Y7KC7Vg9b
         XHTQwKulvnqww==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: arm64/aes-ce - deal with oversight in new CTR carry code
Date:   Tue,  6 Apr 2021 16:25:23 +0200
Message-Id: <20210406142523.1101817-1-ardb@kernel.org>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The new carry handling code in the CTR driver can deal with a carry
occurring in the 4x/5x parallel code path, by using a computed goto to
jump into the carry sequence at the right place as to only apply the
carry to a subset of the blocks being processed.

If the lower half of the counter wraps and ends up at exactly 0x0, a
carry needs to be applied to the counter, but not to the counter values
taken for the 4x/5x parallel sequence. In this case, the computed goto
skips all register assignments, and branches straight to the jump
instruction that gets us back to the fast path. This produces the
correct result, but due to the fact that this branch target does not
carry the correct BTI annotation, this fails when BTI is enabled.

Let's omit the computed goto entirely in this case, and jump straight
back to the fast path after applying the carry to the main counter.

Fixes: 5318d3db465d ("crypto: arm64/aes-ctr - improve tail handling")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/aes-modes.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
index ab6c14ef9f4e..6d1a120c533d 100644
--- a/arch/arm64/crypto/aes-modes.S
+++ b/arch/arm64/crypto/aes-modes.S
@@ -359,6 +359,7 @@ ST5(	mov		v4.16b, vctr.16b		)
 	ins		vctr.d[0], x8
 
 	/* apply carry to N counter blocks for N := x12 */
+	cbz		x12, 2f
 	adr		x16, 1f
 	sub		x16, x16, x12, lsl #3
 	br		x16
-- 
2.31.0.208.g409f899ff0-goog

