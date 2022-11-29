Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B79C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Nov 2022 16:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbiK2QzJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Nov 2022 11:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbiK2Qyh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2022 11:54:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C956314E
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 08:49:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3204B816AA
        for <linux-crypto@vger.kernel.org>; Tue, 29 Nov 2022 16:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B56C4347C;
        Tue, 29 Nov 2022 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669740547;
        bh=ZbRwMgdjVH/Qv9iqeuJCWB3YxvidsTfyQPViGNEqq1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeSuO3dTjzVms3bDEpHzf6u680KHgxUIlXZEEfpMZH821ItLirr5iPD2YTTn/0I64
         uM4vsMqwEX6LZ1M/9ZJrkUpD0qbsQsxvO1Aak/iExpoDt/YGvC8ajM/9WvMdTObWyp
         8wx67kgIThXzhTOsMk1ZwV8SJI06/6mmttXaqjNREY2sw5p4xem9OvknL5Esz0wFYS
         PHbePp1Kc5hRUcaflxbUYlxX460QCMOU7/DvsJMsbXi/srwNoFmTgz8k0TwANqrRMS
         hX8rGUSVGAktUg4sq5iFvAPCyQD1WQEkEntdjTUaGxb6CYe65z+UUqGXd98EyyP/R8
         KuxfHvWRtbNaA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        keescook@chromium.org, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 3/4] crypto: arm64/crct10dif - use frame_push/pop macros consistently
Date:   Tue, 29 Nov 2022 17:48:51 +0100
Message-Id: <20221129164852.2051561-4-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129164852.2051561-1-ardb@kernel.org>
References: <20221129164852.2051561-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=969; i=ardb@kernel.org; h=from:subject; bh=ZbRwMgdjVH/Qv9iqeuJCWB3YxvidsTfyQPViGNEqq1g=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjhjfy6E1CYBE5bA5UpH3kQV3+cRFcI1P5dLV9IY/s RFrVwgSJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY4Y38gAKCRDDTyI5ktmPJNnaC/ 4sswyi115VJR32FGSYpUMS9BQWIlkfr+KNf4ZFr+UnlZdPNK7jazRVYrbAqI12bmz0NA8IIArLk/cF OxjUj0WBzb9/DuCcCl9iSyQy9P4Fk4KQqP9mGPxIEDmvh+qw5Epmesll83fIGkHa9jy3Er2JKRD9dh KsEvWjd4ul1BeCia9c9krSLmAisHQpBluTjbRnZhWYM9ilu1pzXF6d7vB7U2t19ejfevs5O8eIiKC+ e3gEdSJGphj4ZLCrYCOu1kK0oGeMXAdAnpY0Kc38bcaos03if662W05afUnocj1zkkxgYvH5DxAW5s phXYcG77CqJX5csK5+o/gzrwcPFZrW8yWpvhvMgj7nCew8tYbS7oSQ8nt5pYaUXzBb7qVEjFjivNvn LqxttqtYYrAH/QgpbmanXK3tb85ihEnMX4iav3zAjHSDWYB42W3SxkTFStdErAd7OFZpiJtP0/u80C 4/kDW3E2FYp8sa0gOB/RcWmydl+yCeRpE/BzOl4CTPyAA=
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
 arch/arm64/crypto/crct10dif-ce-core.S | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
index dce6dcebfca189ee..5604de61d06d04ee 100644
--- a/arch/arm64/crypto/crct10dif-ce-core.S
+++ b/arch/arm64/crypto/crct10dif-ce-core.S
@@ -429,7 +429,7 @@ CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
 
 	umov		w0, v0.h[0]
 	.ifc		\p, p8
-	ldp		x29, x30, [sp], #16
+	frame_pop
 	.endif
 	ret
 
@@ -466,8 +466,7 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 // Assumes len >= 16.
 //
 SYM_FUNC_START(crc_t10dif_pmull_p8)
-	stp		x29, x30, [sp, #-16]!
-	mov		x29, sp
+	frame_push	1
 	crc_t10dif_pmull p8
 SYM_FUNC_END(crc_t10dif_pmull_p8)
 
-- 
2.35.1

