Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF47C8300C
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 11:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35B5D22264
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 11:04:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmQdy6un"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgKTLEo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 06:04:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728031AbgKTLEn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 06:04:43 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C1752240C;
        Fri, 20 Nov 2020 11:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605870283;
        bh=7dARuHu9cbQ3I9Ea9HX6JH6SkE+ivGjF5QmcCmGwUvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmQdy6unjaZyCFBf/TWAYUJWfZy/CdBA0QDz3JGIs6hQ1yTR4F3jPvNE6BqG1+clJ
         JjbXOl7JfnPtQWPJtoiYAEXKjv6ktjunyU0jVsTvun6NThHwsQxmU6+pRrjia37iyZ
         F91qUCGXUGZB0hOUYDtqZKzE7F/rnMbIl+qh3Buc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH v2 2/3] crypto: tcrypt - permit tcrypt.ko to be builtin
Date:   Fri, 20 Nov 2020 12:04:32 +0100
Message-Id: <20201120110433.31090-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201120110433.31090-1-ardb@kernel.org>
References: <20201120110433.31090-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When working on crypto algorithms, being able to run tcrypt quickly
without booting an entire Linux installation can be very useful. For
instance, QEMU/kvm can be used to boot a kernel from the command line,
and having tcrypt.ko builtin would allow tcrypt to be executed to run
benchmarks, or to run tests for algorithms that need to be instantiated
from templates, without the need to make it past the point where the
rootfs is mounted.

So let's relax the requirement that tcrypt can only be built as a module
when CONFIG_EXPERT is enabled.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 094ef56ab7b4..9014a0ec6a0e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -201,7 +201,7 @@ config CRYPTO_AUTHENC
 
 config CRYPTO_TEST
 	tristate "Testing module"
-	depends on m
+	depends on m || EXPERT
 	select CRYPTO_MANAGER
 	help
 	  Quick & dirty crypto test module.
-- 
2.17.1

