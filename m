From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 11/n]: Have HW invalidate src and dest descriptors after processing
Date: Wed, 07 May 2008 14:53:17 +0200
Message-ID: <4821A63D.1040408@trash.net>
References: <48219D24.1040702@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010707090607060702030902"
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63274 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYEGMx4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 08:53:56 -0400
In-Reply-To: <48219D24.1040702@trash.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010707090607060702030902
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------010707090607060702030902
Content-Type: text/x-diff;
 name="11.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="11.diff"

commit 0b4add2721b85f3ea873b87b02c057f2b5cff7aa
Author: Patrick McHardy <kaber@trash.net>
Date:   Wed May 7 13:15:44 2008 +0200

    [HIFN]: Have HW invalidate src and dest descriptors after processing
    
    The descriptors need to be invalidated after processing for ring
    cleanup to work properly and to avoid using an old destination
    descriptor when the src and cmd descriptors are already set up
    and the dst descriptor isn't.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index c9fe18d..459d283 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1297,7 +1297,7 @@ static int hifn_setup_src_desc(struct hifn_device *dev, struct page *page,
 
 	dma->srcr[idx].p = __cpu_to_le32(addr);
 	dma->srcr[idx].l = __cpu_to_le32(size | HIFN_D_VALID |
-			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST);
+			HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
 
 	if (++idx == HIFN_D_SRC_RSIZE) {
 		dma->srcr[idx].l = __cpu_to_le32(HIFN_D_VALID |
@@ -1325,7 +1325,7 @@ static void hifn_setup_res_desc(struct hifn_device *dev)
 			HIFN_D_VALID | HIFN_D_LAST);
 	/*
 	 * dma->resr[dma->resi].l = __cpu_to_le32(HIFN_MAX_RESULT | HIFN_D_VALID |
-	 *					HIFN_D_LAST | HIFN_D_NOINVALID);
+	 *					HIFN_D_LAST);
 	 */
 
 	if (++dma->resi == HIFN_D_RES_RSIZE) {
@@ -1354,12 +1354,12 @@ static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
 	idx = dma->dsti;
 	dma->dstr[idx].p = __cpu_to_le32(addr);
 	dma->dstr[idx].l = __cpu_to_le32(size |	HIFN_D_VALID |
-			HIFN_D_MASKDONEIRQ | HIFN_D_NOINVALID | HIFN_D_LAST);
+			HIFN_D_MASKDONEIRQ | HIFN_D_LAST);
 
 	if (++idx == HIFN_D_DST_RSIZE) {
 		dma->dstr[idx].l = __cpu_to_le32(HIFN_D_VALID |
 				HIFN_D_JUMP | HIFN_D_MASKDONEIRQ |
-				HIFN_D_LAST | HIFN_D_NOINVALID);
+				HIFN_D_LAST);
 		idx = 0;
 	}
 	dma->dsti = idx;

--------------010707090607060702030902--
