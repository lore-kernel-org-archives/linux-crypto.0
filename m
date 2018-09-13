From: Christoph Manszewski <c.manszewski@samsung.com>
Subject: [PATCH 1/4] crypto: s5p-sss: Fix race in error handling
Date: Thu, 13 Sep 2018 09:58:39 +0200
Message-ID: <20180913075857eucas1p2cbccf3cd452a23eb46a234acb37b3a44~T5q8CpLOD2420024200eucas1p24@eucas1p2.samsung.com>
References: <1536825522-6027-1-git-send-email-c.manszewski@samsung.com>
        <CGME20180913075857eucas1p2cbccf3cd452a23eb46a234acb37b3a44@eucas1p2.samsung.com>
Content-Type: text/plain; charset="utf-8"
Cc: Christoph Manszewski <c.manszewski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536825522-6027-1-git-send-email-c.manszewski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove a race condition introduced by error path in functions:
s5p_aes_interrupt and s5p_aes_crypt_start. Setting the busy field of
struct s5p_aes_dev to false made it possible for s5p_tasklet_cb to
change the req field, before s5p_aes_complete was called.

Change the first parameter of s5p_aes_complete to struct
ablkcipher_request. Before spin_unlock, make a copy of the currently
handled request, to ensure s5p_aes_complete function call with the
correct request.

Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
---
 drivers/crypto/s5p-sss.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index faa282074e5a..0cf3f12d8f74 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -475,9 +475,9 @@ static void s5p_sg_done(struct s5p_aes_dev *dev)
 }
 
 /* Calls the completion. Cannot be called with dev->lock hold. */
-static void s5p_aes_complete(struct s5p_aes_dev *dev, int err)
+static void s5p_aes_complete(struct ablkcipher_request *req, int err)
 {
-	dev->req->base.complete(&dev->req->base, err);
+	req->base.complete(&req->base, err);
 }
 
 static void s5p_unset_outdata(struct s5p_aes_dev *dev)
@@ -655,6 +655,7 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 {
 	struct platform_device *pdev = dev_id;
 	struct s5p_aes_dev *dev = platform_get_drvdata(pdev);
+	struct ablkcipher_request *req;
 	int err_dma_tx = 0;
 	int err_dma_rx = 0;
 	int err_dma_hx = 0;
@@ -725,9 +726,10 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 		if (err_dma_hx == 1)
 			s5p_set_dma_hashdata(dev, dev->hash_sg_iter);
 
+		req = dev->req;
 		spin_unlock_irqrestore(&dev->lock, flags);
 
-		s5p_aes_complete(dev, 0);
+		s5p_aes_complete(req, 0);
 		/* Device is still busy */
 		tasklet_schedule(&dev->tasklet);
 	} else {
@@ -755,8 +757,9 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 	if (err_dma_hx == 1)
 		s5p_set_dma_hashdata(dev, dev->hash_sg_iter);
 
+	req = dev->req;
 	spin_unlock_irqrestore(&dev->lock, flags);
-	s5p_aes_complete(dev, err);
+	s5p_aes_complete(req, err);
 
 hash_irq_end:
 	/*
@@ -1983,7 +1986,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	s5p_sg_done(dev);
 	dev->busy = false;
 	spin_unlock_irqrestore(&dev->lock, flags);
-	s5p_aes_complete(dev, err);
+	s5p_aes_complete(req, err);
 }
 
 static void s5p_tasklet_cb(unsigned long data)
-- 
2.7.4
