From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 0/2] fix a possible NULL dereference
Date: Fri, 20 Nov 2015 08:45:15 +0100
Message-ID: <1448005517-26004-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mtd@lists.infradead.org
To: computersforpeace@gmail.com, davem@davemloft.net,
	dwmw2@infradead.org, herbert@gondor.apana.org.au,
	jamie@jamieiles.com, josh.wu@atmel.com,
	linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36538 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762AbbKTHpX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Nov 2015 02:45:23 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

The main goal of this patch series is to fix a possible NULL dereference.
Even if the probability of this case is very low, fixing it made
static analyzers happy.
In the same time it permits to remove a "cast that drop const qualifiers.

Regards

Changes since v1
- Use of_device_get_match_data
- Add the missing patch for constify atmel_nand_caps structures

LABBE Corentin (2):
  mtd: nand: atmel_nand: constify atmel_nand_caps structures
  mtd: nand: atmel_nand: fix a possible NULL dereference

 drivers/mtd/nand/atmel_nand.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

-- 
2.4.10
