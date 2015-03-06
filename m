From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2 12/17] crypto: talitos - Define compatible in talitos2.h instead of talitos.c
Date: Fri,  6 Mar 2015 17:41:26 +0100 (CET)
Message-ID: <20150306164126.0695F1A241C@localhost.localdomain>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 drivers/crypto/talitos.c  | 4 +---
 drivers/crypto/talitos2.h | 2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8b627d0..0262e75 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1972,9 +1972,7 @@ err_out:
 }
 
 static const struct of_device_id talitos_match[] = {
-	{
-		.compatible = "fsl,sec2.0",
-	},
+	TALITOS_OF_COMPATIBLE,
 	{},
 };
 MODULE_DEVICE_TABLE(of, talitos_match);
diff --git a/drivers/crypto/talitos2.h b/drivers/crypto/talitos2.h
index 7edc563..7177088 100644
--- a/drivers/crypto/talitos2.h
+++ b/drivers/crypto/talitos2.h
@@ -316,3 +316,5 @@ static irqreturn_t talitos_interrupt_##name(int irq, void *data)	       \
 	return (isr & (ch_done_mask | ch_err_mask) || isr_lo) ? IRQ_HANDLED :  \
 								IRQ_NONE;      \
 }
+
+#define TALITOS_OF_COMPATIBLE	{.compatible = "fsl,sec2.0",}
-- 
2.1.0
