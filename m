Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9708CC04AA7
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 03:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A75B2084F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 03:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfEODyL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 May 2019 23:54:11 -0400
Received: from orcrist.hmeau.com ([5.180.42.13]:34226 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbfEODyL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 May 2019 23:54:11 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hQkzF-0000Hf-Fp; Wed, 15 May 2019 11:53:49 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hQkz2-0004cv-Sh; Wed, 15 May 2019 11:53:36 +0800
Date:   Wed, 15 May 2019 11:53:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Axtens <dja@axtens.net>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Nayna <nayna@linux.vnet.ibm.com>, leo.barbosa@canonical.com,
        Stephan Mueller <smueller@chronox.de>, nayna@linux.ibm.com,
        omosnacek@gmail.com, leitao@debian.org, pfsmorigo@gmail.com,
        linux-crypto@vger.kernel.org, marcelo.cerri@canonical.com,
        George Wilson <gcwilson@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
Message-ID: <20190515035336.y42wzhs3wzqdpwzn@gondor.apana.org.au>
References: <20190315043433.GC1671@sol.localdomain>
 <8736nou2x5.fsf@dja-thinkpad.axtens.net>
 <20190410070234.GA12406@sol.localdomain>
 <87imvkwqdh.fsf@dja-thinkpad.axtens.net>
 <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com>
 <8736mmvafj.fsf@concordia.ellerman.id.au>
 <20190506155315.GA661@sol.localdomain>
 <20190513005901.tsop4lz26vusr6o4@gondor.apana.org.au>
 <87pnomtwgh.fsf@concordia.ellerman.id.au>
 <877eat0wi0.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877eat0wi0.fsf@dja-thinkpad.axtens.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 15, 2019 at 03:35:51AM +1000, Daniel Axtens wrote:
>
> By all means disable vmx ctr if I don't get an answer to you in a
> timeframe you are comfortable with, but I am going to at least try to
> have a look.

I'm happy to give you guys more time.  How much time do you think
you will need?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
