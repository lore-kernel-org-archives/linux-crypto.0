Return-Path: <SRS0=FTK2=EP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DDA5C55ABD
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 08:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C369620731
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 08:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604910782;
	bh=FsuoJJunC/4tMzPNtstSZSa/79VLpx65XXrmfCpTleI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=V6nh7DOiwCY1jHgF/EQIp+JoR8RrN6oBz+9fjp9hVNAgHE6c6GzJWQ1q6iI8O01x9
	 RRhXNQzsAoJGMHI4bXx0jit6rhnuTQNrC33pmql9ByeLUcCox0T0TIS+oUT0x9XxVi
	 q/DWJj+f9763EJFKdCD5nz1u51KIR7/wwaeATBHI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgKIIdC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Nov 2020 03:33:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgKIIdC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Nov 2020 03:33:02 -0500
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96F952076E;
        Mon,  9 Nov 2020 08:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604910781;
        bh=FsuoJJunC/4tMzPNtstSZSa/79VLpx65XXrmfCpTleI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/QIiIpOwQCCbJvWFf9lk31NXpApXySyLqFG0s9m5vJOZoMBj48sn9VU2ktirr+eg
         5Ap/D9fRipKVdRPO3/hnxiskIL8Tb5NMwDscLUVv4A34dI0hq9SruHAqS+EEu2lOy+
         uFBGNUqSzv4GQuf0VNrCQON5sCV2yKDeMHpmKG1E=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 2/3] crypto: tcrypt - permit tcrypt.ko to be builtin
Date:   Mon,  9 Nov 2020 09:31:42 +0100
Message-Id: <20201109083143.2884-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201109083143.2884-1-ardb@kernel.org>
References: <20201109083143.2884-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When working on crypto algorithms, being able to run tcrypt quickly
without booting an entire Linux installation can be very useful. For
instance, QEMU/kvm can be used to boot a kernel from the command line,
and having tcrypt.ko builtin would allow tcrypt to be executed to run
benchmarks, or to run tests for algortithms that need to be instantiated
from templates, without the need to make it past the point where the
rootfs is mounted.

So let's relax the requirement that tcrypt can only be built as a
module when CRYPTO_MANAGER_EXTRA_TESTS is enabled, as this is already
documented as a crypto development-only symbol.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 094ef56ab7b4..9ff2d687e334 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -201,7 +201,7 @@ config CRYPTO_AUTHENC
 
 config CRYPTO_TEST
 	tristate "Testing module"
-	depends on m
+	depends on m || CRYPTO_MANAGER_EXTRA_TESTS
 	select CRYPTO_MANAGER
 	help
 	  Quick & dirty crypto test module.
-- 
2.17.1

