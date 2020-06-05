Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC938C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 06:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44FE720823
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 06:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="U/QQ9VZq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgFEGxC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 02:53:02 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.165]:31008 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgFEGxC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 02:53:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1591339980;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=PoCqx/BPrQUxxmYNVEn+WdcUiY/cfzIG9OQ05nQcY9o=;
        b=U/QQ9VZq+WkO1u+PT3BsZsiS+oArC0aG04yb8X0GCLefCJk2/SmrxWYWU9JcFkLmAE
        gxJSarBf66GwWej99D8Vqxbc8POtramg3xsgratl8lo7mKPQsYYyE9Zs1oWEWF5O9sG8
        qOoNkz1ez8GBrOS6k7qZa/yTGxCwQ2+BDGTlRGuHG3fvUF5+4bJO//J9R+5BW2aYbZEE
        lbr8STENJcRFtD/Tv1SY5k4FxnJUQa+xEEUkoL8TaHHiKYAIpuUzP7SCn3WvMqTncmaA
        jbDX+qsQGYNX4RYaKGLf2EIiAz/GcaMH9ckw/Q0JKehJNNdldIfneom6tYbbXaTZOJWy
        c6Og==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvdOeueZtw="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.9.1 DYNA|AUTH)
        with ESMTPSA id I05374w556qv9kf
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 5 Jun 2020 08:52:57 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2] crypto: DRBG - always try to free Jitter RNG instance
Date:   Fri, 05 Jun 2020 08:52:57 +0200
Message-ID: <4575667.y41LbVH5lo@tauon.chronox.de>
In-Reply-To: <20200605061646.GA107328@sol.localdomain>
References: <0000000000002a280b05a725cd93@google.com> <5789529.snvNDI1NMy@tauon.chronox.de> <20200605061646.GA107328@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 5. Juni 2020, 08:16:46 CEST schrieb Eric Biggers:

Hi Eric,

> On Fri, Jun 05, 2020 at 07:58:15AM +0200, Stephan Mueller wrote:
> > Am Freitag, 5. Juni 2020, 02:43:36 CEST schrieb Eric Biggers:
> >=20
> > Hi Eric,
> >=20
> > > On Thu, Jun 04, 2020 at 08:41:00AM +0200, Stephan M=FCller wrote:
> > > > The Jitter RNG is unconditionally allocated as a seed source follwo=
ing
> > > > the patch 97f2650e5040. Thus, the instance must always be deallocat=
ed.
> > > >=20
> > > > Reported-by: syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com
> > > > Fixes: 97f2650e5040 ("crypto: drbg - always seeded with SP800-90B
> > > > ...")
> > > > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > > > ---
> > > >=20
> > > >  crypto/drbg.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >=20
> > > > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > > > index 37526eb8c5d5..8a0f16950144 100644
> > > > --- a/crypto/drbg.c
> > > > +++ b/crypto/drbg.c
> > > > @@ -1631,6 +1631,9 @@ static int drbg_uninstantiate(struct drbg_sta=
te
> > > > *drbg)>
> > > >=20
> > > >  	if (drbg->random_ready.func) {
> > > >  =09
> > > >  		del_random_ready_callback(&drbg->random_ready);
> > > >  		cancel_work_sync(&drbg->seed_work);
> > > >=20
> > > > +	}
> > > > +
> > > > +	if (!IS_ERR_OR_NULL(drbg->jent)) {
> > > >=20
> > > >  		crypto_free_rng(drbg->jent);
> > > >  		drbg->jent =3D NULL;
> > > >  =09
> > > >  	}
> > >=20
> > > It it okay that ->jent can be left as an ERR_PTR() value?
> > >=20
> > > Perhaps it should always be set to NULL?
> >=20
> > The error value is used in the drbg_instantiate function. There it is
> > checked whether -ENOENT (i.e. the cipher is not available) or any other
> > error is present. I am not sure we should move that check.
> >=20
> > Thanks for the review.
>=20
> drbg_seed() and drbg_async_seed() check for drbg->jent being NULL.
>=20
> Will that now break due it drbg->jent possibly being an ERR_PTR()?
>=20
> Hence why I'm asking whether drbg_uninstantiate() should set it to NULL.

The allocation happens in drbg_prepare_hrng that is only invoked by=20
drbg_instantiate.

drbg_instantiate checks for the ERR_PTR and sets it to NULL in case the err=
or=20
is deemed ok.

Thus, any subsequent functions would see either a valid pointer or NULL. Th=
e=20
only exception is drbg_uninstantiate when invoked from the error case=20

                ret =3D drbg_prepare_hrng(drbg);
                if (ret)
                        goto free_everything;

Thus, I think that the two functions you mention will never see any values=
=20
other than NULL or a valid pointer.

Thanks


Ciao
Stephan


