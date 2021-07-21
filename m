Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93ABC12002
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 11:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 961C961175
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Jul 2021 11:37:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhGUK4f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Jul 2021 06:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238070AbhGUKga (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jul 2021 06:36:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 357E060FED;
        Wed, 21 Jul 2021 11:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626866221;
        bh=NWYaHNv3Ni0zyuqO1rUfqLULE5ZBPCsn6kFjPseILWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sapDQ4NPrMyEC5pbgvPlwQ8XJhdyBfq7tK9RMPeUxGRfKGL2PchsjtQM+2+8nOhAx
         HbAeuB6L6TmBo2vTaor1cmXBJU5w4ynpa7qL+7CRSnFjrcwaAVo2eAT7YagLVpLhTO
         qKhF47If46jMcH6gRrYMujMOfEY7HpaZIdOcFSUOOhItj0vQRcXm5GZnWSZtnOKvMQ
         nVhdvDkZQMfG47qeMIBFFPCG/oQBlyzjTU7+uJNHK/DtJgJAiUgzCqgmfRuVGvlAET
         J0c6MJQjNo5XpNp5lSYJVru4JcGpEsdN7qeZpADyIFuxlDrDNS33V8PtAJdW/m9a6x
         KGD1W8YlVXadw==
Date:   Wed, 21 Jul 2021 12:16:56 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>, Ali Saidi <alisaidi@amazon.com>,
        Jon Nettleton <jon@solid-run.com>
Subject: Re: [PATCH v2] hwrng: Add Arm SMCCC TRNG based driver
Message-ID: <20210721111656.GA4259@sirena.org.uk>
References: <20210720152158.31804-1-andre.przywara@arm.com>
 <CAMj1kXEW7DT3P3FuV+poFykf6wwm4FTJuV6emGSWabCp7UZX9A@mail.gmail.com>
 <20210720171631.071f84f5@slackpad.fritz.box>
 <e494866f38e9dcd2834971d3867244fb1d7e6ceb.camel@kernel.crashing.org>
 <20210721001803.303dfba1@slackpad.fritz.box>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20210721001803.303dfba1@slackpad.fritz.box>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 21, 2021 at 12:18:03AM +0100, Andre Przywara wrote:
> On Wed, 21 Jul 2021 08:02:42 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > On Tue, 2021-07-20 at 17:16 +0100, Andre Przywara wrote:

> > > Yes, a similar idea was already brought up before. I think there is e=
ven
> > > the potential for something like an artificial SMCCC "bus", where tho=
se
> > > services presentable as devices could be auto-detected (by checking
> > > known function IDs), the respective drivers would then probe
> > > automatically? =20

> > Sounds like a boot time killer...

> How so? To be clear, at the moment there is basically just the TRNG
> service we would probe for, maybe FF-A, then adding as we go. But in
> any case it would be just a handful, and querying is very quick
> (SMC/HVC, then just a switch/case on the other side, and ERET).
> Is there any particular scenario you are concerned about? Quick
> starting guests?

It's also worth pointing out that we're already doing the enumeration
part, making things a bus would just be about reorganising the code that
checks if services are present to a central place so it looks more Linux
style.  If anything I'd guess that if we get to the point where things
are slow enough to worry about having that code in one central place
would make doing something about it easier (eg, adding a "list all
services" service or firmware binding).

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmD4AicACgkQJNaLcl1U
h9B1/Qf+POQrRjDcaawnwQmaPxlIW3/6Swx2huY1ofbdsQ/4vZlt6Ju2sXX1md1J
LCNF+B2/pxjieNhz3Eswsf/LYr4+yeLtuHNgWsEmgcxSNhYBFvw6kjUn8/yUdsTR
d2QItg/3wqqcitKz3DQnuylZPrbh46pgt9jboJUqYmnyvxgOrtwG1Va+ng692SKA
cMvSib8oQQehNhQ3jl88EuJ2g1hoBKQlRrQkw8vpDLRpN7dZlSlEkzBaOZFsChKE
dYptfBTDBx7RUYHWQT3GY4/xYcdcmH8ICSm2+WPRTy02qorgGyNnKwsJvf3BCbK4
zJhyg/66rMJExeRp2L/Cy+za+YxSlg==
=8SIw
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
