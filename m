Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83156C61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Feb 2023 03:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjBFDdB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Feb 2023 22:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBFDdB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Feb 2023 22:33:01 -0500
Received: from aib29gb127.yyz1.oracleemaildelivery.com (aib29gb127.yyz1.oracleemaildelivery.com [192.29.72.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A541631B
        for <linux-crypto@vger.kernel.org>; Sun,  5 Feb 2023 19:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CmS6jCxptoO9vSmseA54nl/palyPlbLDD4usnOrfUsw=;
 b=VrEjxSoeHVMZ8XzbB9f2rGlavK9harItP9NQoKHyaysaPXqEcBoLlSry1JQnYWJ4ic6tJs/47EOa
   oA8WQkXsPGkQT8iTb9WTQFSDFstlUNzv2cP7GmGeNVIHOrJ1ClQFXxBzpXSC2PvRjnFbOIScvgHA
   GFWgJaKGob8Jcw/L5O55BMdfEPYiVGPt7FYkaR7dikwRm3risCVU1p2MlTaJjB/4LXHunOqtZwlH
   M3tjqKLLxwNckGkKeCZl2zYr1tu86+7QSPfCw0a+VmpSDJo3nkGWMq8Q3KF/7ccqG3ghxWMhI/u8
   rdcknnQn3d8fM7hfGbaAB7cckvZhkcRf8NeBoQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=CmS6jCxptoO9vSmseA54nl/palyPlbLDD4usnOrfUsw=;
 b=PeE1o5D4w5VffTcykvKNbJuI5zhWN1pb7iyhonUJefMTCNvWlmBWSy0iyhPtyGtH3obpC4Neoh9i
   qzUbhzjFLq3fFG2Sn5Y2iYlO9YIdk+a/dxe5M5UtgBd8tAAXOpJeEnOLRuu4Cdi3nW3kJogR6QJ5
   Iw9oQtH+MQafSKK8ZoVXZsSo4zxvW2WyCHX0TtT5dNz4yMXXVmTu8awoVaVN8Jov+kpZlgNtLUYa
   jz+1rXApmZBpl6tuR6JxBbOrRZXMLIdeqQPuTLJIzSWQ3CcRyeniMbDJJkbu2K0aWsN5f7w/xw5L
   hxHp8LHN1+cqxF8ouB/HszXfmDHbQ12WuG0L7Q==
Received: by omta-ad1-fd3-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230123 64bit (built Jan 23
 2023))
 with ESMTPS id <0RPN00E8X36YFX80@omta-ad1-fd3-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Mon, 06 Feb 2023 03:32:58 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH 3/3] crypto: x86/twofish-3way - Remove unused macro argument
Date:   Sun,  5 Feb 2023 22:31:35 -0500
Message-id: <39dcdd3216a4163e43cb922892047c86a2a6abef.1675653010.git.peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
In-reply-to: <cover.1675653010.git.peter@n8pjl.ca>
References: <cover.1675653010.git.peter@n8pjl.ca>
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAFM0bY0qh8/6zbmsPQzEX+WOYHeLRhAzCfu1eznTJ2bOIpFPUo5XCr17EtjzhYF
 ut6+H4y7kaUVFnofIfQnlKq4IAriR8XX+Jwp6k3m3MpVF0yDCmm+nqOlqAWyCytQ
 czXTsFm00VVBGr7AjRZ24JrQT5IAZ80lxhw26fMs4X9S8AcVolPEu+/OA0TSAeiR
 kI72ZH1lanIoqMhJBXVxRytrl9XAdTbXBg/u9A1fTpMTtSiQKI44wGRy5qweo1nb
 gSpjEYRflxDx2A1bAUEQmww2Hl97wQDYcdzO3egQU2rDMI9JsC0+9/fDoAnSFDNK
 pB2shxth1mfBU4O/CdcncN2DIiZmRwamBHbsmq4mJShrKi62mZFNwFMoKJQKaEOz
 a2xP6ake2mamGClKJq5zqLfItsbAPZKx12NwFSTafl5nxbhBzbJS6KUsjbn4hdU=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The outunpack3() macro has an op parameter that is only ever called with
"mov". Removing that argument altogether leads to gains to code
readability. There is no effect on the resulting binary.

Signed-off-by: Peter Lafreniere <peter@n8pjl.ca>
---
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S | 24 ++++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
index 29e0fe664386..c2cd9b5406da 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64-3way.S
@@ -182,23 +182,23 @@
 	movq 4*(8+(n))(in),		xy ## 2; \
 	xorq w+4*m(CTX),		xy ## 2;
 
-#define outunpack3(op, out, n, xy, m) \
+#define outunpack3(out, n, xy, m) \
 	xorq w+4*m(CTX),		xy ## 0; \
-	op ## q xy ## 0,		4*(n)(out); \
+	movq xy ## 0,			4*(n)(out); \
 	\
 	xorq w+4*m(CTX),		xy ## 1; \
-	op ## q xy ## 1,		4*(4+(n))(out); \
+	movq xy ## 1,			4*(4+(n))(out); \
 	\
 	xorq w+4*m(CTX),		xy ## 2; \
-	op ## q xy ## 2,		4*(8+(n))(out);
+	movq xy ## 2,			4*(8+(n))(out);
 
 #define inpack_enc3() \
 	inpack3(RIO, 0, RAB, 0); \
 	inpack3(RIO, 2, RCD, 2);
 
-#define outunpack_enc3(op) \
-	outunpack3(op, RIO, 2, RAB, 6); \
-	outunpack3(op, RIO, 0, RCD, 4);
+#define outunpack_enc3() \
+	outunpack3(RIO, 2, RAB, 6); \
+	outunpack3(RIO, 0, RCD, 4);
 
 #define inpack_dec3() \
 	inpack3(RIO, 0, RAB, 4); \
@@ -214,11 +214,11 @@
 	rorq $32,			RCD0; \
 	rorq $32,			RCD1; \
 	rorq $32,			RCD2; \
-	outunpack3(mov, RIO, 0, RCD, 0); \
+	outunpack3(RIO, 0, RCD, 0); \
 	rorq $32,			RAB0; \
 	rorq $32,			RAB1; \
 	rorq $32,			RAB2; \
-	outunpack3(mov, RIO, 2, RAB, 2);
+	outunpack3(RIO, 2, RAB, 2);
 
 #define outunpack_cbc_dec3() \
 	rorq $32,			RCD0; \
@@ -226,13 +226,13 @@
 	xorq (RT1),			RCD1; \
 	rorq $32,			RCD2; \
 	xorq 16(RT1),			RCD2; \
-	outunpack3(mov, RIO, 0, RCD, 0); \
+	outunpack3(RIO, 0, RCD, 0); \
 	rorq $32,			RAB0; \
 	rorq $32,			RAB1; \
 	xorq 8(RT1),			RAB1; \
 	rorq $32,			RAB2; \
 	xorq 24(RT1),			RAB2; \
-	outunpack3(mov, RIO, 2, RAB, 2);
+	outunpack3(RIO, 2, RAB, 2);
 
 SYM_FUNC_START(twofish_enc_blk_3way)
 	/* input:
@@ -261,7 +261,7 @@ SYM_FUNC_START(twofish_enc_blk_3way)
 
 	popq RIO; /* dst */
 
-	outunpack_enc3(mov);
+	outunpack_enc3();
 
 	popq %rbx;
 	popq %r12;
-- 
2.39.1

