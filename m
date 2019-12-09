Return-Path: <SRS0=S8oY=Z7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71210C43603
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 16:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47FB72080D
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Dec 2019 16:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575908121;
	bh=FY7vsAel2xCJ1W5McVQlq77WqrZlNWH/dnxk/5QI/dc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YXoMHaYltEVDZU6TADrJJieKdTamN4maxEI/Pe6AmzPYGqXfsEwW+FZziUmtztW5T
	 TUBPMQvvPnYqbGdhbWdaa/XyEoeQm+pSly88LsDTzNPzgXyr+IKc3JUhU9kLbXOoaC
	 O7bdUSvsWyXYr/N+QHu4nQ73TA3jInA9vB1AosdA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfLIQPU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Dec 2019 11:15:20 -0500
Received: from foss.arm.com ([217.140.110.172]:37174 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfLIQPU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Dec 2019 11:15:20 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABD781FB;
        Mon,  9 Dec 2019 08:15:19 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 23FCE3F718;
        Mon,  9 Dec 2019 08:15:18 -0800 (PST)
Date:   Mon, 9 Dec 2019 16:15:17 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Richard Henderson <richard.henderson@linaro.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, ard.biesheuvel@linaro.org
Subject: Re: [PATCH v7] arm64: Implement archrandom.h for ARMv8.5-RNG
Message-ID: <20191209161517.GB5483@sirena.org.uk>
References: <20191114113932.26186-1-richard.henderson@linaro.org>
 <20191114142512.GC37865@lakrids.cambridge.arm.com>
 <3b1d5f2a-5a8d-0c33-176a-f1c35b8356de@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <3b1d5f2a-5a8d-0c33-176a-f1c35b8356de@linaro.org>
X-Cookie: We read to say that we have read.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 14, 2019 at 07:11:29PM +0100, Richard Henderson wrote:
> On 11/14/19 3:25 PM, Mark Rutland wrote:

> > As I asked previously, please separate the common case and the boot-cpu
> > init-time case into separate functions.

> Ok, beyond just making arch_get_random_seed_long be a function pointer, how?

> I honestly don't understand how what you want is different from what's here.

I believe that what Mark is saying when he says you should change the
arch hooks is that you should change the interface between the core code
and the architecture code to separate the runtime and early init
interfaces with the goal of making it clear the separation between the
two.

> > Any boot-time seeding should be in a separate function that external
> > callers cannot invoke at runtime. Either have an arch function that the
> > common random code calls at init time on the boot CPU, or have some
> > arch_add_foo_entropy() function that the arm64 code can call somewhere
> > around setup_arch().

> What "external callers" are you talking about?

Again Mark can correct me if I'm wrong here but anything that isn't
the arch code or the core random code.

> As for arch_add_boot_entropy() or whatnot... you're now you're asking for
> non-trivial changes to the common drivers/char/random.c code.  I'm not keen on
> designing such a thing when I really don't know what the requirements are.  In
> particular, how it would differ from what I have.

The biggest issue here is one of reviewability and maintainability
around early use of the capabilities code.  Without being really up to
speed on those interfaces it can be hard to tell what conditions are
true when and what interfaces are safe to use at any given point in boot
which makes things harder to work with.  This is especially true when we
start to mix in things like preemption disables which also need a lot of
attention.  Avoiding mixing code that needs to run in both init and
normal runtime contexts in the same function makes things easier to
understand.

Looking briefly at the random code you may find that the existing
add_device_randomness() is already close to the arch_add_foo_entropy()
suggested by Mark if not actually good enough, data injected with that
is not going to be credited as entropy but it will feed into the pool.

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl3ucxQACgkQJNaLcl1U
h9Abygf49pMSCQEuwmazZxHMTjuxhxEpfwh8KxNQDPNroTdxIPUxHHL+ifeGMh1y
StafJtieoAWSeUWc/G+A44wB6BITr+nNVu9NlU2/l0wLULpOznjn+X51InqQKKdq
mLNtHpMDE0TsPwNCX+vk78eYCI2FO4Vje5n0MghcQLuYFCsdkgmQ/jQJLsdku3/f
zLbC0Hs3/yhTRW386Ypk9jXOBNkSFAUuL0nKXBFBUn7CTrNRzHM6Zeo4RJHBq2Bq
bG4IjYTJattDDOWf17DiiiTRYP0vPu+DtBYsETZzaTm2VRotPOKn0OP98kDfdHlk
ONtKIWf8ArfiV69l7ix4sd5DTRzW
=Lyx1
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
