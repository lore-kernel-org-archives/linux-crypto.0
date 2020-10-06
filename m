Return-Path: <SRS0=C5lZ=DN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB067C4363D
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 03:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B03F1208A9
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 03:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgJFDs5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 23:48:57 -0400
Received: from foss.arm.com ([217.140.110.172]:36992 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbgJFDs5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 23:48:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A340B113E;
        Mon,  5 Oct 2020 20:48:56 -0700 (PDT)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 960893F70D;
        Mon,  5 Oct 2020 20:48:56 -0700 (PDT)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux-crypto@vger.kernel.org, broonie@kernel.org, ardb@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: [BUG][PATCH] crypto: arm64: Avoid indirect branch to bti_c
Date:   Mon,  5 Oct 2020 22:48:54 -0500
Message-Id: <20201006034854.2277538-1-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The AES code uses a 'br x7' as part of a function called by
a macro. That branch needs a bti_j as a target. This results
in a panic as seen below. Instead of trying to replace the branch
target with a bti_jc, lets replace the indirect branch with a
bl/ret, bl sequence that can target the existing bti_c.

  Bad mode in Synchronous Abort handler detected on CPU1, code 0x34000003 -- BTI
  CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch64 #1
  pstate: 20400c05 (nzCv daif +PAN -UAO BTYPE=j-)
  pc : aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
  lr : aesbs_xts_encrypt+0x48/0xe0 [aes_neon_bs]
  sp : ffff80001052b730

  aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
   __xts_crypt+0xb0/0x2dc [aes_neon_bs]
   xts_encrypt+0x28/0x3c [aes_neon_bs]
  crypto_skcipher_encrypt+0x50/0x84
  simd_skcipher_encrypt+0xc8/0xe0
  crypto_skcipher_encrypt+0x50/0x84
  test_skcipher_vec_cfg+0x224/0x5f0
  test_skcipher+0xbc/0x120
  alg_test_skcipher+0xa0/0x1b0
  alg_test+0x3dc/0x47c
  cryptomgr_test+0x38/0x60

Fixes: commit 0e89640b640d ("crypto: arm64 - Use modern annotations for assembly functions")
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 arch/arm64/crypto/aes-neonbs-core.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/aes-neonbs-core.S b/arch/arm64/crypto/aes-neonbs-core.S
index b357164379f6..32f53ebe5e2c 100644
--- a/arch/arm64/crypto/aes-neonbs-core.S
+++ b/arch/arm64/crypto/aes-neonbs-core.S
@@ -788,7 +788,7 @@ SYM_FUNC_START_LOCAL(__xts_crypt8)
 
 0:	mov		bskey, x21
 	mov		rounds, x22
-	br		x7
+	ret
 SYM_FUNC_END(__xts_crypt8)
 
 	.macro		__xts_crypt, do8, o0, o1, o2, o3, o4, o5, o6, o7
@@ -806,8 +806,8 @@ SYM_FUNC_END(__xts_crypt8)
 	uzp1		v30.4s, v30.4s, v25.4s
 	ld1		{v25.16b}, [x24]
 
-99:	adr		x7, \do8
-	bl		__xts_crypt8
+99:	bl		__xts_crypt8
+	bl 		\do8
 
 	ldp		q16, q17, [sp, #.Lframe_local_offset]
 	ldp		q18, q19, [sp, #.Lframe_local_offset + 32]
-- 
2.25.4

