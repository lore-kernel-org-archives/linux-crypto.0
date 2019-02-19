Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3575EC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 15:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05DA021738
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 15:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfBSPwh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:52:37 -0500
Received: from hirvola.fi ([95.183.53.103]:42889 "EHLO hirvola.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfBSPwh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 10:52:37 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2019 10:52:36 EST
Received: by hirvola.fi (Postfix, from userid 1000)
        id 92323C0FA8; Tue, 19 Feb 2019 17:45:54 +0200 (EET)
Date:   Tue, 19 Feb 2019 17:45:54 +0200
From:   Tommi Hirvola <tommi@hirvola.fi>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: x86/poly1305 - Clear key material from stack in SSE2
 variant
Message-ID: <20190219154554.GA3009@hirvola.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1-block SSE2 variant of poly1305 stores variables s1..s4 containing key
material on the stack. This commit adds missing zeroing of the stack
memory. Benchmarks show negligible performance hit (tested on i7-3770).

Signed-off-by: Tommi Hirvola <tommi@hirvola.fi>
---
Similarly, poly1305_blocks() in crypto/poly1305_generic.c stores s1..s4
as well as r0..r4 to local variables which may be stored in the stack by
the compiler. Fixing that is less trivial and left for another patch.

Tests were run with poly1305_simd_blocks() patched to call only 1-block
SSE2 poly1305 function.
---
 arch/x86/crypto/poly1305-sse2-x86_64.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/crypto/poly1305-sse2-x86_64.S b/arch/x86/crypto/poly1305-sse2-x86_64.S
index c88c670cb5fc..e6add74d78a5 100644
--- a/arch/x86/crypto/poly1305-sse2-x86_64.S
+++ b/arch/x86/crypto/poly1305-sse2-x86_64.S
@@ -272,6 +272,10 @@ ENTRY(poly1305_block_sse2)
 	dec		%rcx
 	jnz		.Ldoblock
 
+	# Zeroing of key material
+	mov		%rcx,0x00(%rsp)
+	mov		%rcx,0x08(%rsp)
+
 	add		$0x10,%rsp
 	pop		%r12
 	pop		%rbx
-- 
2.20.1

