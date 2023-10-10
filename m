Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F9A4CD690A
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 08:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjJJIq4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 04:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjJJIqz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 04:46:55 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A87297;
        Tue, 10 Oct 2023 01:46:53 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qq8Nz-005TAX-RP; Tue, 10 Oct 2023 16:46:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Oct 2023 16:46:44 +0800
Date:   Tue, 10 Oct 2023 16:46:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 6.6
Message-ID: <ZSUPdPFo+M/rQhwo@gondor.apana.org.au>
References: <Y0zcWCmNmdXnX8RP@gondor.apana.org.au>
 <Y1thZ/+Gh/ONyf7x@gondor.apana.org.au>
 <Y7fmtJHWT1Zx+A1j@gondor.apana.org.au>
 <ZARrt99wJb7IhoY4@gondor.apana.org.au>
 <ZFeldCJcieIlXKJ8@gondor.apana.org.au>
 <ZHQe9A8CC93iCFMG@gondor.apana.org.au>
 <ZKtH5zrS4pR22PGT@gondor.apana.org.au>
 <ZOLcCC523FoBAyv0@gondor.apana.org.au>
 <ZPAiMYaqUslSyZ6+@gondor.apana.org.au>
 <ZQz3qxwwAjDaqi5V@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQz3qxwwAjDaqi5V@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

The following changes since commit 21155620fbf2edbb071144894ff9d67ba9a1faa0:

  crypto: sm2 - Fix crash caused by uninitialized context (2023-09-20 13:10:10 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git v6.6-p4 

for you to fetch changes up to 152d0bcdf1efcb54a4fa20f694e9c7bbb6d06cbf:

  dm crypt: Fix reqsize in crypt_iv_eboiv_gen (2023-10-06 10:39:18 +0800)

----------------------------------------------------------------
This push fixes a 6.5 regression in dm-crypt.
----------------------------------------------------------------

Herbert Xu (1):
      dm crypt: Fix reqsize in crypt_iv_eboiv_gen

 drivers/md/dm-crypt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
