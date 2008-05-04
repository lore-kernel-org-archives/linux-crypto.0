From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH 0/3][CRYPTO] RIPEMD: add support for RIPEMD hash algorithms.
Date: Sun,  4 May 2008 17:03:30 +0200
Message-ID: <1209913413-8229-1-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2534 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbYEDPDn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 May 2008 11:03:43 -0400
In-Reply-To: <>
References: <>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These patches add RIPEMD-128/160 support to the cryptoapi.

The first patch contains the actual implementation of the hash
algorithms. It is based on the sample implementation by Antoon
Bosselaers (ESAT-COSIC) found at:
         <http://homes.esat.kuleuven.be/~bosselae/ripemd160.html>

The second patch adds test vectors for both hash functions and their
respective digests (HMAC) to tcrypt. The test vectors for the hash
functions are taken from ISO/IEC 10118-3:2004 and the ones for HMAC
from RFC2286.

The third patch contains the Kconfig entries for both algorithms.

