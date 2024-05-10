Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79DF149C78
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 08:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715330512; cv=none; b=BbEImsVQ+C+mEYq1ySAUZlD36ANHM6mfIJUgDPa01Hg9xRiY6iIzzt5ZKxV6t51DC1jEKiRskMxe0KL1R4jqwBAmUDSqT4f3weoNUKltirWkElT153ZZfBIMjyUheJ3xw1TJ0dJ+Lrw3BvJM6OvslKhfrj+YIbd+xov+mzh5E2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715330512; c=relaxed/simple;
	bh=oentOgrI2THJQuz2c9joNwVrMfGxLzCxYS+pUJkIYso=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=OlhsC6IcB3wbfn2loq8c4KTwCMDiWtg7ySlMT3CRe1qMfP2q4n7Y1cCUHZCb01rXIUN/oUh+boqIwDMdufdyUQwZE3WdV854qitFOCWg1wKCnAznt/CbHj0ErXDIxrihVnuzM1ZKVacuqE0i2KHavCPqKBt4qLI37r0BpUuUNpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JtphqfaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JtphqfaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F7C113CC;
	Fri, 10 May 2024 08:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715330512;
	bh=oentOgrI2THJQuz2c9joNwVrMfGxLzCxYS+pUJkIYso=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=JtphqfaT0y4UgLNq9iVRB+Xcqo7Wxu4xbMusmylhG5bTb5k3jwd/fSkVEEvX+1wIw
	 3uZBSDqLNoDd1FrmGdidpDrljbyv6K3Zk+XtloDkwLJ9Ri0XqGOJ/fkPvCuNZZXFde
	 6guh8uVYnRz240v0DLvH8a/LZ5NOIPwetbq8cBw8L8Y+an40MqORekXJhhESdyNilF
	 V7SnHDDto7hjV0cWZR4yTZz2KkGNC61ZOUL+siDF8lQd9dAyaOP/w3Fo+LX/JhGHXb
	 wKnjH0sQIyflJTOrtbrGYf75uU4SMPLtdbqCIE77PPfR04gwzD34kC+WQoNfiwmEsn
	 yCmvnQnmIrfoA==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 May 2024 11:41:49 +0300
Message-Id: <D15TX19UXQSW.34JYJLN21P1RH@kernel.org>
Subject: Re: [PATCH v3 1/2] certs: Move RSA self-test data to separate file
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>, "Joachim Vandersmissen"
 <git@jvdsn.com>
Cc: <linux-crypto@vger.kernel.org>, "David Howells" <dhowells@redhat.com>,
 "Simo Sorce" <simo@redhat.com>, "Stephan Mueller" <smueller@chronox.de>
X-Mailer: aerc 0.17.0
References: <20240503043857.45515-1-git@jvdsn.com>
 <Zj3XtsHcwRAv_EvT@gondor.apana.org.au>
In-Reply-To: <Zj3XtsHcwRAv_EvT@gondor.apana.org.au>

On Fri May 10, 2024 at 11:15 AM EEST, Herbert Xu wrote:
> On Thu, May 02, 2024 at 11:38:56PM -0500, Joachim Vandersmissen wrote:
> >
> > diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kc=
onfig
> > index 59ec726b7c77..68434c745b3c 100644
> > --- a/crypto/asymmetric_keys/Kconfig
> > +++ b/crypto/asymmetric_keys/Kconfig
> > @@ -86,4 +86,14 @@ config FIPS_SIGNATURE_SELFTEST
> >  	depends on PKCS7_MESSAGE_PARSER=3DX509_CERTIFICATE_PARSER
> >  	depends on X509_CERTIFICATE_PARSER
> > =20
> > +config FIPS_SIGNATURE_SELFTEST_RSA
> > +	bool "Include RSA selftests"
>
> Please don't ask questinons in Kconfig that we can avoid.  In
> this case I see no valid reason for having this extra knob.
>
> One question for FIPS_SIGNATURE_SELFTEST is enough.
>
> Oh and please cc Jarkko Sakkinen <jarkko@kernel.org> since he
> picked up two earlier fixes for this and it's best if this went
> through his tree.
>
> Thanks,

Fine with me. I've yet to send asymmetric keys pull request (last
remaining) so there is some window left too.

BR, Jarkko
