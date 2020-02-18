Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7243CC34047
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 19:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BCDC24672
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 19:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582055939;
	bh=rser7L/TlChhfAw4/EWBy5Mt4/UXpcAt5CSaJhFUou8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=z+tics9JYnzTeCbABJkc2hr3zvZpz+pmUrIKuHxYSw4O2Ywnh8uD6w/835NMjiCVz
	 KlvvK99HxF8487ATLKTpKB7ReYSH+frJDBT5MdlrF4TKdDiZP9mAHO5NVkXCKkJ/4a
	 FMc+u9UCDRxx3pLZGeFXYgqHzRCKUZyaVAOAiC6Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgBRT65 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 14:58:57 -0500
Received: from foss.arm.com ([217.140.110.172]:60426 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbgBRT64 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:58:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 241B4FEC;
        Tue, 18 Feb 2020 11:58:56 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98B4F3F68F;
        Tue, 18 Feb 2020 11:58:55 -0800 (PST)
From:   Mark Brown <broonie@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 01/18] arm64: crypto: Modernize some extra assembly annotations
Date:   Tue, 18 Feb 2020 19:58:25 +0000
Message-Id: <20200218195842.34156-2-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218195842.34156-1-broonie@kernel.org>
References: <20200218195842.34156-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A couple of functions were missed in the modernisation of assembly macros,
update them too.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index 084c6a30b03a..6b958dcdf136 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -587,20 +587,20 @@ CPU_LE(	rev		w8, w8		)
 	 *			  struct ghash_key const *k, u64 dg[], u8 ctr[],
 	 *			  int rounds, u8 tag)
 	 */
-ENTRY(pmull_gcm_encrypt)
+SYM_FUNC_START(pmull_gcm_encrypt)
 	pmull_gcm_do_crypt	1
-ENDPROC(pmull_gcm_encrypt)
+SYM_FUNC_END(pmull_gcm_encrypt)
 
 	/*
 	 * void pmull_gcm_decrypt(int blocks, u8 dst[], const u8 src[],
 	 *			  struct ghash_key const *k, u64 dg[], u8 ctr[],
 	 *			  int rounds, u8 tag)
 	 */
-ENTRY(pmull_gcm_decrypt)
+SYM_FUNC_START(pmull_gcm_decrypt)
 	pmull_gcm_do_crypt	0
-ENDPROC(pmull_gcm_decrypt)
+SYM_FUNC_END(pmull_gcm_decrypt)
 
-pmull_gcm_ghash_4x:
+SYM_FUNC_START_LOCAL(pmull_gcm_ghash_4x)
 	movi		MASK.16b, #0xe1
 	shl		MASK.2d, MASK.2d, #57
 
@@ -681,9 +681,9 @@ pmull_gcm_ghash_4x:
 	eor		XL.16b, XL.16b, T2.16b
 
 	ret
-ENDPROC(pmull_gcm_ghash_4x)
+SYM_FUNC_END(pmull_gcm_ghash_4x)
 
-pmull_gcm_enc_4x:
+SYM_FUNC_START_LOCAL(pmull_gcm_enc_4x)
 	ld1		{KS0.16b}, [x5]			// load upper counter
 	sub		w10, w8, #4
 	sub		w11, w8, #3
@@ -746,7 +746,7 @@ pmull_gcm_enc_4x:
 	eor		INP3.16b, INP3.16b, KS3.16b
 
 	ret
-ENDPROC(pmull_gcm_enc_4x)
+SYM_FUNC_END(pmull_gcm_enc_4x)
 
 	.section	".rodata", "a"
 	.align		6
-- 
2.20.1

