From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 2/2] crypto: lrw: fix nblocks not being updated in walk loop
Date: Sun, 23 Oct 2011 18:23:13 +0300
Message-ID: <20111023152313.31041.22706.stgit@localhost6.localdomain6>
References: <20111023152302.31041.36522.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:56962 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab1JWPXP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 23 Oct 2011 11:23:15 -0400
In-Reply-To: <20111023152302.31041.36522.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In lrw_crypt() function, nblocks should be updated after blkcipher_walk_done
call.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/lrw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 66c4d22..ba42acc 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -284,6 +284,7 @@ first:
 		if (!nbytes)
 			break;
 
+		nblocks = min(nbytes / bsize, max_blks);
 		src = (be128 *)walk.src.virt.addr;
 		dst = (be128 *)walk.dst.virt.addr;
 	}
