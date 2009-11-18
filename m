From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH -next] crypto: ghash - put proper .data section in place
Date: Wed, 18 Nov 2009 17:15:44 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911181713200.15039@wotan.suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491AbZKRQPk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Nov 2009 11:15:40 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Lbswap_mask, Lpoly and Ltwo_one should clearly belong to
.data section, not .text.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/x86/crypto/ghash-clmulni-intel_asm.S |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index 5958498..24f84e1 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -19,6 +19,8 @@
 #include <linux/linkage.h>
 #include <asm/i387.h>
 
+.data
+
 .align 16
 .Lbswap_mask:
 	.octa 0x000102030405060708090a0b0c0d0e0f
-- 
1.5.6
