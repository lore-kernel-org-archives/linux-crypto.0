Return-Path: <SRS0=oD/a=4Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DBEC3F2CD
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 15:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D6EA246AC
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 15:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582903343;
	bh=UYhn1fFg3Y1GTYbKIfl4ZZ2iyw/AGPyqHaUlJ70F77o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=WuTNJW3j6CQAQOh6OQl2AxhuHei85DmbjjqeNal0ynxdxnYSCRWJ2RV059DO4qJoy
	 wikj9DvsURF9gURb6CoYTqkunb9uJaEbRuRRv4np3yZAMAsXd9zgUqRVdK1NyG53TT
	 RH7FrTe1jasBOCWXL1VIJMvj+YbIjWf6CTw/qAg4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgB1PWW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Feb 2020 10:22:22 -0500
Received: from foss.arm.com ([217.140.110.172]:40002 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgB1PWW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Feb 2020 10:22:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C442831B;
        Fri, 28 Feb 2020 07:22:21 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 457573F73B;
        Fri, 28 Feb 2020 07:22:21 -0800 (PST)
Date:   Fri, 28 Feb 2020 15:22:19 +0000
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
Message-ID: <20200228152219.GA4956@sirena.org.uk>
References: <20200218195842.34156-1-broonie@kernel.org>
 <20200218195842.34156-13-broonie@kernel.org>
 <CAKv+Gu9Bt93hCaOUrgtfYWp+BU4gheVf2Y==PXVyMZcCssRLQg@mail.gmail.com>
 <20200228133718.GB4019108@arrakis.emea.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20200228133718.GB4019108@arrakis.emea.arm.com>
X-Cookie: There Is No Cabal.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2020 at 01:37:18PM +0000, Catalin Marinas wrote:
> On Fri, Feb 28, 2020 at 01:41:21PM +0100, Ard Biesheuvel wrote:

> > This hunk is going to conflict badly with the EFI tree. I will
> > incorporate this change for v5.7, so could you please just drop it
> > from this patch?

Will do for any reposts.

> I wonder whether it would be easier to merge all these patches at
> 5.7-rc1, once most of the major changes went in.

Only thing I can think that doing that might cause issue with is if
people are doing work that's not likely to make it in this cycle then
it'd be some extra rebasing or carrying of out of tree patches they'd
need to do (plus obviously this series might pick up new conflicts
itself).  It's not a completely automated process unfortunately,
especially with trying to fix up some of the problems with the existing
annotations changing the output.  But yeah, we could do that.

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5ZMCgACgkQJNaLcl1U
h9Di0Qf/VWvMvqHepDi/x0ZXGJfY242zVkoLHcIp9UV0+4JT0IyKVRbIsBf/DfdM
CjvFlDIqp3m35lh9dEDlKUi+0Pynyd/SXEsIyGf4vl5OrWGVUZoTSiWsy00gWp5e
RFpAo4g4nxGRc4t86UeHZyu9D2+ezFOioFfmCWWmOZZOVKV+DBph+ct/pRqLogJ8
PyTeSZqJZYmOHQxxe68/jU/bIIhohgxh15poE4vYjVZZaD82+oNANqy0seFJ/rSu
7Lr3SduLDq7WeVMo/jYb4u3uOZVHvBCKwhktF1c3t602RBQhm+8pNKh33AFUOsRO
twDGT/8JVuS8HI1K0+7fIlfd4zPxHg==
=/8sV
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
