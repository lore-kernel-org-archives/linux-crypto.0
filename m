Return-Path: <SRS0=NP+Z=6A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1A2C2BA2B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 652182087E
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 06:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="DTN2gq82"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437288AbgDPG4q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Apr 2020 02:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2436660AbgDPG4n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Apr 2020 02:56:43 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B077C061A0C
        for <linux-crypto@vger.kernel.org>; Wed, 15 Apr 2020 23:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1587020199;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=eF+Fqq444WDO93t747NuGcGR1MIY3iJaKoZjDeiX99s=;
        b=DTN2gq82kKEzQRDobOJg1pya4ZLeZ1d31WzBLi4kO4hTSZZmd5VZg+MWFTxuANy1u3
        dcHuyop0VunAPoJQQpQUPN6cv/q9OieicWS5Gzcp9laBulSb6g6sv0pqYyaKZ5vWIgSw
        IxvWWg4A3th374hQzjNg+Kh+Jf91tXKXyQgjhA93Tho+qAHC7OlIqmvu1z6yAU660/Yo
        FC1QvMKVoPkeSfwvYLL7Z2BGnbex2zyvhPX8RHKTKLCAF/oSl+DiSVvIuHG1gc5aAGFe
        wu37S5Mpn2hh65pY6KATX4CyKA1NeA7pQYtQ1/TO6E/r0VmXFjTMfkVFWH1kxDmGtPc6
        PH9w==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIvSaiyU="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.4.0 DYNA|AUTH)
        with ESMTPSA id 404ef0w3G6ud57o
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 16 Apr 2020 08:56:39 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: Jitter RNG SP800-90B compliance
Date:   Thu, 16 Apr 2020 08:56:38 +0200
Message-ID: <2920846.pNu1SyRcjk@tauon.chronox.de>
In-Reply-To: <20200416061529.GB19267@gondor.apana.org.au>
References: <16276478.9hrKPGv45q@positron.chronox.de> <4128830.EzT7ouGoCQ@positron.chronox.de> <20200416061529.GB19267@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 16. April 2020, 08:15:29 CEST schrieb Herbert Xu:

Hi Herbert,

> On Sat, Apr 11, 2020 at 09:35:03PM +0200, Stephan M=FCller wrote:
> > @@ -142,7 +143,47 @@ static int jent_kcapi_random(struct crypto_rng *tf=
m,
> >=20
> >  	int ret =3D 0;
> >  =09
> >  	spin_lock(&rng->jent_lock);
> >=20
> > +
> > +	/* Return a permanent error in case we had too many resets in a row.=
=20
*/
> > +	if (rng->reset_cnt > (1<<10)) {
> > +		ret =3D -EFAULT;
> > +		goto out;
> > +	}
> > +
> >=20
> >  	ret =3D jent_read_entropy(rng->entropy_collector, rdata, dlen);
> >=20
> > +
> > +	/* Reset RNG in case of health failures */
> > +	if (ret < -1) {
> > +		pr_warn_ratelimited("Reset Jitter RNG due to health test=20
failure: %s
> > failure\n", +				    (ret =3D=3D -2) ? "Repetition=20
Count Test" :
> > +						  "Adaptive Proportion Test");
> > +
> > +		rng->reset_cnt++;
> > +
> > +		ret =3D jent_entropy_init();
> > +		if (ret) {
> > +			pr_warn_ratelimited("Jitter RNG self-tests failed:=20
%d\n",
> > +					    ret);
> > +			ret =3D -EFAULT;
> > +			goto out;
> > +		}
> > +		jent_entropy_collector_free(rng->entropy_collector);
> > +		rng->entropy_collector =3D jent_entropy_collector_alloc(1, 0);
>=20
> You can't do a GFP_KERNEL allocation inside spin-locks.

Of course, thanks for pointing that out. I will send an update shortly.

Ciao
Stephan


