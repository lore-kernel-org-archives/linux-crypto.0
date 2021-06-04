Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FA3C4743C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 17:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68A1B61400
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 17:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFDRQh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Jun 2021 13:16:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhFDRQh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jun 2021 13:16:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83DB261359;
        Fri,  4 Jun 2021 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622826891;
        bh=7nmz1raQFUKAtzJAzWxRYkCXBl994MaAmMtLTvmwAO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sHSbVNo3kyn5LCW9dS1oK+6B0SEvvjF5/l5WIgrZ85u6WwfAVJlJR/xYTyDIBX6dD
         gg1zU/5WSAZoFVONBO+2toI2vMa3CrlNNewDlfQJmN48JfIPmqBNG5NWEikICH6tyk
         /pgSMf91JTLOgjNxQtbBJ5sWfdAIP64FSbAvpS10JUPinMsU8bcdcuXAZwuDPdQZei
         iCC05K5KV22uVnTyw1qe6uD2cEjjH9XiKt64YECFDYh3gMhc8RZSZvg6L+o9ruTCQk
         ELCqTXp2JVE/T2DKYiqFeCm+j0ddsP7XX8NRTqxZ3Wb6teq0KjJQxiZYow/vuZS3Si
         zaSl/gwVoOG9w==
Date:   Fri, 4 Jun 2021 18:14:39 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Ali Saidi <alisaidi@amazon.com>
Subject: Re: [PATCH] hwrng: Add Arm SMCCC TRNG based driver
Message-ID: <20210604171439.GA39696@sirena.org.uk>
References: <20210604170216.4705-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20210604170216.4705-1-andre.przywara@arm.com>
X-Cookie: optimist, n:
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 04, 2021 at 06:02:16PM +0100, Andre Przywara wrote:

> +static int __init smccc_trng_dev_init(void)
> +{
> +	platform_device_register_simple("smccc_trng", -1, NULL, 0);
> +
> +	return 0;
> +}
> +
> +device_initcall(smccc_trng_dev_init);

This will leave the device registered if the driver is removed and cause
the attempt to register the device again to fail if the module is
reloaded.  We don't check the error here but I'm not sure the driver
core won't complain about that and it's generally icky, better to clean
up the device on module removal.

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmC6X34ACgkQJNaLcl1U
h9BBVQf/XQdxBvCAtkGB0q2r1SwBLIFxttR/4U1G2b30Z2V0EeHjbDa3guGVMoe6
u/py83JO8RdTaFIDUgpJVTSn4YEQ49Jmw+zTng51oDEu/Jdkp390mYZ2+jnPzt6R
PezUOOaD5P5mSPlEhZLSb9cSBlU60aFHIFcpjK11F5jechFsGz0H2g9mNN7AU7rH
GR2CjCliZpkJsTG9ZTmd2tJMJqTRcU+KT/D/yw1+ynpMTXBaV6hrUduiD4E2VSs4
2+rstDlKGZcwl8Rnz8DMum8c1uP0W/21yQYK2jmC72H+yDsyMlBJ291bqh//pQPn
Qszkn3otjj3IL+Zg4JhoLzRxHenW3w==
=LpY4
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
