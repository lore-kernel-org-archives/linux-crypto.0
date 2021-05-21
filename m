Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94415C433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 08:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F1E36135A
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 08:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhEUIP3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 04:15:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55980 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhEUIP3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 04:15:29 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lk0IA-0004pW-RG; Fri, 21 May 2021 16:13:58 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lk0I8-0005ur-GX; Fri, 21 May 2021 16:13:56 +0800
Date:   Fri, 21 May 2021 16:13:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org, Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/3] crypto: ecdh - fix 'ecdh_init'
Message-ID: <20210521081356.3bnytzdxhjkgzb7g@gondor.apana.org.au>
References: <1620801602-49287-1-git-send-email-tanghui20@huawei.com>
 <1620801602-49287-2-git-send-email-tanghui20@huawei.com>
 <20210521074553.w6qtqv5nnbdbqycx@gondor.apana.org.au>
 <2a5bcd22-455d-6348-9a72-dc5a7ab49ca6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a5bcd22-455d-6348-9a72-dc5a7ab49ca6@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 21, 2021 at 04:08:10PM +0800, Hui Tang wrote:
> 
> On 2021/5/21 15:45, Herbert Xu wrote:
> > On Wed, May 12, 2021 at 02:40:00PM +0800, Hui Tang wrote:
> > > NIST P192 is not unregistered if failed to register NIST P256,
> > > actually it need to unregister the algorithms already registered.
> > > 
> > > Signed-off-by: Hui Tang <tanghui20@huawei.com>
> > > ---
> > >  crypto/ecdh.c | 11 ++++++++++-
> > >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > Thanks for catching this.  The variable ecdh_nist_p192_registered
> > is bogus.  You should just make it so that if p192 fails to
> > register then the init function aborts.  There would then be
> > no need to check for the registered state in the exit function.
> 
> Okay, I will fix it in next version, and 'ecdsa_init' should
> do the same thing too?

Actually, it looks like it is needed for FIPS.  We should add
a comment that p192 will fail to register in FIPS mode and that's
why there is a check for it.

Funnily enough, ecdsa has the FIPS comment but testmgr doesn't
set fips_allowed for any of them while ecdh is set but has no
comment.

Stephan, can you confirm that both ecdh-nist-p192 and ecdsa-nist-p192
should be disabled in FIPS mode?

Also, we should fix ecdh-nist-p192's entry in testmgr by removing
the ifdefs and not setting fips_allowed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
