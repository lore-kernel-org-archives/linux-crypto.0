Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D332C47424F;
	Fri, 25 Sep 2026 08:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790325406; cv=none; b=JWk4K1E7670fA1ZkogKzabHbuwvTIiXlXrkyK2/muzahPbrdiefFADeh2j/D9931ZwJHI1A8GdoSJYycrOPB2W1wfQE0MDuTPhASRjwJCYQm4SVuBV/ToTUFsaayXbYLpLwOEAYO8A/R2uM8IyeFJ/1p4NpDgVf77MyyYObJSXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790325406; c=relaxed/simple;
	bh=GCuHOtJxm2b81KOhBCW3cvDuSryx1XyY6JNkak6BgMU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=nOtaUrCeVnwXr2z8shx9k5fH2gPqCibcS+ICBgzrwPgGWXQff3v0PaxkO5AlJDLuNOZVEeiCZzOPMkMwY9rhNbw4s69h3uwcD0BJgBy5fuFgliak4gxfadrFAyuo3CJaUkH6WDDIkLCJy4LQko37CMWkElWdfw5Ra+4cw+cIXaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GT++3n+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GT++3n+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE521F000FF;
	Fri, 25 Sep 2026 08:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790325398;
	bh=114QUcBjjdn/IrfmK2pagwdgwGYp8phHItNsHUG/lW0=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=GT++3n+mowteJa7krPBjbDK0jxXHVqMBd8SO4Guelgt6HTK/pety6CYEhb9xs57KJ
	 5JOfymKiJQoldqc1xKYubaeI7dktqIpw2MNDuapU5zKX5mZtfIxhoanAhSqaVCRUsu
	 IQW87I56vBp15J++VoCrRvgU/GTa69bpOyc1ZryKQvsqb5GfMG8eewQoZhDITwFPcx
	 DF9RPjvPblhcE2ZwOZ5aAnm3yluyuKwSnMz06osYQkTIIdxKrCRiXpgsbCDD/xRJeV
	 O6G9PykyAgOrJ0PHiwxwvHprjWvsW9paT84ILI9LDgnBGjbMd9HePKjT88PtAaShWV
	 DCJMbVmf++g6Q==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5D5841980058;
	Fri, 25 Sep 2026 04:36:36 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 25 Sep 2026 04:36:36 -0400
X-ME-Sender: <xms:kjK2alLn0W67eVNMXqVzfC49pNkreK-6drIThm-wQ5pgtxGNNHaHUw>
    <xme:kjK2ar_9WfxoRsTpdjKtODuzf0PhdTCsWpbUTyoQzUQlVftKXFgSGa8RihuFHGeKo
    BnqX4t-_J4Mgd7eAqAAgZQ8YVIFTpMcWjKoOhz-gmBDIBXrVZApFmXu>
X-ME-Proxy-Cause: dmFkZTE19TdlFNXcVstMCPHlxqFbrrYCTMKU7W9t/zo/ImM33i9J0Nu1hqKT8WARXS4ZiL
    T1WF8VvaawVP116ZV0OM0JjvMVs4WIhHQEwqPmXFksN3sPauN3UbP+7W7zbbv8h4sn/67y
    6/mUe1oNDXe5RntjArkae2Ydpo7U57hgWFZ9zHfyCAGcVbJjNE5ukrpGQSZ2D078BdPeZv
    ispqGkfwPLnGcxOhXiQS8wOdCMjYLUnW8qVrUuCg0LEjc2E51FPdmikrPhs6waLXN8pyz+
    W6rIgau98G2q4fQOQ9UpY7ZkopTiDEmq6FC8HpR2hnPo1eFMwXlflvORftU69caH9og/Pb
    /6yTp9mRIK92E2eMRH8X3EdLJ2iK75UgXQNArOWonlE1DUbCTjiiR/dusDbB+AtN/y7ycs
    +Fexm/ThmaK8f5Qqnowha8KDXlsLQ6VU09HY/Nkk2aJ6xhwvQp5uoLr6g9k/aT2s+txD71
    Ea606KX3Cl68DaBOEq+pzq9Yq2Nziz/hprckeFCNCS8fD9DRlJ+8tWm4oZBMsQlrrMd++u
    HXflPGnGcsmKMDsb6tD0MO0DexNP0VLw5I+w5onRTzZFlbD0m9fJ5tv1x0qr3IZ7tMuzQH
    H7F9ZWkZZFMa3qRxvyUxcgU9VQ8baNndx0yVXOtdPiHzGEpVYuJ9F9gcKvhg
X-ME-Proxy: <xmx:lDK2aixz3L-G3mwnLj-VmkDmwt3LDanpo_ekNuEVPOxAy8kwoBw5cA>
    <xmx:lDK2aoXxM2c8uIDxm1ihsyVyHXUt7PX-QUHXt3ipGHxdWuNxM4MA6w>
    <xmx:lDK2akOvkQyupuptjP4sCsBFQaG5hD1LBhqiP2U1Z25veDLwq8DT1g>
    <xmx:lDK2aqDMqnfDd4dylSgCur0CcDH4RUzaJqObfOwfJSdCza9vgtSBZA>
    <xmx:lDK2aheenV4_rz8Db9L7nGDGOEAv79_5ckYOOz2sJmGB1HWeFHq-uSvf>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 814B3F80080; Fri, 25 Sep 2026 04:36:34 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 25 Sep 2026 10:36:14 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linux-doc@vger.kernel.org
Message-Id: <53592751-bcde-4dc0-9ea1-89d6ad39126e@app.fastmail.com>
In-Reply-To: <20260925053240.189395-1-ebiggers@kernel.org>
References: <20260925053240.189395-1-ebiggers@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Place libcrypto docs under CRYPTO LIBRARY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Fri, 25 Sep 2026, at 07:32, Eric Biggers wrote:
> Place Documentation/crypto/libcrypto* under the appropriate entry in
> MAINTAINERS.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is intended to be taken through libcrypto-next
>
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index c52ec2d7d3c1..12647d3b367a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6980,6 +6980,7 @@ L:	linux-crypto@vger.kernel.org
>  S:	Maintained
>  T:	git 
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git 
> libcrypto-next
>  T:	git 
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git 
> libcrypto-fixes
> +F:	Documentation/crypto/libcrypto*
>  F:	lib/crypto/
>  F:	scripts/crypto/
> 
>
> base-commit: 165768bb70265b5c38cf0b73fafd75be235f8b14
> -- 
> 2.55.0
