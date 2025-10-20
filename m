Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3DC26B2CE
	for <linux-crypto@vger.kernel.org>; Mon, 20 Oct 2025 03:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760931248; cv=none; b=m7fjmMc2+/86DWFVefI0xIyZazyU/1iLz+K5LtF232Wl0YqoPcLbR+FgSwfuD5+fJHRxaq7U8cHRzx+AA7fiHJCPE4tqHqD84bT3m7IR2s58PbvfBxlC/P3Iyj2reJZunoeV0rsmnEPQ75kPBPqz/OO4HT2SX1frql9ttZtrPY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760931248; c=relaxed/simple;
	bh=ubONa7ropRcOUm568w5bPPTu9W0xpzaxAOWU/R0wKy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cM3/tn8IPlvD52BuW2rNFialnzPYz/nblAAvMJeDa3tOJWSL1cMVlPOb7e8PnFR9keT6lEZJBDu+RuMw6rnKoSikzvkEq14s98HaNoXwWwiTcooxU4bSnAA+v/Ngq0VxAi6VEXG2TVqYLrEyfSCwY2lHme4NDKy7Uv2W0n/R4fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLLlUaZ/; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLLlUaZ/"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7810289cd4bso3749459b3a.2
        for <linux-crypto@vger.kernel.org>; Sun, 19 Oct 2025 20:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760931245; x=1761536045; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e9KCGk0JC3CTk5iIZQYbC1DgG/1ZW9eR1AJEbPiuOW0=;
        b=XLLlUaZ/gc5cPikZoKIpw+1TRZ9tNhl7I7xfmjpB4ygJmBH8vz1TczHOaqGKmeBb3E
         /Du6uwAOnuG8jW9x5NpzkHqWU7MDMx68Y6W30GWI3UgVZbRFTM2ve29tWHuIsnuRrhsI
         uq1W/GQAv6v5X3w+JEn6H67gNrYiH+G/JzcDx/GpPDQuyU5CCFw09wpphVNDA4ao02RU
         Fmt/gWQzgdnbanrMasK2RxPl9Xi2CHhuHFWh5KMtnPrJWNixBfIt1EdLIFU0SmAiu86v
         NhZMEKt80MoZIXatn2nz8FF1KO1hRGfuEWWzJ505rCY/x1DJtIv6XyqnXW9p8/H5OdUT
         erag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760931245; x=1761536045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e9KCGk0JC3CTk5iIZQYbC1DgG/1ZW9eR1AJEbPiuOW0=;
        b=WkkYYstjeKLP8qeMY3GLpi+h/yDUapoABSTfjQiDHUX2P/V0azR39VdYHfjlj43eRf
         dptTWXHDP6DDf9EXi75FqglhUWKfqSMRaqDtQpspICwsS7oQeO8Ck08u3ozSWxXqUTAS
         L0CscgSP1FD7fXRxfsdXVQBbayY3hfOUfoJWRRrCu6FP/dLNjV+9wRkweufpL77klbx5
         p40SsMdRHYKxeho/nVLdbTaueXfbH6QRRFmFcDGydi7iLE/fljuXLlZbvcjSxrtz8I68
         ePKVFxaCMDCNcbmYjxLaExMjPclKBrLytti3aXu9tGX68pYuk+MrfhaLp2fNff7F/v7X
         MtTg==
X-Forwarded-Encrypted: i=1; AJvYcCWI7G3C/n4IOohxj702LM8a6OXnypbRyBwn8iidowx/geisqqDO386lYQbRT6+adgUH4qNjqPTP0uES/No=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy5Ost7kxiGTLe3uM0R9Xd2Dcy0bSTBAvO3PxL+TUq2Wl9ucxT
	BzffGYaSazIm+bG1H7DbJz6FHK6y+boqoU2RsqL+MOXCi0l6NUKW61vY
X-Gm-Gg: ASbGncuaxHYOASNfUNwS829O8hzZLkkx9kVHSWvFh4M8umYVH0xao07S9w9JOqdfc9z
	2+RaSB4wtd0X1bA2NVUeq1Ww1u+hdOWwWY+X6gOuZxY70cx6DA8eWBp/l7JOWRtKGMbC2cFotzH
	eUU4IKsH+yKttEale5L2+95n0PNhFrfwKKVKaeT8DVGfw6WteDMpUhzKVnr0tnq5Ao7IiueJOdT
	kbYd8Ad2MV9HvR7mwv602QEjjoF21P3F7yHRseBTEzo4RbzF2DNPFZwoamOBI7Da5woXvZZivrM
	l7Wfv29gbeIdKsAtvFbDEHTXs8MtlnEeLZj2KRFOOxXEdwARcAwQn7tsOHt2bYJo4lyZUi6zsAX
	M4DvGZb5fUGfGmCrqXJWz4FrBgt7NvdJKCeO/iJtZLof/AK8IzDw1t4ltMfI5nPsHb7KfwxGNbp
	X8HqQLRHz1vnIPeQ==
X-Google-Smtp-Source: AGHT+IE3Iwg4NUHF6OYx4wb4cVhQ7Cs6qD/ZwCO1Ze/O5Ksvhac9AtWKMOgaiXSa0ybeYFo8/3pCWg==
X-Received: by 2002:a05:6a21:328c:b0:334:8239:56dc with SMTP id adf61e73a8af0-334a8650107mr15007720637.56.1760931244502;
        Sun, 19 Oct 2025 20:34:04 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b59d0csm6330782a12.30.2025.10.19.20.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 20:34:03 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 7AAE641E481B; Mon, 20 Oct 2025 10:34:01 +0700 (WIB)
Date: Mon, 20 Oct 2025 10:34:01 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Meenakshi Aggarwal <meenakshi.aggarwal@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Linux Crypto List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the crypto tree
Message-ID: <aPWtqT17TiqKTibG@archie.me>
References: <20251020135339.5df5ec50@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8rjPh9wMhciqOQRv"
Content-Disposition: inline
In-Reply-To: <20251020135339.5df5ec50@canb.auug.org.au>


--8rjPh9wMhciqOQRv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 01:53:39PM +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the crypto tree, today's linux-next build (htmldocs)
> produced this warning:
>=20
> Documentation/security/keys/trusted-encrypted.rst:18: ERROR: Unexpected i=
ndentation. [docutils]
> Documentation/security/keys/trusted-encrypted.rst:19: WARNING: Block quot=
e ends without a blank line; unexpected unindent. [docutils]
>=20
> Introduced by commit
>=20
>   95c46f40aac4 ("docs: trusted-encrypted: trusted-keys as protected keys")

Fixed by [1].

Thanks.

[1]: https://lore.kernel.org/linux-doc/20251017181135.354411-1-krishnagopi4=
87@gmail.com/

--=20
An old man doll... just what I always wanted! - Clara

--8rjPh9wMhciqOQRv
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaPWtnwAKCRD2uYlJVVFO
o6V8AP9EERIgzNXWepKUt/dJ+FI1xiL7XrKtxTO+dHX/XlNmhwEA8F+VLcrlw4CM
RD8IRaGDSenpZ7Pw8YJ1mpqsnKVGDAQ=
=4Xco
-----END PGP SIGNATURE-----

--8rjPh9wMhciqOQRv--
