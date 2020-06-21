Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60FCC433E1
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 08:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91B8E24884
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 08:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgFUIXS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 04:23:18 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40830 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729491AbgFUIXS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 04:23:18 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jmvFn-0003ad-EX; Sun, 21 Jun 2020 18:23:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 21 Jun 2020 18:23:03 +1000
Date:   Sun, 21 Jun 2020 18:23:03 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.8
Message-ID: <20200621082303.GA30729@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200408061513.GA23636@gondor.apana.org.au>
 <20200611040544.GA27603@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200611040544.GA27603@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

This push contains a number of fixes:

- NULL dereference in octeontx.
- PM reference imbalance in ks-sa.
- Dead-lock in crypto manager.
- Memory leak in drbg.
- Missing socket limit check on receive SG list size in algif_skcipher.
- Typos in caam.
- Warnings in ccp and hisilicon.

The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

for you to fetch changes up to 819966c06b759022e9932f328284314d9272b9f3:

  crypto: drbg - always try to free Jitter RNG instance (2020-06-15 17:38:54 +1000)

----------------------------------------------------------------
Dan Carpenter (1):
      crypto: marvell/octeontx - Fix a potential NULL dereference

Dinghao Liu (1):
      hwrng: ks-sa - Fix runtime PM imbalance on error

Eric Biggers (1):
      crypto: algboss - don't wait during notifier callback

Heinrich Schuchardt (1):
      crypto: caam - fix typos

Herbert Xu (3):
      crypto: algif_skcipher - Cap recv SG list at ctx->used
      crypto: hisilicon - Cap block size at 2^31
      crypto: ccp - Fix sparse warnings in sev-dev

Stephan Müller (1):
      crypto: drbg - always try to free Jitter RNG instance

 crypto/algboss.c                                 |  2 --
 crypto/algif_skcipher.c                          |  6 +-----
 crypto/drbg.c                                    |  6 ++++--
 drivers/char/hw_random/ks-sa-rng.c               |  1 +
 drivers/crypto/caam/Kconfig                      |  2 +-
 drivers/crypto/caam/ctrl.c                       | 18 +++++++++---------
 drivers/crypto/caam/desc.h                       |  4 ++--
 drivers/crypto/caam/pdb.h                        |  2 +-
 drivers/crypto/ccp/sev-dev.c                     | 23 ++++++++++++++++-------
 drivers/crypto/hisilicon/sgl.c                   |  3 ++-
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c | 11 +++++++----
 include/linux/psp-sev.h                          |  2 +-
 12 files changed, 45 insertions(+), 35 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
