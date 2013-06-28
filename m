From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] fix typo in comment
Date: Fri, 28 Jun 2013 15:56:20 +0300
Message-ID: <1372424180-23969-1-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<trivial@kernel.org>,
	Cristian Stoica <cristian.stoica@freescale.com>
To: <herbert@gondor.hengli.com.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:52723 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754506Ab3F1M7F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Jun 2013 08:59:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 crypto/api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..733e4ef 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -397,7 +397,7 @@ EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
  *	@mask: Mask for type comparison
  *
  *	This function should not be used by new algorithm types.
- *	Plesae use crypto_alloc_tfm instead.
+ *	Please use crypto_alloc_tfm instead.
  *
  *	crypto_alloc_base() will first attempt to locate an already loaded
  *	algorithm.  If that fails and the kernel supports dynamically loadable
-- 
1.8.1.5
