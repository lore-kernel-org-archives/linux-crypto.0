Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC511DFE4;
	Mon, 27 May 2024 22:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716850192; cv=none; b=pZY6e9CLAYf8PXmt4ae8ZXIK1KQ9siA5bWJKxs7h6QudXNm3TmN5510nzy1t6AxnVP/4LJZpC5n0wD8voOQqFfgRDLGpFvzFF4g4FrLLgI4f8lxnXNx2Vw64Cz4xn8uwbhYsZNqlxcgVPlFdjsISvzfbqqaOtsnWiCXggViZsyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716850192; c=relaxed/simple;
	bh=hertHfbcpJw8JoTdFV/lxLDsx0EAanE9Z0HvkoE8yJw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=QPVV6DGigUO2Fzzd3yrEade5tfjSTFH31wmiXDPL0Mr59GYDPAMLRSPT2qZTZ12TUeJ1adsrLKITRZHfY8WQANyvtVcYh+zpW9yPluLkAKE2Rox++6wx7a7ETBYNTxGdmPj+76xL7ID+zqzuA2riJG+51xjNXOfO/FoLNs8Yn58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJmRQ1T0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJmRQ1T0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73786C2BBFC;
	Mon, 27 May 2024 22:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716850191;
	bh=hertHfbcpJw8JoTdFV/lxLDsx0EAanE9Z0HvkoE8yJw=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=cJmRQ1T0Wp1HeszluEDk5/MA0HN4jAYUchfYZm1tHLFET7+gSF+6FvgaiJ0F9oQTN
	 yBJdqOFjP7JtJwTzdJ5nCxYsECvYkBsd9/9FrDyGmICSepdyCGzAb52oH/5vLbzzCW
	 ngrvePezcffJWiAnlcmDdqArVn85v0oXCgUlZoB8vGmo1nxECDfS1ecX1aQngZs+hf
	 pmZc14UChc/99EavDaoksV6mmNpFkJWs46F6eGVoDtiy/MzN8znKD4dRBCsBOaJo9v
	 8LFJRGWxRoHWezzXJ9a8p4r2Mal1goTEhEomjUIxx0wIixQR2YtPXvZQE1WQTq8Tp6
	 G9OxOSlS2UxVQ==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 May 2024 01:49:48 +0300
Message-Id: <D1KSLKGUWGFO.21T4OBXQQ88D@kernel.org>
Cc: <linux-crypto@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
 "Stefan Berger" <stefanb@linux.ibm.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: ecdsa: Fix the public key format description
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>
X-Mailer: aerc 0.17.0
References: <20240527202840.4818-1-jarkko@kernel.org>
 <D1KQDPOZRWCW.1763CCYF1B84X@kernel.org>
 <D1KRILI1KRQ8.2CNPU7PFES0VI@kernel.org>
 <D1KRXI87G4S0.1ROKTQENIZHT7@kernel.org>
 <D1KS7LCALKD4.1J13QGYGZ6LBW@kernel.org>
In-Reply-To: <D1KS7LCALKD4.1J13QGYGZ6LBW@kernel.org>

On Tue May 28, 2024 at 1:31 AM EEST, Jarkko Sakkinen wrote:
> >         ret =3D crypto_akcipher_set_pub_key(tfm, data, 3 * x_size + 1);

Noticed this mistake i.e. fixed it with "2 * x_size + 1"

This is results earlier failure:

ecdsa: (tpm2_key_ecdsa_query+0x10d/0x170 <- ecdsa_set_pub_key) arg1=3D0xfff=
fffea

Totally lost with the expected input format after trying out various=20
options.

BR, Jarkko

