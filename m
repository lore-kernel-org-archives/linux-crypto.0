From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Tue, 23 Sep 2008 20:55:21 +0400
Message-ID: <20080923165521.GA26513@2ka.mipt.ru>
References: <48D7D84B.9020507@psycast.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dimitri Puzin <max@psycast.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:43228 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbYIWQ4Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Sep 2008 12:56:24 -0400
Content-Disposition: inline
In-Reply-To: <48D7D84B.9020507@psycast.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dimitri.

On Mon, Sep 22, 2008 at 07:39:23PM +0200, Dimitri Puzin (max@psycast.de) wrote:
> nommu_map_single: overflow 1fe047e00+512 of device mask ffffffff

Does attached patch fix the problem?

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 81f3f95..b288bbd 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2593,7 +2593,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
 	if (err)
 		goto err_out_disable_pci_device;
 
-- 
	Evgeniy Polyakov
