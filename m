From: Valdis.Kletnieks@vt.edu
Subject: [PATCH V2] fix typo in crypto/Kconfig
Date: Wed, 09 Nov 2011 01:29:20 -0500
Message-ID: <20111.1320820160@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:37912 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1KIG3d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Nov 2011 01:29:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix a typo in the Kconfig file help text.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
---
Third time's the charm? Rebased to next-20111108 ("depends on NET"
caused the first 2 tries to not appy).

--- linux-next/crypto/Kconfig.dist	2011-11-06 01:35:20.423166379 -0400
+++ linux-next/crypto/Kconfig	2011-11-09 01:21:15.325935266 -0500
@@ -105,7 +105,7 @@ config CRYPTO_USER
 	depends on NET
 	select CRYPTO_MANAGER
 	help
-	  Userapace configuration for cryptographic instantiations such as
+	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
 
 config CRYPTO_MANAGER_DISABLE_TESTS
