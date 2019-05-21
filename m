Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878C1C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 658AE208C3
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 13:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfEUNiA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 09:38:00 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59382 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727969AbfEUNiA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 09:38:00 -0400
X-Greylist: delayed 2376 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2019 09:38:00 EDT
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hT4LW-0001TA-HU; Tue, 21 May 2019 20:58:22 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hT4LR-0003Ma-I4; Tue, 21 May 2019 20:58:17 +0800
Date:   Tue, 21 May 2019 20:58:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT] Crypto Fixes for 5.2
Message-ID: <20190521125817.6lqknb2kztxddi4p@gondor.apana.org.au>
References: <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
 <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus: 

This push fixes the following issues:

- Two long-standing bugs in the powerpc assembly of vmx.
- Stack overrun caused by HASH_MAX_DESCSIZE being too small.
- Regression in caam.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Daniel Axtens (2):
      crypto: vmx - CTR: always increment IV as quadword
      crypto: vmx - ghash: do nosimd fallback manually

Eric Biggers (1):
      crypto: hash - fix incorrect HASH_MAX_DESCSIZE

Iuliana Prodan (1):
      crypto: caam - fix typo in i.MX6 devices list for errata

 crypto/hmac.c                   |   2 +
 drivers/crypto/caam/ctrl.c      |   2 +-
 drivers/crypto/vmx/aesp8-ppc.pl |   2 +-
 drivers/crypto/vmx/ghash.c      | 211 ++++++++++++++++------------------------
 include/crypto/hash.h           |   8 +-
 5 files changed, 97 insertions(+), 128 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
