From: David Miller <davem@davemloft.net>
Subject: [PATCH] crypto: Niagara2 driver needs to depend upon CRYPTO_DES.
Date: Thu, 09 Sep 2010 21:10:23 -0700 (PDT)
Message-ID: <20100909.211023.242144504.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59672
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751036Ab0IJEKF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Sep 2010 00:10:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Reported-by: Dennis Gilmore <dennis@ausil.us>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ea0b386..ad1cd59 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -172,6 +172,7 @@ config CRYPTO_DEV_MV_CESA
 
 config CRYPTO_DEV_NIAGARA2
        tristate "Niagara2 Stream Processing Unit driver"
+       select CRYPTO_DES
        select CRYPTO_ALGAPI
        depends on SPARC64
        help
