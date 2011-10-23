From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 0/2] Fixes for parallel XTS/LRW patch series
Date: Sun, 23 Oct 2011 18:23:02 +0300
Message-ID: <20111023152302.31041.36522.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:56942 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1JWPXH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Oct 2011 11:23:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These patches fix bug in xts_crypt()/lrw_crypt() where nblocks is
not updated in the block walk loop.

This causes nblocks to be left at 0, after blkcipher_walk_done() call.
This leads 'do { ... } while (nblocks > 0)' loop to be run one extra
time with nblocks == 0 and at end of do-while loop nblocks gets updated
correctly.

---

Jussi Kivilinna (2):
      crypto: xts: fix nblocks not being updated in walk loop
      crypto: lrw: fix nblocks not being updated in walk loop


 crypto/lrw.c |    1 +
 crypto/xts.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)
