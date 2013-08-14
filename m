From: John Haxby <john.haxby@oracle.com>
Subject: [PATCH 1/1] Check for osxsave as well as avx in crypto/xor
Date: Wed, 14 Aug 2013 16:23:18 +0100
Message-ID: <1376493798-9668-2-git-send-email-john.haxby@oracle.com>
References: <1376493798-9668-1-git-send-email-john.haxby@oracle.com>
Cc: linux-crypto@vger.kernel.org, John Haxby <john.haxby@oracle.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
	" \"David S. Miller\"" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from inet-emmc03-o.oracle.co.uk ([193.9.13.135]:49957 "EHLO
	sheep.uk.oracle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014Ab3HNPfc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Aug 2013 11:35:32 -0400
In-Reply-To: <1376493798-9668-1-git-send-email-john.haxby@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This affects xen pv guests with sufficiently old versions of xen and
sufficiently new hardware.  On such a system, a guest with a btrfs
root won't even boot.

Signed-off-by: John Haxby <john.haxby@oracle.com>
---
 arch/x86/include/asm/xor_avx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
index 7ea79c5..492b298 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -167,12 +167,12 @@ static struct xor_block_template xor_block_avx = {
 
 #define AVX_XOR_SPEED \
 do { \
-	if (cpu_has_avx) \
+	if (cpu_has_avx && cpu_has_osxsave) \
 		xor_speed(&xor_block_avx); \
 } while (0)
 
 #define AVX_SELECT(FASTEST) \
-	(cpu_has_avx ? &xor_block_avx : FASTEST)
+	(cpu_has_avx && cpu_has_osxsave ? &xor_block_avx : FASTEST)
 
 #else
 
-- 
1.8.1.4
