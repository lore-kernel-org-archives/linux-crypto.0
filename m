From: Marek Vasut <marex@denx.de>
Subject: [PATCH 00/11] crypto: caam: Error reporting fixes
Date: Thu, 24 Apr 2014 20:05:11 +0200
Message-ID: <1398362722-16430-1-git-send-email-marex@denx.de>
Cc: Marek Vasut <marex@denx.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:44399 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983AbaDXSFb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Apr 2014 14:05:31 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

First stab at reworking the error.c thing in Freescale CAAM.
This patchset cleans it up so it's not doing any too insane
string messing anymore.

NOTE: Can someone please test this on real hardware? I have
      none at hand, so THIS IS COMPILE-TESTED ONLY!

Marek Vasut (11):
  crypto: caam: Contain caam_jr_strstatus() ugliness
  crypto: caam: Pull all the error codes out
  crypto: caam: Implement fast-path for error codes with no handler
  crypto: caam: Pass error type into the functions
  crypto: caam: Kill the easy targets
  crypto: caam: Dissolve report_jump_idx()
  crypto: caam: Clean up report_ccb_status()
  crypto: caam: Clean up report_deco_status()
  crypto: caam: Kill SPRINTFCAT() with fire
  crypto: caam: Sweep the remnants
  crypto: caam: Fix the 'quoted string split across lines'

 drivers/crypto/caam/caamalg.c  |  28 +--
 drivers/crypto/caam/caamhash.c |  28 +--
 drivers/crypto/caam/caamrng.c  |   7 +-
 drivers/crypto/caam/error.c    | 389 +++++++++++++++++++----------------------
 drivers/crypto/caam/error.h    |   2 +-
 drivers/crypto/caam/key_gen.c  |   7 +-
 6 files changed, 200 insertions(+), 261 deletions(-)

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>

-- 
1.9.2
