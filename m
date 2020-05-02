Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B96C3A5A9
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 06:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6824F208DB
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 06:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588401309;
	bh=KEgCnu6QyCC/5zlYR9dkUf5lWxIoJKj2MCz88qiaa/E=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=CJL7/y0P+xeLOvuacvZbIdQeBTzzfZ5IAyHCP+YbpsxbTaMjDGW1AF9l6gEUVH8zp
	 kXjStVu4LlMAjc5LvN4ITK1owZv/A/GIJaVuDglsk3CIndPEzfheZqHAhO8rAYDyC+
	 Ky4hNXDHqwALFKir6Z2FiRAcMoIajK5evjJ2X1Ak=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgEBGfI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 02:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgEBGfG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 02:35:06 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05961208DB;
        Sat,  2 May 2020 06:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588401304;
        bh=KEgCnu6QyCC/5zlYR9dkUf5lWxIoJKj2MCz88qiaa/E=;
        h=From:To:Cc:Subject:Date:From;
        b=Vb6niibUTcJXGEnoXuVUpmm/EHXP6ZqInsH2HRchqHe3EZz26c8wjKbw79DHnJtO1
         TA4IY4+6edRpJD6QqkjS08OgqBuDsQJcZUAxPo3rdGYp6Oq+sfit3L5/vrx8QhnHKw
         mxcXkmBZpoW9jqGnnLpqv0zrWHnc6+RsJ2hdjfsE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] lib/xxhash: make xxh{32,64}_update() return void
Date:   Fri,  1 May 2020 23:34:23 -0700
Message-Id: <20200502063423.1052614-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The return value of xxh64_update() is pointless and confusing, since an
error is only returned for input==NULL.  But the callers must ignore
this error because they might pass input=NULL, length=0.

Likewise for xxh32_update().

Just make these functions return void.

Cc: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

lib/xxhash.c doesn't actually have a maintainer, but probably it makes
sense to take this through the crypto tree, alongside the other patch I
sent to return void in lib/crypto/sha256.c.

 include/linux/xxhash.h |  8 ++------
 lib/xxhash.c           | 20 ++++++--------------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/include/linux/xxhash.h b/include/linux/xxhash.h
index 52b073fea17fe4..e1c469802ebdba 100644
--- a/include/linux/xxhash.h
+++ b/include/linux/xxhash.h
@@ -185,10 +185,8 @@ void xxh32_reset(struct xxh32_state *state, uint32_t seed);
  * @length: The length of the data to hash.
  *
  * After calling xxh32_reset() call xxh32_update() as many times as necessary.
- *
- * Return:  Zero on success, otherwise an error code.
  */
-int xxh32_update(struct xxh32_state *state, const void *input, size_t length);
+void xxh32_update(struct xxh32_state *state, const void *input, size_t length);
 
 /**
  * xxh32_digest() - produce the current xxh32 hash
@@ -218,10 +216,8 @@ void xxh64_reset(struct xxh64_state *state, uint64_t seed);
  * @length: The length of the data to hash.
  *
  * After calling xxh64_reset() call xxh64_update() as many times as necessary.
- *
- * Return:  Zero on success, otherwise an error code.
  */
-int xxh64_update(struct xxh64_state *state, const void *input, size_t length);
+void xxh64_update(struct xxh64_state *state, const void *input, size_t length);
 
 /**
  * xxh64_digest() - produce the current xxh64 hash
diff --git a/lib/xxhash.c b/lib/xxhash.c
index aa61e2a3802f0a..64bb68a9621ed1 100644
--- a/lib/xxhash.c
+++ b/lib/xxhash.c
@@ -267,21 +267,19 @@ void xxh64_reset(struct xxh64_state *statePtr, const uint64_t seed)
 }
 EXPORT_SYMBOL(xxh64_reset);
 
-int xxh32_update(struct xxh32_state *state, const void *input, const size_t len)
+void xxh32_update(struct xxh32_state *state, const void *input,
+		  const size_t len)
 {
 	const uint8_t *p = (const uint8_t *)input;
 	const uint8_t *const b_end = p + len;
 
-	if (input == NULL)
-		return -EINVAL;
-
 	state->total_len_32 += (uint32_t)len;
 	state->large_len |= (len >= 16) | (state->total_len_32 >= 16);
 
 	if (state->memsize + len < 16) { /* fill in tmp buffer */
 		memcpy((uint8_t *)(state->mem32) + state->memsize, input, len);
 		state->memsize += (uint32_t)len;
-		return 0;
+		return;
 	}
 
 	if (state->memsize) { /* some data left from previous update */
@@ -331,8 +329,6 @@ int xxh32_update(struct xxh32_state *state, const void *input, const size_t len)
 		memcpy(state->mem32, p, (size_t)(b_end-p));
 		state->memsize = (uint32_t)(b_end-p);
 	}
-
-	return 0;
 }
 EXPORT_SYMBOL(xxh32_update);
 
@@ -374,20 +370,18 @@ uint32_t xxh32_digest(const struct xxh32_state *state)
 }
 EXPORT_SYMBOL(xxh32_digest);
 
-int xxh64_update(struct xxh64_state *state, const void *input, const size_t len)
+void xxh64_update(struct xxh64_state *state, const void *input,
+		  const size_t len)
 {
 	const uint8_t *p = (const uint8_t *)input;
 	const uint8_t *const b_end = p + len;
 
-	if (input == NULL)
-		return -EINVAL;
-
 	state->total_len += len;
 
 	if (state->memsize + len < 32) { /* fill in tmp buffer */
 		memcpy(((uint8_t *)state->mem64) + state->memsize, input, len);
 		state->memsize += (uint32_t)len;
-		return 0;
+		return;
 	}
 
 	if (state->memsize) { /* tmp buffer is full */
@@ -436,8 +430,6 @@ int xxh64_update(struct xxh64_state *state, const void *input, const size_t len)
 		memcpy(state->mem64, p, (size_t)(b_end-p));
 		state->memsize = (uint32_t)(b_end - p);
 	}
-
-	return 0;
 }
 EXPORT_SYMBOL(xxh64_update);
 
-- 
2.26.2

