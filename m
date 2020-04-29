Return-Path: <SRS0=SZPK=6N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46217C83007
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Apr 2020 05:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 251FB20757
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Apr 2020 05:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgD2Fyf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Apr 2020 01:54:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52222 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbgD2Fye (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Apr 2020 01:54:34 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jTffd-0008AU-2m; Wed, 29 Apr 2020 15:54:10 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 Apr 2020 15:54:20 +1000
Date:   Wed, 29 Apr 2020 15:54:20 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.7
Message-ID: <20200429055420.GA26381@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200408061513.GA23636@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408061513.GA23636@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

This push fixes a bunch of bugs detected by KASAN in the caam driver.

The following changes since commit 8f3d9f354286745c751374f5f1fcafee6b3f3136:

  Linux 5.7-rc1 (2020-04-12 12:35:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 55b3209acbb01cb02b1ee6b1afe80d83b1aab36d:

  crypto: caam - fix the address of the last entry of S/G (2020-04-16 16:48:56 +1000)

----------------------------------------------------------------
Iuliana Prodan (5):
      crypto: caam - fix use-after-free KASAN issue for SKCIPHER algorithms
      crypto: caam - fix use-after-free KASAN issue for AEAD algorithms
      crypto: caam - fix use-after-free KASAN issue for HASH algorithms
      crypto: caam - fix use-after-free KASAN issue for RSA algorithms
      crypto: caam - fix the address of the last entry of S/G

 drivers/crypto/caam/caamalg.c  | 10 +++++++---
 drivers/crypto/caam/caamhash.c |  8 ++++++--
 drivers/crypto/caam/caampkc.c  |  8 ++++++--
 3 files changed, 19 insertions(+), 7 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
