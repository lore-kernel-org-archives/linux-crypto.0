Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB81C10F0A
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E13020872
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062759;
	bh=WyFW0Wbb7YXGKrbrUhOrdyeSisGf10uRnisl7Ut7Fek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VsmEy7gPeq7MHQjfdw/FT04HbZaHqcynQeJOFdE1T9gEBNqXNb5c+XK1FK+HA1RFU
	 6wMAGhJr/RiAUssbPV59wPm58gSKvEnJOwCtnUIcD8E449p9LmDrjSBRyaxElR5CpP
	 qgMeScVMusyTyhnieENV7LvdhrKofrWqHhWvXgZE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbfCaUF5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731328AbfCaUF5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:05:57 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF9B20882;
        Sun, 31 Mar 2019 20:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062756;
        bh=WyFW0Wbb7YXGKrbrUhOrdyeSisGf10uRnisl7Ut7Fek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRMIcqUk50wjI/SQB1kRBHV6uo3+ukvufdrcXaaOCeS+PfiTSdaq0F+I6JCSNJRqW
         sqIk4dMr/ZHMM+kYix3DRhMYebZxtEP8jFyFPTSFs4Yag3cYlEYwPop7x50F9CQWIO
         1c3vL1B14kSOrFROP7sswC1/DHwzwhAZqm1YLNCU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Subject: [RFC/RFT PATCH 02/18] crypto: crct10dif-generic - fix use via crypto_shash_digest()
Date:   Sun, 31 Mar 2019 13:04:12 -0700
Message-Id: <20190331200428.26597-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190331200428.26597-1-ebiggers@kernel.org>
References: <20190331200428.26597-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The ->digest() method of crct10dif-generic reads the current CRC value
from the shash_desc context.  But this value is uninitialized, causing
crypto_shash_digest() to compute the wrong result.  Fix it.

Probably this wasn't noticed before because lib/crc-t10dif.c only uses
crypto_shash_update(), not crypto_shash_digest().  Likewise,
crypto_shash_digest() is not yet tested by the crypto self-tests because
those only test the ahash API which only uses shash init/update/final.

This bug was detected by my patches that improve testmgr to fuzz
algorithms against their generic implementation.

Fixes: 2d31e518a428 ("crypto: crct10dif - Wrap crc_t10dif function all to use crypto transform framework")
Cc: <stable@vger.kernel.org> # v3.11+
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/crct10dif_generic.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/crypto/crct10dif_generic.c b/crypto/crct10dif_generic.c
index 8e94e29dc6fc8..d08048ae55527 100644
--- a/crypto/crct10dif_generic.c
+++ b/crypto/crct10dif_generic.c
@@ -65,10 +65,9 @@ static int chksum_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
-static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
-			u8 *out)
+static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 *out)
 {
-	*(__u16 *)out = crc_t10dif_generic(*crcp, data, len);
+	*(__u16 *)out = crc_t10dif_generic(crc, data, len);
 	return 0;
 }
 
@@ -77,15 +76,13 @@ static int chksum_finup(struct shash_desc *desc, const u8 *data,
 {
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	return __chksum_finup(&ctx->crc, data, len, out);
+	return __chksum_finup(ctx->crc, data, len, out);
 }
 
 static int chksum_digest(struct shash_desc *desc, const u8 *data,
 			 unsigned int length, u8 *out)
 {
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup(&ctx->crc, data, length, out);
+	return __chksum_finup(0, data, length, out);
 }
 
 static struct shash_alg alg = {
-- 
2.21.0

