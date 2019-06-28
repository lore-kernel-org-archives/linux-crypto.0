Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504C8C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F9F72133F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbfF1ETL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 00:19:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55928 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbfF1ETL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 00:19:11 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hgiLl-0004uw-RY; Fri, 28 Jun 2019 12:19:01 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hgiLj-00025S-Hb; Fri, 28 Jun 2019 12:18:59 +0800
Date:   Fri, 28 Jun 2019 12:18:59 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] crypto: testmgr - dynamically allocate
 testvec_config
Message-ID: <20190628041859.hm4xk7rmgpfo64ny@gondor.apana.org.au>
References: <20190618092215.2790800-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618092215.2790800-1-arnd@arndb.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 18, 2019 at 11:21:52AM +0200, Arnd Bergmann wrote:
> On arm32, we get warnings about high stack usage in some of the functions:
> 
> crypto/testmgr.c:2269:12: error: stack frame size of 1032 bytes in function 'alg_test_aead' [-Werror,-Wframe-larger-than=]
> static int alg_test_aead(const struct alg_test_desc *desc, const char *driver,
>            ^
> crypto/testmgr.c:1693:12: error: stack frame size of 1312 bytes in function '__alg_test_hash' [-Werror,-Wframe-larger-than=]
> static int __alg_test_hash(const struct hash_testvec *vecs,
>            ^
> 
> On of the larger objects on the stack here is struct testvec_config, so
> change that to dynamic allocation.
> 
> Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
> Fixes: d435e10e67be ("crypto: testmgr - fuzz skciphers against their generic implementation")
> Fixes: 9a8a6b3f0950 ("crypto: testmgr - fuzz hashes against their generic implementation")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/testmgr.c | 43 ++++++++++++++++++++++++++++++++-----------
>  1 file changed, 32 insertions(+), 11 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
