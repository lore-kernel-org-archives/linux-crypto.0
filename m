Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50991C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 26 May 2022 09:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiEZJgW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 May 2022 05:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238729AbiEZJgV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 May 2022 05:36:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB875A45C
        for <linux-crypto@vger.kernel.org>; Thu, 26 May 2022 02:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 294B4B81F7F
        for <linux-crypto@vger.kernel.org>; Thu, 26 May 2022 09:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F19CC385A9;
        Thu, 26 May 2022 09:36:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="NCzvigq6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653557773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LhRpIcB8qtwyX5nMLtDc/qxWcla2iV5VbxNiAGGPiU0=;
        b=NCzvigq6ul9AyQEb6lT2XcHS4sta6kkz7RyxdvIsttRXyZG8nj9bRzkF4jyUnT+yP1mILK
        OwvRsic5Hj+0Za8VH3Udg/18bABmhBkZ+lkcgXLMkHm7hJQAn1JrsS6qO8bRIYo/LPMup3
        3aa+hzaTUd+cZtCGEgSX8ejPRnBaB4o=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8b02b4d9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 26 May 2022 09:36:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH crypto] crypto: poly1305 - cleanup stray CRYPTO_LIB_POLY1305_RSIZE
Date:   Thu, 26 May 2022 11:35:47 +0200
Message-Id: <20220526093547.212294-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When CRYPTO_LIB_POLY1305 is unset, CRYPTO_LIB_POLY1305_RSIZE is still
set in the Kconfig, cluttering things. Fix this by making
CRYPTO_LIB_POLY1305_RSIZE depend on CRYPTO_LIB_POLY1305.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 lib/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 379a66d7f504..a80b8c4dc2cf 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -85,6 +85,7 @@ config CRYPTO_LIB_POLY1305_RSIZE
 	default 11 if X86_64
 	default 9 if ARM || ARM64
 	default 1
+	depends on CRYPTO_LIB_POLY1305
 
 config CRYPTO_ARCH_HAVE_LIB_POLY1305
 	tristate
-- 
2.35.1

