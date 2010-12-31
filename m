From: roel kluin <roel.kluin@gmail.com>
Subject: [PATCH] crypto: dont return PTR_ERR() of wrong pointer
Date: Fri, 31 Dec 2010 16:21:41 +0100
Message-ID: <4D1DF505.3040005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41704 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab0LaPVo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Dec 2010 10:21:44 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix a PTR_ERR() return of the wrong pointer

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/crypto/mv_cesa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 7d279e5..c99305a 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -857,7 +857,7 @@ static int mv_cra_hash_init(struct crypto_tfm *tfm, const char *base_hash_name,
 			printk(KERN_WARNING MV_CESA
 			       "Base driver '%s' could not be loaded!\n",
 			       base_hash_name);
-			err = PTR_ERR(fallback_tfm);
+			err = PTR_ERR(base_hash);
 			goto err_bad_base;
 		}
 	}
