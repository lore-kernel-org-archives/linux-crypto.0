From: David Miller <davem@davemloft.net>
Subject: [PATCH 2/6] crypto: Fix scatterwalk_done() test.
Date: Mon, 17 May 2010 22:22:37 -0700 (PDT)
Message-ID: <20100517.222237.232897853.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50945
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755579Ab0ERFW2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 May 2010 01:22:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


We are done with the scattergather entry when the walk offset goes
past sg->offset + sg->length, not when it crosses a page boundary.

There is a similarly queer test in the second half of
scatterwalk_pagedone() that probably needs some scrutiny.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 crypto/scatterwalk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 3de89a4..b3acf4f 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -68,7 +68,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 
 void scatterwalk_done(struct scatter_walk *walk, int out, int more)
 {
-	if (!offset_in_page(walk->offset) || !more)
+	if (walk->offset >= walk->sg->offset + walk->sg->length || !more)
 		scatterwalk_pagedone(walk, out, more);
 }
 EXPORT_SYMBOL_GPL(scatterwalk_done);
-- 
1.7.0.4
