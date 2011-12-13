From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 3/7] crypto - twofish-x86_64-3way: select LRW and XTS
Date: Tue, 13 Dec 2011 12:53:01 +0200
Message-ID: <20111213105301.14934.42601.stgit@localhost6.localdomain6>
References: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:51409 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab1LMKxE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Dec 2011 05:53:04 -0500
In-Reply-To: <20111213105251.14934.61565.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

twofish-x86_64-3way uses functions from LRW and XTS modules, so selecting would
appear to be better option than using #ifdefs in twofish_glue_3way.c to
enable/disable LRW and XTS features.

This also fixes build problem when twofish-x86_64-3way would be build into
kernel but XTS/LRW are build as modules.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index a77cd8e..3cd303b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -876,6 +876,8 @@ config CRYPTO_TWOFISH_X86_64_3WAY
 	select CRYPTO_ALGAPI
 	select CRYPTO_TWOFISH_COMMON
 	select CRYPTO_TWOFISH_X86_64
+	select CRYPTO_LRW
+	select CRYPTO_XTS
 	help
 	  Twofish cipher algorithm (x86_64, 3-way parallel).
 
