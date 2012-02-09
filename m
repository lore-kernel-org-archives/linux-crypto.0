From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] X86, crypto: remove dead code from
 serpent_sse2_glue.c::serpent_sse2_init()
Date: Thu, 9 Feb 2012 23:16:04 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202092314340.32491@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: trivial@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>
To: x86@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26735 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403Ab2BIWP2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Feb 2012 17:15:28 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We cannot reach the line after 'return err'. Remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/x86/crypto/serpent_sse2_glue.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/serpent_sse2_glue.c b/arch/x86/crypto/serpent_sse2_glue.c
index 7955a9b..de81cf4 100644
--- a/arch/x86/crypto/serpent_sse2_glue.c
+++ b/arch/x86/crypto/serpent_sse2_glue.c
@@ -1025,7 +1025,6 @@ static int __init serpent_sse2_init(void)
 		goto ablk_xts_err;
 	return err;
 
-	crypto_unregister_alg(&ablk_xts_alg);
 ablk_xts_err:
 	crypto_unregister_alg(&blk_xts_alg);
 blk_xts_err:
-- 
1.7.9


PS. Please CC me on replies.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
