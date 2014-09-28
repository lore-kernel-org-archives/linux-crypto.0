From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/3] crypto: aesni - remove unused defines in "by8" variant
Date: Sun, 28 Sep 2014 22:24:00 +0200
Message-ID: <1411935841-11294-3-git-send-email-minipli@googlemail.com>
References: <1411935841-11294-1-git-send-email-minipli@googlemail.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57438 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaI1UY0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Sep 2014 16:24:26 -0400
Received: by mail-wi0-f178.google.com with SMTP id ho1so738238wib.17
        for <linux-crypto@vger.kernel.org>; Sun, 28 Sep 2014 13:24:25 -0700 (PDT)
In-Reply-To: <1411935841-11294-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The defines for xkey3, xkey6 and xkey9 are not used in the code. They're
probably left overs from merging the three source files for 128, 192 and
256 bit AES. They can safely be removed.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index a029bc744244..2df2a0298f5a 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -79,9 +79,6 @@
 #define xcounter	%xmm8
 #define xbyteswap	%xmm9
 #define xkey0		%xmm10
-#define xkey3		%xmm11
-#define xkey6		%xmm12
-#define xkey9		%xmm13
 #define xkey4		%xmm11
 #define xkey8		%xmm12
 #define xkey12		%xmm13
-- 
1.7.10.4
