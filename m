Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12976C3A5A9
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5DB624959
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588397623;
	bh=Cay7/GP0dae7IJrK064oyAbylA+W00bKDeNseMLpuzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uhM9mQcnNPk3pSCW3+/cYOPfqdHu2Hp29V/lgTE0qoKvQL5vCGV54gE8lEGuqp87t
	 mKQ0EzyY2AXYF+Dl1RKeCubPOW8R5g2fVOnhSBKCA6AJWhxY7BTpK24J93IGw/RLcX
	 +xW0fnxVg2ZckzzZLSbDNnXVOQ2bkJRO/jCAeVAs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgEBFdn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 01:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726058AbgEBFdm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 01:33:42 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 760BD2071E;
        Sat,  2 May 2020 05:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588397622;
        bh=Cay7/GP0dae7IJrK064oyAbylA+W00bKDeNseMLpuzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTi1AbLyuRBTE6jA8bd4iplXDUQobJR7Dr/uTPm+lv/8x0J43czffciDP0gb109Iu
         BZqDfYxI4hlTnRwOYrWaXfdSCvUQyXnKwFVevI5li5UoIvE3pu5bFYkllhUYMxI0pT
         ULTJydf5V8BYalLHN29p6UX7ufyFaK35VxSmvzH8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>
Subject: [PATCH 04/20] crypto: artpec6 - use crypto_shash_tfm_digest()
Date:   Fri,  1 May 2020 22:31:06 -0700
Message-Id: <20200502053122.995648-5-ebiggers@kernel.org>
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

Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/axis/artpec6_crypto.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index fcf1effc7661ec..62ba0325a61871 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -2239,16 +2239,12 @@ artpec6_crypto_hash_set_key(struct crypto_ahash *tfm,
 	blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 
 	if (keylen > blocksize) {
-		SHASH_DESC_ON_STACK(hdesc, tfm_ctx->child_hash);
-
-		hdesc->tfm = tfm_ctx->child_hash;
-
 		tfm_ctx->hmac_key_length = blocksize;
-		ret = crypto_shash_digest(hdesc, key, keylen,
-					  tfm_ctx->hmac_key);
+
+		ret = crypto_shash_tfm_digest(tfm_ctx->child_hash, key, keylen,
+					      tfm_ctx->hmac_key);
 		if (ret)
 			return ret;
-
 	} else {
 		memcpy(tfm_ctx->hmac_key, key, keylen);
 		tfm_ctx->hmac_key_length = keylen;
-- 
2.26.2

