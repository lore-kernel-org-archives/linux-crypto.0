From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: hmac(crc32)
Date: Wed, 08 Mar 2017 09:20:08 +0100
Message-ID: <1891573.4Vd40q9uOn@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:57830 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751757AbdCHI3n (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2017 03:29:43 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

hmac(crc32) is defined in testmgr.c and tcrypt.c. Yet, when using that cipher, 
I get an ENOENT:

alg: hash: Failed to load transform for hmac(crc32): -2


Is there such a thing as hmac(crc32)?

Ciao
Stephan
