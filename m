From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 1/5] crypto: atmel-sha: fix crash when computing digest on empty message
Date: Fri, 15 Jan 2016 15:49:31 +0100
Message-ID: <4396c236d6cc6dc89801ef6d179d10b901461654.1452867917.git.cyrille.pitchen@atmel.com>
References: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<nicolas.ferre@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:39253 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbcAOOt2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jan 2016 09:49:28 -0500
In-Reply-To: <cover.1452867917.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes a crash which occured during the computation of the
digest of an empty message.

Indeed, when processing an empty message, the atmel_sha_handle_queue()
function was never called, hence the dd->req pointer remained
uninitialized.

Later, when the atmel_sha_final_req() function was called, it used
to crash while using this uninitialized dd->req pointer.

Hence this patch adds missing initializations of dd->req before calls of
the atmel_sha_final_req() function.

This bug prevented us from passing the tcrypt test suite on SHA algo.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 20de861aa0ea..006b2aefba30 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -939,6 +939,7 @@ static int atmel_sha_final(struct ahash_request *req)
 		if (err)
 			goto err1;
 
+		dd->req = req;
 		dd->flags |= SHA_FLAGS_BUSY;
 		err = atmel_sha_final_req(dd);
 	} else {
-- 
1.8.2.2
