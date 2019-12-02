Return-Path: <SRS0=ccn8=ZY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09910C432C0
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 06:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE80420833
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Dec 2019 06:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLBGU0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Dec 2019 01:20:26 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52646 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbfLBGU0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Dec 2019 01:20:26 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ibf4I-00033O-DD; Mon, 02 Dec 2019 14:20:22 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ibf4D-0000d9-Q7; Mon, 02 Dec 2019 14:20:17 +0800
Date:   Mon, 2 Dec 2019 14:20:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.5
Message-ID: <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923050515.GA6980@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

This push fixes the following issues:

- Fix build error in crypto lib code when crypto API is off.
- Fix NULL/error check in hisilicon.
- Fix Kconfig-related build error in talitos.

The following changes since commit 4ee812f6143d78d8ba1399671d78c8d78bf2817c:

  crypto: vmx - Avoid weird build failures (2019-11-22 18:48:39 +0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

for you to fetch changes up to 8a6b8f4d7a891ac66db4f97900a86b55c84a5802:

  crypto: hisilicon - fix a NULL vs IS_ERR() bug in sec_create_qp_ctx() (2019-11-27 13:08:50 +0800)

----------------------------------------------------------------
Dan Carpenter (1):
      crypto: hisilicon - fix a NULL vs IS_ERR() bug in sec_create_qp_ctx()

Herbert Xu (1):
      crypto: talitos - Fix build error by selecting LIB_DES

Jason A. Donenfeld (1):
      crypto: arch - conditionalize crypto api in arch glue for lib code

 arch/arm/crypto/chacha-glue.c              | 26 ++++++++++++++++----------
 arch/arm/crypto/curve25519-glue.c          |  5 +++--
 arch/arm/crypto/poly1305-glue.c            |  9 ++++++---
 arch/arm64/crypto/chacha-neon-glue.c       |  5 +++--
 arch/arm64/crypto/poly1305-glue.c          |  5 +++--
 arch/mips/crypto/chacha-glue.c             |  6 ++++--
 arch/mips/crypto/poly1305-glue.c           |  6 ++++--
 arch/x86/crypto/blake2s-glue.c             |  6 ++++--
 arch/x86/crypto/chacha_glue.c              |  5 +++--
 arch/x86/crypto/curve25519-x86_64.c        |  7 ++++---
 arch/x86/crypto/poly1305_glue.c            |  5 +++--
 drivers/crypto/Kconfig                     |  1 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  4 ++--
 13 files changed, 56 insertions(+), 34 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
