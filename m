From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in ecb.c
Date: Wed, 10 Feb 2010 02:35:08 +0100
Message-ID: <1265765709-26802-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53956 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab0BJBfo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 20:35:44 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/ecb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/ecb.c b/crypto/ecb.c
index a46838e..935cfef 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -55,7 +55,7 @@ static int crypto_ecb_crypt(struct blkcipher_desc *desc,
 
 		do {
 			fn(crypto_cipher_tfm(tfm), wdst, wsrc);
-	
+
 			wsrc += bsize;
 			wdst += bsize;
 		} while ((nbytes -= bsize) >= bsize);
-- 
1.6.6.1

