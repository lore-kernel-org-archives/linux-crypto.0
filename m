Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59B06C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 04:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 116C421D1B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 04:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600229989;
	bh=y5XYa852j/46q1Vtpz0g41jdORWK44Dm//BZxPIZRVo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Dh3C/8JmCY4V3yNA/X3qaxBlwptpVoDVzfmdXV9kWBi20qryz0Sjzl/FECnfhq2P9
	 FANYeotZ9eVHlQA8fe5wsSB0yQ6XTeE9Xi6F6NJya6lqRUlG0Zxr10xzJTGMbdJV1N
	 la8yQOWLUZkQcAvmeQk99dPTXkIRGN9dudseR+FU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgIPETs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 00:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgIPETs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 00:19:48 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5E992078D;
        Wed, 16 Sep 2020 04:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600229987;
        bh=y5XYa852j/46q1Vtpz0g41jdORWK44Dm//BZxPIZRVo=;
        h=From:To:Cc:Subject:Date:From;
        b=n6FwfqG1WlQSa+5tT2oKpNJsv1yS7a4BADyqcAWJIZ69yGPcHeJ1cS13NB4sJDt0+
         TB8f/mohIJ+anQ1xLk+tM2nHBO28kD/Vp/nMumEOEJUJPW000nsKquh+sZvXM1Oxk4
         9WkRVaYnYWMEcdHBKC9hSK3hIsaKMoV+Wqf8hI9s=
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>
Subject: [PATCH] random: fix the RNDRESEEDCRNG ioctl
Date:   Tue, 15 Sep 2020 21:19:08 -0700
Message-Id: <20200916041908.66649-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The RNDRESEEDCRNG ioctl reseeds the primary_crng from itself, which
doesn't make sense.  Reseed it from the input_pool instead.

Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d20ba1b104ca3..a8b9e66f41435 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1973,7 +1973,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 			return -EPERM;
 		if (crng_init < 2)
 			return -ENODATA;
-		crng_reseed(&primary_crng, NULL);
+		crng_reseed(&primary_crng, &input_pool);
 		crng_global_init_time = jiffies - 1;
 		return 0;
 	default:
-- 
2.28.0

