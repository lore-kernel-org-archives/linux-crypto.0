Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC56C10F13
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 00:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8674B2084E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 00:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555288752;
	bh=YeKkuQgM3HDpFsIQzPAuM+Nms5k0BstPZbox6qixykE=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=0gJooutamcReO+zqnUV7ZI3JEF8Fy46b00MX11cIaTLcDFss9SwjREqEpKOE9CVwh
	 ChDDdZFbUoOE/Gchn74LN0LPmd8J/Ei7qe8weEmlPV1p6MrCPBW4GHsyOrEHIfN2UW
	 oVvyPLoda9LnsR5orp9HSpnEuiMv1K/B8eeZ8dt0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfDOAjL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Apr 2019 20:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbfDOAjL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Apr 2019 20:39:11 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC74520850
        for <linux-crypto@vger.kernel.org>; Mon, 15 Apr 2019 00:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555288750;
        bh=YeKkuQgM3HDpFsIQzPAuM+Nms5k0BstPZbox6qixykE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=SuX6xC9kcjOf3cg0d0vJOk6zIp/1E6rYx4HziyT3XKAkMQTlrJ+eDzEBWt61jVoLb
         bl0cCwq/De6RYWKjJ9HLya5eNKVsbyaC47+6UVeyzmEig7QYjttjmfQ/d1g3DdOCKS
         lHhaUiQXRRntGa3LNCDgqhxyr3P1xDgWOkepTqt8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [RFC PATCH 1/3] crypto: shash - remove useless crypto_yield() in shash_ahash_digest()
Date:   Sun, 14 Apr 2019 17:37:07 -0700
Message-Id: <20190415003709.1531-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190415003709.1531-1-ebiggers@kernel.org>
References: <20190415003709.1531-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The crypto_yield() in shash_ahash_digest() occurs after the entire
digest operation already happened, so there's no real point.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/shash.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index b85930e9a7a2e..599468478f7bb 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -314,7 +314,6 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 		err = crypto_shash_digest(desc, data + offset, nbytes,
 					  req->result);
 		kunmap_atomic(data);
-		crypto_yield(desc->flags);
 	} else
 		err = crypto_shash_init(desc) ?:
 		      shash_ahash_finup(req, desc);
-- 
2.21.0

