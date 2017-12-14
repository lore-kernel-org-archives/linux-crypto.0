From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 09/10] staging: ccree: fix fips event irq handling build
Date: Thu, 14 Dec 2017 14:02:46 +0000
Message-ID: <1513260170-26346-10-git-send-email-gilad@benyossef.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

When moving from internal for kernel FIPS infrastructure the FIPS event irq
handling code was left with the old ifdef by mistake. Fix it.

Fixes: b7e607bf33a2 ("staging: ccree: move FIPS support to kernel infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index df6d415..56b5d45 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -123,7 +123,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 		irr &= ~CC_COMP_IRQ_MASK;
 		complete_request(drvdata);
 	}
-#ifdef CC_SUPPORT_FIPS
+#ifdef CONFIG_CRYPTO_FIPS
 	/* TEE FIPS interrupt */
 	if (irr & CC_GPR0_IRQ_MASK) {
 		/* Mask interrupt - will be unmasked in Deferred service
-- 
2.7.4
