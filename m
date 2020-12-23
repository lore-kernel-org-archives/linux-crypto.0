Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC0E7C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A20DE224B0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgLWIOQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:14:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgLWIOP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:14:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3042D22512;
        Wed, 23 Dec 2020 08:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711178;
        bh=gZU5h+3+EaOoF4SX/C9e5RdZA4PwrlP/kPxt0AaR0Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iKhNh3FyKWUCsqIS29saRGqHsC5eS6qYKuPIwzYZsAgPBI3TrWygntpp7WRLNILJ7
         xR29UuidItsqwjG879rJIulFsYJAqdWVgEv5iiezs73frIYde1IDKFXTNmjrUEvWku
         ljjhtWYSejaV0u3ZAE1ZVNN2lIMrasdtF581j8GIlCUbc/dBsS0TN4Pg6z21Va3px4
         1gL8pqO2iwpQP+VXJgrIMpZXbfmixtNn9nnxa63aLI5aOsb9h1F2S1iPUWEefX1nLc
         E4AuoNrwrzm8y15kVLTmm2G6Ptrn/rRt0/NsCzp6UK5O6ie8YvzetTx941LcaXsr5a
         YeBGDJwQw9xRw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 11/14] wireguard: Kconfig: select CRYPTO_BLAKE2S_ARM
Date:   Wed, 23 Dec 2020 00:10:00 -0800
Message-Id: <20201223081003.373663-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223081003.373663-1-ebiggers@kernel.org>
References: <20201223081003.373663-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When available, select the new implementation of BLAKE2s for 32-bit ARM.
This is faster than the generic C implementation.

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/net/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 260f9f46668b8..672fcdd9aecbb 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -90,6 +90,7 @@ config WIREGUARD
 	select CRYPTO_CHACHA20_NEON if (ARM || ARM64) && KERNEL_MODE_NEON
 	select CRYPTO_POLY1305_NEON if ARM64 && KERNEL_MODE_NEON
 	select CRYPTO_POLY1305_ARM if ARM
+	select CRYPTO_BLAKE2S_ARM if ARM
 	select CRYPTO_CURVE25519_NEON if ARM && KERNEL_MODE_NEON
 	select CRYPTO_CHACHA_MIPS if CPU_MIPS32_R2
 	select CRYPTO_POLY1305_MIPS if CPU_MIPS32 || (CPU_MIPS64 && 64BIT)
-- 
2.29.2

