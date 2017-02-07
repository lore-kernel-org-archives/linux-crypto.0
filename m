From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: atmel-sha - update request queue management to
 make it more generic
Date: Tue, 7 Feb 2017 13:56:14 +0300
Message-ID: <20170207105614.GA7777@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: cyrille.pitchen@atmel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50250 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdBGK4c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Feb 2017 05:56:32 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Cyrille Pitchen,

The patch a29af939b24d: "crypto: atmel-sha - update request queue
management to make it more generic" from Jan 26, 2017, leads to the
following static checker warning:

	drivers/crypto/atmel-sha.c:673 atmel_sha_xmit_dma()
	error: we previously assumed 'in_desc' could be null (see line 670)

drivers/crypto/atmel-sha.c
   652  
   653          dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf);
   654  
   655          if (length2) {
   656                  sg_init_table(sg, 2);
   657                  sg_dma_address(&sg[0]) = dma_addr1;
   658                  sg_dma_len(&sg[0]) = length1;
   659                  sg_dma_address(&sg[1]) = dma_addr2;
   660                  sg_dma_len(&sg[1]) = length2;
   661                  in_desc = dmaengine_prep_slave_sg(dd->dma_lch_in.chan, sg, 2,
   662                          DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
   663          } else {
   664                  sg_init_table(sg, 1);
   665                  sg_dma_address(&sg[0]) = dma_addr1;
   666                  sg_dma_len(&sg[0]) = length1;
   667                  in_desc = dmaengine_prep_slave_sg(dd->dma_lch_in.chan, sg, 1,
   668                          DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
   669          }
   670          if (!in_desc)
   671                  atmel_sha_complete(dd, -EINVAL);

Did you mean return atmel_sha_complete(dd, -EINVAL);???  That patch
change a bunch of returns to just call atmel_sha_complete().  Someone
should probably review it again to make sure there aren't other bugs
as well.

   672  
   673          in_desc->callback = atmel_sha_dma_callback;
                ^^^^^^^^^^^^^^^^^
NULL dereference.

   674          in_desc->callback_param = dd;
   675  
   676          atmel_sha_write_ctrl(dd, 1);
   677  

regards,
dan carpenter
