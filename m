Return-Path: <SRS0=6fPk=5K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A97CBC43331
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 12:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D7F720771
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Mar 2020 12:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585137722;
	bh=qlL293moBJ7TH4zouafkEfslOpaT8vrok39qKJ7ff04=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xfWbGSrMg8YQOe3cguCq4Wy8KOn9cPlPYnDA3Y1z3mDsWblEwemr+X2d8IZR8+7qE
	 HxbgcMLLjzYdYzCSutbvb0wcuFTiOX93CVdXt6nUFVXuo2dAf00q4hZxkdp879+oLe
	 9JF0I2rmDYHPCsRUxXCjrCsm7+XJMZDX6Qm+p9qA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgCYMCB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Mar 2020 08:02:01 -0400
Received: from foss.arm.com ([217.140.110.172]:47434 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbgCYMCB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Mar 2020 08:02:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2395731B;
        Wed, 25 Mar 2020 05:02:01 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 981C93F71F;
        Wed, 25 Mar 2020 05:02:00 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:01:59 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] arm64: Open code .arch_extension
Message-ID: <20200325120159.GE4346@sirena.org.uk>
References: <20200325114110.23491-1-broonie@kernel.org>
 <CAMj1kXH=g5N4ZtnZeX5N8hf9cnWVam4Htnov6qAmQwD58Wp73Q@mail.gmail.com>
 <20200325115038.GD4346@sirena.org.uk>
 <CAMj1kXEogCrLS1o9sQyiXsKZhykfc2kuOssCeME8HyhSnMEFvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5oH/S/bF6lOfqCQb"
Content-Disposition: inline
In-Reply-To: <CAMj1kXEogCrLS1o9sQyiXsKZhykfc2kuOssCeME8HyhSnMEFvA@mail.gmail.com>
X-Cookie: Many are called, few volunteer.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--5oH/S/bF6lOfqCQb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 25, 2020 at 12:54:10PM +0100, Ard Biesheuvel wrote:
> On Wed, 25 Mar 2020 at 12:50, Mark Brown <broonie@kernel.org> wrote:

> > Since BTI is a mandatory feature of v8.5 there is no BTI arch_extension,
> > you can only enable it by moving the base architecture to v8.5.  You'd
> > need to use .arch and that feels likely to find us sharp edges to run
> > into.

> I think we should talk to the toolchain folks about this. Even if
> .arch_extension today does not support the 'bti' argument, it *is*
> most definitely an architecture extension, even it it is mandatory in
> v8.5 (given that v8.5 is itself an architecture extension).

I agree entirely, the current behaviour is surprising and doesn't really
map onto how the architecture is described - my first thought was
similar to yours.  It won't help us right now but it would help for
future architecture extensions and for other projects.

--5oH/S/bF6lOfqCQb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl57SDYACgkQJNaLcl1U
h9C9Awf/W+fMgLWF5FZHyxhrynQzezNK9R7qjS3beGwi2LFpIzvm6hjlsqoXdSe9
zj6u/m9I6rp778cHUVSBlTb4ruG4A+UaZ2oXxqAQbC4isC104eC038jn8Kn2yYJu
j6Qx96WXCnB8HAWE26GbtQi1wk/cVvIH7Mrw2ePeajg120JXOrjjSgUV7RzepZW9
HsS/pDNXmic5MO+2jHUdW6dibApwCznce6gyvr1a9WG8m6RWmCWZERNdIlthJ9R+
eZYE6qNC2/ne24trLWgEm7MgIXRVY+c1SBCl8hpaC+RbGjhQiBOqen/GTMq+QwrH
GtwP4oGzpMlMrYacu/PF1ZmFH0AR/Q==
=Woxe
-----END PGP SIGNATURE-----

--5oH/S/bF6lOfqCQb--
