Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432E4C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 22:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1924F60F6C
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 22:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbhGZV5T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 17:57:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233660AbhGZV5T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 17:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D882B6023B;
        Mon, 26 Jul 2021 22:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627339067;
        bh=Yg7eSshipIVYnhSHZdJfXu8FRZJlv508EUoxtizeAQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=clXK4L4anzF7XWNSq0schNI3oPf+oeZUtWlitJIZka61QSrWdhX5P3P37bYPiP4Ub
         QR1GMArds0uJsB+2XT0YdTqhgH0LAj1fC2Of5KivKXvo/26U7lDaXmdeeLDZYvSoOc
         9gtPxtMrA8H1z79ZJCnLTE9oBOWgP1TNh19re2+mFBiGmhs88RZv7d+pr2VH675W9m
         qLQPOaBPvcUH/AJ8wo7oltUDilkTIkBN8grIAlRJ6gbl2su5LuEuAVUkoSj6xRPtki
         nCuPWcE6+xXqDJmI/RZ15ydfnRDUKCIminOpbIQVk9QVOjTpB1+mccnXpR2MoBOkQw
         k1MkPgv50x6Jg==
Date:   Mon, 26 Jul 2021 23:37:38 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Ali Saidi <alisaidi@amazon.com>,
        Jon Nettleton <jon@solid-run.com>
Subject: Re: [PATCH v3 2/2] hwrng: Add Arm SMCCC TRNG based driver
Message-ID: <20210726223738.GM4670@sirena.org.uk>
References: <20210726175610.3311-1-andre.przywara@arm.com>
 <20210726175610.3311-3-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Z1Z8UV8BNhgCynIS"
Content-Disposition: inline
In-Reply-To: <20210726175610.3311-3-andre.przywara@arm.com>
X-Cookie: Vini, vidi, Linux!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--Z1Z8UV8BNhgCynIS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 26, 2021 at 06:56:10PM +0100, Andre Przywara wrote:

> +static int smccc_trng_init(struct hwrng *rng)
> +{
> +	return 0;
> +}

If this can be empty (looking at the core it seems like it can) then
best just remove it.

> +	platform_set_drvdata(pdev, trng);
> +	ret = devm_hwrng_register(&pdev->dev, trng);
> +	if (!ret)
> +		dev_info(&pdev->dev,
> +			 "ARM SMCCC TRNG firmware random number generator\n");

Is the log message needed given that we're not announcing any version
information here or anything?  A brief sampling of other drivers
suggests it's not a standard thing for the subsystem.

--Z1Z8UV8BNhgCynIS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmD/OTEACgkQJNaLcl1U
h9DF7wf9GqmHJLZkYahxYPpoXwvLcvsZt6nYbntvEyaggYXeftDozXfAGzJUwtVA
j43FX18gocM2pF69qk3kpzyt36ESGVWBnENrKlpBmonaZBd+OjEtf0Of3cfwXvfe
TrzFuo5BBcPdBhA2ijXjTZK3eiVhiwqbw/OO6xf6u0ZgZAJDtAOC0+cVmFC/pE6Q
8cVSY5v4izXNENx9COp3o6Irq1KvV3d5qsfMbU26N046nEbwtkUE5QLrNRk11hOg
7F1jg0P4Lny1jVNXkrtjrAZY9wlL/XOAUjQawf1kU29xLUn8BJHTqsz7uyu3Zd6k
tkl1X6LuTHtJ9rGRj+S3NaJ539HsYg==
=QpYI
-----END PGP SIGNATURE-----

--Z1Z8UV8BNhgCynIS--
