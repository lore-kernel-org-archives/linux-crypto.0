From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
Subject: [PATCH 11/11] omap-sham: do not schedule tasklet if there is no active requests
Date: Thu,  2 Jun 2011 21:10:13 +0300
Message-ID: <0cc70c890c54199d93820e603ddd38fd47d7af09.1306926921.git.dmitry.kasatkin@gmail.com>
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
 drivers/crypto/omap-sham.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 804c16b..6399a8f 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1085,6 +1085,11 @@ static irqreturn_t omap_sham_irq(int irq, void *dev_id)
 				 SHA_REG_CTRL_OUTPUT_READY);
 	omap_sham_read(dd, SHA_REG_CTRL);
 
+	if (!test_bit(FLAGS_BUSY, &dd->flags)) {
+		dev_warn(dd->dev, "Interrupt when no active requests.\n");
+		return IRQ_HANDLED;
+	}
+
 	set_bit(FLAGS_OUTPUT_READY, &dd->flags);
 	tasklet_schedule(&dd->done_task);
 
-- 
1.7.4.1

