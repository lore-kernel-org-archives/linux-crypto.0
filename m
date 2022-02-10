Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE90C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 02:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbiBJCKa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 21:10:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiBJCKP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 21:10:15 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE4610F3
        for <linux-crypto@vger.kernel.org>; Wed,  9 Feb 2022 18:09:43 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nHytw-0006P9-3u; Thu, 10 Feb 2022 13:09:41 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Feb 2022 13:09:40 +1100
Date:   Thu, 10 Feb 2022 13:09:40 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        rftc@gmx.de
Subject: [PATCH] crypto: xts - Add softdep on ecb
Message-ID: <YgRz5HKiN3fPigjW@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The xts module needs ecb to be present as it's meant to work
on top of ecb.  This patch adds a softdep so ecb can be included
automatically into the initramfs.

Reported-by: rftc <rftc@gmx.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/xts.c b/crypto/xts.c
index 6c12f30dbdd6..63c85b9e64e0 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -466,3 +466,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("XTS block cipher mode");
 MODULE_ALIAS_CRYPTO("xts");
 MODULE_IMPORT_NS(CRYPTO_INTERNAL);
+MODULE_SOFTDEP("pre: ecb");
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
