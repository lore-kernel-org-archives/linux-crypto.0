From: Marek Vasut <marex@denx.de>
Subject: [PATCH 0/3] crypto: Clean up ahash handling confusion
Date: Tue, 14 Jan 2014 18:33:46 +0100
Message-ID: <1389720829-5963-1-git-send-email-marex@denx.de>
Cc: linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>,
	"David S. Miller" <davem@davemloft.net>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shawn Guo <shawn.guo@linaro.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:41328 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaANReF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jan 2014 12:34:05 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This set of patches shall clean up the confusion in restoring the ahash request
context in crypto/ahash.c . The code was a bit refactored to make it easier to
understand as well.

Please, make sure the code is well tested before applying. Also, please review
very thoroughly.

Marek Vasut (3):
  crypto: Fix the pointer voodoo in unaligned ahash
  crypto: Pull out the functions to save/restore request
  crypto: Simplify the ahash_finup implementation

 crypto/ahash.c | 172 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 110 insertions(+), 62 deletions(-)

Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
-- 
1.8.5.2
