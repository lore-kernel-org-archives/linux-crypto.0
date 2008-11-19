From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] Remove some unused cruft.
Date: Wed, 19 Nov 2008 17:03:32 +0300
Message-ID: <1227103414231-git-send-email-zbr@ioremap.net>
References: <12271034133347-git-send-email-zbr@ioremap.net>
 <12271034132587-git-send-email-zbr@ioremap.net>
 <12271034131753-git-send-email-zbr@ioremap.net>
 <1227103414646-git-send-email-zbr@ioremap.net>
 <1227103414418-git-send-email-zbr@ioremap.net>
 <12271034142436-git-send-email-zbr@ioremap.net>
 <12271034143351-git-send-email-zbr@ioremap.net>
Cc: linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zbr.yandex.ru ([213.180.219.33]:37378 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753979AbYKSOHy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2008 09:07:54 -0500
In-Reply-To: <12271034143351-git-send-email-zbr@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/crypto/hifn_795x.c |   32 +-------------------------------
 1 files changed, 1 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 47952d8..73aef49 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -38,9 +38,6 @@
 
 #include <asm/kmap_types.h>
 
-#undef dprintk
-
-#define HIFN_TEST
 //#define HIFN_DEBUG
 
 #ifdef HIFN_DEBUG
@@ -406,8 +403,6 @@ struct hifn_dma {
 	u8			command_bufs[HIFN_D_CMD_RSIZE][HIFN_MAX_COMMAND];
 	u8			result_bufs[HIFN_D_CMD_RSIZE][HIFN_MAX_RESULT];
 
-	u64			test_src, test_dst;
-
 	/*
 	 *  Our current positions for insertion and removal from the descriptor
 	 *  rings.
@@ -434,9 +429,6 @@ struct hifn_device
 	struct pci_dev		*pdev;
 	void __iomem		*bar[3];
 
-	unsigned long		result_mem;
-	dma_addr_t		dst;
-
 	void			*desc_virt;
 	dma_addr_t		desc_dma;
 
@@ -446,8 +438,6 @@ struct hifn_device
 
 	spinlock_t		lock;
 
-	void 			*priv;
-
 	u32			flags;
 	int			active, started;
 	struct delayed_work	work;
@@ -2638,22 +2628,11 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto err_out_unmap_bars;
 	}
 
-	dev->result_mem = __get_free_pages(GFP_KERNEL, HIFN_MAX_RESULT_ORDER);
-	if (!dev->result_mem) {
-		dprintk("Failed to allocate %d pages for result_mem.\n",
-				HIFN_MAX_RESULT_ORDER);
-		goto err_out_unmap_bars;
-	}
-	memset((void *)dev->result_mem, 0, PAGE_SIZE*(1<<HIFN_MAX_RESULT_ORDER));
-
-	dev->dst = pci_map_single(pdev, (void *)dev->result_mem,
-			PAGE_SIZE << HIFN_MAX_RESULT_ORDER, PCI_DMA_FROMDEVICE);
-
 	dev->desc_virt = pci_alloc_consistent(pdev, sizeof(struct hifn_dma),
 			&dev->desc_dma);
 	if (!dev->desc_virt) {
 		dprintk("Failed to allocate descriptor rings.\n");
-		goto err_out_free_result_pages;
+		goto err_out_unmap_bars;
 	}
 	memset(dev->desc_virt, 0, sizeof(struct hifn_dma));
 
@@ -2713,11 +2692,6 @@ err_out_free_desc:
 	pci_free_consistent(pdev, sizeof(struct hifn_dma),
 			dev->desc_virt, dev->desc_dma);
 
-err_out_free_result_pages:
-	pci_unmap_single(pdev, dev->dst, PAGE_SIZE << HIFN_MAX_RESULT_ORDER,
-			PCI_DMA_FROMDEVICE);
-	free_pages(dev->result_mem, HIFN_MAX_RESULT_ORDER);
