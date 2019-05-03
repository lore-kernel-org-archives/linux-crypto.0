Return-Path: <SRS0=LfhG=TD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FF2C43219
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 05:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B882C2075C
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 05:11:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="UNt9lJnZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfECFL1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 May 2019 01:11:27 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:18319 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfECFL1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 May 2019 01:11:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1556860285;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=qqMvg8+ahBhu4uOS+PFySGC3mA76mH3N/mKxfGy11/w=;
        b=UNt9lJnZo1e7UedcUWuNyEAzk7bB/XtmQ6rEr4xMPM1NmjHv3Z0Txs4bnzicNA9xPn
        z6jV+kmHd2KED/+yxRSe1BbeZafx0S9eKMKmZi+K3SE/MzpS4Kbl88t7I58YVor1wDDa
        jZ4OCmZjzAQLaiD4f+AVjBvzjPIlBC0C9143ruutt08dai3U3PJI7+ESybqtTcrk5vd8
        GRPsEu85iKZiqYpqu/GMaKZFuhUs3NLIoHDOTGrjQLbpx8L47kpwNHcjyEwTBL+AE6kV
        4ViFBpXdNRDwvFSbhBhn4TgA3sHzRQFKGkdF149g+QoNOHGZvFZmXK1z280Wue5ytPRB
        oXJQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSd/cc="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv435BOlv8
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 3 May 2019 07:11:24 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] crypto: DRBG - add FIPS 140-2 CTRNG for noise source
Date:   Fri, 03 May 2019 07:11:23 +0200
Message-ID: <2145637.ukeSOrXKR8@tauon.chronox.de>
In-Reply-To: <20190503014241.cy35pjinezhapga7@gondor.apana.org.au>
References: <1852500.fyBc0DU23F@positron.chronox.de> <5352150.0CmBXKFm2E@positron.chronox.de> <20190503014241.cy35pjinezhapga7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 3. Mai 2019, 03:42:41 CEST schrieb Herbert Xu:

Hi Herbert,

> On Thu, May 02, 2019 at 06:38:12PM +0200, Stephan M=FCller wrote:
> > +static int drbg_fips_continuous_test(struct drbg_state *drbg,
> > +				     const unsigned char *entropy)
> > +{
> > +#if IS_ENABLED(CONFIG_CRYPTO_FIPS)
>=20
> This should look like
>=20
> 	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
> 		...
> 	} else {
> 		...
> 	}
>=20
> This way the compiler will see everything regardless of whether
> FIPS is enabled or not.
>=20
> > diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
> > index 3fb581bf3b87..939051480c83 100644
> > --- a/include/crypto/drbg.h
> > +++ b/include/crypto/drbg.h
> > @@ -129,6 +129,10 @@ struct drbg_state {
> >=20
> >  	bool seeded;		/* DRBG fully seeded? */
> >  	bool pr;		/* Prediction resistance enabled? */
> >=20
> > +#if IS_ENABLED(CONFIG_CRYPTO_FIPS)
> > +	bool fips_primed;	/* Continuous test primed? */
> > +	unsigned char *prev;	/* FIPS 140-2 continuous test value */
> > +#endif
>=20
> You can still use #ifdef here.

The variables would need to be defined unconditionally if we use a runtime=
=20
check in the C code. Is that what you want me to do?

Ciao
Stephan


