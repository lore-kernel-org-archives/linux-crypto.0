Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B16757EA
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 05:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784094659; cv=none; b=TCYSzLt8jEMF4FynRUF8jCImhOJeBSnHdnRVqyRpbx0UGSmq8jjgy/TyoJNM2525Pp1DPqk05m7ZNOTxD4wHWKedo63tpHyZAXKFmddLfzDnZc3tc3XXjfu4l+N0Z0DtFuEooka/1VVgorMvyesgsuBO6fz8RUK/LK98VE+8UV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784094659; c=relaxed/simple;
	bh=y9zJCJqthSz9htFq842Li44TgFEhHGKT4sXvU54bFkY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Q8UNVFqxHsfrkUPppR0ypi4AzxIspTaSAS6QTDN4Gv531T3H2QvwNgHrII95ZJ6bhHScgKhgi5PAu1Vgf40ZkJR3j4GhTDPBckLzw93Cj1uL1PAsGjha2a2sz1zqbt4QnzTAfFU4UNdnyJYPg+p5zeI+dly0Y9btTDrOzGV13fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=KEBSk6Ac; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="KEBSk6Ac"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id DDC67C2B9C3
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 05:51:09 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id DCD556035C;
	Wed, 15 Jul 2026 05:50:52 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5C91E11BD3B92;
	Wed, 15 Jul 2026 07:50:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784094652; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=tN8ocsSAAVFw4bDIjsH1zW9UU6Mh3tQaTN0uIUZ4+Ho=;
	b=KEBSk6Aci7s4ISaqwVShupaQbNqHEwsw83rairV8nJFFhEYUjvKX/5hX5hmcUTwGIVn/cV
	Y6Eaw+AY80oJW2bs3I8SMxcVGhBKyeyueYMBTzVgNtEY18jCm4mdSsoU9XbKeM1cybtJHO
	s7eF9r8gjrki6//DpyqYlK4CC6eF+HU2cE7409zyt6RPC+RFdydk7tNMra8BujsBA4vkgN
	ITG+fuS7ccCTxhRohG/TBX2kpdvSc2g6Co9mtBAbPNp9xF6JezID5dPiLSXo5s7uneS2nk
	1rBP8C517FrDTY/vBYlI2XeZ/7lZvo8QTtj8edWS2YgI/iigv5jJ1g6HXvD4EA==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Jul 2026 07:50:47 +0200
Message-Id: <DJYWRQ3SZ407.7CA8QWJ5UVRM@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Herve Codina" <herve.codina@bootlin.com>,
 "Christophe Leroy" <chleroy@kernel.org>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/19] crypto: talitos/hash - Use
 CRYPTO_AHASH_BLOCK_ONLY API
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>, "Paul Louvel"
 <paul.louvel@bootlin.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260611-7-1-rc1_talitos_cleanup-v2-0-aa4a813ce69b@bootlin.com>
 <20260611-7-1-rc1_talitos_cleanup-v2-1-aa4a813ce69b@bootlin.com>
 <akdiMro0yKwwicaa@gondor.apana.org.au>
In-Reply-To: <akdiMro0yKwwicaa@gondor.apana.org.au>
X-Last-TLS-Session-Version: TLSv1.3

On Fri Jul 3, 2026 at 9:18 AM CEST, Herbert Xu wrote:
> On Thu, Jun 11, 2026 at 09:35:55AM +0200, Paul Louvel wrote:
>>
>> @@ -2932,8 +2861,11 @@ static struct talitos_alg_template driver_algs[] =
=3D {
>>  				.cra_name =3D "md5",
>>  				.cra_driver_name =3D "md5-talitos",
>>  				.cra_blocksize =3D MD5_HMAC_BLOCK_SIZE,
>> +				.cra_reqsize =3D sizeof(struct talitos_ahash_req_ctx),
>>  				.cra_flags =3D CRYPTO_ALG_ASYNC |
>> -					     CRYPTO_ALG_ALLOCATES_MEMORY,
>> +					     CRYPTO_ALG_ALLOCATES_MEMORY |
>> +					     CRYPTO_AHASH_ALG_BLOCK_ONLY |
>> +					     CRYPTO_AHASH_ALG_FINAL_NONZERO,
>
> Sorry, but the FINAL_NONZERO flag doesn't work for algorithms like
> md5.
>
> The reason is that all implementations of md5 must accept the exports
> from each other.  So as long as the generic md5 doesn't not set
> FINAL_NONZERO, your driver will need to be able to take that on
> import.
>
> Cheers,

Hi Herbert,

Thanks for the info.

Paul.

--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

