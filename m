Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61390C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23907218A1
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552623694;
	bh=666UtQRKReCiJACuOrxR6mH37KrfOp39EKNDy/Xm8HE=;
	h=From:To:Subject:Date:List-ID:From;
	b=cSTa8O4sMBrJ1rKzrJmGhKkYQ/lQ63bcCNMJC2A5IvistPTba/hZkf69Wdn2vkRlk
	 7YAhC2YE4wRKDVDidYwlYLR1HRaR0t7oAanK2UiaUi+/ImjJ1PbSgjEJLThnpkt9SX
	 k3hwKrDjuhRx3eF1xzZYPh2zUFcg/RqGUdTkBMJw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbfCOEVd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbfCOEVd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 00:21:33 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F33C92186A;
        Fri, 15 Mar 2019 04:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552623693;
        bh=666UtQRKReCiJACuOrxR6mH37KrfOp39EKNDy/Xm8HE=;
        h=From:To:Subject:Date:From;
        b=s/1wkxFlO0Hbf8pSn+WwNKUkmiYUJq1el5UeCam2E8no+lvV3MUBAPd7d8wMLKVph
         0kz7IDe4APDjqYcfUbrgTAU5qwNLW04ltR5T9lzpd4v8dG3e47IF3LPxQnK3S4TFOS
         tk2IFvXgcfrhtPU6gSBtBgMxQxCkkAVWUq7U6gMY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: salsa20-generic - use crypto_xor_cpy()
Date:   Thu, 14 Mar 2019 21:21:28 -0700
Message-Id: <20190315042128.32403-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In salsa20_docrypt(), use crypto_xor_cpy() instead of crypto_xor().
This avoids having to memcpy() the src buffer to the dst buffer.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/salsa20_generic.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index 00fce32ae17a..443fba09cbed 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -86,18 +86,17 @@ static void salsa20_docrypt(u32 *state, u8 *dst, const u8 *src,
 {
 	__le32 stream[SALSA20_BLOCK_SIZE / sizeof(__le32)];
 
-	if (dst != src)
-		memcpy(dst, src, bytes);
-
 	while (bytes >= SALSA20_BLOCK_SIZE) {
 		salsa20_block(state, stream);
-		crypto_xor(dst, (const u8 *)stream, SALSA20_BLOCK_SIZE);
+		crypto_xor_cpy(dst, src, (const u8 *)stream,
+			       SALSA20_BLOCK_SIZE);
 		bytes -= SALSA20_BLOCK_SIZE;
 		dst += SALSA20_BLOCK_SIZE;
+		src += SALSA20_BLOCK_SIZE;
 	}
 	if (bytes) {
 		salsa20_block(state, stream);
-		crypto_xor(dst, (const u8 *)stream, bytes);
+		crypto_xor_cpy(dst, src, (const u8 *)stream, bytes);
 	}
 }
 
-- 
2.21.0

