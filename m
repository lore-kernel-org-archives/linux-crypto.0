From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: omap-sham: remove unnecessary static in
 omap_sham_remove()
Date: Tue, 18 Jul 2017 18:03:11 -0500
Message-ID: <20170718230311.GA24035@embeddedgus>
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

Remove unnecessary static on local variable dd. Such variable
is initialized before being used, on every execution path throughout
the function. The static has no benefit and, removing it reduces the
object file size.

This issue was detected using Coccinelle and the following semantic patch:
https://github.com/GustavoARSilva/coccinelle/blob/master/static/static_unused.cocci

In the following log you can see a difference in the object file size.
This log is the output of the size command, before and after the code
change:

before:
   text    data     bss     dec     hex filename
  26135   11944     128   38207    953f drivers/crypto/omap-sham.o

after:
   text    data     bss     dec     hex filename
  26084   11856      64   38004    9474 drivers/crypto/omap-sham.o

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/omap-sham.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 9ad9d39..c40ac30 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2133,7 +2133,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 static int omap_sham_remove(struct platform_device *pdev)
 {
-	static struct omap_sham_dev *dd;
+	struct omap_sham_dev *dd;
 	int i, j;
 
 	dd = platform_get_drvdata(pdev);
-- 
2.5.0
