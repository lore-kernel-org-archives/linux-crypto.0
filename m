From: Jason Cooper <jason@lakedaemon.net>
Subject: [RFC PATCH 20/22] staging: crypto: skein: remove braces from single-statement block
Date: Tue, 11 Mar 2014 21:32:52 +0000
Message-ID: <073fe26a8e89c9673bea20b9b09e0e4e8e57d17f.1394570068.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Cc: devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
	Jason Cooper <jason@lakedaemon.net>
To: Greg KH <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:22620 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbaCKVzt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Mar 2014 17:55:49 -0400
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
In-Reply-To: <cover.1394570067.git.jason@lakedaemon.net>
References: <cover.1394570067.git.jason@lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/skeinApi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/skein/skeinApi.c b/drivers/staging/skein/skeinApi.c
index f0015d5b10f5..dd109bf6f7b9 100644
--- a/drivers/staging/skein/skeinApi.c
+++ b/drivers/staging/skein/skeinApi.c
@@ -188,9 +188,9 @@ int skeinUpdateBits(struct skein_ctx *ctx, const u8 *msg,
 			msgBitCnt == 0, SKEIN_FAIL);
 
 	/* if number of bits is a multiple of bytes - that's easy */
-	if ((msgBitCnt & 0x7) == 0) {
+	if ((msgBitCnt & 0x7) == 0)
 		return skeinUpdate(ctx, msg, msgBitCnt >> 3);
-	}
+
 	skeinUpdate(ctx, msg, (msgBitCnt >> 3) + 1);
 
 	/*
-- 
1.9.0
