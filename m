From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 1/2] crypto: xts: fix nblocks not being updated in walk loop
Date: Sun, 23 Oct 2011 18:23:08 +0300
Message-ID: <20111023152308.31041.54696.stgit@localhost6.localdomain6>
References: <20111023152302.31041.36522.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:41635 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1JWPXK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Oct 2011 11:23:10 -0400
In-Reply-To: <20111023152302.31041.36522.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In xts_crypt() function, nblocks should be updated after blkcipher_walk_done
call.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/xts.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/crypto/xts.c b/crypto/xts.c
index 5681d66..ca1608f 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -229,6 +229,7 @@ first:
 		if (!nbytes)
 			break;
 
+		nblocks = min(nbytes / bsize, max_blks);
 		src = (be128 *)walk.src.virt.addr;
 		dst = (be128 *)walk.dst.virt.addr;
 	}
