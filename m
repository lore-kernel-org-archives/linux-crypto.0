Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D420C004C9
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 13:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA15E205C9
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 13:18:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="EHxf82fu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfEGNSy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 09:18:54 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.25]:15879 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbfEGNSy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 09:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1557235131;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=jv5P72dCZybcQkpv8dIWweCx6+nNSotuhzwul2PwsIk=;
        b=EHxf82fuxRMibKZV/qFNtkLnskCtuWWBa8ITQB2lnfvvuweSPnNOpCfbSVopx2cYMW
        Cam2EtIPhiCXlVtIZem3mtxp638NFSE1BfDBcRFF+eDb7HCSCHxEkMbIXNrr4yyPIjHp
        f0rDOYIYL0bytJqmEDhijTbMP0uSHo8mc2kfZrdSId26HezPwCR0P0ZQGmytev+AT3i6
        ZI9dvGtKnS6E95xgFPRaj0GLIWlRymuVmnD0KTnm7lt2lBWmQm6EvuJYdJMcZO5ZhseF
        fmtcER/0cGhNOzf2rPL7/v8d18jo14sosKjhdUeyTYHAoh9xP5gPiA8ayA0VFy6rLUiM
        SvIQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x2wdNs6neUFoh7cs0E0="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 AUTH)
        with ESMTPSA id R0373fv47DIn5jm
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Tue, 7 May 2019 15:18:49 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Yann Droneaud <ydroneaud@opteya.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v5] crypto: DRBG - add FIPS 140-2 CTRNG for noise source
Date:   Tue, 07 May 2019 15:18:48 +0200
Message-ID: <2220012.cB1XuMDAq9@tauon.chronox.de>
In-Reply-To: <74c517ac2c654a7372af731a67e24743c843e157.camel@opteya.com>
References: <1852500.fyBc0DU23F@positron.chronox.de> <1654549.mqJkfNR9fV@positron.chronox.de> <74c517ac2c654a7372af731a67e24743c843e157.camel@opteya.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 7. Mai 2019, 15:10:38 CEST schrieb Yann Droneaud:

Hi Yann,

> Hi,
>=20
> Le mardi 07 mai 2019 =E0 11:29 +0200, Stephan M=FCller a =E9crit :
> > FIPS 140-2 section 4.9.2 requires a continuous self test of the noise
> > source. Up to kernel 4.8 drivers/char/random.c provided this continuous
> > self test. Afterwards it was moved to a location that is inconsistent
> > with the FIPS 140-2 requirements. The relevant patch was
> > e192be9d9a30555aae2ca1dc3aad37cba484cd4a .
>=20
> Please elaborate: in commit e192be9d9a30 ("random: replace non-blocking
> pool with a Chacha20-based CRNG") the "self test" code was moved from
> extract_entropy() to _extract_entropy(), which is used by
> extract_entropy().
>=20
> Only crng_initialize() call _extract_entropy() with fips =3D 0, regarless
> of fips_enabled.
>=20
> Is this the issue ?

The issue is that _extract_entropy is invoked with the input_pool from the=
=20
ChaCha20 RNG during its initialization or reseed. So, this function is call=
ed=20
to extract data from the input_pool and inject it into the ChaCha20 RNG.

However, we need the test to be applied at the output of the ChaCha20 RNG (=
or=20
/dev/random).

>=20
> Could crng_initialize() pass fips_enabled to _extract_entropy() instead
> of 0 ?

This small change does not fix it. At the time the change to ChaCha20 was=20
applied, I provided a patch that moved the continuous test back to the=20
locations were we need it. But it was ignored.


Ciao
Stephan


