From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: chelsio - Move DMA un/mapping to chcr from lld
 cxgb4 driver
Date: Wed, 8 Nov 2017 11:46:58 +0300
Message-ID: <20171108084658.m2tkthbg4p2k7zcv@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: harsh@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20182 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbdKHIrH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Nov 2017 03:47:07 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Harsh Jain,

This is a semi-automatic email about new static checker warnings.

The patch 2f47d5804311: "crypto: chelsio - Move DMA un/mapping to
chcr from lld cxgb4 driver" from Oct 8, 2017, leads to the following
Smatch complaint:

    drivers/crypto/chelsio/chcr_algo.c:562 ulptx_walk_add_sg()
    error: we previously assumed 'sg' could be null (see line 551)

drivers/crypto/chelsio/chcr_algo.c
   550	
   551		while (sg && skip) {
                       ^^
The patch adds a new check for NULL

   552			if (sg_dma_len(sg) <= skip) {
   553				skip -= sg_dma_len(sg);
   554				skip_len = 0;
   555				sg = sg_next(sg);
   556			} else {
   557				skip_len = skip;
   558				skip = 0;
   559			}
   560		}
   561		if (walk->nents == 0) {
   562			small = min_t(unsigned int, sg_dma_len(sg) - skip_len, len);
                                                               ^^
This dereference (inside the macro) isn't checked.

   563			sgmin = min_t(unsigned int, small, CHCR_SRC_SG_SIZE);
   564			walk->sgl->len0 = cpu_to_be32(sgmin);

regards,
dan carpenter
