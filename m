From: Nadim Almas <nadim.902@gmail.com>
Subject: [PATCH] Crypto: mv_cesa: Switch to using managed resources
Date: Wed, 2 Nov 2016 17:28:45 +0530
Message-ID: <20161102115845.GA8386@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Switch to resource-managed function devm_kzalloc instead
of kzalloc and remove unneeded kfree

Also, remove kfree in probe function and remove
function, mv_remove as it is now has nothing to do.
The Coccinelle semantic patch used to make this change is as follows:
//<smpl>
@platform@
identifier p, probefn, removefn;
@@
struct platform_driver p = {
.probe = probefn,
.remove = removefn,
};

@prb@
identifier platform.probefn, pdev;
expression e, e1, e2;
@@
probefn(struct platform_device *pdev, ...) {
<+...
- e = kzalloc(e1, e2)
+ e = devm_kzalloc(&pdev->dev, e1, e2)
...
?-kfree(e);
...+>
}
@rem depends on prb@
identifier platform.removefn;
expression prb.e;
@@
removefn(...) {
<...
- kfree(e);
...>
}
//</smpl>

Signed-off-by: Nadim Almas <nadim.902@gmail.com>
---
 drivers/crypto/mv_cesa.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 104e9ce..451fa18 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1073,7 +1073,7 @@ static int mv_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENXIO;
 
-	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
+	cp = devm_kzalloc(&pdev->dev, sizeof(*cp), GFP_KERNEL);
 	if (!cp)
 		return -ENOMEM;
 
@@ -1163,7 +1163,6 @@ static int mv_probe(struct platform_device *pdev)
 err_thread:
 	kthread_stop(cp->queue_th);
 err:
-	kfree(cp);
 	cpg = NULL;
 	return ret;
 }
@@ -1187,7 +1186,6 @@ static int mv_remove(struct platform_device *pdev)
 		clk_put(cp->clk);
 	}
 
-	kfree(cp);
 	cpg = NULL;
 	return 0;
 }
-- 
2.7.4
