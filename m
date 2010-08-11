From: Andy Isaacson <adi@hexapodia.org>
Subject: [PATCH] crypto/Kconfig: fix typo
Date: Wed, 11 Aug 2010 11:37:17 -0700
Message-ID: <20100811183717.GF20015@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	trivial@kernel.org, Alexander Shishkin <virtuoso@slind.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <d
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from straum.hexapodia.org ([207.7.131.186]:55269 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0HKShR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Aug 2010 14:37:17 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

algolithm -> algorithm

Signed-off-by: Andy Isaacson <adi@hexapodia.org>
---
 crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1cd497d..27484e4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -102,7 +102,7 @@ config CRYPTO_MANAGER2
 	select CRYPTO_PCOMP2
 
 config CRYPTO_MANAGER_TESTS
-	bool "Run algolithms' self-tests"
+	bool "Run algorithms' self-tests"
 	default y
 	depends on CRYPTO_MANAGER2
 	help
-- 
1.7.1
