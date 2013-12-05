From: Daniel Borkmann <dborkman@redhat.com>
Subject: [PATCH cryptodev] crypto: memneq: fix for archs without efficient unaligned access
Date: Fri,  6 Dec 2013 00:33:33 +0100
Message-ID: <1386286413-8636-1-git-send-email-dborkman@redhat.com>
Cc: linux-crypto@vger.kernel.org,
	Cesar Eduardo Barros <cesarb@cesarb.eti.br>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab3LEXe4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Dec 2013 18:34:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit fe8c8a126806 introduced a possible build error for archs
that do not have CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS set. :/
Fix this up by bringing else braces outside of the ifdef.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Fixes: fe8c8a126806 ("crypto: more robust crypto_memneq")
Cc: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
---
 Sending stand-alone fix as original patch is already applied.

 crypto/memneq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/memneq.c b/crypto/memneq.c
index 570f6f3..afed1bd 100644
--- a/crypto/memneq.c
+++ b/crypto/memneq.c
@@ -108,8 +108,9 @@ static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
 		OPTIMIZER_HIDE_VAR(neq);
 		neq |= *(unsigned int *)(a+12) ^ *(unsigned int *)(b+12);
 		OPTIMIZER_HIDE_VAR(neq);
-	} else {
+	} else
 #endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
+	{
 		neq |= *(unsigned char *)(a)    ^ *(unsigned char *)(b);
 		OPTIMIZER_HIDE_VAR(neq);
 		neq |= *(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1);
-- 
1.8.3.1
