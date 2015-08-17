From: Stephan Mueller <smueller@chronox.de>
Subject: crypto/Konfig
Date: Mon, 17 Aug 2015 14:34:05 +0200
Message-ID: <11252787.PiQGprMvJX@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48120 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbbHQMeL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Aug 2015 08:34:11 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

something seems to be missing in the latest Kconfig file.

Shall there be a tristate added?

$ make menuconfig
scripts/kconfig/mconf  Kconfig
crypto/Kconfig:159:warning: config symbol defined without type
crypto/Kconfig:160:warning: config symbol 'CRYPTO_NULL2' uses select, but is 
not boolean or tristate
crypto/Kconfig:161:warning: config symbol 'CRYPTO_NULL2' uses select, but is 
not boolean or tristate
crypto/Kconfig:162:warning: config symbol 'CRYPTO_NULL2' uses select, but is 
not boolean or tristate

-- 
Ciao
Stephan
