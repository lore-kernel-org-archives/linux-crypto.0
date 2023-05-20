Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 375BAC77B7A
	for <linux-crypto@archiver.kernel.org>; Sat, 20 May 2023 17:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjETRbt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 May 2023 13:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjETRbs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 May 2023 13:31:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD3FB0
        for <linux-crypto@vger.kernel.org>; Sat, 20 May 2023 10:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C6D860A09
        for <linux-crypto@vger.kernel.org>; Sat, 20 May 2023 17:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD60C433EF
        for <linux-crypto@vger.kernel.org>; Sat, 20 May 2023 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684603907;
        bh=KFAvUu+44FKYgASeRDY3GAaD0FCGvbMA2vTyDUhjC0k=;
        h=From:To:Subject:Date:From;
        b=vH2cz99+xqQwkHUArh9OO8Q2B/Gg1Z/PWhe67WhF1NPRV9Xbbh0BkJzRNgPI7sr91
         i3fIiB8b1vB2RqqBTf9Ln1Wsx6uzrHtbrErZhe60wZGFGChs7PFXySU9nuHqoQbiWf
         /ImGVHI11x9hdacw2ajz1sr6SPiPpoVkCFr2SjSIrldQ8Mpmy46ghg37Xw2vXcjYJV
         7Mn+uTssYrWv5tRGxeCFlI9VJh/pVS4Pk78YertlkUmF2F3buDGNs0G4bqmE4vIwoo
         0weJZN2uO8gvruKfn8KTLuav5ZZL7K0rs/ZmfqEVpOJqWxe8ykISP2kJEz4jpwW/Cb
         7du63nXER34xQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto/Kconfig: warn about performance overhead of CRYPTO_STATS
Date:   Sat, 20 May 2023 10:31:05 -0700
Message-Id: <20230520173105.8562-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make the help text for CRYPTO_STATS explicitly mention that it reduces
the performance of the crypto API.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 42751d63cd4d9..fdf3742f1106b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1393,6 +1393,9 @@ config CRYPTO_STATS
 	help
 	  Enable the gathering of crypto stats.
 
+	  Enabling this option reduces the performance of the crypto API.  It
+	  should only be enabled when there is actually a use case for it.
+
 	  This collects data sizes, numbers of requests, and numbers
 	  of errors processed by:
 	  - AEAD ciphers (encrypt, decrypt)

base-commit: f573db7aa528f11820dcc811bc7791b231d22b1c
-- 
2.40.1

