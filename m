From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 1/9] crypto: omap-sham - Remove unnecessary pr_info noise
Date: Fri, 21 Dec 2012 10:04:01 -0700
Message-ID: <1356109449-11624-2-git-send-email-mgreer@animalcreek.com>
References: <1356109449-11624-1-git-send-email-mgreer@animalcreek.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	"Mark A. Greer" <mgreer@animalcreek.com>,
	Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1356109449-11624-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: "Mark A. Greer" <mgreer@animalcreek.com>

Remove the unnecessary pr_info() call in omap_sham_mod_init().

CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
---
 drivers/crypto/omap-sham.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 1d75e6f..2df7a54 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1286,8 +1286,6 @@ static struct platform_driver omap_sham_driver = {
 
 static int __init omap_sham_mod_init(void)
 {
-	pr_info("loading %s driver\n", "omap-sham");
-
 	return platform_driver_register(&omap_sham_driver);
 }
 
-- 
1.7.12

