From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH 0/5][CRYPTO] add support for extended RIPEMD hash algorithms
Date: Wed,  7 May 2008 23:58:34 +0200
Message-ID: <1210197519-18432-1-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2358 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbYEGV6m (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2008 17:58:42 -0400
In-Reply-To: <>
References: <>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These patches add RIPEMD-256/320 support to the cryptoapi and fix the
makefile entry for rmd128.o

The first patch contains a fix for to crypto/Makefile so rmd128.o is dependent
on CONFIG_CRYPTO_RMD128.

The second patch extracts all common values of the RIPEMD algorithms to the
proper header file.

The third patch contains the actual implementation of the extended hash
algorithms RIPEMD-256 and RIPEMD-320. They are described by Antoon
Bosselaers (ESAT-COSIC) at:
      <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html#extenions>

The fourth patch adds test vectors for both hash functions to tcrypt.
There are no standardized HMAC test vectors. The test vectors for the hash
functions are taken from
      <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html#extenions>

The fifth patch contains the Kconfig entries for both algorithms.


