From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC 0/2] AES ablkcipher driver for SPUs
Date: Wed, 27 Jun 2007 00:59:52 +0200
Message-ID: <20070626225952.GA4571@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:36770 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbXFZXAB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jun 2007 19:00:01 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Herbert,

This driver adds support for AES on SPU. Patch is for review only because
some parts of the code are not upstream yet.
Patch one contains the main driver (which uses ablkcipher_ctx_cast()), 
patch two is for clarity (parts of the missing API that is used).

Currently only ECB block mode is supported. I plan support for CBC but the
way the IV currently handled is unfavorable (later more).

aes_spu_wrap.c and kspu_helper.c run in the kernel, spu_main.c will run on
a SPU (my hardware for computing :)). SPU can access kernel memory (even
virtual) via asynchronous DMA transfers.
All requests from the crypto user end up in a linked list which is managed
by the kspu module (even no crypto requests will end up there as well but
currently the AES driver is the only user). AES callback function
(aes_queue_work_items()) is called to queue the request in a ring buffer 
which is located on the hardware. Once some requests are enqueued the SPU
is started.
The SPU requests the first couple of blocks via DMA (init_get_data()).
This request may not get satisfied immediately, the command does not
block. Once all requests (DMA_BUFFERS num) are fired up, the SPU waits
for the first buffer to complete and starts processing (via spu_funcs()).
Ideally there are always transfers in the background (copy new data from
main storage to SPU and copy processed data from SPU to main storage)
while the SPU is processing a block of data.
This is where my problems with the IV are starting. Currently I have to
request the IV from main storage, wait for it, than I can use it and once
I processed the block, I must write it back.
What about a different handling of the IV with two functions like
ablk_set_iv()
ablk_get_iv()
With something like this, I could store the IV in the SPU (in my key 
struct for instance) and don't have to transfer it on every request
(similar to what I do now with the key). I don't know if there are any
crypto user that have multiple IVs/key but in such a case, I could cache
IVs like I cache keys now. Any comments on that?

Sebastian
-- 
