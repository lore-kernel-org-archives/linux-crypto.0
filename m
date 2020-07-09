Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BAE4C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E610820786
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgGIMoJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 08:44:09 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36098 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgGIMoJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 08:44:09 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jtVuG-0003gj-Bo; Thu, 09 Jul 2020 22:44:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Jul 2020 22:44:04 +1000
Date:   Thu, 9 Jul 2020 22:44:04 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Subject: [PATCH] crypto: ccp - Silence strncpy warning
Message-ID: <20200709124404.GA27076@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch kills an strncpy by using strscpy instead.  The name
would be silently truncated if it is too long.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index b0cc2bd73af8..2bc29736fa45 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -19,6 +19,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/sha.h>
 #include <crypto/scatterwalk.h>
+#include <linux/string.h>
 
 #include "ccp-crypto.h"
 
@@ -424,7 +425,7 @@ static int ccp_register_hmac_alg(struct list_head *head,
 	*ccp_alg = *base_alg;
 	INIT_LIST_HEAD(&ccp_alg->entry);
 
-	strncpy(ccp_alg->child_alg, def->name, CRYPTO_MAX_ALG_NAME);
+	strscpy(ccp_alg->child_alg, def->name, CRYPTO_MAX_ALG_NAME);
 
 	alg = &ccp_alg->alg;
 	alg->setkey = ccp_sha_setkey;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
