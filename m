From: Joel Fernandes <joelf@ti.com>
Subject: [PATCH v2 03/14] crypto: omap-aes: Populate number of SG elements
Date: Sat, 17 Aug 2013 21:42:24 -0500
Message-ID: <1376793755-30478-4-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Joel Fernandes <joelf@ti.com>, Linux OMAP List <linux-omap@vger.kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.hengli.com.au>, "David S. Miller"
 <davem@davemloft.net>, Mark Greer <mgreer@animalcreek.com>, Tony Lindgren
 <tony@atomide.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Rajendra
 Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
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

Crypto layer only passes nbytes but number of SG elements is needed for mapping
or unmapping SGs at one time using dma_map* API and also needed to pass in for
dmaengine prep function.

We call function added to scatterwalk for this purpose in omap_aes_handle_queue
to populate the values which are used later.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 26b802b..e369e6e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -164,6 +164,8 @@ struct omap_aes_dev {
 	void			*buf_out;
 	int			dma_out;
 	struct dma_chan		*dma_lch_out;
+	int			in_sg_len;
+	int			out_sg_len;
 	dma_addr_t		dma_addr_out;
 
 	const struct omap_aes_pdata	*pdata;
@@ -731,6 +733,10 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 	dd->out_offset = 0;
 	dd->out_sg = req->dst;
 
+	dd->in_sg_len = scatterwalk_bytes_sglen(dd->in_sg, dd->total);
+	dd->out_sg_len = scatterwalk_bytes_sglen(dd->out_sg, dd->total);
+	BUG_ON(dd->in_sg_len < 0 || dd->out_sg_len < 0);
+
 	rctx = ablkcipher_request_ctx(req);
 	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
 	rctx->mode &= FLAGS_MODE_MASK;
-- 
1.7.9.5
