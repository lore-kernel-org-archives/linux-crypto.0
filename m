Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D97C433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB7D610A7
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhELVH0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245218AbhELSp6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 14:45:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38C246142C;
        Wed, 12 May 2021 18:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620845087;
        bh=nX+u8lxMcY7ppjq3Y1KWiUaWS7k47IypQzIdfThldJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QZBwbUFR6BeKWuuU3yrTGKJjp9SZjCtCsHvNGekQKHN648yAiOniUb/UmZCSUWmpH
         fz9tSm08KxZrQw7S1V4fa1Ksy62/LDXL/6yG2HsoV4BR1krrGm0msVa3yoH1wn9rzf
         xFb5bPGw8/MIBAvojju2Ge0OJTgoMe4ai8WflPWsG9F1Unedl28HYVFV+7GWpxPC38
         bJ8ssetYd8HWccqztQjtSM5rC0FD8mPhl+4VHwcDxYySS4r9CUXafKtKsPlEMpTOsM
         I8SZZ6JqGLGaa3N5/i4eiB3kv1nlq/Y6eKI5Vv9Wm9zuw+6+ZItfH0PXas/EF3Ut37
         lhOAZieEcOrkw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, ebiggers@kernel.org,
        herbert@gondor.apana.org.au, will@kernel.org,
        kernel-team@android.com, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v3 1/7] crypto: handle zero sized AEAD inputs correctly
Date:   Wed, 12 May 2021 20:44:33 +0200
Message-Id: <20210512184439.8778-2-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210512184439.8778-1-ardb@kernel.org>
References: <20210512184439.8778-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

There are corner cases where skcipher_walk_aead_[en|de]crypt() may be
invoked with a zero sized input, which is not rejected by the walker
code, but results in the skcipher_walk structure to not be fully
initialized. This will leave stale values in its page and buffer
members, which will be subsequently passed to kfree() or free_page() by
skcipher_walk_done(), resulting in a crash if those routines fail to
identify them as in valid inputs.

Fix this by setting page and buffer to NULL even if the size of the
input is zero.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/skcipher.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index a15376245416..93fdacf49697 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -511,6 +511,8 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 	walk->nbytes = 0;
 	walk->iv = req->iv;
 	walk->oiv = req->iv;
+	walk->buffer = NULL;
+	walk->page = NULL;
 
 	if (unlikely(!walk->total))
 		return 0;
-- 
2.20.1

