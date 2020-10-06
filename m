Return-Path: <SRS0=C5lZ=DN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3883C41604
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 10:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E2AD20853
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Oct 2020 10:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601980573;
	bh=PQR6Uxb0nhKxapVOyR72S8ZRuO6rYgI0q0HVtWS+SLw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=v7lwmHYyVwrNiNwl57792R3mNZjruXiJWnJUojXDqTeHXf3rCVBgTybXS37CLWAMs
	 hSg8WDrTG+VRhUTzc3FhCxXhvdwu0x1sXksjA8aVNru6s7VJJZd62VihelTwKYMfxT
	 t718lPYrxVs0VOa4nVC2ftd/zA/320Hix93dIBQU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgJFKgM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Oct 2020 06:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJFKgM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Oct 2020 06:36:12 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4231B2080A;
        Tue,  6 Oct 2020 10:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601980571;
        bh=PQR6Uxb0nhKxapVOyR72S8ZRuO6rYgI0q0HVtWS+SLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KqYOAPReH7n44rGE3eR/7G8NJ/kciOyAi89FCE5ICAvLmdYAY4y5Jko+Xpjh5cWnA
         4l0JLCPa06YEbZ4dO3gzyiMf+PmUFLUHjDj7H+lYQH6QkAkZwWJqHvYKx2dL9HZ3Yw
         U1WTtryX+e5tsaolPiyztZK4vULw7Wbr38Tm4Ckw=
Date:   Tue, 6 Oct 2020 11:35:08 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        ardb@kernel.org, will@kernel.org, catalin.marinas@arm.com,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG][PATCH] crypto: arm64: Avoid indirect branch to bti_c
Message-ID: <20201006103508.GA5259@sirena.org.uk>
References: <20201006034854.2277538-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20201006034854.2277538-1-jeremy.linton@arm.com>
X-Cookie: Will it improve my CASH FLOW?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 05, 2020 at 10:48:54PM -0500, Jeremy Linton wrote:
> The AES code uses a 'br x7' as part of a function called by
> a macro. That branch needs a bti_j as a target. This results
> in a panic as seen below. Instead of trying to replace the branch
> target with a bti_jc, lets replace the indirect branch with a
> bl/ret, bl sequence that can target the existing bti_c.

Reviewed-by: Mark Brown <broonie@kernel.org>

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl98SFsACgkQJNaLcl1U
h9BMrwf/RiJaQYvD/q24Fy2YkxfBrOM7a14fYbCR6mSTUD1AauKZxhnZcdF18CgJ
EOJ5dddU832+k7MJxQIlLmtfYMFrP3wu6f+uxQH4Ft4q6MGXNhMjAJcmiGoZsVdG
5LCtaCxJrjzFMl7t30C9G1OCFU2YdBDVNeKVsgpgRROHKNfk7mnZJdxbX/HPNmkb
8mhjE4CazgyLRrp5goweWCi/nGc0uPKnfLqiGgJRpfEskB/y8jBvrQ3EaTEnnxFp
+I/Wzej1o4QCE1QKYYMQr0Y+lQsAih9kcvVDJgETlwyXgYgcTo3kL2TTCT9pMEaQ
qKa+msQKZvs+bWYZPCQp9Un+hZBzpg==
=LGy1
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
