Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBD8C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 19 Dec 2021 08:53:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhLSIxH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 19 Dec 2021 03:53:07 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:24849 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231907AbhLSIxG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Dec 2021 03:53:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1639903980;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=4xfjlTuryYHGq4CldUoaQRCYJjyk3Av4kzeFbjPwTGU=;
    b=R3TzUle86Rc/ggxVANCKEcoFsFQPld39OBCpaL+Jgg+U0NIhll2STO+m6RAWRgNVLi
    IyrPFpTnADbasV0n7fCuHAc6SiDudQIirHKXarJPXccx9Xw7TiizHSJXE3tS2moNxSBs
    NGQicSnECiyRRN3DSI0ytM/mBVsOoMNxAf5f+uY+ZeNL6AbYggF12L7hYvI0TTP9ycjD
    /XgXrNLclgUUEfA0T+HGDJLvg5j4XWcNGMtMD3CNW/Dek2idM/JQsOM0Rsygsd6Freyq
    iILDSSYKU1jufcMNXnyyfpIuoCyhGOW4OJ28YGRxtBJm4iphe8Fd7C4IxY2JORJ7ocnh
    PCpg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/SWzl0="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.35.3 DYNA|AUTH)
    with ESMTPSA id h03d91xBJ8qxMn7
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 19 Dec 2021 09:52:59 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com, skozina@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: Re: [PATCH] crypto: jitter - add oversampling of noise source
Date:   Sun, 19 Dec 2021 09:52:57 +0100
Message-ID: <4499108.vXUDI8C0e8@positron.chronox.de>
In-Reply-To: <20211218032720.GA11637@gondor.apana.org.au>
References: <2573346.vuYhMxLoTh@positron.chronox.de> <20211218032720.GA11637@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Samstag, 18. Dezember 2021, 04:27:21 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Dec 17, 2021 at 10:41:42AM +0100, Stephan M=FCller wrote:
> > diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> > index 2d115bec15ae..b02f93805e83 100644
> > --- a/crypto/jitterentropy-kcapi.c
> > +++ b/crypto/jitterentropy-kcapi.c
> > @@ -59,6 +60,11 @@ void jent_zfree(void *ptr)
> >=20
> >  	kfree_sensitive(ptr);
> > =20
> >  }
> >=20
> > +int jent_fips_enabled(void)
> > +{
> > +	return fips_enabled;
> > +}
>=20
> Why do you need this function? And why can't it be inlined?
>=20
> Normally fips_enabled is entirely optimised away if FIPS is
> disabled in Kconfig.  This function breaks this.

You are right, fips.h can be included into jitterentropy.c and this helper=
=20
function can be eliminated.

Thanks
>=20
> Thanks,


Ciao
Stephan


