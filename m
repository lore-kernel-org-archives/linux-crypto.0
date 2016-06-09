From: Stephan Mueller <smueller@chronox.de>
Subject: CTR mode: Kconfig cyclic dependency
Date: Thu, 09 Jun 2016 11:07:06 +0200
Message-ID: <1465466750.NsZ2X8r4WP@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36138 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbcFIJHK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jun 2016 05:07:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

during the finalization of my patch set for converting the CTR DRBG over to 
CTR AES, I ran into a Kconfig problem. Maybe you have an idea how to resolve 
it.

As the CTR DRBG now uses the CTR mode, I added "select CRYPTO_CTR" to 
CRYPTO_DRBG_CTR. This now lead to the following cyclic dependency:

crypto/Kconfig:1547:error: recursive dependency detected!
For a resolution refer to Documentation/kbuild/kconfig-language.txt
subsection "Kconfig recursive dependency limitations"
crypto/Kconfig:1547:    symbol CRYPTO_DRBG_MENU is selected by 
CRYPTO_RNG_DEFAULT
For a resolution refer to Documentation/kbuild/kconfig-language.txt
subsection "Kconfig recursive dependency limitations"
crypto/Kconfig:83:      symbol CRYPTO_RNG_DEFAULT is selected by CRYPTO_SEQIV
For a resolution refer to Documentation/kbuild/kconfig-language.txt
subsection "Kconfig recursive dependency limitations"
crypto/Kconfig:255:     symbol CRYPTO_SEQIV is selected by CRYPTO_CTR
For a resolution refer to Documentation/kbuild/kconfig-language.txt
subsection "Kconfig recursive dependency limitations"
crypto/Kconfig:286:     symbol CRYPTO_CTR is selected by CRYPTO_DRBG_CTR
For a resolution refer to Documentation/kbuild/kconfig-language.txt
subsection "Kconfig recursive dependency limitations"
crypto/Kconfig:1566:    symbol CRYPTO_DRBG_CTR depends on CRYPTO_DRBG_MENU

i.e. CRYPTO_RNG_DEFAULT -> CRYPTO_DRBG_MENU -> CRYPTO_CTR -> CRYPTO_SEQIV -> 
CRYPTO_RNG_DEFAULT

Thanks
Stephan
