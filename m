Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BA0C2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C30C206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbgKFL2r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:47 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgKFL2r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:47 -0500
IronPort-SDR: QWw62aOyl2+u/bGp4llSAsrFO8GsGnZ1326ziImfY5PNSYdW7MPIFL97pytuIyx69JfMxMeBMV
 L37xIlSRdvjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698290"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698290"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:46 -0800
IronPort-SDR: PjzzTeuXLdeRvBZqBnUoAU12EXLjqn6hMcPnseeTdAB8GkDiMaWJ/Nv/xdSAPq5UxV+zzGYIa9
 KG5A7xYWBUhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779215"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:45 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 08/32] crypto: qat - loader: add support for relative FW ucode loading
Date:   Fri,  6 Nov 2020 19:27:46 +0800
Message-Id: <20201106112810.2566-9-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Improve the way micro instructions (FW code) are uploaded to Accelerator
Engines (AEs). If code starts at PC zero (absolute addressing), read
uwords with no relative address. Otherwise, use relative addressing to
the page region.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index dc2f2dcf21b8..1c03205c7166 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1735,21 +1735,22 @@ static void qat_uclo_fill_uwords(struct icp_qat_uclo_objhandle *obj_handle,
 				 u64 *uword, unsigned int addr_p,
 				 unsigned int raddr, u64 fill)
 {
+	unsigned int i, addr;
 	u64 uwrd = 0;
-	unsigned int i;
 
 	if (!encap_page) {
 		*uword = fill;
 		return;
 	}
+	addr = (encap_page->page_region) ? raddr : addr_p;
 	for (i = 0; i < encap_page->uwblock_num; i++) {
-		if (raddr >= encap_page->uwblock[i].start_addr &&
-		    raddr <= encap_page->uwblock[i].start_addr +
+		if (addr >= encap_page->uwblock[i].start_addr &&
+		    addr <= encap_page->uwblock[i].start_addr +
 		    encap_page->uwblock[i].words_num - 1) {
-			raddr -= encap_page->uwblock[i].start_addr;
-			raddr *= obj_handle->uword_in_bytes;
+			addr -= encap_page->uwblock[i].start_addr;
+			addr *= obj_handle->uword_in_bytes;
 			memcpy(&uwrd, (void *)(((uintptr_t)
-			       encap_page->uwblock[i].micro_words) + raddr),
+			       encap_page->uwblock[i].micro_words) + addr),
 			       obj_handle->uword_in_bytes);
 			uwrd = uwrd & 0xbffffffffffull;
 		}
-- 
2.25.4

