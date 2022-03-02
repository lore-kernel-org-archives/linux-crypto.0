Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D64C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 16:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiCBQzl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 11:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbiCBQzk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 11:55:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5003F5640D
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 08:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E06E9B820D0
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 16:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92B3C340ED;
        Wed,  2 Mar 2022 16:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646240093;
        bh=jdRPRHTRy3udzvsKCj00x/7JkQhJ1JxPOp38h0Sv3T0=;
        h=From:To:Cc:Subject:Date:From;
        b=LuuTsJ11Jcwwf6an0H14+jQ64CUZrWBm1/WtFkmLYtrLADcBs+goQ0BreaikOLvk7
         Fkj51Oo4B8my5JcEUClLhvjovWWW1aIVRatStXWGN26ZQwYwwjMC2ofDK7LIEGiyo3
         iIZhhpSH9VfAos04MTbAcZvesMPlFbE6HqGWtcJqxIPOAas4zaMNCARD2EYM65NuPG
         A46n2NZ1ALpHIBhylSB4IOQ9zoNU0ojjeoK7hZ8yNRCC/6E6QGR/WGvX3k6XheGYQ/
         iV/C2FwOTpTCeFfpghzt1D4y8jl28El7Du1dVtFYkNFjLiFnyt1YgGv3xUytqwdEwi
         g/hzCRGLARisg==
From:   Mark Brown <broonie@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH] arm64: crypto: Don't allow v8.2 extensions to be used with BROKEN_GAS_INST
Date:   Wed,  2 Mar 2022 16:54:38 +0000
Message-Id: <20220302165438.1140256-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1973; h=from:subject; bh=jdRPRHTRy3udzvsKCj00x/7JkQhJ1JxPOp38h0Sv3T0=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiH5/eHqq6x7Be353oQD4PdIF+0Mtq58vnDm+YzaCT hwPWU3yJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYh+f3gAKCRAk1otyXVSH0LgSB/ 9byWLMEI6QYG6+9qNujF4bsQFqCe49kp8iTLWLaIZtLZ8y5fYwQiF1kIOYFpktqo5Q4Ih6egA/g8O4 CKhuofHRPE/ArV7jrkZzf51an5+W2OjuhhBDO9fHz2/D0JdVuU9A2yijyaretKToKB5Qkt8Zr2UhMu lBMFbqI2TGjr9z6lbTcZVVuhVQH9xDOilvUptUBOMZub3ySQlRY34SEBn+bI+fjdoi4Hg/0sUpxnNl MrKXxyhXbUeayThzhbRVATr/Su7d/FDl0LAIGtz4WFnI9i+o8On0vCjCBCR2U+PQ13ezhryT38r1Ow WnPZ464GwA6Ez0QyXH+nV98n/unCa7
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We support building the kernel with archaic versions of binutils which
had some confusion regarding how instructions should be encoded for .inst
which we work around with the __emit_inst() macro. Unfortunately we have
not consistently used this macro, one of the places where it's missed being
the macros that manually encode v8.2 crypto instructions. This means that
kernels built with such toolchains have never supported use of the affected
instructions correctly.

Since these toolchains are very old (some idle research suggested 2015
era) it seems more sensible to just refuse to build v8.2 crypto support
with them, in the unlikely event that someone has a need to use such a
toolchain to build a kernel which will run on a system with v8.2 crypto
support they can always fix this properly but it seems more likely that
we will deprecate support for these toolchains and remove __emit_inst()
before that happens.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/crypto/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index 2a965aa0188d..90dd62d46739 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -32,12 +32,14 @@ config CRYPTO_SHA2_ARM64_CE
 config CRYPTO_SHA512_ARM64_CE
 	tristate "SHA-384/SHA-512 digest algorithm (ARMv8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
+	depends on !BROKEN_GAS_INST
 	select CRYPTO_HASH
 	select CRYPTO_SHA512_ARM64
 
 config CRYPTO_SHA3_ARM64
 	tristate "SHA3 digest algorithm (ARMv8.2 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
+	depends on !BROKEN_GAS_INST
 	select CRYPTO_HASH
 	select CRYPTO_SHA3
 
@@ -50,6 +52,7 @@ config CRYPTO_SM3_ARM64_CE
 config CRYPTO_SM4_ARM64_CE
 	tristate "SM4 symmetric cipher (ARMv8.2 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
+	depends on !BROKEN_GAS_INST
 	select CRYPTO_ALGAPI
 	select CRYPTO_LIB_SM4
 
-- 
2.30.2

