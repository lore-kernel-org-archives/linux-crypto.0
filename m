From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 1/1] CRYPTO: Fix checkpatch errors & warnings in aes_generic
Date: Wed, 10 Feb 2010 02:48:11 +0100
Message-ID: <1265766491-28159-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Phil Carmody <ext-phil.2.carmody@nokia.com>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:11394 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0BJBsn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 20:48:43 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/aes_generic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
index e78b7ee..a68c73d 100644
--- a/crypto/aes_generic.c
+++ b/crypto/aes_generic.c
@@ -1,4 +1,4 @@
-/* 
+/*
  * Cryptographic API.
  *
  * AES Cipher Algorithm.
@@ -1127,7 +1127,7 @@ EXPORT_SYMBOL_GPL(crypto_il_tab);
 
 #define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) * 0x1b)
 
-#define imix_col(y,x)	do {		\
+#define imix_col(y, x)	do {		\
 	u	= star_x(x);		\
 	v	= star_x(u);		\
 	w	= star_x(v);		\
-- 
1.6.6.1

