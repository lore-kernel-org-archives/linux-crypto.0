From: Alex Porosanu <alexandru.porosanu@freescale.com>
Subject: [PATCH 0/3] CAAM RNG4 fixes
Date: Mon, 11 Aug 2014 11:40:14 +0300
Message-ID: <1407746417-9134-1-git-send-email-alexandru.porosanu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:43251
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752564AbaHKIlC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2014 04:41:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series of patches target the RNG4 block of CAAM and fix an
issue identified on new platforms using this IP. 
Two of the patches, change the way the entropy is being taken
from the internal oscillator and adjust the delay accordingly.

Alex Porosanu (3):
  crypto: caam - disable RNG oscillator maximum frequency check
  crypto: caam - change starting entropy delay value
  crypto: caam - enable raw data instead of von Neumann data

 drivers/crypto/caam/ctrl.c | 24 +++++++++++++++++++++---
 drivers/crypto/caam/regs.h | 13 ++++++++++++-
 2 files changed, 33 insertions(+), 4 deletions(-)

-- 
1.8.3.1
