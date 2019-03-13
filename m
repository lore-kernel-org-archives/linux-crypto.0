Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A87C4360F
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B42721874
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 05:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552454139;
	bh=4bywO5eXatDKtqu/5HOPPSncChimudaqktyjzb5khMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=feZqx8GYxCynhH/kQfU+vFO+tPX1A1//yacjyJHH6xuPUcfyDn00ZmPCycTiM114a
	 S96z7hMG+8Rcu9vpGQXkAFYV9k1R1b7YEaq7Hfe6oTQX9LdHJZNDUseNRZ+CuFZ5Sj
	 J0Rcco4z7g4a1clhi9KNQd+D2BMl4i5Lm1TYvS+s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfCMFPh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbfCMFPh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 01:15:37 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 507CA21873;
        Wed, 13 Mar 2019 05:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552454136;
        bh=4bywO5eXatDKtqu/5HOPPSncChimudaqktyjzb5khMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0zxmAGwjT8/V73gaaM6KiCK2jKkZT1H2hb4gzX5eR48O5om3ACRG9czPRIBn9HV8
         7c+8IWunmG9rxx0HE/Y57qpOjEXgKyN68VTE+S+WNv6+GhpEG8iwrIHKjdAahExyz4
         4YbVEVI9xvftGjW6FgaTr4RFs2BJ49XYByBWPtks=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 7/8] crypto: simd - convert to use crypto_simd_usable()
Date:   Tue, 12 Mar 2019 22:12:51 -0700
Message-Id: <20190313051252.2917-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313051252.2917-1-ebiggers@kernel.org>
References: <20190313051252.2917-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Replace all calls to may_use_simd() in the shared SIMD helpers with
crypto_simd_usable(), in order to allow testing the no-SIMD code paths.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/simd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/simd.c b/crypto/simd.c
index 7d62686d3a3f..3e3b1d1a6b1f 100644
--- a/crypto/simd.c
+++ b/crypto/simd.c
@@ -85,7 +85,7 @@ static int simd_skcipher_encrypt(struct skcipher_request *req)
 	subreq = skcipher_request_ctx(req);
 	*subreq = *req;
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
 		child = &ctx->cryptd_tfm->base;
 	else
@@ -106,7 +106,7 @@ static int simd_skcipher_decrypt(struct skcipher_request *req)
 	subreq = skcipher_request_ctx(req);
 	*subreq = *req;
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (in_atomic() && cryptd_skcipher_queued(ctx->cryptd_tfm)))
 		child = &ctx->cryptd_tfm->base;
 	else
@@ -336,7 +336,7 @@ static int simd_aead_encrypt(struct aead_request *req)
 	subreq = aead_request_ctx(req);
 	*subreq = *req;
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (in_atomic() && cryptd_aead_queued(ctx->cryptd_tfm)))
 		child = &ctx->cryptd_tfm->base;
 	else
@@ -357,7 +357,7 @@ static int simd_aead_decrypt(struct aead_request *req)
 	subreq = aead_request_ctx(req);
 	*subreq = *req;
 
-	if (!may_use_simd() ||
+	if (!crypto_simd_usable() ||
 	    (in_atomic() && cryptd_aead_queued(ctx->cryptd_tfm)))
 		child = &ctx->cryptd_tfm->base;
 	else
-- 
2.21.0

