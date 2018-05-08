From: Colin King <colin.king@canonical.com>
Subject: [PATCH] hwrng: n2: fix spelling mistake: "restesting" -> "retesting"
Date: Tue,  8 May 2018 23:18:42 +0100
Message-ID: <20180508221842.22198-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in dev_err error message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/char/hw_random/n2-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 92dd4e925315..f8411515fe1c 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -435,7 +435,7 @@ static int n2rng_data_read(struct hwrng *rng, u32 *data)
 			*data = np->test_data & 0xffffffff;
 			len = 4;
 		} else {
-			dev_err(&np->op->dev, "RNG error, restesting\n");
+			dev_err(&np->op->dev, "RNG error, retesting\n");
 			np->flags &= ~N2RNG_FLAG_READY;
 			if (!(np->flags & N2RNG_FLAG_SHUTDOWN))
 				schedule_delayed_work(&np->work, 0);
-- 
2.17.0
