Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B605C54FD0
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 13:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D07102076A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 13:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585143058;
	bh=SCkE5dLj3/SXFfvOdxKSyfxSEprqrnbYZIdjrePOVRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=idijYuVv6oSQC3saCrU7gxeJ2l6bC0ixf1kbmqcAcIqYjqbcDwUuNeUbvPP7v9Jt5
	 wzj34brHkylO7UUoGTGhsWef1/6f/Z2LgGPjcZDcugQbxVZ7GoeQyWLB+mFVbOB+FZ
	 JHevKxknZ5N4LUWqKzC5JFMSl8RPA2IBil0UIeKY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgCYNa6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 09:30:58 -0400
Received: from foss.arm.com ([217.140.110.172]:48444 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726842AbgCYNa6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 09:30:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B18CE31B;
        Wed, 25 Mar 2020 06:30:57 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3488F3F71F;
        Wed, 25 Mar 2020 06:30:57 -0700 (PDT)
Date:   Wed, 25 Mar 2020 13:30:55 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] arm64: Open code .arch_extension
Message-ID: <20200325133055.GG4346@sirena.org.uk>
References: <20200325114110.23491-1-broonie@kernel.org>
 <20200325123157.GA12236@lakrids.cambridge.arm.com>
 <CAMj1kXH1OC0hqnP5hWUVMK8Z5CrWp+XFfxAyufXY4bKwN2U2xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9Iq5ULCa7nGtWwZS"
Content-Disposition: inline
In-Reply-To: <CAMj1kXH1OC0hqnP5hWUVMK8Z5CrWp+XFfxAyufXY4bKwN2U2xw@mail.gmail.com>
X-Cookie: Many are called, few volunteer.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--9Iq5ULCa7nGtWwZS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 25, 2020 at 02:26:49PM +0100, Ard Biesheuvel wrote:

> I think using macros wrapping .inst directives is the most hassle free
> way to achieve this, assuming there is no need to encode registers or
> immediates (which makes it slightly messy - refer to
> arch/arm64/crypto/sm3-ce-core.S for an example)

There isn't - you just have to encode the four target classes, of which
we only use one.

--9Iq5ULCa7nGtWwZS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl57XQ4ACgkQJNaLcl1U
h9AgRgf+PuOD/PfRQNTSNziC+ioXPuc2pH15lOCN5KAAdbm0bKP1ojqjalUzKzw8
hufMtyLux3sKdnbiWcw3wyNMUr5rZb6GCzo5HWTDG68a/elnrYnK4rQCqaOph6QI
SlVFLqPerEXDNGtC3pCY7nypVj2yoDNuhKAVChEFFnkYN8g1BZJP8M4etku0Ke/R
kwcUXl2M29a57GK221OCue2SJgK3/d/pQ71uHFjMrYoVCgGTDHh5sHsn+Yfe5nyR
7vr2kv3Qodjg2JAhIWnZFqPTjzojDdmjtV4zVVbG9PtTcVn1w44uugiDbhemypts
QJxTe1Fzp7trhU7VLifFmPeo5XxXwg==
=6wKN
-----END PGP SIGNATURE-----

--9Iq5ULCa7nGtWwZS--
