From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: atmel-tdes: remove unnecessary static in
 atmel_tdes_remove()
Date: Tue, 18 Jul 2017 18:05:50 -0500
Message-ID: <20170718230550.GA11042@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove unnecessary static on local variable tdes_dd. Such variable
is initialized before being used, on every execution path throughout
the function. The static has no benefit and, removing it reduces the
object file size.

This issue was detected using Coccinelle and the following semantic patch:
https://github.com/GustavoARSilva/coccinelle/blob/master/static/static_unused.cocci

In the following log you can see a significant difference in the object
file size. This log is the output of the size command, before and after
the code change:

before:
   text    data     bss     dec     hex filename
  17079    8704     128   25911    6537 drivers/crypto/atmel-tdes.o

after:
   text    data     bss     dec     hex filename
  17039    8616      64   25719    6477 drivers/crypto/atmel-tdes.o

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/atmel-tdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index b25f1b3..f4b335d 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1487,7 +1487,7 @@ static int atmel_tdes_probe(struct platform_device *pdev)
 
 static int atmel_tdes_remove(struct platform_device *pdev)
 {
-	static struct atmel_tdes_dev *tdes_dd;
+	struct atmel_tdes_dev *tdes_dd;
 
 	tdes_dd = platform_get_drvdata(pdev);
 	if (!tdes_dd)
-- 
2.5.0
