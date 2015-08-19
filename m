From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: crypto: broken Kconfig option CRYPTO_NULL2
Date: Wed, 19 Aug 2015 09:49:37 +0200
Message-ID: <CAD3Xx4+R3f1H1vpRRcMEMfwMF-b7jggYhbk=V7JFg_=ujr-E+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Paul Bolle <pebolle@tiscali.nl>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34269 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbbHSHuI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2015 03:50:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

your commit 149a39717dcc ("crypto: aead - Add type-safe geniv
init/exit helpers") has shown up in Linux next (i.e., next-20150818)
adding the following lines of code to crypto/Kconfig:

@@ -150,12 +152,15 @@ config CRYPTO_GF128MUL
[...]

+config CRYPTO_NULL2
+       select CRYPTO_ALGAPI2
+       select CRYPTO_BLKCIPHER2
+       select CRYPTO_HASH2
+

There are two problems with the option above: (1) It does not have a
type, (2) it selects other options without being a tristate/boolean,
see below:

scripts/kconfig/mconf  Kconfig
crypto/Kconfig:159:warning: config symbol defined without type
crypto/Kconfig:160:warning: config symbol 'CRYPTO_NULL2' uses select,
but is not boolean or tristate
crypto/Kconfig:161:warning: config symbol 'CRYPTO_NULL2' uses select,
but is not boolean or tristate
crypto/Kconfig:162:warning: config symbol 'CRYPTO_NULL2' uses select,
but is not boolean or tristate


If you want to, I can send a trivial patch making it a boolean without prompt.

I detected this issue with undertaker-checkpatch (undertaker.cs.fau.de).

Kind regards,
 Valentin
