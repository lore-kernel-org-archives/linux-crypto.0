Return-Path: <SRS0=1Zye=TW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4960EC282CE
	for <linux-crypto@archiver.kernel.org>; Wed, 22 May 2019 19:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 100D82081C
	for <linux-crypto@archiver.kernel.org>; Wed, 22 May 2019 19:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558554200;
	bh=Eu5uL8cehpI9lUHeQu0RY/lyRyhIwPZeIGqy8mq0Q/U=;
	h=From:To:Subject:Date:List-ID:From;
	b=CMQ8uT0IuIbNRbWqt0+8QEjgAnkuZBCnBN8sPgKjlsT7ZrrOttGtISE4lIsOLH/Zu
	 UFFtWUzldRt5kih+/lrYfLT6uq87l6dQimfh5dN39k1GbC3XaFvj5oVY/5832lvog/
	 iIfLoYxFW5Mza74fvIhHVkJfBUJS/6P9R/oANmx4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbfEVTnT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 May 2019 15:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730495AbfEVTnS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 May 2019 15:43:18 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC1B20856;
        Wed, 22 May 2019 19:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558554198;
        bh=Eu5uL8cehpI9lUHeQu0RY/lyRyhIwPZeIGqy8mq0Q/U=;
        h=From:To:Subject:Date:From;
        b=QrTQY/4uvadf3vyKhdLWkDjQOvLKWx0M0yoIqc3WCb+rAuBEK/Rr++xBtr+JCsUwd
         wUMP0erGXJ1YQgE/SmaQhZZUMit1P4lLkyDSO3C1NpoElq/xHVfwNTLKtxu8rcvsby
         dCzTxtjL+Po4y+zmr5PfiHsiFoDxA+5/eoLRV6vM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: hmac - fix memory leak in hmac_init_tfm()
Date:   Wed, 22 May 2019 12:42:29 -0700
Message-Id: <20190522194229.101989-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When I added the sanity check of 'descsize', I missed that the child
hash tfm needs to be freed if the sanity check fails.  Of course this
should never happen, hence the use of WARN_ON(), but it should be fixed.

Fixes: e1354400b25d ("crypto: hash - fix incorrect HASH_MAX_DESCSIZE")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/hmac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 241b1868c1d01..ac8c611ee33e4 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -157,8 +157,10 @@ static int hmac_init_tfm(struct crypto_tfm *tfm)
 
 	parent->descsize = sizeof(struct shash_desc) +
 			   crypto_shash_descsize(hash);
-	if (WARN_ON(parent->descsize > HASH_MAX_DESCSIZE))
+	if (WARN_ON(parent->descsize > HASH_MAX_DESCSIZE)) {
+		crypto_free_shash(hash);
 		return -EINVAL;
+	}
 
 	ctx->hash = hash;
 	return 0;
-- 
2.22.0.rc1.257.g3120a18244-goog

