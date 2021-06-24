Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7C3CC49EA5
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jun 2021 14:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 845C9613C0
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jun 2021 14:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhFXO4m (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jun 2021 10:56:42 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:18748 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhFXO4m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jun 2021 10:56:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1624546457;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=W2MgDacQ33/X9d6+F78XQIRZzmwtx0Fdnf86GnFtV00=;
    b=F74ogym0czh4a+2Z0x0enWuulqBNA2Zr6T6vVzhejRMyzlIfI5ZsODElFZELijRLB6
    9VXEOL6zfg080nlvFLdFFx34yHq3yVpyjyUvE4krKr+XX/C6ZTy5RxQobh8+2p697ySq
    RTpk2epa2mu3JB5USJUvgf4NUIGlSk3sQRuXTGXydf/4p166b43yzTwtKrDU43DX3TEZ
    wRywUZkfiGtwhJhpPkTGB1GEaltzkIFfaZGV2sEoF6kyrCBhhzU3WFSleJEf1782MeXZ
    K7WmptH5o00r1KrOeF/kSsdF6mPVLyMKMaqlqFYZRH5m038M2REypGB52Bh5xH7ZkPkP
    wuBA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJShFkMdZNkE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.27.5 DYNA|AUTH)
    with ESMTPSA id L04113x5OEsG6D8
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 24 Jun 2021 16:54:16 +0200 (CEST)
Message-ID: <7a7f5523271ffe9784cfc98cf28e474ca5507e6c.camel@chronox.de>
Subject: Re: [PATCH] crypto: DRBG - switch to HMAC SHA512 DRBG as default
 DRBG
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Vlad Dronov <vdronov@redhat.com>
Date:   Thu, 24 Jun 2021 16:54:16 +0200
In-Reply-To: <20210624143019.GA20222@gondor.apana.org.au>
References: <3171520.o5pSzXOnS6@positron.chronox.de>
         <20210624143019.GA20222@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, dem 24.06.2021 um 22:30 +0800 schrieb Herbert Xu:
> On Thu, May 20, 2021 at 09:31:11PM +0200, Stephan Müller wrote:
> > 
> > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > index 1b4587e0ddad..ea85d4a0fe9e 100644
> > --- a/crypto/drbg.c
> > +++ b/crypto/drbg.c
> > @@ -176,18 +176,18 @@ static const struct drbg_core drbg_cores[] = {
> >                 .blocklen_bytes = 48,
> >                 .cra_name = "hmac_sha384",
> >                 .backend_cra_name = "hmac(sha384)",
> > -       }, {
> > -               .flags = DRBG_HMAC | DRBG_STRENGTH256,
> > -               .statelen = 64, /* block length of cipher */
> > -               .blocklen_bytes = 64,
> > -               .cra_name = "hmac_sha512",
> > -               .backend_cra_name = "hmac(sha512)",
> >         }, {
> >                 .flags = DRBG_HMAC | DRBG_STRENGTH256,
> >                 .statelen = 32, /* block length of cipher */
> >                 .blocklen_bytes = 32,
> >                 .cra_name = "hmac_sha256",
> >                 .backend_cra_name = "hmac(sha256)",
> > +       }, {
> > +               .flags = DRBG_HMAC | DRBG_STRENGTH256,
> > +               .statelen = 64, /* block length of cipher */
> > +               .blocklen_bytes = 64,
> > +               .cra_name = "hmac_sha512",
> > +               .backend_cra_name = "hmac(sha512)",
> >         },
> 
> Hi Stephan:
> 
> I just noticed that unlike hmac(sha256) drbg with hmac(sha512)
> doesn't have a self-test.  Could you add one for it please?

Thank you very much for pointing this out. I will prepare one asap.

Thanks
Stephan
> 
> Thanks,


