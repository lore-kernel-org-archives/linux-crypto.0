From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: atmel-sha: remove unnecessary static in
 atmel_sha_remove()
Date: Tue, 18 Jul 2017 18:04:45 -0500
Message-ID: <20170718230444.GA23140@embeddedgus>
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

Remove unnecessary static on local variable sha_dd. Such variable
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
  30005   10264     128   40397    9dcd drivers/crypto/atmel-sha.o

after:
   text    data     bss     dec     hex filename
  29934   10208      64   40206    9d0e drivers/crypto/atmel-sha.o

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/atmel-sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index dad4e5b..3e2f41b 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -2883,7 +2883,7 @@ static int atmel_sha_probe(struct platform_device *pdev)
 
 static int atmel_sha_remove(struct platform_device *pdev)
 {
-	static struct atmel_sha_dev *sha_dd;
+	struct atmel_sha_dev *sha_dd;
 
 	sha_dd = platform_get_drvdata(pdev);
 	if (!sha_dd)
-- 
2.5.0
