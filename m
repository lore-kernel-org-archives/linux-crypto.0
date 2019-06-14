Return-Path: <SRS0=me0G=UN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3330AC31E4B
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 20:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF26221473
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jun 2019 20:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560544679;
	bh=1UHtruAhcIKtbxyrI9yPCM/Ec1ZsP54ZaoOnGt4gJt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=F38vQB8mkLvqKSrtqjWqYDEVC+2tz2scR9NxARaYUT8y6BxIR3N0KM1il92Ssp3DQ
	 hM4ESdmf5sCY8I+6eMyUpWMPFQx23kvP5UuLskmJ+AV2L0z8xbVi8KxkAF065W08lN
	 3MDPrj32g3WwrGRjXfSQ/I/9HndQQejnEbXXjBg0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727621AbfFNUhw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jun 2019 16:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbfFNU3F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:05 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8F7821872;
        Fri, 14 Jun 2019 20:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544144;
        bh=1UHtruAhcIKtbxyrI9yPCM/Ec1ZsP54ZaoOnGt4gJt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZ9TzDrh0rZq9lMzmld85Jz8N/6bxUAsD6kG3LtefVhq9ay/jY+5U0OCsnJ2yJoVw
         Ysj9iJ7F0j5jc50y3O/m4O9wvqOpyI53o1YUdVMbtmq0HzvWYLLf4v5X9Cy1VfV9aA
         h/cJfDZCte7kwV4ZoKU+e4dt/rz3iUous+XPtcdI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 26/59] crypto: hmac - fix memory leak in hmac_init_tfm()
Date:   Fri, 14 Jun 2019 16:28:10 -0400
Message-Id: <20190614202843.26941-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit 7829a0c1cb9c80debfb4fdb49b4d90019f2ea1ac ]

When I added the sanity check of 'descsize', I missed that the child
hash tfm needs to be freed if the sanity check fails.  Of course this
should never happen, hence the use of WARN_ON(), but it should be fixed.

Fixes: e1354400b25d ("crypto: hash - fix incorrect HASH_MAX_DESCSIZE")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/hmac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index 4b8c8ee8f15c..c623778b36ba 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -168,8 +168,10 @@ static int hmac_init_tfm(struct crypto_tfm *tfm)
 
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
2.20.1

