Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86297C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Nov 2022 16:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbiK2QzU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Nov 2022 11:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbiK2Qyr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2022 11:54:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4805A6C731
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 08:49:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD360B816D7
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 16:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25902C433C1;
        Tue, 29 Nov 2022 16:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669740549;
        bh=3Un66ME/YBPoZ24cwKV2SzyOGE4rdUdVCnXFE16r1Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrPzwmJn+Uzlk2qfvMsFlHfr7nYLwjTrf8hIXl8ZGblfO3nAeBjZAZcJpBkiyAO+0
         Og7nddGuFBk5xEXTjQ1ilIp1suOjIrWzpAbFIBAQ/U8u61HudlCu+B3fWeorzqLG6I
         Wi6ix9L+hL/8xXtWeybFbMeEMqzQVpE8ySR4zTa5+yXPqeDjdvNiY4MWKvWpr3u3bj
         jmUci7kl9k1Y/oh4i0UHEacHbfygFhoz58U3k6/OcbnpQ4bzQdqnq9XNEoepu/jvzd
         PLyf9PQfJEPtcxi4LQHraKlfhmUNsJUm+DFzDNo7JqszSZwyor76L2FWOrGLigHC4u
         2l1cbiZqFvDyw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        keescook@chromium.org, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4/4] crypto: arm64/ghash-ce - use frame_push/pop macros consistently
Date:   Tue, 29 Nov 2022 17:48:52 +0100
Message-Id: <20221129164852.2051561-5-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129164852.2051561-1-ardb@kernel.org>
References: <20221129164852.2051561-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1139; i=ardb@kernel.org; h=from:subject; bh=3Un66ME/YBPoZ24cwKV2SzyOGE4rdUdVCnXFE16r1Hk=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjhjfz7YFBiwxd4UCpUDmgUSpDwO1YjaGw6iPNEpQA xESGIOGJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY4Y38wAKCRDDTyI5ktmPJFT6C/ sF5tQASYPPFPqCfks/slJwKDkEn1/KblsnebUqsqmFgYYABVWf9MJVuRJjqAjU1jxRTqfjRRcSpiRx dB2Qc7uFXi1uzSBaH2buSUDhwQZsYgdF8OI0nb+yzxEVIh0TCvfH/fXtxCTrP16Nxldah+KIf/0+At qLf34PeQfclrpvN97TuM/j4mSReZwD/yKgm0VhYhMdB+04eWwE5L+srf7kZPOETYghj7ZNu0rnAv26 yZ3bVLLOgsSy+trqMQeFxYrNUQfzpd1sVnxtcWZa9/Zbtat0xnqPUOET3hTfEj0PiAS8O5WAFWEO3f 9BAm366mdRjLzNNwVmRgPurNE5j5R+rZXCh1bUY4wSWZFjada9IX0bGVEUHGEKp6VMd50eUjeN3tkV C45MmZ3T1OKAfn4rUvjLZBzN/oYNVrVE0lr6H5Nrtjs0eek1bRM7e3V+MIIFd9MfuALtbh86SPp+M5 rrvosJOtW2uQk1M0870mDdqvZdECg7yT+efsLih8zuuHI=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the frame_push and frame_pop macros to set up the stack frame so
that return address protections will be enabled automically when
configured.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-core.S | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-core.S b/arch/arm64/crypto/ghash-ce-core.S
index ebe5558929b7bba6..23ee9a5eaf27c23c 100644
--- a/arch/arm64/crypto/ghash-ce-core.S
+++ b/arch/arm64/crypto/ghash-ce-core.S
@@ -436,9 +436,7 @@ SYM_FUNC_END(pmull_ghash_update_p8)
 
 	.align		6
 	.macro		pmull_gcm_do_crypt, enc
-	stp		x29, x30, [sp, #-32]!
-	mov		x29, sp
-	str		x19, [sp, #24]
+	frame_push	1
 
 	load_round_keys	x7, x6, x8
 
@@ -529,7 +527,7 @@ CPU_LE(	rev		w8, w8		)
 	.endif
 	bne		0b
 
-3:	ldp		x19, x10, [sp, #24]
+3:	ldr		x10, [sp, #.Lframe_local_offset]
 	cbz		x10, 5f				// output tag?
 
 	ld1		{INP3.16b}, [x10]		// load lengths[]
@@ -562,7 +560,7 @@ CPU_LE(	rev		w8, w8		)
 	smov		w0, v0.b[0]			// return b0
 	.endif
 
-4:	ldp		x29, x30, [sp], #32
+4:	frame_pop
 	ret
 
 5:
-- 
2.35.1

