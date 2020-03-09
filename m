Return-Path: <SRS0=CB0V=42=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E22CC10F27
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Mar 2020 17:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DD2C20727
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Mar 2020 17:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583776517;
	bh=kv0imhuGgVBmD8tg3GSMh09nDq4PC76bGe3hs2deFqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eRpSUUwr+IMvaD5znjEuAd+6IiGl/TUp7ATV+y62TAP9GapPkXhnSlvcKSkP70BDZ
	 OxCn+laUe58iiO+qjOmYXywFNz6K55b1Sfm3CMFialm7yxRA6WElOBJq4/+WfrXUV7
	 I2brKzeRnskKOc5ZEERhLlOBtCNMKR7YVinzYxEc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgCIRzQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Mar 2020 13:55:16 -0400
Received: from foss.arm.com ([217.140.110.172]:55344 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgCIRzQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Mar 2020 13:55:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 101541FB;
        Mon,  9 Mar 2020 10:55:16 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 877C23F67D;
        Mon,  9 Mar 2020 10:55:15 -0700 (PDT)
Date:   Mon, 9 Mar 2020 17:55:14 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 12/18] arm64: kernel: Convert to modern annotations for
 assembly functions
Message-ID: <20200309175514.GL4101@sirena.org.uk>
References: <20200218195842.34156-1-broonie@kernel.org>
 <20200218195842.34156-13-broonie@kernel.org>
 <CAKv+Gu9Bt93hCaOUrgtfYWp+BU4gheVf2Y==PXVyMZcCssRLQg@mail.gmail.com>
 <20200228133718.GB4019108@arrakis.emea.arm.com>
 <20200228152219.GA4956@sirena.org.uk>
 <20200309175203.GE4124965@arrakis.emea.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bFUYW7mPOLJ+Jd2A"
Content-Disposition: inline
In-Reply-To: <20200309175203.GE4124965@arrakis.emea.arm.com>
X-Cookie: Above all things, reverence yourself.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--bFUYW7mPOLJ+Jd2A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 09, 2020 at 05:52:03PM +0000, Catalin Marinas wrote:

> I queued this series for 5.7, apart from patch 12. I'll try to fix any
> conflicts with whatever patches I'm adding but may drop some of them if
> they conflict badly with code in -next (not likely). We'll revisit at
> -rc1 to see what's left.

Thanks.

--bFUYW7mPOLJ+Jd2A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5mgwEACgkQJNaLcl1U
h9C/Gwf+I7COBLhEJB5O4BpJwqHs8Eu6fm4Xs3yxlGbeuJsbvREuUQ6Nla07nK/y
3LjxWqI38XL2N7Ruw7KfHzAfvZa0yZIkERdKFnP3Ycy6tRNp8miugtgK4qrPyO9I
8wuH7ulbNMafqQVx4LQqQbLpRck31y4qUQk76JMjWFpqT23Hu/wCr+UpOKWc/Vke
eDb4XriX32xLsHDeh5W5FJL6vFkxYfgyhi9Tmw4C5EXTE+8Kn5FLls5as9GBUwEZ
jm4VHcWUntxBCjWaesLvxDPUazFabAJIjLVGwtqXKZO0/7yLzxf7fE0AKdG3PQc8
s5lYxilRm61ZWeaHvnDGcfoS0/wX7A==
=/gTP
-----END PGP SIGNATURE-----

--bFUYW7mPOLJ+Jd2A--
