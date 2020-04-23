Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3ACC54FCB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 11:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC2112077D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 11:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587640687;
	bh=CJNoxUHgvPPi6Qz7NFobk1lVAPAIYHcYUb9EZMXpEDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MmUnQnE+Ou8UTYtG476J38KgN7QsuisYVRh/6mMtRtR6HsKzfQdezMkHlUaRryTon
	 wqEY3UeravG5KKHlMiJcfH5jhJ0UYF5AOxLX05IQM0H14lfD19kXY8x/qYMmQMn19Y
	 PkKrjfPtaqh+QJktH6CZAjwBbykJGdT8Xfe5Oie0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgDWLSH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 07:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgDWLSH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 07:18:07 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC7C42071C;
        Thu, 23 Apr 2020 11:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587640686;
        bh=CJNoxUHgvPPi6Qz7NFobk1lVAPAIYHcYUb9EZMXpEDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GJCLBypKIbMdCv9trAb+I5k8OsD4fiQDXU6P5swdLzc3OXz+KZh52sGY0IBsQmZDl
         Zvp5rXoeiBeVugDynp8aCksN9cDMZGjGbBC6IBqfSU6djcbF/ZVvxT5Wo/Kzq5v81F
         jiqFm0EGjrdCwq8CnID2TyHz7Pwr8R1suZddVsfc=
Date:   Thu, 23 Apr 2020 12:18:03 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH 0/3] arm64: Open code .arch_extension
Message-ID: <20200423111803.GG4808@sirena.org.uk>
References: <20200325114110.23491-1-broonie@kernel.org>
 <CAMj1kXH=g5N4ZtnZeX5N8hf9cnWVam4Htnov6qAmQwD58Wp73Q@mail.gmail.com>
 <20200325115038.GD4346@sirena.org.uk>
 <20200422180027.GH3585@gaia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yQbNiKLmgenwUfTN"
Content-Disposition: inline
In-Reply-To: <20200422180027.GH3585@gaia>
X-Cookie: This unit... must... survive.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--yQbNiKLmgenwUfTN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 22, 2020 at 07:00:28PM +0100, Catalin Marinas wrote:
> On Wed, Mar 25, 2020 at 11:50:38AM +0000, Mark Brown wrote:

> > Since BTI is a mandatory feature of v8.5 there is no BTI arch_extension,
> > you can only enable it by moving the base architecture to v8.5.  You'd
> > need to use .arch and that feels likely to find us sharp edges to run
> > into.

> For MTE, .arch armv8-a+memtag won't work since this is only available
> with armv8.5-a. My preference would be to have the highest arch version
> supported by the kernel in the assembler.h file, i.e. ".arch armv8.5-a"
> followed by .arch_extension in each .S file, as needed.

I think we decided that .arch_extension was too new to be used for
things like the crypto stuff where we still support older toolchains?

> Forcing .S files to armv8.5 would not cause any problems with
> the base armv8.0 that the kernel image support since it shouldn't change
> the opcodes gas generates. The .S files would use alternatives anyway
> (or simply have code not called).

We do loose the checking that the assembler does that nobody used a
newer feature by mistake but yeah, shouldn't affect the output.

> The inline asm is slightly more problematic, especially with the clang
> builtin assembler which goes in a single pass. But we could do something
> similar to what we did with the LSE atomics and raising the base of the
> inline asm to armv8.5 (or 8.6 etc., whatever we need in the future).

FWIW I did something different to this for BTI so I wasn't using the
instructions directly so I was going to abandon this series.

--yQbNiKLmgenwUfTN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl6heWoACgkQJNaLcl1U
h9CcYQf/YAY5cG0Z+KJA/4mDzsfJIXzFJiQYAT2tuyJHZjf/3CTPE3It3sTDp4i1
yxquKeKVGvnDrZobr9Mlb8GA92dM7ALcN8GEYLMqYWn4YFH5YGTrO2ThNMwGtFW2
yWun9x3SKPg8HWXOTmuumLyUXtnV7dcr21zQa+jgY6x4xyumKXs2xUXe85geF3Kl
CHWbPxMxwIHcw1R+hfAhqY18gBA9RRZ5Cdb9Dronv+EXpj7gpCi3kqjAuGqtzx6f
tocf6Rd8paJ1PRftJEBb/7Vy00mWBRQGgxiVLSNdxGWe15SYgswYrsuafKEOh3Qx
BRw4/z8CFxIpdOgEPm0vi4cFX8+VIg==
=kbYd
-----END PGP SIGNATURE-----

--yQbNiKLmgenwUfTN--
