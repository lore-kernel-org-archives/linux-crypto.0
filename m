Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B2CC43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 21:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6363524684
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 21:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576012118;
	bh=z88IOY+YMC7QchWuaCMq11vzPMHWIBYHvXtSH+ltZno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RZI6DOMIF8gVxmmdsM91rd/1QgjRd9Xa/agb3bOhU8lHqcBguSJ4dqrgzlllJNqm0
	 DX86BGnw3VWhr3/FmYo8xvrLs0guNjh9cWJIOKsC2btJY3Fs1sWzDJkuztAO+BgwWF
	 snkDKypfwGhF+rKQnruhgRafLw6GDyfiLpT17tUk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfLJVIf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 16:08:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:56022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbfLJVIe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 16:08:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 218A024698;
        Tue, 10 Dec 2019 21:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012114;
        bh=z88IOY+YMC7QchWuaCMq11vzPMHWIBYHvXtSH+ltZno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lgs/TjuJkw6n0n0QB9Vc0UakrsCZ0SF2PrXqV1YygnPg3ngDNUTlCw93rdCp2JWHO
         +VuSmyLTQHuV3b/07gjeE3pSyXaYvisEbgpRYR3S2X2cu7H1vP+DMSZYFGSQBTym36
         SjT7hOeYJ3rFdvuiZjeeyQvn6K9HfMNugC63AGFs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        ci_notify@linaro.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.4 086/350] crypto: aegis128/simd - build 32-bit ARM for v8 architecture explicitly
Date:   Tue, 10 Dec 2019 16:03:11 -0500
Message-Id: <20191210210735.9077-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

[ Upstream commit 830536770f968ab33ece123b317e252c269098db ]

Now that the Clang compiler has taken it upon itself to police the
compiler command line, and reject combinations for arguments it views
as incompatible, the AEGIS128 no longer builds correctly, and errors
out like this:

  clang-10: warning: ignoring extension 'crypto' because the 'armv7-a'
  architecture does not support it [-Winvalid-command-line-argument]

So let's switch to armv8-a instead, which matches the crypto-neon-fp-armv8
FPU profile we specify. Since neither were actually supported by GCC
versions before 4.8, let's tighten the Kconfig dependencies as well so
we won't run into errors when building with an ancient compiler.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: <ci_notify@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9e524044d3128..29472fb795f34 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -309,6 +309,7 @@ config CRYPTO_AEGIS128
 config CRYPTO_AEGIS128_SIMD
 	bool "Support SIMD acceleration for AEGIS-128"
 	depends on CRYPTO_AEGIS128 && ((ARM || ARM64) && KERNEL_MODE_NEON)
+	depends on !ARM || CC_IS_CLANG || GCC_VERSION >= 40800
 	default y
 
 config CRYPTO_AEGIS128_AESNI_SSE2
-- 
2.20.1

