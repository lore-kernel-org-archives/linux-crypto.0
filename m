Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD495C10F06
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B42421873
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062758;
	bh=S+VPA/js+3Wi5LAsbZq+CblueXa8BKl2WKAutCe/PqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lTQ4T2Nejyx8M0gnVNPq+ZXumCwZuvkISR4VsKs0DsQP9xmhibGWGRgLS+Zso6FXA
	 8M4wYxGPksGG8f78Ya2TUjktoalSbS6IgIi/TI+TuRsUegU6RmO+Kb17XVNPqFn+iV
	 i34YlGOPxW9pVbCkMA0JwoxP1og9cVU7SRQZayBw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731388AbfCaUF5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731347AbfCaUF5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:05:57 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C09CB21841;
        Sun, 31 Mar 2019 20:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062756;
        bh=S+VPA/js+3Wi5LAsbZq+CblueXa8BKl2WKAutCe/PqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODmDbx+LkLSjLr0aF8vp3AFt3DZUZw10EnPlIC+NeNBtBmM9iTr25vwfS/cTIFDxi
         OXw75Ki7fHMwkn+LZTNjl6OKLzkDm0d19HuPKhvNvVX8SAWK14i1TolREgGP1VOBaj
         zrLOFTtr9XNtPV56Q524UwyeL2K3szm4D1nWvJio=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org, Tim Chen <tim.c.chen@linux.intel.com>
Subject: [RFC/RFT PATCH 03/18] crypto: x86/crct10dif-pcl - fix use via crypto_shash_digest()
Date:   Sun, 31 Mar 2019 13:04:13 -0700
Message-Id: <20190331200428.26597-4-ebiggers@kernel.org>
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

The ->digest() method of crct10dif-pclmul reads the current CRC value
from the shash_desc context.  But this value is uninitialized, causing
crypto_shash_digest() to compute the wrong result.  Fix it.

Probably this wasn't noticed before because lib/crc-t10dif.c only uses
crypto_shash_update(), not crypto_shash_digest().  Likewise,
crypto_shash_digest() is not yet tested by the crypto self-tests because
those only test the ahash API which only uses shash init/update/final.

Fixes: 0b95a7f85718 ("crypto: crct10dif - Glue code to cast accelerated CRCT10DIF assembly as a crypto transform")
Cc: <stable@vger.kernel.org> # v3.11+
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/crct10dif-pclmul_glue.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
index 64f17d2d8b67a..3c81e15b0873f 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -71,15 +71,14 @@ static int chksum_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
-static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
-			u8 *out)
+static int __chksum_finup(__u16 crc, const u8 *data, unsigned int len, u8 *out)
 {
 	if (len >= 16 && crypto_simd_usable()) {
 		kernel_fpu_begin();
-		*(__u16 *)out = crc_t10dif_pcl(*crcp, data, len);
+		*(__u16 *)out = crc_t10dif_pcl(crc, data, len);
 		kernel_fpu_end();
 	} else
-		*(__u16 *)out = crc_t10dif_generic(*crcp, data, len);
+		*(__u16 *)out = crc_t10dif_generic(crc, data, len);
 	return 0;
 }
 
@@ -88,15 +87,13 @@ static int chksum_finup(struct shash_desc *desc, const u8 *data,
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

