Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B908C10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C4AD206B6
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389015AbfDROYf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:24:35 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55140 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388806AbfDROYf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:24:35 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH7xq-0004ln-4z; Thu, 18 Apr 2019 22:24:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH7xp-0004Cz-TV; Thu, 18 Apr 2019 22:24:34 +0800
Date:   Thu, 18 Apr 2019 22:24:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 0/7] crypto: fixes in preparation of new fuzz tests
Message-ID: <20190418142433.57nznoh4g4gi3kxf@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410064635.11813-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> This series contains the remaining fixes in preparation of the
> comparison fuzz tests I've proposed in the series
> "crypto: fuzz algorithms against their generic implementation".
> 
> I will send a new version of the testmgr patches separately.
> 
> These fixes and my latest tests can also be retrieved from git at:
> 
>        Repository: https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
>        Branch: cryptofuzz-vs-generic
> 
> Eric Biggers (7):
>  crypto: lrw - don't access already-freed walk.iv
>  crypto: salsa20 - don't access already-freed walk.iv
>  crypto: arm/aes-neonbs - don't access already-freed walk.iv
>  crypto: arm64/aes-neonbs - don't access already-freed walk.iv
>  crypto: gcm - fix incompatibility between "gcm" and "gcm_base"
>  crypto: ccm - fix incompatibility between "ccm" and "ccm_base"
>  crypto: vmx - return correct error code on failed setkey
> 
> arch/arm/crypto/aes-neonbs-glue.c   |  2 ++
> arch/arm64/crypto/aes-neonbs-glue.c |  2 ++
> crypto/ccm.c                        | 43 ++++++++++++-----------------
> crypto/gcm.c                        | 32 ++++++---------------
> crypto/lrw.c                        |  4 ++-
> crypto/salsa20_generic.c            |  2 +-
> drivers/crypto/vmx/aes.c            |  7 +++--
> drivers/crypto/vmx/aes_cbc.c        |  7 +++--
> drivers/crypto/vmx/aes_ctr.c        |  5 ++--
> drivers/crypto/vmx/aes_xts.c        |  9 +++---
> 10 files changed, 50 insertions(+), 63 deletions(-)

Patches 1-4 and 7 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
