From: Stephan Mueller <smueller@chronox.de>
Subject: Memory corruption in algif_skciper AIO sendpage with multiple iocb
Date: Mon, 12 Sep 2016 14:43:45 +0200
Message-ID: <13399079.xub8KL5p6S@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47936 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758671AbcILMr3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Sep 2016 08:47:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

after getting the AIO code working on sendmsg, tried it with vmsplice/splice 
and I get a memory corruption. Interestingly, the stack trace is partially 
garbled too. Thus, tracking this one down may be a bit of a challenge.

Ciao
Stephan
