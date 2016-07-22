From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH 1/2] crypto: ixp4xx - Fix a "simple if" coding style warning
Date: Fri, 22 Jul 2016 15:32:42 +0200
Message-ID: <20160722133242.21916-3-lambert.quentin@gmail.com>
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

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/crypto/ixp4xx_crypto.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -447,9 +447,8 @@ static int init_ixp_crypto(struct device
 
 	if (!npe_running(npe_c)) {
 		ret = npe_load_firmware(npe_c, npe_name(npe_c), dev);
-		if (ret) {
+		if (ret)
 			return ret;
-		}
 		if (npe_recv_message(npe_c, msg, "STATUS_MSG"))
 			goto npe_error;
 	} else {
