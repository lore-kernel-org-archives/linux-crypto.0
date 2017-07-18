From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: img-hash: remove unnecessary static in
 img_hash_remove()
Date: Tue, 18 Jul 2017 18:07:12 -0500
Message-ID: <20170718230712.GA15507@embeddedgus>
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

Remove unnecessary static on local variable hdev. Such variable
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
  14842    6464     128   21434    53ba drivers/crypto/img-hash.o

after:
   text    data     bss     dec     hex filename
  14789    6376      64   21229    52ed drivers/crypto/img-hash.o

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/img-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 0c6a917..b87000a 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -1054,7 +1054,7 @@ static int img_hash_probe(struct platform_device *pdev)
 
 static int img_hash_remove(struct platform_device *pdev)
 {
-	static struct img_hash_dev *hdev;
+	struct img_hash_dev *hdev;
 
 	hdev = platform_get_drvdata(pdev);
 	spin_lock(&img_hash.lock);
-- 
2.5.0
