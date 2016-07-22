From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH 2/2] crypto: ixp4xx - Add missing npe_c release in error branches
Date: Fri, 22 Jul 2016 15:32:41 +0200
Message-ID: <20160722133242.21916-2-lambert.quentin@gmail.com>
References: <20160722133242.21916-1-lambert.quentin@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
	Quentin Lambert <lambert.quentin@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160722133242.21916-1-lambert.quentin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Most error branches following the call to npe_request contain a call to
npe_request. This patch add a call to npe_release to error branches
following the call to npe_request that do not have it.

This issue was found with Hector.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 If I am right in thinking that these call to npe_release are missing, another
 solution would be to jump to err since the rest of the code does it.

 drivers/crypto/ixp4xx_crypto.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -448,7 +448,7 @@ static int init_ixp_crypto(struct device
 	if (!npe_running(npe_c)) {
 		ret = npe_load_firmware(npe_c, npe_name(npe_c), dev);
 		if (ret)
-			return ret;
+			goto npe_release;
 		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
 			goto npe_error;
 	} else {
@@ -472,7 +472,8 @@ static int init_ixp_crypto(struct device
 	default:
 		printk(KERN_ERR "Firmware of %s lacks crypto support\n",
 			npe_name(npe_c));
-		return -ENODEV;
+		ret = -ENODEV;
+		goto npe_release;
 	}
 	/* buffer_pool will also be used to sometimes store the hmac,
 	 * so assure it is large enough
@@ -511,6 +512,7 @@ npe_error:
 err:
 	dma_pool_destroy(ctx_pool);
 	dma_pool_destroy(buffer_pool);
+npe_release:
 	npe_release(npe_c);
 	return ret;
 }
