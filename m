Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D9CC47254
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F0D724954
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588397624;
	bh=CT5T+FWIwZZ4k0IhAgE2/ARqIcMpCjboija1/f3cLtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=I3wos3Y4xZugDRyqj1LWtgx5g5iT3/jnkIKIBi3iTeRHHI/TZqH11nX6FF/Uawq+w
	 d07IGluDKhJRYNO1sL2BFbVHTErz2IBhUpr7DizuPAmI3VbBoNG5b8bfoc0GZHUuGH
	 v+NKKezxWde02P96NnNyjU2euI+ogNKCzyy+TVHQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgEBFdn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 01:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgEBFdn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 01:33:43 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B86FC208DB;
        Sat,  2 May 2020 05:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588397622;
        bh=CT5T+FWIwZZ4k0IhAgE2/ARqIcMpCjboija1/f3cLtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c3CXxZgb/pHNFcliYxooaDt+5xIHcz6eqtG3BqthskKjGWgYZA5Kvsbd39/VlIVdg
         4FaIQcbP8xoa7dZ3ODF9CIXEnHDgSSuBdw5FQqO5gj+5rupNxX5JaYmwC5ju/nuL1O
         FZoA84/IWINV5U4VnPpTZ1ahCxGZ69fEAo3tm4yw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 05/20] crypto: ccp - use crypto_shash_tfm_digest()
Date:   Fri,  1 May 2020 22:31:07 -0700
Message-Id: <20200502053122.995648-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502053122.995648-1-ebiggers@kernel.org>
References: <20200502053122.995648-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instead of manually allocating a 'struct shash_desc' on the stack and
calling crypto_shash_digest(), switch to using the new helper function
crypto_shash_tfm_digest() which does this for us.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/ccp/ccp-crypto-sha.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 474e6f1a6a84ec..b0cc2bd73af804 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -272,9 +272,6 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 {
 	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 	struct crypto_shash *shash = ctx->u.sha.hmac_tfm;
-
-	SHASH_DESC_ON_STACK(sdesc, shash);
-
 	unsigned int block_size = crypto_shash_blocksize(shash);
 	unsigned int digest_size = crypto_shash_digestsize(shash);
 	int i, ret;
@@ -289,10 +286,8 @@ static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 
 	if (key_len > block_size) {
 		/* Must hash the input key */
-		sdesc->tfm = shash;
-
-		ret = crypto_shash_digest(sdesc, key, key_len,
-					  ctx->u.sha.key);
+		ret = crypto_shash_tfm_digest(shash, key, key_len,
+					      ctx->u.sha.key);
 		if (ret)
 			return -EINVAL;
 
-- 
2.26.2

