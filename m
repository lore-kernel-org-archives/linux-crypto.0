From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in des_generic.c
Date: Wed, 10 Feb 2010 02:34:38 +0100
Message-ID: <1265765679-26485-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53956 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab0BJBfN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 20:35:13 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/des_generic.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index 5bd3ee3..249f903 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -869,8 +869,7 @@ static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 
 	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
 		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
-		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY))
-	{
+		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
 		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
 		return -EINVAL;
 	}
-- 
1.6.6.1

