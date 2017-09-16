From: Harsh Jain <Harsh@chelsio.com>
Subject: DMA error when sg->offset value is greater than PAGE_SIZE in Intel
 IOMMU
Date: Sat, 16 Sep 2017 11:41:23 +0530
Message-ID: <be3bb850-a9f2-61fa-e378-eb44489256e0@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, leedom@chelsio.com
To: dwmw2@infradead.org, joro@8bytes.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:40491 "EHLO l.chelsio.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751203AbdIPGNW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Sep 2017 02:13:22 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

While debugging DMA mapping error in chelsio crypto driver we observed that when scatter/gather list received by driver has some entry with page->offset > 4096 (PAGE_SIZE). It starts giving DMA error.  Without IOMMU it works fine.

Before reaching to chelsio crypto driver(driver/crypto/chelsio) following entities change the sg'

1) IN esp_output() "__skb_to_sgvec()" convert skb frags to scatter gather list. At that moment sg->offset was 4094.
2) From esp_output control reaches to "crypto_authenc_encrypt()". Here in "scatterwalk_ffwd()" sg->offset become 4110.
3) Same sg list received by chelsio crypto driver(chcr). When chcr try to do DMA mapping it starts giving DMA errors.

Following error observed. first two prints are added for debugging in chcr. Kernel version used to reproduce is 4.9.28 on x86_64.

Sep 15 12:40:52 heptagon kernel: process_cipher req src ffff8803cb41f0a8
Sep 15 12:40:52 heptagon kernel: ========= issue    hit offset:4110 ======= dma_addr f24b000e ==> DMA mapped address returned by dma_map_sg()

Sep 15 12:40:52 heptagon kernel: DMAR: DRHD: handling fault status reg 2
Sep 15 12:40:52 heptagon kernel: DMAR: [DMA Write] Request device [02:00.4] fault addr f24b0000 [fault reason 05] PTE Write access is not set

 By applying following hack in kernel. Things start working.

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index c16c94f8..1d75a3a 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -78,6 +78,8 @@ struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2]
                                     struct scatterlist *src,
                                     unsigned int len)
 {
+       unsigned int mod_page_offset;
+
        for (;;) {
                if (!len)
                        return src;
@@ -90,7 +92,9 @@ struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2]
        }

        sg_init_table(dst, 2);
-       sg_set_page(dst, sg_page(src), src->length - len, src->offset + len);
+        mod_page_offset = (src->offset + len) / PAGE_SIZE;
+       sg_set_page(dst, sg_page(src) + mod_page_offset, src->length - len,
+                   (src->offset + len) - (mod_page_offset * PAGE_SIZE));
        scatterwalk_crypto_chain(dst, sg_next(src), 0, 2);


1) We are not expecting issue in "scatterwalk_ffwd" because it is not the only place where kernel 
updates src->offset without checking page boundary. similar logic used in "__skb_to_sgvec".
 
2) It cannot be driver's responsibilty to update received sg entries to adjust offset and page 
because we are not the only one who directly uses received sg list.

3) Since Without IOMMU every thing works fine. We are expecting IOMMU bugs.

Regards

Harsh Jain
