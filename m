From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v3 10/10] crypto: marvell: Increase the size of the crypto
 queue
Date: Tue, 21 Jun 2016 10:08:40 +0200
Message-ID: <1466496520-28806-11-git-send-email-romain.perier@free-electrons.com>
References: <1466496520-28806-1-git-send-email-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
 Russell King <linux@arm.linux.org.uk>, linux-crypto@vger.kernel.org,
 Gregory Clement <gregory.clement@free-electrons.com>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
 Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1466496520-28806-1-git-send-email-romain.perier@free-electrons.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Now that crypto requests are chained together at the DMA level, we
increase the size of the crypto queue for each engine. The result is
that as the backlog list is reached later, it does not stop the crypto
stack from sending asychronous requests, so more cryptographic tasks
are processed by the engines.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index bb91156..5147073 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -32,7 +32,7 @@
 #include "cesa.h"
 
 /* Limit of the crypto queue before reaching the backlog */
-#define CESA_CRYPTO_DEFAULT_MAX_QLEN 50
+#define CESA_CRYPTO_DEFAULT_MAX_QLEN 128
 
 static int allhwsupport = !IS_ENABLED(CONFIG_CRYPTO_DEV_MV_CESA);
 module_param_named(allhwsupport, allhwsupport, int, 0444);
-- 
2.7.4
