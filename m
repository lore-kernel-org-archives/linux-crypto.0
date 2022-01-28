Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6412AC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 06:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346269AbiA1GFq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:05:46 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.23]:43993 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346272AbiA1GFq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 01:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643349934;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=LfgyuYj4G0g1iMmVYf2axeVDbQXKKQcZ9H/fS+KMx9U=;
    b=GdVe7FAkehp0oDka7XGoCbMlj9d15oBoNawoIxt0JfR900tskLERb1OTo6CnsR1SC2
    jgHSp6jiPMXHf31uRt9ag4MvdXGJ2rORcdkauVpPD9ckBPJM2NNxqNT6fnt/9fmdAvtR
    GPQefwOJNQDWbpSvz76emFA8ZmTU2PsxUSffIx1r1mtgdXBZizfsCb/ZeIOA7pnFPlpW
    Cd4DoHu+9lvLqgZrJyc3BXiemjW/l4qtMgBBEwXZrxNAgiRtrWAIeNSsL35c5PEM+h1e
    VRfhDNof7UBrCrG2/84rOiM3h1ztQ/w12Hgpnsw5hu1MPsKbmSj+PpOfmn2ytlUdXGDh
    IBsg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIfSfD3I="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
    with ESMTPSA id v5f65ay0S65YsKK
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 28 Jan 2022 07:05:34 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Niolai Stange <nstange@suse.com>,
        Simo Sorce <simo@redhat.com>
Subject: Re: [PATCH] crypto: HMAC - disallow keys < 112 bits in FIPS mode
Date:   Fri, 28 Jan 2022 07:05:33 +0100
Message-ID: <2285874.XlJOkxW7XW@tauon.chronox.de>
In-Reply-To: <YfN1HKqL9GT9R25Z@gondor.apana.org.au>
References: <2075651.9o76ZdvQCi@positron.chronox.de> <YfN1HKqL9GT9R25Z@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 28. Januar 2022, 05:46:20 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 07, 2022 at 08:25:24PM +0100, Stephan M=FCller wrote:
> > diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> > index a253d66ba1c1..1c39d294b9ba 100644
> > --- a/crypto/testmgr.h
> > +++ b/crypto/testmgr.h
> > @@ -5706,6 +5706,7 @@ static const struct hash_testvec
> > hmac_sha1_tv_template[] =3D {>=20
> >  		.digest	=3D "\xb6\x17\x31\x86\x55\x05\x72\x64"
> >  	=09
> >  			  "\xe2\x8b\xc0\xb6\xfb\x37\x8c\x8e\xf1"
> >  			  "\x46\xbe",
> >=20
> > +#ifndef CONFIG_CRYPTO_FIPS
> >=20
> >  	}, {
> >  =09
> >  		.key	=3D "Jefe",
> >  		.ksize	=3D 4,
>=20
> Please don't use ifdefs, you can instead add a fips_skip setting
> just like we do for cipher test vectors.

Thank you for the hint, will do.
>=20
> Thanks,


Ciao
Stephan


