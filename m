Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BFDC4332F
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 10:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356331AbiBEKfN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Feb 2022 05:35:13 -0500
Received: from isilmar-4.linta.de ([136.243.71.142]:58140 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbiBEKfM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Feb 2022 05:35:12 -0500
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id 867B62010EB;
        Sat,  5 Feb 2022 10:35:10 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id A198680719; Sat,  5 Feb 2022 11:35:05 +0100 (CET)
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 0/2] random: fix write locking for crng_init
Date:   Sat,  5 Feb 2022 11:34:56 +0100
Message-Id: <20220205103458.133386-1-linux@dominikbrodowski.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

According to a comment in random.c, crng_init is protected by
primary_crng->lock. These two patches fix the locking for
writing tp (that is: increasing) crng_init in call sites where it
may matter. At rand_initialize() time (precisely: either in
crng_initialize_primary() or in crng_finalize_init()), crng_init
is set to 2 without the lock being held. However, then the
kernel is running with IRQs disabled and only the boot CPU
active (but not yet in PID 1).

Dominik Brodowski (2):
  random: fix locking in crng_fast_load()
  random: fix locking for crng_init in crng_reseed()

 drivers/char/random.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

-- 
2.35.1

