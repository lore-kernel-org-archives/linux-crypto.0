Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD727C4363A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 20:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 765B62100A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 20:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601928062;
	bh=oj+jcDmEQ2N35sIvH7wXOvwFFCWD41A5g42JGA78/P8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MNIyPlQr1KpG3l0piSHwXWlEHP2MHsXczPHAdvcKY0htvKObPQAPjnQpCAvLbQXE5
	 npEOKsnr9jmgXZ7OvvDM6uSdmLHjZj1Vj5D4vdvDfgyjEkBWJH0T+fj4K5hhY9kM6K
	 UuCIjUGizywnaGGk0gTjBnpUoiZgeRh+Henx/pFE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729465AbgJEUBB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 16:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729424AbgJEUBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 16:01:01 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F56220848;
        Mon,  5 Oct 2020 20:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601928060;
        bh=oj+jcDmEQ2N35sIvH7wXOvwFFCWD41A5g42JGA78/P8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CcgNuec45OLWgjUhYQ+1cd8ZuxyY2vEj9LeaoxPnVEUg85Xun9DtWP0WFPN2yQbZi
         zrLdvD0cGsTAjKUU1uZHyEwBDnvSZUfSk+X1uFcACU+2rbMjyDCwBu3e8B8EsSzfUS
         WRHnZ1g890h0ck7szssNEK47AJdYiqblKUIaK1m8=
Date:   Mon, 5 Oct 2020 20:59:57 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        ardb@kernel.org, will@kernel.org, catalin.marinas@arm.com,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG][PATCH] arm64: bti: fix BTI to handle local indirect
 branches
Message-ID: <20201005195957.GF5139@sirena.org.uk>
References: <20201005181804.1331237-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ExXT7PjY8AI4Hyfa"
Content-Disposition: inline
In-Reply-To: <20201005181804.1331237-1-jeremy.linton@arm.com>
X-Cookie: Most of your faults are not your fault.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--ExXT7PjY8AI4Hyfa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 05, 2020 at 01:18:04PM -0500, Jeremy Linton wrote:

> The AES code uses a 'br x7' as part of a function called by
> a macro, that ends up needing a BTI_J as a target. Lets
> define SYN_CODE_START_LOCAL() for this and replace the
> SYM_FUNC_START_LOCAL with a SYM_FUNC_CODE_LOCAL in the AES block.

Really what the subject here should say is that this code is not a
standard function and therefore should not be annotated as such - it's
wrong with or without BTI, BTI just makes it very apparent.  It'd also
be better to split the change in linkage.h out into a separate patch,
that'd make things clearer for review.

>   CPU: 1 PID: 265 Comm: cryptomgr_test Not tainted 5.8.11-300.fc33.aarch6=
4 #1
>   pstate: 20400c05 (nzCv daif +PAN -UAO BTYPE=3Dj-)
>   pc : aesbs_encrypt8+0x0/0x5f0 [aes_neon_bs]
>   lr : aesbs_xts_encrypt+0x48/0xe0 [aes_neon_bs]
>   sp : ffff80001052b730
>   x29: ffff80001052b730 x28: 0000000000000001
>   x27: ffff0001ec8f4000 x26: ffff0001ec5d27b0

Please think hard before including complete backtraces in upstream
reports, they are very large and contain almost no useful information
relative to their size so often obscure the relevant content in your
message. If part of the backtrace is usefully illustrative (it often is
for search engines if nothing else) then it's usually better to pull out
the relevant sections.

> -SYM_FUNC_START_LOCAL(aesbs_encrypt8)
> +SYM_CODE_START_LOCAL(aesbs_encrypt8)
>  	ldr		q9, [bskey], #16		// round 0 key
>  	ldr		q8, M0SR
>  	ldr		q24, SR
> @@ -488,10 +488,10 @@ SYM_FUNC_START_LOCAL(aesbs_encrypt8)
>  	eor		v2.16b, v2.16b, v12.16b
>  	eor		v5.16b, v5.16b, v12.16b
>  	ret
> -SYM_FUNC_END(aesbs_encrypt8)
> +SYM_END(aesbs_encrypt8)

This should be SYM_CODE_END() to match the opening.  However...

>   * When using in-kernel BTI we need to ensure that PCS-conformant assemb=
ly
> @@ -42,6 +43,9 @@
>  	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
>  	BTI_C
> =20
> +#define SYM_CODE_START_LOCAL(name)			\
> +	SYM_START(name, SYM_L_LOCAL, SYM_A_ALIGN)       \
> +	BTI_JC

=2E..this is going to cause problems, SYM_CODE means that we should
assemble *exactly* what was written since it's some non-standard thing -
we use it for the vectors table for example.  Looking at the code it's
not 100% clear that the best approach here isn't just to change the call
to a regular function call, this isn't a fast path or anything as far as
I can see so it's unclear to me why we need to tail call.

Failing that I think we need an annotation for tail called functions,=20
that'd need to be a new thing as I am not seeing anything appropriate in
the current generic annotations.

--ExXT7PjY8AI4Hyfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl97ezwACgkQJNaLcl1U
h9Bs2Af+JXsXs6kh94WyAh0jlOgct0f+Ay3VvJxgWnky8BRJrKtYjhANEJr+rrkA
FvVjaN2Flbf9Qxhq7vEywIqOzaogW+VdUxokEo0/nHMWEr/Y/+8ZNUQmxn3b/y3y
cZtU6Qhd+sRWFz57DrgOH1M9FGCkpBpEz8ooFOBoUwk/0qqNqO7QHmvLNAiZRhpu
sYMb19Jq5ZEk0u2fAc/JkYQFSFsSoDVnku3hPuVehwijjpgaTzTxZnHMBYCJp9tq
0GAjy2kfIuktwjwCrVcTD71O8Fa1pvSkSc6A4tz4lc4cZIl1fbuuFoW+frR3wcnV
he8dRYfW+kSEWmRc5BuWhvNUyW4JoQ==
=qGOi
-----END PGP SIGNATURE-----

--ExXT7PjY8AI4Hyfa--
