From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: Re: [bug report] crypto: atmel-sha - update request queue management
 to make it more generic
Date: Tue, 7 Feb 2017 18:31:45 +0100
Message-ID: <c1f6d365-06cc-a055-4797-ce7a5121533f@atmel.com>
References: <20170207105614.GA7777@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from exsmtp03.microchip.com ([198.175.253.49]:58022 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754498AbdBGRbr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Feb 2017 12:31:47 -0500
In-Reply-To: <20170207105614.GA7777@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Dan,

Le 07/02/2017 à 11:56, Dan Carpenter a écrit :
> Hello Cyrille Pitchen,
> 
> The patch a29af939b24d: "crypto: atmel-sha - update request queue
> management to make it more generic" from Jan 26, 2017, leads to the
> following static checker warning:
> 
> 	drivers/crypto/atmel-sha.c:673 atmel_sha_xmit_dma()
> 	error: we previously assumed 'in_desc' could be null (see line 670)
> 
> drivers/crypto/atmel-sha.c
>    652  
>    653          dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf);
>    654  
>    655          if (length2) {
>    656                  sg_init_table(sg, 2);
>    657                  sg_dma_address(&sg[0]) = dma_addr1;
>    658                  sg_dma_len(&sg[0]) = length1;
>    659                  sg_dma_address(&sg[1]) = dma_addr2;
>    660                  sg_dma_len(&sg[1]) = length2;
>    661                  in_desc = dmaengine_prep_slave_sg(dd->dma_lch_in.chan, sg, 2,
>    662                          DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>    663          } else {
>    664                  sg_init_table(sg, 1);
>    665                  sg_dma_address(&sg[0]) = dma_addr1;
>    666                  sg_dma_len(&sg[0]) = length1;
>    667                  in_desc = dmaengine_prep_slave_sg(dd->dma_lch_in.chan, sg, 1,
>    668                          DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
>    669          }
>    670          if (!in_desc)
>    671                  atmel_sha_complete(dd, -EINVAL);
> 
> Did you mean return atmel_sha_complete(dd, -EINVAL);???  That patch
> change a bunch of returns to just call atmel_sha_complete().  Someone
> should probably review it again to make sure there aren't other bugs
> as well.

Indeed, you're totally right: the "return -EINVAL" lines updated by the
patch should have been replaced by "return atmel_sha_complete(dd, -EINVAL);".

Sorry for that :(
and thanks for having caught it :)

I will prepare a fix for it.

Best regards,

Cyrille

> 
>    672  
>    673          in_desc->callback = atmel_sha_dma_callback;
>                 ^^^^^^^^^^^^^^^^^
> NULL dereference.
> 
>    674          in_desc->callback_param = dd;
>    675  
>    676          atmel_sha_write_ctrl(dd, 1);
>    677  
> 
> regards,
> dan carpenter
> 
