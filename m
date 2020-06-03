Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC436C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 11:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2889620738
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 11:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="IdFJ2cwW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgFCLkz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 07:40:55 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.167]:18419 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgFCLkx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 07:40:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1591184448;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=YS0Q02CwvzhXKETKCOJGeBcNkXNrzQU6s9jv8NvKqN4=;
        b=IdFJ2cwWNd6sz+wbrgNumAN+lJPh+ulKDcJSVbVaTXN1U3agJqfG5q0aZ1Fkm42pmZ
        EFyiw1kM+4Lyi2tWJ3dzOkI9lWQymkMVJk9NBzoqATdvcyqGM5EpVZ5yXfU7tyvWyZHj
        KDMDAkH0ajxRXmdL5xUcYBep0XdhPf1zx2eQh+V3IHZ5AqWNuIgqXMyzbE7j/t1Ypab3
        T/ddcFGnpOps/r3GM1dCjId/xNxE2Qq72dc3175al8m6CEFWIovjgw0zOxRF1Zeeu2Pr
        qeXBZVSsUbA9rZk6rrz/xYrcTHy6GDPmguvgL7jWFMlXgZGosMiZXYiSdnXYFnSbkMPq
        P5Ng==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJPSf9iic"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.9.1 DYNA|AUTH)
        with ESMTPSA id I05374w53Bee2F8
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 3 Jun 2020 13:40:40 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+2e635807decef724a1fa@syzkaller.appspotmail.com>
Subject: Re: [PATCH] crypto: DRBG - always try to free Jitter RNG instance
Date:   Wed, 03 Jun 2020 13:40:40 +0200
Message-ID: <3191597.j9rW5h07Xc@tauon.chronox.de>
In-Reply-To: <20200603110919.GK30374@kadam>
References: <0000000000002a280b05a725cd93@google.com> <2583872.mvXUDI8C0e@positron.chronox.de> <20200603110919.GK30374@kadam>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 3. Juni 2020, 13:09:19 CEST schrieb Dan Carpenter:

Hi Dan,

> On Wed, Jun 03, 2020 at 10:08:56AM +0200, Stephan M=FCller wrote:
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
> > index 37526eb8c5d5..33d28016da2d 100644
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
> > +	if (drbg->jent) {
> >=20
> >  		crypto_free_rng(drbg->jent);
> >  		drbg->jent =3D NULL;
> >  =09
> >  	}
>=20
> free_everything functions never work.  For example, "drbg->jent" can be
> an error pointer at this point.
>=20
> crypto/drbg.c
>   1577          if (!drbg->core) {
>   1578                  drbg->core =3D &drbg_cores[coreref];
>   1579                  drbg->pr =3D pr;
>   1580                  drbg->seeded =3D false;
>   1581                  drbg->reseed_threshold =3D drbg_max_requests(drbg=
);
>   1582
>   1583                  ret =3D drbg_alloc_state(drbg);
>   1584                  if (ret)
>   1585                          goto unlock;
>   1586
>   1587                  ret =3D drbg_prepare_hrng(drbg);
>   1588                  if (ret)
>   1589                          goto free_everything;
>                                 ^^^^^^^^^^^^^^^^^^^^
> If we hit two failures inside drbg_prepare_hrng() then "drbg->jent" can
> be an error pointer.
>=20
>   1590
>   1591                  if (IS_ERR(drbg->jent)) {
>   1592                          ret =3D PTR_ERR(drbg->jent);
>   1593                          drbg->jent =3D NULL;
>   1594                          if (fips_enabled || ret !=3D -ENOENT)
>   1595                                  goto free_everything;
>   1596                          pr_info("DRBG: Continuing without Jitter
> RNG\n"); 1597                  }
>   1598
>   1599                  reseed =3D false;
>   1600          }
>   1601
>   1602          ret =3D drbg_seed(drbg, pers, reseed);
>   1603
>   1604          if (ret && !reseed)
>   1605                  goto free_everything;
>   1606
>   1607          mutex_unlock(&drbg->drbg_mutex);
>   1608          return ret;
>   1609
>   1610  unlock:
>   1611          mutex_unlock(&drbg->drbg_mutex);
>   1612          return ret;
>   1613
>   1614  free_everything:
>   1615          mutex_unlock(&drbg->drbg_mutex);
>   1616          drbg_uninstantiate(drbg);
>                                    ^^^^
> Leading to an Oops.

Thanks a lot for the hint - a version 2 should come shortly.
>=20
>   1617          return ret;
>   1618  }
>=20
> regards,
> dan carpenter


Ciao
Stephan


