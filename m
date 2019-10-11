Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F12BECE58C
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 07:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B5E421D71
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 07:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570780630;
	bh=ExPB2LcrboMFCzOhxLXtekTOETsdzGtWe31It1sxYHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=D8RdthwGNb9z1NMusJjknhxxGmxdHagMhSRI7WNeXkRl2q8nXzbqy//8Gp5OksrhZ
	 2NNaLQ8x76S/me6N12UpmjEblJleTiy80rgqi6SVyFdqf/bXbmMbwsUY4gKUWESnOX
	 YzGUW8Al41/H8PJZORA7MhXxpBsEbnI31Swj9mzM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfJKH5J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 03:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbfJKH5J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 03:57:09 -0400
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BF3820679;
        Fri, 11 Oct 2019 07:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570780628;
        bh=ExPB2LcrboMFCzOhxLXtekTOETsdzGtWe31It1sxYHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T1W64LmGdrrKsHb5lcFrWm1EuOHiJhzQ6vuZZ9mmBBI1NJUOV0sEs2fPdkr4/iQZT
         jPeOEqrSRYtipmjPoW8ugXL3sqbe7ZJyhkJaSnB7qfsQ05KIEYh8nyu5JVQM1UhfE7
         paxcRWUwtYPnLYetmPpVXXyWWnixB+fKrCNzENjM=
Date:   Fri, 11 Oct 2019 09:57:05 +0200
From:   Maxime Ripard <mripard@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, wens@csie.org,
        will@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v3 02/11] crypto: Add Allwinner sun8i-ce Crypto Engine
Message-ID: <20191011075705.j5bqw2w6jmcrv5dz@gilmour>
References: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
 <20191010182328.15826-3-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hxdp6s4p3ktvf5rr"
Content-Disposition: inline
In-Reply-To: <20191010182328.15826-3-clabbe.montjoie@gmail.com>
User-Agent: NeoMutt/20180716
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--hxdp6s4p3ktvf5rr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 10, 2019 at 08:23:19PM +0200, Corentin Labbe wrote:
> +	ce->reset = devm_reset_control_get_optional(&pdev->dev, "bus");
> +	if (IS_ERR(ce->reset)) {
> +		if (PTR_ERR(ce->reset) == -EPROBE_DEFER)
> +			return PTR_ERR(ce->reset);
> +		dev_err(&pdev->dev, "No reset control found\n");
> +		return PTR_ERR(ce->reset);
> +	}

There's only one reset so you don't need that name.

And I'm not sure why you're using the optional variant, it's required
by your binding.

Maxime

--hxdp6s4p3ktvf5rr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCXaA10QAKCRDj7w1vZxhR
xdFDAP4z2YXaSscQlnjsH4zr2VB2gt6uDBKoFCnpm7jjmt5m8wD6A51EfrA7MNrg
+4UUrvYx5Q4Ij377kSHvZ927yk3uXAg=
=IagG
-----END PGP SIGNATURE-----

--hxdp6s4p3ktvf5rr--
