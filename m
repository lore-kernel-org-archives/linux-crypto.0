Return-Path: <SRS0=EIvj=EK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65107C2D0A3
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Nov 2020 18:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0222C20782
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Nov 2020 18:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604515758;
	bh=2A5OF6h6qHudL5Ez9ylNZyQmHAgeM1uxYZWr9nhyngM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RaHVm4I+Cwt1cMK5YqAD7JDtKl2eQC0DGyoXpxit41MPdKOT7RoGbVln+l3Egzo4x
	 3zc2TwShyWBJcZMiRK3yu+sYTCF7QteEfFNNEkCtHChnXPYTUtTngZpHhrs6yVsfJ5
	 xzZ0geI+hBKVQdsuDT4OjFPl9qgtD23nLZGMkdW0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgKDStR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Nov 2020 13:49:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:59698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgKDStR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Nov 2020 13:49:17 -0500
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E2320780;
        Wed,  4 Nov 2020 18:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604515756;
        bh=2A5OF6h6qHudL5Ez9ylNZyQmHAgeM1uxYZWr9nhyngM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XasNv1TzYodZT78eld5r/GIyEJmyQ1Dp9r5yXD5ijNWtxmZ3dRzX55iGLXFFA8sAY
         XIxhpK6I+SyqWWC9rYYEfmr3lXcKgnI7gJ8KbdoFTZYJ+zm4I2FV/Gv/AvAXqhe3oO
         lyvy56yCBaTExY5naozurJa8hxVbUgD5q9jIStxU=
Date:   Wed, 4 Nov 2020 18:49:05 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Dave Martin <Dave.Martin@arm.com>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        l00374334 <liqiang64@huawei.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE
 instructions.
Message-ID: <20201104184905.GB4812@sirena.org.uk>
References: <20201103121506.1533-1-liqiang64@huawei.com>
 <20201103121506.1533-2-liqiang64@huawei.com>
 <CAMj1kXFJRQ59waFwbe2X0v5pGvMv6Yo6DJPLMEzjxDAThC-+gw@mail.gmail.com>
 <20201103180031.GO6882@arm.com>
 <20201104175032.GA15020@sirena.org.uk>
 <20201104181256.GG6882@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <20201104181256.GG6882@arm.com>
X-Cookie: Take your Senator to lunch this week.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 04, 2020 at 06:13:06PM +0000, Dave Martin wrote:
> On Wed, Nov 04, 2020 at 05:50:33PM +0000, Mark Brown wrote:

> > I think at a minimum we'd want to handle the vector length explicitly
> > for kernel mode SVE, vector length independent code will work most of
> > the time but at the very least it feels like a landmine waiting to cause
> > trouble.  If nothing else there's probably going to be cases where it
> > makes a difference for performance.  Other than that I'm not currently

...

> The main reasons for constraining the vector length are a) to hide
> mismatches between CPUs in heterogeneous systems, b) to ensure that
> validated software doesn't run with a vector length it wasn't validated
> for, and c) testing.

> For kernel code, it's reasonable to say that all code should be vector-
> length agnostic unless there's a really good reason not to be.  So we
> may not care too much about (b).

> In that case, just setting ZCR_EL1.LEN to max in kernel_sve_begin() (or
> whatever) probably makes sense.

I agree, that's most likely a good default.

> For (c), it might be useful to have a command-line parameter or debugfs
> widget to constrain the vector length for kernel code; perhaps globally
> or perhaps per driver or algo.

I think a global control would be good for testing, it seems simpler and
easier all round.  The per thing tuning seems more useful for cases
where we run into something like a performance reason to use a limited
set of vector lengths but I think we should only add that when we have
at least one user for it, some examples of actual restrictions we want
would probably be helpful for designing the interface.

> Nonetheless, working up a candidate algorithm to help us see whether
> there is a good use case seems like a worthwhile project, so I don't
> want to discourage that too much.

Definitely worth exploring.

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+i96AACgkQJNaLcl1U
h9BDdwf/Wf3rFlhyHJXhtm3oJ/tp2NIupBTg/F/Exk30EuZkvBoJ+x6jogqI344/
uRvlOaXl8Cw30CDUpoHk2/F9sU/iULuR1GE/A22PV4qu5cLWDEqUwuALauA1OJ6U
6SnIy6SmCIyv3pRVKWiNEAlN/MzvZDFp3xQ5piUl6dBvK9tg1wD0I89hAJxNSWIo
rTboa3g+5r/Fr0yNY8H1QflGlKuflf1YZaPEPluQsIj8ptzJTv6icBnP9joKytep
EagSqjWcP4zCE/1WuL859nDcrlJvc+6yRG4sqDVT1lgKE0uEQKvkf69J3N2m3Zse
Mw/6CqyFCPj5iM6ueSHcaASZGztDPA==
=6u/G
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
