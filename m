Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A56C3A5A9
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 18:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 257852080C
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588444089;
	bh=cCmn2mCi34UzXJr2dq7JnXx4lYXQMsRd9Knm/QvGdQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=F3QhlUvH3d16gjiTHEqH6+lhc44Ts5nuJPIw0tqxijsZ3DpMxNda96NXSVxnVj9KV
	 WdtmOTfY5oUAQz7YoVbwgQjeCF35fgRv3ByvxPBT5IkRvBOnmpbYrcpS8GTj5+v/Us
	 z/xnXdZFRQjYVp4vxHc/AoqqVh6CQSei0qJO3gDE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgEBS2I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 14:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbgEBS2I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 14:28:08 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DEBB20757;
        Sat,  2 May 2020 18:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588444087;
        bh=cCmn2mCi34UzXJr2dq7JnXx4lYXQMsRd9Knm/QvGdQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3ixzjM7pKpsC+3fxs/xq6sFiJoJ+QN3bIzuUU8aTYcvqONZhBlRY9jiCYBW61Zb9
         8LK9f3dhwzHlGceUj3qRvIKuDZOwGr4EupJXe9ZUG3xiYdGYxg8KV0bebrM7NKFU0L
         cjKE09fnzlGvcQ1fOsRdM7Zkbpd91PFj4vyGLmZ8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>, Paolo Abeni <pabeni@redhat.com>,
        mptcp@lists.01.org
Subject: [PATCH 1/7] mptcp: use SHA256_BLOCK_SIZE, not SHA_MESSAGE_BYTES
Date:   Sat,  2 May 2020 11:24:21 -0700
Message-Id: <20200502182427.104383-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502182427.104383-1-ebiggers@kernel.org>
References: <20200502182427.104383-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for naming the SHA-1 stuff in <linux/cryptohash.h>
properly and moving it to a more appropriate header, fix the HMAC-SHA256
code in mptcp_crypto_hmac_sha() to use SHA256_BLOCK_SIZE instead of
"SHA_MESSAGE_BYTES" which is actually the SHA-1 block size.
(Fortunately these are both 64 bytes, so this wasn't a "real" bug...)

Cc: Paolo Abeni <pabeni@redhat.com>
Cc: mptcp@lists.01.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 net/mptcp/crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/crypto.c b/net/mptcp/crypto.c
index c151628bd4161a..81b06d875f9249 100644
--- a/net/mptcp/crypto.c
+++ b/net/mptcp/crypto.c
@@ -61,7 +61,7 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac)
 	put_unaligned_be64(key2, key2be);
 
 	/* Generate key xored with ipad */
-	memset(input, 0x36, SHA_MESSAGE_BYTES);
+	memset(input, 0x36, SHA256_BLOCK_SIZE);
 	for (i = 0; i < 8; i++)
 		input[i] ^= key1be[i];
 	for (i = 0; i < 8; i++)
@@ -78,7 +78,7 @@ void mptcp_crypto_hmac_sha(u64 key1, u64 key2, u8 *msg, int len, void *hmac)
 	sha256_final(&state, &input[SHA256_BLOCK_SIZE]);
 
 	/* Prepare second part of hmac */
-	memset(input, 0x5C, SHA_MESSAGE_BYTES);
+	memset(input, 0x5C, SHA256_BLOCK_SIZE);
 	for (i = 0; i < 8; i++)
 		input[i] ^= key1be[i];
 	for (i = 0; i < 8; i++)
-- 
2.26.2

