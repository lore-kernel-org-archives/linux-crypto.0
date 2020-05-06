Return-Path: <SRS0=2pnx=6U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999EBC28CBC
	for <linux-crypto@archiver.kernel.org>; Wed,  6 May 2020 05:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7359C206F9
	for <linux-crypto@archiver.kernel.org>; Wed,  6 May 2020 05:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgEFFKe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 May 2020 01:10:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37498 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgEFFKd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 May 2020 01:10:33 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jWCEq-0008BX-5s; Wed, 06 May 2020 15:04:57 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 06 May 2020 15:10:06 +1000
Date:   Wed, 6 May 2020 15:10:06 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.7
Message-ID: <20200506051006.GA6537@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200408061513.GA23636@gondor.apana.org.au>
 <20200429055420.GA26381@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429055420.GA26381@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

This push fixes a potential scheduling latency problem for the
algorithms used by WireGuard.

The following changes since commit 55b3209acbb01cb02b1ee6b1afe80d83b1aab36d:

  crypto: caam - fix the address of the last entry of S/G (2020-04-16 16:48:56 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to a9a8ba90fa5857c2c8a0e32eef2159cec717da11:

  crypto: arch/nhpoly1305 - process in explicit 4k chunks (2020-04-30 15:16:59 +1000)

----------------------------------------------------------------
Jason A. Donenfeld (2):
      crypto: arch/lib - limit simd usage to 4k chunks
      crypto: arch/nhpoly1305 - process in explicit 4k chunks

 arch/arm/crypto/chacha-glue.c            | 14 +++++++++++---
 arch/arm/crypto/nhpoly1305-neon-glue.c   |  2 +-
 arch/arm/crypto/poly1305-glue.c          | 15 +++++++++++----
 arch/arm64/crypto/chacha-neon-glue.c     | 14 +++++++++++---
 arch/arm64/crypto/nhpoly1305-neon-glue.c |  2 +-
 arch/arm64/crypto/poly1305-glue.c        | 15 +++++++++++----
 arch/x86/crypto/blake2s-glue.c           | 10 ++++------
 arch/x86/crypto/chacha_glue.c            | 14 +++++++++++---
 arch/x86/crypto/nhpoly1305-avx2-glue.c   |  2 +-
 arch/x86/crypto/nhpoly1305-sse2-glue.c   |  2 +-
 arch/x86/crypto/poly1305_glue.c          | 13 ++++++-------
 11 files changed, 69 insertions(+), 34 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
