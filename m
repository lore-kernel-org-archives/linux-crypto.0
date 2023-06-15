Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185B6EB64D9
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jun 2023 10:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239326AbjFOK3T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jun 2023 06:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241136AbjFOK3M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2023 06:29:12 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A002943;
        Thu, 15 Jun 2023 03:29:08 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q9kDi-003HqK-TQ; Thu, 15 Jun 2023 18:28:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Jun 2023 18:28:50 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Thu, 15 Jun 2023 18:28:50 +0800
Subject: [PATCH 3/5] KEYS: Add forward declaration in asymmetric-parser.h
References: <ZIrnPcPj9Zbq51jK@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Roberto Sassu <roberto.sassu@huaweicloud.com>,
        David Howells <dhowells@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>, dmitry.kasatkin@gmail.com,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, keyrings@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1q9kDi-003HqK-TQ@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add forward declaration for struct key_preparsed_payload so that
this header file is self-contained.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/keys/asymmetric-parser.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/keys/asymmetric-parser.h b/include/keys/asymmetric-parser.h
index c47dc5405f79..516a3f51179e 100644
--- a/include/keys/asymmetric-parser.h
+++ b/include/keys/asymmetric-parser.h
@@ -10,6 +10,8 @@
 #ifndef _KEYS_ASYMMETRIC_PARSER_H
 #define _KEYS_ASYMMETRIC_PARSER_H
 
+struct key_preparsed_payload;
+
 /*
  * Key data parser.  Called during key instantiation.
  */
