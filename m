From: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Subject: [PATCH 03/13] serial: 8250_dma: Support for deferred probing when requesting DMA channels
Date: Tue, 26 May 2015 16:25:58 +0300
Message-ID: <1432646768-12532-4-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>,
	Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
To: <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Switch to use ma_request_slave_channel_compat_reason() to request the DMA
channels. In case of error, return the error code we received including
-EPROBE_DEFER

Signed-off-by: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
CC: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
---
 drivers/tty/serial/8250/8250_dma.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 21d01a491405..a617eca4e97d 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -182,21 +182,19 @@ int serial8250_request_dma(struct uart_8250_port *p)
 	dma_cap_set(DMA_SLAVE, mask);
 
 	/* Get a channel for RX */
-	dma->rxchan = dma_request_slave_channel_compat(mask,
-						       dma->fn, dma->rx_param,
-						       p->port.dev, "rx");
-	if (!dma->rxchan)
-		return -ENODEV;
+	dma->rxchan = dma_request_slave_channel_compat_reason(mask, dma->fn,
+					dma->rx_param, p->port.dev, "rx");
+	if (IS_ERR(dma->rxchan))
+		return PTR_ERR(dma->rxchan);
 
 	dmaengine_slave_config(dma->rxchan, &dma->rxconf);
 
 	/* Get a channel for TX */
-	dma->txchan = dma_request_slave_channel_compat(mask,
-						       dma->fn, dma->tx_param,
-						       p->port.dev, "tx");
-	if (!dma->txchan) {
+	dma->txchan = dma_request_slave_channel_compat_reason(mask, dma->fn,
+					dma->tx_param, p->port.dev, "tx");
+	if (IS_ERR(dma->txchan)) {
 		dma_release_channel(dma->rxchan);
-		return -ENODEV;
+		return PTR_ERR(dma->txchan);
 	}
 
 	dmaengine_slave_config(dma->txchan, &dma->txconf);
-- 
2.3.5

--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
