From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/6] crypto: api - Include linux/fips.h
Date: Wed, 22 Apr 2015 13:25:53 +0800
Message-ID: <E1YknAX-0001yq-LU@gondolin.me.apana.org.au>
References: <20150422052452.GA7553@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35334 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbbDVFZ4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Apr 2015 01:25:56 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YknAX-0005Ry-U7
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2015 15:25:54 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

All users of fips_enabled should include linux/fips.h directly
instead of getting it through internal.h.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algapi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index f835f43..c63836f 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -12,6 +12,7 @@
 
 #include <linux/err.h>
 #include <linux/errno.h>
+#include <linux/fips.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
