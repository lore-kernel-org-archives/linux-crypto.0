From: Stephan Mueller <smueller@chronox.de>
Subject: algif_aead: AIO broken with more than one iocb
Date: Sun, 11 Sep 2016 04:59:19 +0200
Message-ID: <6245755.LbXSUvPjJL@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47920 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755935AbcIKKzk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Sep 2016 06:55:40 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

The AIO support for algif_aead is broken when submitting more than one iocb. 
The break happens in aead_recvmsg_async at the following code:

        /* ensure output buffer is sufficiently large */
        if (usedpages < outlen)
                goto free;

The reason is that when submitting, say, two iocb, ctx->used contains the 
buffer length for two AEAD operations (as expected). However, the recvmsg code 
is invoked for each iocb individually and thus usedpages should only be 
expected to point to memory for one AEAD operation. But this violates the 
check above.

For example, I have two independent AEAD operations that I want to trigger. 
The input to each is 48 bytes (including space for AAD and tag). The output 
buffer that I have for each AEAD operation is also 48 bytes and thus 
sufficient for the AEAD operation. Yet, when submitting the two AEAD 
operations in one io_submit (i.e. using two iocb), ctx->used indicates that 
the kernel has 96 bytes to process. This is correct, but only half of it 
should be processed in one recvmsg_async invocation.

Note, the AIO operation works perfectly well, when io_submit only sends one 
iocb.

Do you have any idea on how to fix that?

Ciao
Stephan
