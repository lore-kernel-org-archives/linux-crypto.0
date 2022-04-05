Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EABBC43219
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 01:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348805AbiDFBH4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445942AbiDEPnu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Apr 2022 11:43:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2CF194819;
        Tue,  5 Apr 2022 07:10:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 372BAB81C9B;
        Tue,  5 Apr 2022 14:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8CFC385A6;
        Tue,  5 Apr 2022 14:10:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="OqzFRuQw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1649167820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KY5AEKEkClJXCIcB/dp2K6YipiPmN6Pkkmc24/xM1sc=;
        b=OqzFRuQwwJQY39ID/slPUumYo6AOavy60E9Jx/PhGjvSpalfA9QaWfYovGjvouaDvLKbcc
        8Y9+iNUVaOEas6EsxLIxTQa2xEvq7DfBph6PJoYhE49AnrjBdLnH+SW111QD2coIaLxXyo
        nuigC41yGXliUAzBh0XPKdNA1zzrexA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 61798ffe (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Apr 2022 14:10:20 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH] random: opportunistically initialize on /dev/urandom reads
Date:   Tue,  5 Apr 2022 16:09:06 +0200
Message-Id: <20220405140906.222350-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In 6f98a4bfee72 ("random: block in /dev/urandom"), we tried to make a
successful try_to_generate_entropy() call *required* if the RNG was not
already initialized. Unfortunately, weird architectures and old
userspaces combined in TCG test harnesses, making that change still not
realistic, so it was reverted in 0313bc278dac ("Revert "random: block in
/dev/urandom"").

However, rather than making a successful try_to_generate_entropy() call
*required*, we can instead make it *best-effort*.

If try_to_generate_entropy() fails, it fails, and nothing changes from
the current behavior. If it succeeds, then /dev/urandom becomes safe to
use for free. This way, we don't risk the regression potential that led
to us reverting the required-try_to_generate_entropy() call before.

Practically speaking, this means that at least on x86, /dev/urandom
becomes safe. Probably other architectures with working cycle counters
will also become safe. And architectures with slow or broken cycle
counters at least won't be affected at all by this change.

So it may not be the glorious "all things are unified!" change we were
hoping for initially, but practically speaking, it makes a positive
impact.

Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ee3ad2ba0942..388025d6d38d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1534,6 +1534,13 @@ static ssize_t urandom_read(struct file *file, char __user *buf, size_t nbytes,
 {
 	static int maxwarn = 10;
 
+	/*
+	 * Opportunistically attempt to initialize the RNG on platforms that
+	 * have fast cycle counters, but don't (for now) require it to succeed.
+	 */
+	if (!crng_ready())
+		try_to_generate_entropy();
+
 	if (!crng_ready() && maxwarn > 0) {
 		maxwarn--;
 		if (__ratelimit(&urandom_warning))
-- 
2.35.1

