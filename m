Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2ECC4725A
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 560A324956
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588397625;
	bh=QZs8P473wPsf3cbvaC4ELX+xuF5ysg6fyzP6woBqpPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=d6953TrSTtXYcTW7JnA/8cCZNqXJiqQAwrd/d3acasUxoT2b12vv55izf42nevfJH
	 ki3vqd91eglPdOCSZqqu59q8veWWtbvaQ6ISJF6E6aIZqmaJekjbAKvXDhRKTrpw8i
	 4hRRoxI0eFUxZi9gniyDHb/iCRBAyDWuALIwlKZs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgEBFdo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 01:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727121AbgEBFdn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 01:33:43 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A6AA2192A;
        Sat,  2 May 2020 05:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588397623;
        bh=QZs8P473wPsf3cbvaC4ELX+xuF5ysg6fyzP6woBqpPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scGDPZMjLPExTI6o1Kw6y8aFWf3Ycc36HkEIqM0A6fWvyLU0/CsMpUlOCxKcQ+shq
         q8vZ8MgGzNd7RbB5xN6/u05DiDoNpb0mfAkK2gP+jVt4ZSD8jNxxG3x8K4/dE40xy1
         buNqbQR5mgRkqf6XzNFrTICCy2oKYm7F5DTAEXJ0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Zaibo Xu <xuzaibo@huawei.com>
Subject: [PATCH 07/20] crypto: hisilicon/sec2 - use crypto_shash_tfm_digest()
Date:   Fri,  1 May 2020 22:31:09 -0700
Message-Id: <20200502053122.995648-8-ebiggers@kernel.org>
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

Cc: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 7f1c6a31b82f35..848ab492d26e3e 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -832,7 +832,6 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
 				 struct crypto_authenc_keys *keys)
 {
 	struct crypto_shash *hash_tfm = ctx->hash_tfm;
-	SHASH_DESC_ON_STACK(shash, hash_tfm);
 	int blocksize, ret;
 
 	if (!keys->authkeylen) {
@@ -842,8 +841,8 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
 
 	blocksize = crypto_shash_blocksize(hash_tfm);
 	if (keys->authkeylen > blocksize) {
-		ret = crypto_shash_digest(shash, keys->authkey,
-					  keys->authkeylen, ctx->a_key);
+		ret = crypto_shash_tfm_digest(hash_tfm, keys->authkey,
+					      keys->authkeylen, ctx->a_key);
 		if (ret) {
 			pr_err("hisi_sec2: aead auth digest error!\n");
 			return -EINVAL;
-- 
2.26.2

