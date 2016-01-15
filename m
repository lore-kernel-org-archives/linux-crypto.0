From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 0/5] crypto: atmel-sha: fix registration issue and other bugs
Date: Fri, 15 Jan 2016 15:49:30 +0100
Message-ID: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:39219 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbcAOOtG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jan 2016 09:49:06 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

This series of patches fixes many issues such as the algo registration failure
or the broken support of context switches.

This series was applied to linux-next and tested on a sama5d2 xplained
ultra board. We now pass the tcrypt tests in the following modes:
-  2: sha1
-  6: sha256
- 11: sha384
- 12: sha512
- 33: sha224

The context switch fix was tested with a userspace program using the cryptodev
module. This single thread program computes the SHA256 hashes of many files
by splitting then into fixed size chunks. The chunks of each file are
processed by calling 'update' operations using a round robin algorithm.

However, the .import() / .export() implementation was NOT tested!
Nonetheless the last patch is needed to fix the registration issue, otherwise
atmel_sha_probe() would still fail.

Best regards,

Cyrille


Cyrille Pitchen (5):
  crypto: atmel-sha: fix crash when computing digest on empty message
  crypto: atmel-sha: fix a race between the 'done' tasklet and the
    crypto client
  crypto: atmel-sha: add support of sama5d2x SoCs
  crypto: atmel-sha: fix context switches
  crypto: atmel-sha: fix algorihtm registration

 drivers/crypto/atmel-sha-regs.h |   4 +
 drivers/crypto/atmel-sha.c      | 186 +++++++++++++++++++++++++++++++++-------
 2 files changed, 158 insertions(+), 32 deletions(-)

-- 
1.8.2.2
