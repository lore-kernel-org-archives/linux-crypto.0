Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA3EC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 18:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B363160232
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Mar 2021 18:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhCASnu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Mar 2021 13:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234814AbhCASjw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83F2B65138;
        Mon,  1 Mar 2021 17:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618241;
        bh=csma62ucd/N2Z7+ni/Ibcnfb/n5NZO5kSEDmfrmXfoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q7U8AUD8q99qYLg/MNaEdjgc2ClxfL4OW7E8zbM1hmIOweaPtDi5Oz+QP29KF1W3+
         2Bzwt1MNtvcbR99t0NekoEIvMqVBd9lA6p3UIvu15hlURkjmTreTFDFfwCB1Tc1nT4
         neYFsNBpPpPwL1g8HV51Qt6xebnnh7StaXcezWCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Theodore Tso <tytso@mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.10 016/663] random: fix the RNDRESEEDCRNG ioctl
Date:   Mon,  1 Mar 2021 17:04:24 +0100
Message-Id: <20210301161142.590802328@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 11a0b5e0ec8c13bef06f7414f9e914506140d5cb upstream.

The RNDRESEEDCRNG ioctl reseeds the primary_crng from itself, which
doesn't make sense.  Reseed it from the input_pool instead.

Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
Cc: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20210112192818.69921-1-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1972,7 +1972,7 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (crng_init < 2)
 			return -ENODATA;
-		crng_reseed(&primary_crng, NULL);
+		crng_reseed(&primary_crng, &input_pool);
 		crng_global_init_time = jiffies - 1;
 		return 0;
 	default:


