Return-Path: <SRS0=TGTC=ZJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E37C432C0
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 01:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BFE7206F4
	for <linux-crypto@archiver.kernel.org>; Sun, 17 Nov 2019 01:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbfKQBAk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Nov 2019 20:00:40 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57604 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfKQBAk (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Sat, 16 Nov 2019 20:00:40 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iW8vd-0003V8-Kb; Sun, 17 Nov 2019 09:00:37 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iW8vc-000481-G2; Sun, 17 Nov 2019 09:00:36 +0800
Date:   Sun, 17 Nov 2019 09:00:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.4
Message-ID: <20191117010036.7vww6vqrakv3avkw@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191010123849.GA30001@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010123849.GA30001@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

This push reverts a number of changes to the khwrng thread which
feeds the kernel random number pool from hwrng drivers.  They
were trying to fix issues with suspend-and-resume but ended up
causing regressions.

The following changes since commit f703964fc66804e6049f2670fc11045aa8359b1a:

  crypto: arm/aes-ce - add dependency on AES library (2019-10-01 23:06:43 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 08e97aec700aeff54c4847f170e566cbd7e14e81:

  Revert "hwrng: core - Freeze khwrng thread during suspend" (2019-11-17 08:48:17 +0800)

----------------------------------------------------------------
Herbert Xu (1):
      Revert "hwrng: core - Freeze khwrng thread during suspend"

 drivers/char/hw_random/core.c | 5 +----
 drivers/char/random.c         | 4 +---
 2 files changed, 2 insertions(+), 7 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
