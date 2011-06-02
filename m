From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: [PATCH 09/11] omap-sham: irq handler must not clear error code
Date: Thu,  2 Jun 2011 21:10:11 +0300
Message-ID: <a959ed5c34ee0db81c50127988232e6de66ee8ef.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org,
	Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
In-Reply-To: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
References: <cover.1306926921.git.dmitry.kasatkin@gmail.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a8de7b8..7ca7075 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1084,7 +1084,6 @@ static irqreturn_t omap_sham_irq(int irq, void *dev_id)
 	omap_sham_read(dd, SHA_REG_CTRL);
 
 	set_bit(FLAGS_OUTPUT_READY, &dd->flags);
-	dd->err = 0;
 	tasklet_schedule(&dd->done_task);
 
 	return IRQ_HANDLED;
-- 
1.7.4.1

