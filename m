Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED29C433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 15:54:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C75E364F8D
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 15:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhBCPys (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 10:54:48 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:37250 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbhBCPex (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 10:34:53 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id B764572C8B1;
        Wed,  3 Feb 2021 18:34:06 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id A502A4A46F3;
        Wed,  3 Feb 2021 18:34:06 +0300 (MSK)
Date:   Wed, 3 Feb 2021 18:34:06 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Saulo Alessandre <saulo.alessandre@gmail.com>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Saulo Alessandre <saulo.alessandre@tse.jus.br>
Subject: Re: [PATCH v2 4/4] ecdsa: implements ecdsa signature verification
Message-ID: <20210203153406.pqheygwcyzmmhfxd@altlinux.org>
References: <20210129212535.2257493-1-saulo.alessandre@gmail.com>
 <20210129212535.2257493-5-saulo.alessandre@gmail.com>
 <20210202051003.GA27641@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20210202051003.GA27641@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

On Tue, Feb 02, 2021 at 04:10:03PM +1100, Herbert Xu wrote:
> On Fri, Jan 29, 2021 at 06:25:35PM -0300, Saulo Alessandre wrote:
> > From: Saulo Alessandre <saulo.alessandre@tse.jus.br>
> > 
> > * Documentation/admin-guide/module-signing.rst
> >   - Documents how to generate certificate and signature for (ECDSA).
> > 
> > * crypto/Kconfig
> >   - ECDSA added into kernel Public-key cryptography section.
> > 
> > * crypto/Makefile
> >    - add ECDSA objects and asn1 params to compile.
> > 
> > * crypto/ecdsa.c
> >   - Elliptical Curve DSA verify implementation
> > 
> > * crypto/ecdsa_params.asn1
> >   - Elliptical Curve DSA verify definitions
> > 
> > * crypto/ecdsa_signature.asn1
> >   - Elliptical Curve DSA asn.1 parameters
> > 
> > * crypto/testmgr.c
> >   - test_akcipher_one - modified to reflect the real code call for nist code;
> >   - alg_test_descs - added ecdsa vector for test;
> > 
> > * crypto/testmgr.h
> >   - ecdsa_tv_template - added to test ecdsa implementation;
> > ---
> >  Documentation/admin-guide/module-signing.rst |  10 +
> >  crypto/Kconfig                               |  12 +
> >  crypto/Makefile                              |   7 +
> >  crypto/ecdsa.c                               | 509 +++++++++++++++++++
> >  crypto/ecdsa_params.asn1                     |   1 +
> >  crypto/ecdsa_signature.asn1                  |   6 +
> >  crypto/testmgr.c                             |  17 +-
> >  crypto/testmgr.h                             |  78 +++
> >  8 files changed, 638 insertions(+), 2 deletions(-)
> >  create mode 100644 crypto/ecdsa.c
> >  create mode 100644 crypto/ecdsa_params.asn1
> >  create mode 100644 crypto/ecdsa_signature.asn1
> 
> Please join the existing thread on this:
> 
> https://lore.kernel.org/linux-crypto/20210128050354.GA30874@gondor.apana.org.au/

Thanks for the invitation, I'm didn't receive this thread - is
there a temporary problem with the linux-crypto@vger.kernel.org list?
I re-checked my subscription and it seems valid.

Thanks,


> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
