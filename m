From: Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH 0/2] sun4i_ss_prng fixes
Date: Tue,  6 Feb 2018 22:20:20 +0100
Message-ID: <20180206212022.1309-1-artem.savkov@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Artem Savkov <artem.savkov@gmail.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:39985 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753393AbeBFVUe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 16:20:34 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

IPSec hasn't been working on my a10 board since 4.14 and it turned out to be
caused by sun4i_ss_rng driver.

Artem Savkov (2):
  sun4i_ss_prng: fix return value of sun4i_ss_prng_generate
  sun4i_ss_prng: convert lock to _bh in sun4i_ss_prng_generate

 drivers/crypto/sunxi-ss/sun4i-ss-prng.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.15.1
