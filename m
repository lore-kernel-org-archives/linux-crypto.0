From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] X86, crypto: Remove dead code from
 twofish_glue_3way.c::init()
Date: Thu, 9 Feb 2012 23:02:16 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202092300300.32491@swampdragon.chaosbits.net>
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
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26550 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294Ab2BIWBk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Feb 2012 17:01:40 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We can never reach the line just after the 'return 0'
statement. Remove it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/x86/crypto/twofish_glue_3way.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 7fee8c1..adba7b3 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -659,7 +659,6 @@ int __init init(void)
 
 	return 0;
 
-	crypto_unregister_alg(&blk_xts_alg);
 blk_xts_err:
 	crypto_unregister_alg(&blk_lrw_alg);
 blk_lrw_err:
-- 
1.7.9


PS. Please CC me on replies.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
