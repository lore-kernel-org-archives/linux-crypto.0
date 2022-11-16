Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF812C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Nov 2022 13:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiKPN6W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Nov 2022 08:58:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiKPN4a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2022 08:56:30 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E754347312;
        Wed, 16 Nov 2022 05:53:14 -0800 (PST)
Received: from hednb3.intra.ispras.ru (unknown [10.10.2.52])
        by mail.ispras.ru (Postfix) with ESMTPSA id 8001040737B7;
        Wed, 16 Nov 2022 13:53:10 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 8001040737B7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1668606790;
        bh=JxEVrn+CoDPfLQqba4pxYEzAJIOuMvgQmIttHtvn1nE=;
        h=From:To:Cc:Subject:Date:From;
        b=GxRIBPHdwORe3YfuO45TguEuwZDn1SBQbbYIORdScBHlLqWH2KaPNlS6IXwA2t33G
         Suk07DbARRW/aQ1wVSMB0pJ3Wijv6GtYZ3pZ0dS1qL+gnwmVpZ3wOyoiL+08/WMrO8
         c+GhvrD/Jcnb2lBAil85JrLR1GRpCgAwhgqFb9J8=
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: [PATCH] crypto: algapi - fix be32_to_cpu macro call in crypto_inc()
Date:   Wed, 16 Nov 2022 16:52:51 +0300
Message-Id: <1668606771-5382-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

be32_to_cpu() macro in some cases may be expanded to an expression
that evaluates its arguments multiple times. Because of the decrement
in argument it has unexpected result in such cases.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: 7613636def82 ("[CRYPTO] api: Add crypto_inc and crypto_xor")
---
 crypto/algapi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 5c69ff8e8fa5..18f14aed1658 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -987,7 +987,8 @@ void crypto_inc(u8 *a, unsigned int size)
 	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
 	    IS_ALIGNED((unsigned long)b, __alignof__(*b)))
 		for (; size >= 4; size -= 4) {
-			c = be32_to_cpu(*--b) + 1;
+			b--;
+			c = be32_to_cpu(*b) + 1;
 			*b = cpu_to_be32(c);
 			if (likely(c))
 				return;
-- 
2.7.4

