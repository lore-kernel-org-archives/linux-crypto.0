From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [RESEND][PATCH 0/4][CRYPTO] add support for extended RIPEMD hash algorithms
Date: Thu,  8 May 2008 20:06:52 +0200
Message-ID: <1210270016-6725-1-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2388 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbYEHSG7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 May 2008 14:06:59 -0400
In-Reply-To: <>
References: <>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Resending because of missing sign-off.

These patches add RIPEMD-256/320 support to the cryptoapi.

The first patch extracts all common values of the RIPEMD algorithms to the
proper header file.

The second patch contains the actual implementation of the extended hash
algorithms RIPEMD-256 and RIPEMD-320. They are described by Antoon
Bosselaers (ESAT-COSIC) at:
      <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html#extenions>

The third patch adds test vectors for both hash functions to tcrypt.
There are no standardized HMAC test vectors. The test vectors for the hash
functions are taken from
      <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html#extenions>

The fourth patch contains the Kconfig entries for both algorithms.


