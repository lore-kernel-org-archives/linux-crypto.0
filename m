Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9AA6C4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 00:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B694F60F41
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 00:59:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhG0ATD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 20:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhG0ATD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 20:19:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0964460F57;
        Tue, 27 Jul 2021 00:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627347571;
        bh=JhaVN5IfMdFXWWgSRfQeJuoGJgjwaZop9CUTnjtLZJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eiGOvjL2h66Cmuz8vxkxeGAJR7rAM3fgTzeK8yEylTv4PVVyZdihL/PuwOcat1SBL
         BVB2zwSMGjWXTJDWgRydQ0i30vLyozFFS7OdjrJhNL3MHmKnKsc1UjO+jnzr9yHez5
         gF/MhPdQ6+7Uf1Q5RDzwoccmgNybM0I3+crSQVzw9OGF2Qq6ixnxx7MXeDQmYKN6Ha
         U5comA6bOYP8DM51R7gx0aUQc2Z2OwVE00wg9vFa9QicVQ/ENo+n0RtrwudEVEo1+h
         kdrmU+OC0imPq+pQVjRYN8xk9Rt5hG+3+DEAeb5eD9C3tEqxo7Pfvsc8WOjmiyLF1j
         L0gLavyE8MHYA==
Date:   Tue, 27 Jul 2021 01:59:22 +0100
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
Message-ID: <20210727005922.GN4670@sirena.org.uk>
References: <20210726175610.3311-1-andre.przywara@arm.com>
 <20210726175610.3311-3-andre.przywara@arm.com>
 <20210726223738.GM4670@sirena.org.uk>
 <20210727013004.4caca28f@slackpad.fritz.box>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xTKfHyrFnSV9DG3y"
Content-Disposition: inline
In-Reply-To: <20210727013004.4caca28f@slackpad.fritz.box>
X-Cookie: Vini, vidi, Linux!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--xTKfHyrFnSV9DG3y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 27, 2021 at 01:30:04AM +0100, Andre Przywara wrote:

> Now thinking about this, there would probably be some value in making
> the TRNG UUID somehow available, as this can be used to identify flawed
> implementations (general problems in the hardware or backend bugs). But
> this should be some query-able interface, rather than some line in
> dmesg. Any ideas? Might be beyond the scope of this series, though...

I guess you could append it to the name (eg, "SMCCC TRNG ${UUID}")
though it'd be a bit of an eyesore if anyone displays that in UIs much?

A separate version string queryable in parallel with name would be more
work but possibly a bit more sensible, some other hardware entropy
sources will have firmware version numbers or similar they could
usefully report I expect.

--xTKfHyrFnSV9DG3y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmD/WmkACgkQJNaLcl1U
h9DxSQf/SRmE+SMJ3GxdX20HOP2LsvMm9R5rJCf0HK/MQYavnz151pAb5OICJWLT
YC0FOoXaXwAgzz1b8y3MkC+9aAV0d3eSvfGCpbEF7lQ4imCwjnXZPSjZZkLexRcj
r+9yXM2U2iDKtUxrngwh2+OcZlaagC9oJYgxB9YhK+lkuxgsA9Y4PC7QzQ8I9nzN
vgygd/7t4DV4cjadSUdmlcSYKuZlF4ORWUHIUb8KFbLYZ01PlAtcHwUXtXP+mL8S
xK+H5YBAEoIoeSlYPirKHKyOgEnL9We0grsN0JhgPz04oLLLP2WeYBIwEm5w4iHn
gTBNJ39Xlzeq7LOzWJ2I7W/CG2UQ8A==
=Nq3c
-----END PGP SIGNATURE-----

--xTKfHyrFnSV9DG3y--
