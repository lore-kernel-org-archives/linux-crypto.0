From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: cavium: clean up clang warning on unread variable offset
Date: Thu, 12 Oct 2017 17:44:06 +0100
Message-ID: <20171012164406.31934-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Srikanth Jampala <Jampala.Srikanth@cavium.com>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable offset is being assigned and not being used; it should
be passed as the 2nd argument to call to function nitrox_write_csr
but has been omitted. Fix this.

Cleans up clang warning: Value stored to 'offset' is never read

Fixes: 14fa93cdcd9b ("crypto: cavium - Add support for CNN55XX adapters.")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/cavium/nitrox/nitrox_hal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cavium/nitrox/nitrox_hal.c
index f0655f82fa7d..73275ce6a668 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
@@ -126,7 +126,7 @@ void nitrox_config_pkt_input_rings(struct nitrox_device *ndev)
 		 * size and interrupt threshold.
 		 */
 		offset = NPS_PKT_IN_INSTR_BADDRX(i);
-		nitrox_write_csr(ndev, NPS_PKT_IN_INSTR_BADDRX(i), cmdq->dma);
+		nitrox_write_csr(ndev, offset, cmdq->dma);
 
 		/* configure ring size */
 		offset = NPS_PKT_IN_INSTR_RSIZEX(i);
-- 
2.14.1
