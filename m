Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB118C388F9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 22:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9799B20FC3
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 22:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603492128;
	bh=0JGkPldSTQ0mjX8nFULRC/vLmBKJl6lR8G1LPBTcZgw=;
	h=From:To:Subject:Date:List-ID:From;
	b=OJA4Yzo7P7sNINPyufLWvJxRgUEm8BdLO/3YHpo/a2/Dp0vwPLUthWZCjcbkOQjUR
	 lmQIxH4XnUwsey1KAwvV5Q6EL5kUqEMyJa4yRAgbrVyQKyPkMmH1gznTZ0W7rP0EQB
	 shhyTeSKmSrCfNX52kW10Jq9mJBDWWAsIkRdZkv4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757101AbgJWW2s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 18:28:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752863AbgJWW2r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 18:28:47 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EE3120BED;
        Fri, 23 Oct 2020 22:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603492127;
        bh=0JGkPldSTQ0mjX8nFULRC/vLmBKJl6lR8G1LPBTcZgw=;
        h=From:To:Subject:Date:From;
        b=tiGciqw2b7a05vZvzrnG4QAMHQhIVyNMVV1UOMVI/l0Lpdn/S5Fp4t0M1vk2Z7vkZ
         nuNs60eYrRZkxnwR5dOn+L0JuH5KrKOEmfDUcRU4knOswydwPyeJwO32lsNKWR860m
         reOQxtMD++rYTizeWbAzFokyeL3pAixotjTlc+AI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: x86/poly1305 - add back a needed assignment
Date:   Fri, 23 Oct 2020 15:27:48 -0700
Message-Id: <20201023222748.356207-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

One of the assignments that was removed by commit 4a0c1de64bf9 ("crypto:
x86/poly1305 - Remove assignments with no effect") is actually needed,
since it affects the return value.

This fixes the following crypto self-test failure:

    alg: shash: poly1305-simd test failed (wrong result) on test vector 2, cfg="init+update+final aligned buffer"

Fixes: 4a0c1de64bf9 ("crypto: x86/poly1305 - Remove assignments with no effect")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Note, this is a regression in mainline, so please include this in a pull
request for 5.10.

 arch/x86/crypto/poly1305_glue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index e508dbd91813..c44aba290fbb 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -158,6 +158,7 @@ static unsigned int crypto_poly1305_setdctxkey(struct poly1305_desc_ctx *dctx,
 			dctx->s[1] = get_unaligned_le32(&inp[4]);
 			dctx->s[2] = get_unaligned_le32(&inp[8]);
 			dctx->s[3] = get_unaligned_le32(&inp[12]);
+			acc += POLY1305_BLOCK_SIZE;
 			dctx->sset = true;
 		}
 	}
-- 
2.29.0.rc1.297.gfa9743e501-goog

