Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53D9C47247
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAD5224956
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588397624;
	bh=yP/fXzlmOFLFUYfLP8XJIbmBwCM906efeHEFJWhwvGs=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=CBryR3cBu4575JGHfPAfDywxi6hQ4yOF8075f47DjLEYDifWGbeoA4F7R79iLg8HI
	 Dgvp0Jr+Pkk9XIYCWry+8QFkFzXch4OMRtVaIPkc+LHeDwoWsBc0hnhjZr1vLtsDYl
	 DThvOOSbgskbSU72QiE/a6DTgYuVDUDW68PnA03c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgEBFdo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 01:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgEBFdn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 01:33:43 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7708121974
        for <linux-crypto@vger.kernel.org>; Sat,  2 May 2020 05:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588397623;
        bh=yP/fXzlmOFLFUYfLP8XJIbmBwCM906efeHEFJWhwvGs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=J8liRbwiJYEzkZnRWIJfwVOxB7vSYtfTgK0fWSJlfHMeSxReaS107DHcu1d935euv
         H5EvEAikylFK/oQfoNrrQuiiPukqZOoQaxuUK0UtpwCF5M5jPjKcPkvEuglDG5TCAF
         uvy1y+AUyPUZ3h8nFyhUrNBXpPnRgO98AHPVXR1M=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 08/20] crypto: mediatek - use crypto_shash_tfm_digest()
Date:   Fri,  1 May 2020 22:31:10 -0700
Message-Id: <20200502053122.995648-9-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/mediatek/mtk-sha.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/mediatek/mtk-sha.c b/drivers/crypto/mediatek/mtk-sha.c
index bd6309e57ab81a..da3f0b8814aa49 100644
--- a/drivers/crypto/mediatek/mtk-sha.c
+++ b/drivers/crypto/mediatek/mtk-sha.c
@@ -805,12 +805,9 @@ static int mtk_sha_setkey(struct crypto_ahash *tfm, const u8 *key,
 	size_t ds = crypto_shash_digestsize(bctx->shash);
 	int err, i;
 
-	SHASH_DESC_ON_STACK(shash, bctx->shash);
-
-	shash->tfm = bctx->shash;
-
 	if (keylen > bs) {
-		err = crypto_shash_digest(shash, key, keylen, bctx->ipad);
+		err = crypto_shash_tfm_digest(bctx->shash, key, keylen,
+					      bctx->ipad);
 		if (err)
 			return err;
 		keylen = ds;
-- 
2.26.2

