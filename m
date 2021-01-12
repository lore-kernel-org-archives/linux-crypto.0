Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CFA2C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 19:30:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C2A221534
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 19:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436830AbhALTaC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Jan 2021 14:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:49234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436766AbhALTaB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Jan 2021 14:30:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A74F223117;
        Tue, 12 Jan 2021 19:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610479761;
        bh=kmH9MS3x5UgcjDdiDvhjWqvLlClSPny0nE7KD5J6yjI=;
        h=From:To:Cc:Subject:Date:From;
        b=s5Xs20jT0lT6NoMFDWc6+BmFoDt5xWou1d7IZwzizmrSY/fpDfW0RlO9p/2dmrHH0
         vxa4mwiEuSmMsAYUCXjQ6nvE3Zwkv0Ql4dcSrm/erB5ia/TjxfL6wBqtxyM6QNqzp+
         ApGWNXH0HXEBM7RaMOKeOOnpFwYsXobefRLEq3N9zY49Ift+afvK7xBcd6czL82jUa
         HA7Wgn0e4fJZSnOS/pfwIVRbyRm4B7tWSZcpdrWUCUpnLPMPDNvVidUI8lyBUU4roy
         brkJTdO0ECLTIsZAzYWY1e/sp8yGbk++r61TdeRvilte6hB4hr+SHGF8YjJ0KKUmwx
         sZWrZ9tdy9lxg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH RESEND] random: fix the RNDRESEEDCRNG ioctl
Date:   Tue, 12 Jan 2021 11:28:18 -0800
Message-Id: <20210112192818.69921-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The RNDRESEEDCRNG ioctl reseeds the primary_crng from itself, which
doesn't make sense.  Reseed it from the input_pool instead.

Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
Cc: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

Andrew, please consider taking this patch since the maintainer has been
ignoring it for 4 months
(https://lkml.kernel.org/lkml/20200916041908.66649-1-ebiggers@kernel.org/T/#u).


 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5f3b8ac9d97b0..a894c0559a8cf 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1972,7 +1972,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 			return -EPERM;
 		if (crng_init < 2)
 			return -ENODATA;
-		crng_reseed(&primary_crng, NULL);
+		crng_reseed(&primary_crng, &input_pool);
 		crng_global_init_time = jiffies - 1;
 		return 0;
 	default:
-- 
2.30.0

