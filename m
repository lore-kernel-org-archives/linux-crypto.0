From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/7] crypto - xts: remove dependency on EXPERIMENTAL
Date: Tue, 13 Dec 2011 12:52:56 +0200
Message-ID: <20111213105256.14934.20772.stgit@localhost6.localdomain6>
References: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Rik Snel <rsnel@cube.dyndns.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:45041 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1LMKw7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 05:52:59 -0500
In-Reply-To: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

XTS has been EXPERIMENTAL since it was introduced in 2007. I'd say by now
it has seen enough testing to justify removal of EXPERIMENTAL tag.

CC: Rik Snel <rsnel@cube.dyndns.org>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/Kconfig |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3cc7511..a77cd8e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -261,8 +261,7 @@ config CRYPTO_PCBC
 	  This block cipher algorithm is required for RxRPC.
 
 config CRYPTO_XTS
-	tristate "XTS support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	tristate "XTS support"
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_MANAGER
 	select CRYPTO_GF128MUL
