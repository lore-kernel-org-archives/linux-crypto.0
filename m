From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] crypto: remove 842-nx null checks
Date: Fri, 15 May 2015 11:07:33 -0400
Message-ID: <1431702453-12118-1-git-send-email-ddstreet@ieee.org>
References: <20150515070424.GA17008@gondor.apana.org.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Dan Streetman <ddstreet@ieee.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34056 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbbEOPIE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 May 2015 11:08:04 -0400
Received: by ieczm2 with SMTP id zm2so43750000iec.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2015 08:08:04 -0700 (PDT)
In-Reply-To: <20150515070424.GA17008@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove the null checks for tfm, src, slen, dst, dlen; tfm will never
be null and the other fields are always expected to be set correctly.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/nx-842-crypto.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-crypto.c b/drivers/crypto/nx/nx-842-crypto.c
index cb177c3..2ffa103 100644
--- a/drivers/crypto/nx/nx-842-crypto.c
+++ b/drivers/crypto/nx/nx-842-crypto.c
@@ -298,9 +298,6 @@ static int nx842_crypto_compress(struct crypto_tfm *tfm,
 	bool add_header;
 	u16 ignore = 0;
 
-	if (!tfm || !src || !slen || !dst || !dlen)
-		return -EINVAL;
-
 	p.in = (u8 *)src;
 	p.iremain = slen;
 	p.out = dst;
@@ -483,9 +480,6 @@ static int nx842_crypto_decompress(struct crypto_tfm *tfm,
 	u16 ignore = 0;
 	bool usehw = true;
 
-	if (!tfm || !src || !slen || !dst || !dlen)
-		return -EINVAL;
-
 	p.in = (u8 *)src;
 	p.iremain = slen;
 	p.out = dst;
-- 
2.1.0
