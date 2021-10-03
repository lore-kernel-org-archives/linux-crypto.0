Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9169C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A763861A0A
	for <linux-crypto@archiver.kernel.org>; Sun,  3 Oct 2021 18:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhJCSQt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 14:16:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:38416 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbhJCSQs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 14:16:48 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 52C141FFB6;
        Sun,  3 Oct 2021 18:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633284900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=P9I25fWE1JHgtKRx7ZMJwEWzhRPyhbxUL4KSUBb/BwE=;
        b=g3aTgt4VDonWXHJIa8MSBMy9KXZXpgdIY4difzN0PqPcl+QtTtLkfCqSA8AgnfmM/51PRG
        2iEP9XvJpOaPKiAPg8rwYGeDttjUf1JL+5E+VAMeLLHFiyKOrpb7YBOAqwPRbkMLRas9ct
        wk7A1J5n5w9X8k0OpF4K0p4MJEGH0K0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633284900;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=P9I25fWE1JHgtKRx7ZMJwEWzhRPyhbxUL4KSUBb/BwE=;
        b=21TixarJCmVufHIlVuP0kGQnm08TBZg7J0dd3u+b6QYLFlcfKRoh/0Fx+kYl0tQxmTBBwY
        UoHrEDNiakeTj0CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3F11813A09;
        Sun,  3 Oct 2021 18:15:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Xc8dDiTzWWGIEwAAMHmgww
        (envelope-from <nstange@suse.de>); Sun, 03 Oct 2021 18:15:00 +0000
From:   Nicolai Stange <nstange@suse.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        Torsten Duwe <duwe@suse.de>, Nicolai Stange <nstange@suse.de>
Subject: [PATCH 0/8] crypto: api - priorize tested algorithms in lookup
Date:   Sun,  3 Oct 2021 20:14:05 +0200
Message-Id: <20211003181413.12465-1-nstange@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi all,

my initial goal had been to make the algorithm lookup prefer usable
instances over ones where the tests are still pending. In my first attempt
I realized that the code in crypto_alg_lookup() became quite convoluted
and that it could get streamlined somewhat by consolidating
CRYPTO_ALG_TESTED handling for lookup larvals a bit.

This cleanup can be found in [1/8] - [7/8] and might perhaps be worth
considering on its own, independent of whether or not you deem the
final [8/8], the patch implementing my original goal of priorizing
algorithms in working state, suitable for upstream inclusion.

This series is based on current herbert/cryptodev-2.6 master.

All patches have been tested with tcrypt.ko as well as the kernel/crypto
testcases from LTP.

Thanks!

Nicolai

Nicolai Stange (8):
  crypto: af_alg - reject requests for untested algorithms
  crypto: user - reject requests for untested algorithms
  crypto: api - only support lookups for specific CRYPTO_ALG_TESTED
    status
  crypto: api - don't add larvals for !(type & CRYPTO_ALG_TESTED)
    lookups
  crypto: api - always set CRYPTO_ALG_TESTED in lookup larvals'
    ->mask/type
  crypto: api - make crypto_alg_lookup() consistently check for failed
    algos
  crypto: api - lift common mask + type adjustment to
    crypto_larval_lookup()
  crypto: api - make the algorithm lookup priorize non-larvals

 crypto/af_alg.c           |  9 +++++++
 crypto/api.c              | 53 ++++++++++++++++++++++++++++++++-------
 crypto/crypto_user_base.c |  3 +++
 3 files changed, 56 insertions(+), 9 deletions(-)

-- 
2.26.2

