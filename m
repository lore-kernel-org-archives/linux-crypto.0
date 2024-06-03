Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E6112D750;
	Mon,  3 Jun 2024 13:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717421391; cv=none; b=jjhZE2/2JstNhpfxvmti/N6gsVypj+vr7lo3MVsQ2Sn0sicqU/3lqd1UskMC2PT7GzKmwcdHSNs8p22Enf9c3k18qCx3HfO/Rk1+SRADjVWg7wc3ebHCNMNPPI+VvUNH5UFNWMKcSrBr73Cokcporwkc87IdEwkCbWcpb6KO+ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717421391; c=relaxed/simple;
	bh=roo9/J6B3hBxzpAXiJJMIVSoyJBVfDtkBQBzgk7WKws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b664gpOK1r5YYhIKDIAHvrgq0wkX18FJUcQdBs8BrCGlJ7aaa+f1s+xHIw1PmtQtzvxCl+CKa2Ackqz5SOdNwSjwTY8R0DmvkV2Hm1XNPfJlK4iNkT/gEEQYi8jB23EJXvIHoef6eQ/v4VTyKaJn6UGtsuaIobj4jMjnPpGi0GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdIbyzqu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdIbyzqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC38C4AF08;
	Mon,  3 Jun 2024 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717421390;
	bh=roo9/J6B3hBxzpAXiJJMIVSoyJBVfDtkBQBzgk7WKws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KdIbyzquGuYIOJTn2zm82v8ERoyjRyE3cv6vmGXhvtE5TY+RzmLImP8sbU0SyxRjz
	 f7a9nmde/2rPrC7FYPCpjVwEQpndWFJQTAtKaUJKggXd6rWXXEqIT/rypDQpwul1Gx
	 iiwhkmo8/8S9ofBAHMeL2gKqIsQ1N+7gJdSLRJIT/tqja6AxdcEKzv8cnhN0BHH4Ki
	 tLF6+s9j8+woUrPnqr94Gt2mBox7nqf29zw08ElLtrA1Kijw7hE7CXMaGxp2IZvhWE
	 MKHZBavEkO7YmzMkG7Ni8RTXg53aXdy0pVe6PVohdPbKiDM9DPOwYlwk9HgXdkzIHw
	 5ombMTF81Mnjw==
Date: Mon, 3 Jun 2024 14:29:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64/crypto: Raise priority of NEON crct10dif
 implementation
Message-ID: <feb7b143-f2b9-4630-84d8-46eb66b355d5@sirena.org.uk>
References: <20240521-arm64-crct10dif-neon-prio-v1-1-e2975754b8f3@kernel.org>
 <e103fabb-6854-4ce1-b4f9-6f6b7f912895@sirena.org.uk>
 <20240603131507.GD18991@willie-the-truck>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AJXxKeV0pU/5Cp6l"
Content-Disposition: inline
In-Reply-To: <20240603131507.GD18991@willie-the-truck>
X-Cookie: Don't let your status become too quo!


--AJXxKeV0pU/5Cp6l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2024 at 02:15:08PM +0100, Will Deacon wrote:
> On Wed, May 22, 2024 at 12:17:41PM +0100, Mark Brown wrote:
> > On Tue, May 21, 2024 at 09:22:49PM +0100, Mark Brown wrote:
> > > The NEON implementation of crctd10dif is registered with a priority of 100
> > > which is identical to that used by the generic C implementation. Raise the
> > > priority to 150, half way between the PMULL based implementation and the
> > > NEON one, so that it will be preferred over the generic implementation.

> > That second NEON should be PMULL, sorry.

> Sorry, I don't grok that now:

>   | half way between the PMULL based implementation and the PMULL one

> doesn't mean anything?

Yes, one of those PMULLs should say generic (I thought I'd sent a
followup saying that, sorry).

--AJXxKeV0pU/5Cp6l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZdxUkACgkQJNaLcl1U
h9CuNwf+IP0pEWsVg5+92cxDZrTFQZI4P4hAciSGbsT8IfSF6A9U/+iAPzSjJT2q
mWHb2woghIIk/ggMTktn+bbUQ438lr3iRT3Dvr2BkrfLpKchurDewN+sSDUQM2Hm
a67qgaDGo39qbNO3AT6nhwYA3EoJ75aCypS8/QUpVOiqSx9DMMOlVMVJyg9giv3R
+FaKte4sYcf0ubZFn6MekH96QSFaZeeFQK2NXIml4MoqvJqv8puK30ZUozQ5Wa5s
nQRFxDiEfvay4N86/xl7zfZVwKi5pwV+zSv7cueSiftLcLePP92HzqDU1dL1Uvql
j+zZfZHUEfjTIPNGokmt0sECEOG1Gg==
=AF6e
-----END PGP SIGNATURE-----

--AJXxKeV0pU/5Cp6l--
