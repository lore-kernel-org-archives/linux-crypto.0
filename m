From: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] crypto: sha-mb: Fix big integer constant sparse warning
Date: Thu,  5 Feb 2015 10:29:35 +0000
Message-ID: <1423132175-6800-1-git-send-email-prabhakar.csengg@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52077 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbbBEK3v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2015 05:29:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following sparse warning:

sha1_mb_mgr_init_avx2.c:59:31: warning: constant 0xF76543210 is so big it is long

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c b/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
index 4ca7e16..822acb5 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
@@ -56,7 +56,7 @@
 void sha1_mb_mgr_init_avx2(struct sha1_mb_mgr *state)
 {
 	unsigned int j;
-	state->unused_lanes = 0xF76543210;
+	state->unused_lanes = 0xF76543210ULL;
 	for (j = 0; j < 8; j++) {
 		state->lens[j] = 0xFFFFFFFF;
 		state->ldata[j].job_in_lane = NULL;
-- 
1.9.1
