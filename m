From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/4] [CRYPTO] scatterwalk: Handle zero nbytes in scatterwalk_map_and_copy
Date: Fri, 14 Dec 2007 16:39:46 +0800
Message-ID: <E1J365C-00047C-00@gondolin.me.apana.org.au>
References: <20071214083909.GA15726@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4705 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757018AbXLNIjs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Dec 2007 03:39:48 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J365C-00009A-Vm
	for <linux-crypto@vger.kernel.org>; Fri, 14 Dec 2007 19:39:47 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] scatterwalk: Handle zero nbytes in scatterwalk_map_and_copy

It's better to return silently than crash and burn when someone feeds us
a zero length.  In particular the null digest algorithm when used as part
of authenc will do that to us.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c |    3 +++
 1 files changed, 3 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 297e19d..9aeeb52 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -105,6 +105,9 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 	struct scatter_walk walk;
 	unsigned int offset = 0;
 
+	if (!nbytes)
+		return;
+
 	for (;;) {
 		scatterwalk_start(&walk, sg);
 
