Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D2E6C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 06:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6F15207F7
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 06:04:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="ZkmjUnuO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgFEGEX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 02:04:23 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:34769 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgFEGEW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 02:04:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1591337060;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=xQf/uo4q6K1iZBsnpyYY+Pgu4F2NoH+wnims7GdkxsI=;
        b=ZkmjUnuOCOj6MxYn2yi+s5oUYPVr4VpFGgUKFHIv5ExXkdNzfPmdY7ZbnmXPVQ6JtU
        +25eRwfNUesdA9gYDyt2FxyKv8gzy0FtyI+cp1bWQsPQGNVbqYuU9gVy50G93c29+Za0
        16lhrBUxj3PhUbGOLwMdLGartp8PQfWpGThQDkoGw0EMHn9j4yrBbWJcXjisDI/tuvas
        hX6YLoJOwVqgLgyorVAPlanyzkMAvZN7pxxouaGkYICNy8CeQ6jiIEt9is0MtQeiAgAU
        E9OWmXDhQT004ANCtXGoxfBUN5DekVmTTviUJVgvmtY0AalyKGv6BFVsqkh/H64jA2ok
        0BiA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvdOeueZtw="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.9.1 DYNA|AUTH)
        with ESMTPSA id I05374w555wF9Vz
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 5 Jun 2020 07:58:15 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2] crypto: DRBG - always try to free Jitter RNG instance
Date:   Fri, 05 Jun 2020 07:58:15 +0200
Message-ID: <5789529.snvNDI1NMy@tauon.chronox.de>
In-Reply-To: <20200605004336.GC148196@sol.localdomain>
References: <0000000000002a280b05a725cd93@google.com> <2551009.mvXUDI8C0e@positron.chronox.de> <20200605004336.GC148196@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 5. Juni 2020, 02:43:36 CEST schrieb Eric Biggers:

Hi Eric,

> On Thu, Jun 04, 2020 at 08:41:00AM +0200, Stephan M=FCller wrote:
> > The Jitter RNG is unconditionally allocated as a seed source follwoing
> > the patch 97f2650e5040. Thus, the instance must always be deallocated.
> >=20
> > Reported-by: syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com
> > Fixes: 97f2650e5040 ("crypto: drbg - always seeded with SP800-90B ...")
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > ---
> >=20
> >  crypto/drbg.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/crypto/drbg.c b/crypto/drbg.c
> > index 37526eb8c5d5..8a0f16950144 100644
> > --- a/crypto/drbg.c
> > +++ b/crypto/drbg.c
> > @@ -1631,6 +1631,9 @@ static int drbg_uninstantiate(struct drbg_state
> > *drbg)>=20
> >  	if (drbg->random_ready.func) {
> >  =09
> >  		del_random_ready_callback(&drbg->random_ready);
> >  		cancel_work_sync(&drbg->seed_work);
> >=20
> > +	}
> > +
> > +	if (!IS_ERR_OR_NULL(drbg->jent)) {
> >=20
> >  		crypto_free_rng(drbg->jent);
> >  		drbg->jent =3D NULL;
> >  =09
> >  	}
>=20
> It it okay that ->jent can be left as an ERR_PTR() value?
>=20
> Perhaps it should always be set to NULL?

The error value is used in the drbg_instantiate function. There it is check=
ed=20
whether -ENOENT (i.e. the cipher is not available) or any other error is=20
present. I am not sure we should move that check.

Thanks for the review.
>=20
> - Eric


Ciao
Stephan


