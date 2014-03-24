From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 3/3] crypto: x86/sha1 - reduce size of the AVX2 asm implementation
Date: Mon, 24 Mar 2014 17:10:39 +0100
Message-ID: <1395677439-7478-4-git-send-email-minipli@googlemail.com>
References: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Marek Vasut <marex@denx.de>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:64826 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaCXQKv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Mar 2014 12:10:51 -0400
Received: by mail-bk0-f49.google.com with SMTP id my13so566251bkb.36
        for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2014 09:10:50 -0700 (PDT)
In-Reply-To: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

There is really no need to page align sha1_transform_avx2. The default
alignment is just fine. This is not the hot code but only the entry
point, after all.

Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Marek Vasut <marex@denx.de>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/crypto/sha1_avx2_x86_64_asm.S |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/crypto/sha1_avx2_x86_64_asm.S b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
index bacac22b20..1cd792db15 100644
--- a/arch/x86/crypto/sha1_avx2_x86_64_asm.S
+++ b/arch/x86/crypto/sha1_avx2_x86_64_asm.S
@@ -623,7 +623,6 @@ _loop3:
  */
 .macro SHA1_VECTOR_ASM  name
 	ENTRY(\name)
-	.align 4096
 
 	push	%rbx
 	push	%rbp
-- 
1.7.10.4
