From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 7/7] crypto - gf128mul: remove leftover "(EXPERIMENTAL)" in
 Kconfig
Date: Tue, 13 Dec 2011 12:53:22 +0200
Message-ID: <20111213105322.14934.85321.stgit@localhost6.localdomain6>
References: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:51494 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab1LMKxY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 05:53:24 -0500
In-Reply-To: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CRYPTO_GF128MUL does not select EXPERIMENTAL anymore so remove the
"(EXPERIMENTAL)" from its name.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index d7d4d4e..7ae0d0f 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -117,7 +117,7 @@ config CRYPTO_MANAGER_DISABLE_TESTS
 	  algorithm registration.
 
 config CRYPTO_GF128MUL
-	tristate "GF(2^128) multiplication functions (EXPERIMENTAL)"
+	tristate "GF(2^128) multiplication functions"
 	help
 	  Efficient table driven implementation of multiplications in the
 	  field GF(2^128).  This is needed by some cypher modes. This
