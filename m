Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8A61E880;
	Mon, 27 May 2024 22:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716850767; cv=none; b=pWKfqJB/RT2Yeib8wUb7/MqzLFPLEsiFkTWEd5qquHYRKVVv8Hfsi+MjexZn1HDLDbIj1uLCPsG1XE8MY9i4emItmgRLUDqsHJLAyiakqrrLdKcXUUm5ZMYXaaKmGiiOOgOsrgMluiR/HqbB5frVYXbUl2IhW5H48l9kwl7I36w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716850767; c=relaxed/simple;
	bh=VKCgZlWSHFibD4oSASuBd0h+q3F3oLe5CbcNtavGaIE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=k+4+Cs/hqLAAxhcBVCEiDZHq2HKj9NKq8Gxoi2QMVLJcc807f6T80wIEYgeNn2nrxdgO7r91EOEFKfjopdV2AukVylV0klC0ib1QydZEFGmF9f194l2hivwSK7GKYpscN0EEXgKsHPhVYdQjnpkom4alI/LZ4cmDqAx76rcQICU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tEWdmpAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tEWdmpAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A792C2BBFC;
	Mon, 27 May 2024 22:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716850766;
	bh=VKCgZlWSHFibD4oSASuBd0h+q3F3oLe5CbcNtavGaIE=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=tEWdmpAOnHMRsfcTZWnwmQSqLUOl+odU30epMpZP9ayt36mnpySkQJjkHnw1uY+hJ
	 yhQnfhsJp7Th9k5hHHfFxeHnbWED6Rpe7v8dAsqlhvTMdIsVZmvC8XHa2pnFThgJ/Q
	 lar2owTF/wlSJ9h4+fl7YO/dxOxjMKjM6YQRfJAvWzgmGdHylHW22XOvZICkQ4UO9C
	 KPINJJmYi78WePaUfqmPnJbV/BN0NbKaAfKBvM3u4sbx6dLiKw/rYSuedG0nAOoa8T
	 n1CKxFH7LdTmoWCYEjsxtCbr4Waof88mmIvjCAtHj04qT6vKr76bZmvxZ+TGVfA4YU
	 Ppia4Eh5+E7sA==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 May 2024 01:59:23 +0300
Message-Id: <D1KSSWD7FA94.5705Z3J7LKZA@kernel.org>
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
 <D1KSLKGUWGFO.21T4OBXQQ88D@kernel.org>
In-Reply-To: <D1KSLKGUWGFO.21T4OBXQQ88D@kernel.org>

On Tue May 28, 2024 at 1:49 AM EEST, Jarkko Sakkinen wrote:
> On Tue May 28, 2024 at 1:31 AM EEST, Jarkko Sakkinen wrote:
> > >         ret =3D crypto_akcipher_set_pub_key(tfm, data, 3 * x_size + 1=
);
>
> Noticed this mistake i.e. fixed it with "2 * x_size + 1"
>
> This is results earlier failure:
>
> ecdsa: (tpm2_key_ecdsa_query+0x10d/0x170 <- ecdsa_set_pub_key) arg1=3D0xf=
fffffea
>
> Totally lost with the expected input format after trying out various=20
> options.

OK got it working with:

        ptr =3D &data[0];
        *ptr++ =3D 0x04; /* uncompressed */
        memcpy(&ptr[0], &x[2], x_size);
        memcpy(&ptr[x_size], &x[2 + x_size + 2], x_size);
        ret =3D crypto_akcipher_set_pub_key(tfm, data, 2 * x_size + 1);
        crypto_free_akcipher(tfm);

Had still a few "off-bys".

Makes me wonder why this is not in ASN.1.
E.g. TPM2 stuff and for instance RSA code takes ASN.1.

This all and the required prefix byte really should be explained in
the documentation of this function. I.e. follows the RFC in the sense
that number is big-endian and has the prefix byte, but it does not
follow it in the sense that x and y are not in input octect strings.

Why is that? Does not feel right intuitively.

BR, Jarkko
