From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] crypto: inside-secure: safexcel - fix memory allocation
Date: Mon, 8 Oct 2018 21:17:12 +0200
Message-ID: <20181008191712.GA12892@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The original intention is to allocate space for EIP197_DEFAULT_RING_SIZE
*pointers* to struct, so sizeof(priv->ring[i].rdr_req) should be
sizeof(*priv->ring[i].rdr_req).

Addresses-Coverity-ID: 1473962 ("Sizeof not portable")
Fixes: 9744fec95f06 ("crypto: inside-secure - remove request list to improve performance")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 86c699c1..bc6c5cb 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1066,7 +1066,7 @@ static int safexcel_probe(struct platform_device *pdev)
 
 		priv->ring[i].rdr_req = devm_kcalloc(dev,
 			EIP197_DEFAULT_RING_SIZE,
-			sizeof(priv->ring[i].rdr_req),
+			sizeof(*priv->ring[i].rdr_req),
 			GFP_KERNEL);
 		if (!priv->ring[i].rdr_req) {
 			ret = -ENOMEM;
-- 
2.7.4
