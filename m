Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9480425C804;
	Mon, 13 Jul 2026 05:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783921591; cv=none; b=qQeyyJE5t0NaqAIrh95RK3SZYUvKTDZ1a5WMsiDUly4DNiXjTSLQhjYkKupvAEBCNxVep7dydNjKB+2HdCZywzuG1Rd+6X947hQAeKMSqYspBUIEaAdWjPNcr1OIeShZYzXvGq6zQz+fzUWRsax+dfdX9HglVYB2sVJ0bvrQZzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783921591; c=relaxed/simple;
	bh=IH9+XhLTCg2d0PsasILExIUhxCLy1Xq4zpUtShtN4w0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEUtssrySdgIe9uE5oNbihDMxs5j2zxeGu31eU87sUBF94Mfq7O6KbshSwiXQ13NkQLafN5mrIsG8WcgtqC+C6CwEdR821iSzuGdNCtZemsd4o4sSLC/10fLpFnyhKekMdD/AL19TRezd7RTf0ZGibIjNm05QjEjZmbzJ6vRhwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVQ9EyNA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVQ9EyNA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 734D91F000E9;
	Mon, 13 Jul 2026 05:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783921590;
	bh=TslgJxPDu2FoohwrHHfEY80wcLwj5lAHu6Z5tKoMi4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iVQ9EyNAiglnejOK6JjxXr9UuEqXtokYOdkR+LNDbmo0LjyVuV0w4Bsu4Mlygf73u
	 CxCwSW3nlEKkeLcT8HAeucvqwgM7U17faBa0yqsHLIWYX/qRfHjA+x4Bw1dH/wRjL1
	 yZT5Bgtb6TY5D7rJ7A4z4HSQNl9okgTjCjIHRXuwvAaXn6A9v9SprjEhTNyPDq31tA
	 p93HP8ZutPwKtdS3yi336PUujTbOJDSlpPOqs19TtHFWbrnUPMPFEdrkZPU24vkqDs
	 YeklAdUCIbZUkzYi5e0dxxJjxVxBVsXa/HkAB1I+NH6G0UctPAfed6AWGtBXf0isRO
	 C1T+YVlW6uEjQ==
Date: Mon, 13 Jul 2026 07:46:26 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mark Gross <markgross@kernel.org>, Konstantin Ryabitsev <konstantin@linuxfoundation.org>, 
	linux-edac@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, 
	"David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v3] MAINTAINERS: Drop Mark Gross
Message-ID: <alR7WaRFM25AcvJh@monoceros>
References: <20260703173803.3589003-2-ukleinek@kernel.org>
 <alRfWpuiEiRC72u3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="j4bc4txee6jzbdzs"
Content-Disposition: inline
In-Reply-To: <alRfWpuiEiRC72u3@gondor.apana.org.au>


--j4bc4txee6jzbdzs
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v3] MAINTAINERS: Drop Mark Gross
MIME-Version: 1.0

Hello Herbert,

On Mon, Jul 13, 2026 at 01:45:30PM +1000, Herbert Xu wrote:
> Patch applied.  Thanks.

Note that Boris already took this patch. It's already in next for a
while as 97dfcb871ba776ba0e1ded1cdcbe94a357c2817e.

Best regards
Uwe

--j4bc4txee6jzbdzs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmpUe7AACgkQj4D7WH0S
/k4Luwf7BmhMfqLK1e7DXmVCka6JcVYawnOTTaSY9uV1MDjTklYTCLvgYnyBXmra
6ajrv9bd12XpwMKukx4cZ+raB50wDP2o8XQPsKIlRHco5xgi4MLkk9W/mRFtodZP
S66q474WR7z/8ar8rM9O+9KjcnbvqkW+/VM8xiFFkdPIzo1fI4fWmDMZVHVgeK0K
Rzj+4VjMwstHbnHoLcOH0Rk0rfATsTp5Ldv70gjFcJo7S+MyDvkV3BgfXEWdumOB
pSCOYwwtBko06zcydXT2VOrE/67kUIlG35+S9l/63fpjnBYM7Y3KtnFJYNKrxTKr
PH25Ki09UWrC3sEALqfpxBMoSZWq/w==
=XP2N
-----END PGP SIGNATURE-----

--j4bc4txee6jzbdzs--
