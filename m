From: Anatoly Pugachev <matorola@gmail.com>
Subject: [PATCH 2/2] n2rng: Attach on T5/M5, T7/M7 SPARC CPUs
Date: Mon, 25 Jan 2016 19:09:39 +0300
Message-ID: <20160125160939.GB26873@yogzotot>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sparclinux@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

n2rng: Attach on T5/M5, T7/M7 SPARC CPUs

Signed-off-by: Anatoly Pugachev <matorola@gmail.com>
---
 drivers/char/hw_random/n2-drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 843d6f6..8bee43a 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -743,6 +743,16 @@ static const struct of_device_id n2rng_match[] = {
 		.compatible	= "SUNW,kt-rng",
 		.data		= (void *) 1,
 	},
+	{
+		.name           = "random-number-generator",
+		.compatible     = "ORCL,m4-rng",
+		.data           = (void *) 1,
+	},
+	{
+		.name           = "random-number-generator",
+		.compatible     = "ORCL,m7-rng",
+		.data           = (void *) 1,
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(of, n2rng_match);
-- 
2.7.0

