From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: crypto: img-hash - undefined Kconfig symbols
Date: Wed, 18 Mar 2015 08:35:04 +0100
Message-ID: <CAD3Xx4Kz0qT+=FKEy8N-rkubSrPAEhmXkTXk1H+-MGJ7BNiGqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Paul Bolle <pebolle@tiscali.nl>,
	Andreas Ruprecht <rupran@einserver.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
To: james.hartley@imgtec.com, abrestic@chromium.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:36070 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbbCRHfg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 03:35:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

your commit d358f1abbf71 ("crypto: img-hash - Add Imagination
Technologies hw hash accelerator") adds two selects on undefined
Kconfig symbols, namely CRYPTO_ALG_API and CRYPTO_SHA224.

The first symbols looks like a typo since there is an option
CRYPTO_ALGAPI defined in crypto/Kconfig.  However, I do not find a
companion for CRYPTO_SHA224.  Is there a patch scheduled somewhere
that adds this option?

I detected your commit in today's Linux next tree by running
./scripts/checkkconfigsymbols.py.  Git commit 92503ee4ada1
("checkkconfigsymbols.py: make it Git aware") added the functionality
to check Git commits and diff commits for such undefined symbols.

Kind regards,
 Valentin
