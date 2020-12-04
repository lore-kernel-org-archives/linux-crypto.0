Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05061C1B0D9
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 17:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F6722B43
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 17:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388514AbgLDRFw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Dec 2020 12:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388471AbgLDRFw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Dec 2020 12:05:52 -0500
Received: from latitanza.investici.org (latitanza.investici.org [IPv6:2001:888:2000:56::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37AFC061A52
        for <linux-crypto@vger.kernel.org>; Fri,  4 Dec 2020 09:05:03 -0800 (PST)
Received: from mx3.investici.org (unknown [127.0.0.1])
        by latitanza.investici.org (Postfix) with ESMTP id 4CnfFJ4PVmz8sgM;
        Fri,  4 Dec 2020 17:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1607101460;
        bh=gIk9W+Rj/wr2yLXrcQnEBv0D9GdsEMSYb5Q/KwMf3wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPSMRQkbP8NPk5NKlROEj7mrY8QRY3USoQVGMdhcC+Ii+r5Y4xY2pSBE2b9LkLTou
         ZJYYc6olk86+NUF/V0c72u05Bkc3o7ue9Rz1RNdfqFsXuCtAmc+AVaaNJVkzrr9D7g
         eR7OklxOVtWZKHJT1SgDvPUcVE1UNI/P4XTy6EHo=
Received: from [82.94.249.234] (mx3.investici.org [82.94.249.234]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4CnfFJ07MFz8sfb;
        Fri,  4 Dec 2020 17:04:19 +0000 (UTC)
From:   laniel_francis@privacyrequired.com
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 03/12] crypto: Replace strstarts() by str_has_prefix().
Date:   Fri,  4 Dec 2020 18:03:09 +0100
Message-Id: <20201204170319.20383-4-laniel_francis@privacyrequired.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201204170319.20383-1-laniel_francis@privacyrequired.com>
References: <20201204170319.20383-1-laniel_francis@privacyrequired.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Francis Laniel <laniel_francis@privacyrequired.com>

The two functions indicates if a string begins with a given prefix.
The only difference is that strstarts() returns a bool while str_has_prefix()
returns the length of the prefix if the string begins with it or 0 otherwise.

Signed-off-by: Francis Laniel <laniel_francis@privacyrequired.com>
---
 crypto/essiv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index d012be23d496..f85d4416891f 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -504,7 +504,7 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 			goto out_free_inst;
 		aead_alg = crypto_spawn_aead_alg(&ictx->u.aead_spawn);
 		block_base = &aead_alg->base;
-		if (!strstarts(block_base->cra_name, "authenc(")) {
+		if (!str_has_prefix(block_base->cra_name, "authenc(")) {
 			pr_warn("Only authenc() type AEADs are supported by ESSIV\n");
 			err = -EINVAL;
 			goto out_drop_skcipher;
-- 
2.20.1

