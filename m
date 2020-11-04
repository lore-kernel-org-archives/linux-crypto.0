Return-Path: <SRS0=EIvj=EK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B60C2D0A3
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Nov 2020 17:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3B920BED
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Nov 2020 17:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604512245;
	bh=W60LX5v+g9E1e0h4dTb/esJuS//TK5vDQ15NyWbn2vs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GOUtM5/AF92K3ycMlH+jNuiylgm9Bp5BIZPp6dh7kylogVBfg+48xY06LZSBKIGAt
	 IdXeXFDhtiOg2ss4ZiOODJeEwe2F276vjEyCOvGQ68cY8OEij7OMhk6cVmNX+C9OOs
	 IqtDXPoXQMr22NMmx3b6+6/uFeuZ69e9gbrRUZFQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbgKDRup (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Nov 2020 12:50:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKDRup (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Nov 2020 12:50:45 -0500
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 977E12087D;
        Wed,  4 Nov 2020 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604512244;
        bh=W60LX5v+g9E1e0h4dTb/esJuS//TK5vDQ15NyWbn2vs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dDWFH/2NnSU/+gwOcGVLqbLS4qS8JU4llnYaA5Q7dpWhheiX13bvcO+vNsZjCcay7
         NTYh1lQ08oVCEW3RlZBD84dm00yjcyuQ1W1BENgJD8kiz6vlMs3rdxYMTRCXPPA563
         4bIs85NJrrnkJJ7PhNIY/wxbXf1cKVfztKPUi1Sc=
Date:   Wed, 4 Nov 2020 17:50:33 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Dave Martin <Dave.Martin@arm.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        l00374334 <liqiang64@huawei.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
Message-ID: <20201104175032.GA15020@sirena.org.uk>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201103121506.1533-2-liqiang64@huawei.com>
 <CAMj1kXFJRQ59waFwbe2X0v5pGvMv6Yo6DJPLMEzjxDAThC-+gw@mail.gmail.com>
 <20201103180031.GO6882@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20201103180031.GO6882@arm.com>
X-Cookie: Kleeneness is next to Godelness.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 03, 2020 at 06:00:32PM +0000, Dave Martin wrote:
> On Tue, Nov 03, 2020 at 03:34:27PM +0100, Ard Biesheuvel wrote:

> > First of all, I don't think it is safe at the moment to use SVE in the
> > kernel, as we don't preserve all state IIRC. My memory is a bit hazy,

> I'm not convinced that it's safe right now.  SVE in the kernel is
> unsupported, partly due to cost and partly due to the lack of a
> compelling use case.

I think at a minimum we'd want to handle the vector length explicitly
for kernel mode SVE, vector length independent code will work most of
the time but at the very least it feels like a landmine waiting to cause
trouble.  If nothing else there's probably going to be cases where it
makes a difference for performance.  Other than that I'm not currently
seeing any issues since we're handling SVE in the same paths we handle
the rest of the FPSIMD stuff.

> I think it would be preferable to see this algo accelerated for NEON
> first, since all AArch64 hardware can benefit from that.

...

> much of a problem.  kernel_neon_begin() may incur a save of the full SVE
> state anyway, so in some ways it would be a good thing if we could
> actually make use of all those registers.

> SVE hardware remains rare, so as a general policy I don't think we
> should accept SVE implementations of any algorithm that does not
> already have a NEON implementation -- unless the contributor can
> explain why nobody with non-SVE hardware is going to care about the
> performance of that algo.

I tend to agree here, my concerns are around the cost of maintaining a
SVE implementation relative to the number of users who'd benefit from it
rather than around the basic idea of using SVE at all.  If we were
seeing substantial performance benefits over an implementation using
NEON, or had some other strong push to use SVE like a really solid
understanding of why SVE is a good fit for the algorithm but NEON isn't,
then it'd be worth finishing up the infrastructure.  The infrastructure
itself doesn't seem fundamentally problematic.

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+i6egACgkQJNaLcl1U
h9B43wf+Oojz4L+6AYfvOtcIthACUvvQ6ooKAyP1U4NQDoZDDbtbfvFFsPnsRbvv
uFyqf1soqGm6g20Hfky64qSgBCL2t73/2q5cidDKEhnXWUvbrirwOXnlLzdZSoJd
/RUZ5fDAV7OrJNZUyGj4750xN9CoKwlgNJWqzda0FwlvjLR0DIRRO0XJtpraaWmw
3W3XhUn/sCPmuVv0O/PQy3VltjC9/2vGjPDx/jKm2ysQSQUP5NPcqHyvcfgSMrbP
hJnIduuWrdQ6ofekZ0GH84vyyUfXGDZKzm5cKyVfq0/0yF/2UhiPkeJ9Nc/e668i
ZXFpF6pqzyeMbfP7Sy/Gt1ilF6094Q==
=QoMD
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
