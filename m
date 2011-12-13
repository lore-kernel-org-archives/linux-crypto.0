From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/7] crypto - lrw: remove dependency on EXPERIMENTAL
Date: Tue, 13 Dec 2011 12:52:51 +0200
Message-ID: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Rik Snel <rsnel@cube.dyndns.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:51375 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1LMKwz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 05:52:55 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

LRW has been EXPERIMENTAL since it was introduced in 2006. I'd say by now
it has seen enough testing to justify removal of EXPERIMENTAL tag.

CC: Rik Snel <rsnel@cube.dyndns.org>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b8d1b10..3cc7511 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -241,8 +241,7 @@ config CRYPTO_ECB
 	  the input block by block.
 
 config CRYPTO_LRW
-	tristate "LRW support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "LRW support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_GF128MUL
