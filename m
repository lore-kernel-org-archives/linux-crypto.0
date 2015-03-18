From: sri sowj <srisowj4linux@gmail.com>
Subject: How to handle an error while processing crypto request (backlogged)
Date: Wed, 18 Mar 2015 09:31:07 +0530
Message-ID: <CAHTT9V+kthqrE5E0JSp_RiNwQPQsGm0FmJ_QEobpaEVu9SwtSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33810 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbbCREBI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 00:01:08 -0400
Received: by oier21 with SMTP id r21so26584374oie.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2015 21:01:07 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

I am not really clear how  to handle an error when processing
backlogged messages.I did not get any document or references in this
regard,It would be a great help if any suggestions are provided.

As per my understanding "Back Logged messages" Processing will be as below:

Step #1:

Let's say "M" is the message to be encrypted and its divided chunks M1 to M4.
M=M1+M2+M3+M4. Now when feeding  M1 to M4 to crypto engine,when M1 is
under processing [H(M10] ,M2,M3,M4 will be enqueued i.e., backlogged

M4,M3,M2 ----> H(M1)

Here H(M1) under processing, M2 - M4 request comes when M0 is under
processing so M1-M4 are backlogged.

Step #2:

once the  M1 is processed Linux crypto driver has to be notified
through either an interrupt or a call back
to process remaining messages.This process will be repeating till it
completes processing all backlogged
messages M2,M3,M4.

Now let us say when processing M2 if some errors comes like processing
unit like DMA channel is stopped,
then how to handle this error scenario.

I have referred omap-aes.c from open source but its not really clear.

static int omap_aes_handle_queue(struct omap_aes_dev *dd,
                               struct ablkcipher_request *req)
{

///////////
//////////

                 err = omap_aes_crypt_dma_start(dd);
         if (err) {
                 /* aes_task will not finish it, so do it here */

                 omap_aes_finish_req(dd, err);
                //whatever compete call back is called not really sure
what it is meant for?,may for re-initializing the request?


                 tasklet_schedule(&dd->queue_task);
                // Here it will call *_aes_handle_queue again ,but
this messages already deleted while dequeuing,so how does it work?
         }

         return ret; /* return ret, which is enqueue return value */
}


BR,
Srisowj
