From: Stephan Mueller <smueller@chronox.de>
Subject: ahash and halg.statesize
Date: Thu, 26 Nov 2015 17:01:24 +0100
Message-ID: <17889830.Qe4KtthDOe@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34600 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbbKZQBa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Nov 2015 11:01:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

after Fabio's confirmation on the mxs-dcp ahash implementations, I briefly 
looked for the invocation of crypto_register_ahash and found numerous 
invocations. After taking two examples (sahara, n2), I did not find 
halg.statesize.

Thus, I would conclude that none of these ciphers would work currently.

I am currently not sure how to solve that issue as every ahash implementation 
must be assessed for its statesize.

Ciao
Stephan
