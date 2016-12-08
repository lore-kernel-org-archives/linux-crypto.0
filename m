From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: simd ciphers
Date: Thu, 08 Dec 2016 19:32:03 +0100
Message-ID: <3279008.xAQAe6ukNz@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39194 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753220AbcLHSdG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Dec 2016 13:33:06 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

with the addition of the simd cipher change I seem to be unable to use the 
AESNI ciphers. My .config contains CONFIG_CRYPTO_SIMD=y and 
CONFIG_CRYPTO_AES_NI_INTEL=y. Those options always worked to load the AES-NI 
implementation. But now, I do not see the AES-NI implementations any more in /
proc/crypto.

Ciao
Stephan
