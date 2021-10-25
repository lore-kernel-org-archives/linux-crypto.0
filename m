Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DD1C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Oct 2021 09:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BD4160F92
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Oct 2021 09:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbhJYJ2H (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Oct 2021 05:28:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51726 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhJYJ2F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Oct 2021 05:28:05 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E33311FD36;
        Mon, 25 Oct 2021 09:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635153942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+txo1N1OeQ38VR8c9TVCQxEqQEzX9GrJayemgmeIllU=;
        b=Wm+ZHDmSVSSS92iuLxV2KS/vGpORdFKIZb6NUBzyWub1dGMMQcQH3Ksr7pSmgMijbkUMV9
        40BY+nWoBfyWvJNyumHQ3XNGxHIB+prlQLebeKVTK8ZJr9ZSgu4hMo731DosK4dVAq6rn8
        wmQ4spsxdDEQspWUTktQF94X5wkC9T8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635153942;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+txo1N1OeQ38VR8c9TVCQxEqQEzX9GrJayemgmeIllU=;
        b=mVRSzkkOD1tqwxkSouip2ANVQ5FOOqWHTyHOTaWpIa7gjcv6sV8/qtOqe5ujTwgdF0oco0
        faf/8G2DRKrEWIDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CD70E13AAB;
        Mon, 25 Oct 2021 09:25:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lJX9MBZ4dmHPSQAAMHmgww
        (envelope-from <nstange@suse.de>); Mon, 25 Oct 2021 09:25:42 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 0/6] crypto: DRBG - improve 'nopr' reseeding
Date:   Mon, 25 Oct 2021 11:25:19 +0200
Message-Id: <20211025092525.12805-1-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

this patchset aims at (hopefully) improving the DRBG code related to
reseeding from get_random_bytes() a bit:
- Replace the asynchronous random_ready_callback based DRBG reseeding
  logic with a synchronous solution leveraging rng_is_initialized(). This
  move simplifies the code IMO and, as a side-effect, would enable DRBG
  users to rely on wait_for_random_bytes() to sync properly with
  drbg_generate(), if desired. Implemented by patches 1-5/6.
- Make the 'nopr' DRBGs to reseed themselves every 5min from
  get_random_bytes(). This achieves at least kind of a partial prediction
  resistance over the time domain at almost no extra cost. Implemented
  by patch 6/6, the preceding patches in this series are a prerequisite
  for this.

Tested with and without fips_enabled in a x86_64 VM, both with
random.trust_cpu=on and off. As confirmed with a couple of debugging
printks() (added for testing only, not included in this series), DRBGs
have been instantiated with and without rng_is_initialized() evaluating
to true each during my tests and the patched DRBG reseeding code worked as
intended in either case.

Applies to current herbert/cryptodev-2.6.git master.

Many thanks for your comments and remarks!

Nicolai

Nicolai Stange (6):
  crypto: DRBG - prepare for more fine-grained tracking of seeding state
  crypto: DRBG - track whether DRBG was seeded with
    !rng_is_initialized()
  crypto: DRBG - move dynamic ->reseed_threshold adjustments to
    __drbg_seed()
  crypto: DRBG - make reseeding from get_random_bytes() synchronous
  crypto: DRBG - make drbg_prepare_hrng() handle jent instantiation
    errors
  crypto: DRBG - reseed 'nopr' drbgs periodically from
    get_random_bytes()

 crypto/drbg.c         | 145 +++++++++++++++++++++---------------------
 include/crypto/drbg.h |  11 +++-
 2 files changed, 82 insertions(+), 74 deletions(-)

-- 
2.26.2

