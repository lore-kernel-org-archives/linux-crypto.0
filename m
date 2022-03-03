Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6534FC433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 12:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiCCMgK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Mar 2022 07:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiCCMgJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Mar 2022 07:36:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01E317AED8
        for <linux-crypto@vger.kernel.org>; Thu,  3 Mar 2022 04:35:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 882B46195D
        for <linux-crypto@vger.kernel.org>; Thu,  3 Mar 2022 12:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33949C004E1;
        Thu,  3 Mar 2022 12:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646310922;
        bh=MwDLPcO1Ocp7QjMOHMDw33bbS0SqixUvjnBHcbbCEUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cWBLz87Z0hSBQK18GhI/3lgmhYAK8lelFaAt3OwtAFPH/MG4yKa6WdhsHAn8p6pd+
         GIj+nq9XyIBz5nCkp+So1N3cN4fdVN3U/QTfSuCwP81oOYCKrkjNZolXMOaOcUBfmg
         pUR0GIAnMSq7ocMAo6qyn9ImBrnJaXr8FlZxJcvzzFGkNDVf0rcxcL/ZGSGVcZMBHp
         8R6Pn7wIGrtxDUCnISU8jXsD5el9UsacfMyr/4EVsAsgDeyuX9dc0pGXjZ3CsE/HBx
         47NCxfTIIfP6PKuHyMpF7QThVIgZldHJMGZbdzdhKCW7/FlC64p5yKj1dmHWgbtyia
         43Vm8PY/hRoHg==
Date:   Thu, 3 Mar 2022 12:35:17 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: crypto: Don't allow v8.2 extensions to be used
 with BROKEN_GAS_INST
Message-ID: <YiC2Be4/vo9y51Z8@sirena.org.uk>
References: <20220302165438.1140256-1-broonie@kernel.org>
 <CAMj1kXHhTNsB8V=4LNMqSXrAWXroHHNXzjS0xWERboG7a3G-Lg@mail.gmail.com>
 <87y21r1e2b.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wZ3mfu1XPtsV0i4b"
Content-Disposition: inline
In-Reply-To: <87y21r1e2b.wl-maz@kernel.org>
X-Cookie: Password:
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--wZ3mfu1XPtsV0i4b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 03, 2022 at 11:16:28AM +0000, Marc Zyngier wrote:

> Indeed. The only case where the broken GAS .inst has hit us was in
> combination with alternatives (see eb7c11ee3c5c for details). The
> encoding itself is always correct, and it is only the label generation
> that was broken. If we were affected by this, the kernel would simply
> fail to build with these toolchains.

> If this ever happens (because we'd add some extra alternative
> sequences to the crypto code?), we can revisit this. But in the
> meantime, I don't see anything warranting this extra dependency.

Ah, in that case the SVE code should be fine too and there's no issue
with either.  I'd understood the issue to be with the actual instruction
encoding.

--wZ3mfu1XPtsV0i4b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIgtgUACgkQJNaLcl1U
h9ClFQf+JOwIfwI3NV/+kxTUaYpHaafyj0zMiec+gqHkcG3v0aqCKUMJ/P9ky/rw
ZAUncu2aekMm4bCrGKhJPxtAvLSOZdcAu2tFwBARFz4hbXWksezYxePv5rpnrcy8
t6O+tc1oGQmaoqjas1XbMSkxkg8WxNVkeIMQDShwhtnamxa2Sxj7LtFRK+W73WQC
kf9OIK9UzqbC4dpG1tgXLJaYQH0RBwPBlghA8dSNwXqeNK8JgL9UvjwQuEpqC45H
func/j2M4J3s2mCIzzqDQerDRf3JqYQFeJLEQbepuFHGvHLWp6/Eu9eCP6tLrxer
eHhl7MTDtSFvhC185naNBHGeG+43PA==
=rBcZ
-----END PGP SIGNATURE-----

--wZ3mfu1XPtsV0i4b--
