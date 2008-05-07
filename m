From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 01/n]: Endianess fixes
Date: Wed, 07 May 2008 14:14:28 +0200
Message-ID: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010302080408000203000506"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62065 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYEGMPN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:15:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010302080408000203000506
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Attached is the first of my fixes for the HIFN driver. I've
got it to a working state with tcrypt, IPsec and dm-crypt, a
few of the patches still need a bit work though, so I'll send
the ones that I already consider ready one by one.



--------------010302080408000203000506
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit aa543b1fcddd097b5129a9a3056f888737d88102
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 12:27:09 2008 +0200

    [HIFN]: Endianess fixes
    
    HIFN uses little-endian by default, move cpu_to_le32 conversion to hifn_write_0/
    hifn_write_1, add sparse annotations and fix an invalid endian conversion in
    hifn_setup_src_desc.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 81f3f95..d7a51ee 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -535,10 +535,10 @@ struct hifn_crypt_command
  */
 struct hifn_mac_command
 {
-	volatile u16 		masks;
-	volatile u16 		header_skip;
-	volatile u16 		source_count;
-	volatile u16 		reserved;
+	volatile __le16 	masks;
+	volatile __le16 	header_skip;
+	volatile __le16 	source_count;
+	volatile __le16 	reserved;
 };
 
 #define	HIFN_MAC_CMD_ALG_MASK		0x0001
@@ -564,10 +564,10 @@ struct hifn_mac_command
 
 struct hifn_comp_command
 {
-	volatile u16 		masks;
-	volatile u16 		header_skip;
-	volatile u16 		source_count;
-	volatile u16 		reserved;
+	volatile __le16 	masks;
+	volatile __le16 	header_skip;
+	volatile __le16 	source_count;
+	volatile __le16 	reserved;
 };
 
 #define	HIFN_COMP_CMD_SRCLEN_M		0xc000
@@ -583,10 +583,10 @@ struct hifn_comp_command
 
 struct hifn_base_result
 {
-	volatile u16 		flags;
-	volatile u16 		session;
-	volatile u16 		src_cnt;		/* 15:0 of source count */
-	volatile u16 		dst_cnt;		/* 15:0 of dest count */
+	volatile __le16 	flags;
+	volatile __le16 	session;
+	volatile __le16 	src_cnt;		/* 15:0 of source count */
+	volatile __le16 	dst_cnt;		/* 15:0 of dest count */
 };
 
 #define	HIFN_BASE_RES_DSTOVERRUN	0x0200	/* destination overrun */
@@ -597,8 +597,8 @@ struct hifn_base_result
 
 struct hifn_comp_result
 {
-	volatile u16 		flags;
-	volatile u16 		crc;
+	volatile __le16		flags;
+	volatile __le16		crc;
 };
 
 #define	HIFN_COMP_RES_LCB_M		0xff00	/* longitudinal check byte */
@@ -609,8 +609,8 @@ struct hifn_comp_result
 
 struct hifn_mac_result
 {
-	volatile u16 		flags;
-	volatile u16 		reserved;
+	volatile __le16 	flags;
+	volatile __le16 	reserved;
 	/* followed by 0, 6, 8, or 10 u16's of the MAC, then crypt */
 };
 
@@ -619,8 +619,8 @@ struct hifn_mac_result
 
 struct hifn_crypt_result
 {
-	volatile u16 		flags;
-	volatile u16 		reserved;
+	volatile __le16		flags;
+	volatile __le16		reserved;
 };
 
 #define	HIFN_CRYPT_RES_SRC_NOTZERO	0x0001	/* source expired */
@@ -686,12 +686,12 @@ static inline u32 hifn_read_1(struct hifn_device *dev, u32 reg)
 
 static inline void hifn_write_0(struct hifn_device *dev, u32 reg, u32 val)
 {
-	writel(val, dev->bar[0] + reg);
+	writel((__force u32)cpu_to_le32(val), dev->bar[0] + reg);
 }
 
 static inline void hifn_write_1(struct hifn_device *dev, u32 reg, u32 val)
 {
-	writel(val, dev->bar[1] + reg);
+	writel((__force u32)cpu_to_le32(val), dev->bar[1] + reg);
 }
 
 static void hifn_wait_puc(struct hifn_device *dev)
@@ -1037,14 +1037,14 @@ static void hifn_init_registers(struct hifn_device *dev)
 	hifn_write_0(dev, HIFN_0_PUIER, HIFN_PUIER_DSTOVER);
 
 	/* write all 4 ring address registers */
-	hifn_write_1(dev, HIFN_1_DMA_CRAR, __cpu_to_le32(dptr +
-				offsetof(struct hifn_dma, cmdr[0])));
-	hifn_write_1(dev, HIFN_1_DMA_SRAR, __cpu_to_le32(dptr +
-				offsetof(struct hifn_dma, srcr[0])));
-	hifn_write_1(dev, HIFN_1_DMA_DRAR, __cpu_to_le32(dptr +
-				offsetof(struct hifn_dma, dstr[0])));
-	hifn_write_1(dev, HIFN_1_DMA_RRAR, __cpu_to_le32(dptr +
-				offsetof(struct hifn_dma, resr[0])));
+	hifn_write_1(dev, HIFN_1_DMA_CRAR, dptr +
+				offsetof(struct hifn_dma, cmdr[0]));
+	hifn_write_1(dev, HIFN_1_DMA_SRAR, dptr +
+				offsetof(struct hifn_dma, srcr[0]));
+	hifn_write_1(dev, HIFN_1_DMA_DRAR, dptr +
+				offsetof(struct hifn_dma, dstr[0]));
+	hifn_write_1(dev, HIFN_1_DMA_RRAR, dptr +
+				offsetof(struct hifn_dma, resr[0]));
 
 	mdelay(2);
 #if 0
@@ -1178,8 +1178,8 @@ static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
 	idx = dma->srci;
 
 	dma->srcr[idx].p = __cpu_to_le32(addr);
-	dma->srcr[idx].l = __cpu_to_le32(size) | HIFN_D_VALID |
-			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST;
+	dma->srcr[idx].l = __cpu_to_le32(size | HIFN_D_VALID |
+			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST);
 
 	if (++idx == HIFN_D_SRC_RSIZE) {
 		dma->srcr[idx].l = __cpu_to_le32(HIFN_D_VALID |

--------------010302080408000203000506--
