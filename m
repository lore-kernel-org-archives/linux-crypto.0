Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795807896;
	b=Bpo17JD+026T7U9+mUVyyUrvJN758oFtyJZV5ptnLCxPMg2V00Q8uHxWKJMwJV5cHab4
	 7EDRl5G0aGiBsSnnhSiTi2fUnd/qPqTfBGh+SGezqK76sp9ZoWsmVVG/k0QC1DY+0mOv8
	 qhUV1wWnmSkVB+961uBEPO8jvTQfDKXzKtKFB+nFZM8EP0Gm3YsNpRglIV1zevlSin2Lr
	 Li6q0KMHVWuMr6LuGFlG8BXF55CYtV+LQffTD7liprRrdQsvsmVWqil/Xbf69us5HmbIc
	 +RfSanPatndjXr6461dE+rZ8WzpdeI5U7ubeTYnHAjsSQIbikepVequZNoW5pp4C1pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795807896;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=FHm7smnuLcPbXOnsOL9bzFTWbe21BP4HbT3iZXqu3Z4=;
	b=rsEPe2ebT/THFixc6vMaGT5ZNoOwwuIFZcxPVCSjRY+tw9ddwTWW7wKIO92S0CbNeyjh
	 Tfk81YN4quBNHmQXesxoyQrbWFzDLvJWDlS6LL7aRRa8PoyOJS9ai3loYPOCTzPLsx22Q
	 b3uHaIKc4F4b1d4gc40ES+qi8kKxYmQ+O503Gpu3yPDAxmdK+ku/onmBakWc1IGS6NFWz
	 Yr0fHart2wAa6Byhwv+fwWVotNxhpH4pkP+OLk3GuhzhqcHpRL0auMfysqoW5WYoBl+8E
	 hJrqxfvOgONR5xqimMqWx/eZDFoCPzriVuZWDV3LSoHLPI3FAwhV1whlmAsyL+IA6kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hmfHF8HW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDFA606A31C;
	Fri, 27 Nov 2026 19:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hmfHF8HW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF6B1F00893;
	Fri, 27 Nov 2026 19:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795807896;
	bh=FHm7smnuLcPbXOnsOL9bzFTWbe21BP4HbT3iZXqu3Z4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hmfHF8HWqGe9fllK3m+JO8EXWm/LlKZRc9dNB9YqTNuggAx0G8a+Jj92V8Br5uMBM
	 4GbLWKMkZX56Q9MNagn3luHmpx8DRomhIUaccCA5bYwVDNW7H3I0fIP3X2DiCXVke1
	 feG0pkah19v53e+ijbWKvejGyFD7stt1D7yIlVpTqkC7iGpNLbdXVqm2PZhPFufYWI
	 hr3LVPJhflalZ9baVdkgJ7CY0JgGdrJWiWBrTok18WJ4tTr24i9TJdLp9mcWeKNl2G
	 +5du+ascO34JTp+ITfMPe5cpMVHQMsGSZOSfSp5DLq2b8kw3xOdAs98HkY4Jysh8zQ
	 MLxSpvwVm0dLQ==
Date: Fri, 27 Nov 2026 11:31:33 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: keyrings@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Alasdair Kergon <agk@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	David Gstir <david@sigma-star.at>,
	David Howells <dhowells@redhat.com>,
	David Laight <david.laight.linux@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ignat Korchagin <ignat@linux.win>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Morris <jmorris@namei.org>,
	James Prestwood <prestwoj@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>,
	Jonathan McDowell <noodles@meta.com>,
	Lukas Wunner <lukas@wunner.de>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sumit Garg <sumit.garg@kernel.org>
Subject: Re: [PATCH v5 00/17] KEYS: trusted: asymmetric keys
Message-ID: <20261127193133.GE8300@quark>
References: <20261127055602.2357884-1-jarkko@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127055602.2357884-1-jarkko@kernel.org>

On Fri, Nov 27, 2026 at 07:55:45AM +0200, Jarkko Sakkinen wrote:
> OVERVIEW
> ========
> 
> Extend TPM 2.0 trusted keys to load ASN.1 TPMKey [1] asymmetric keys
> (OID_TPMLoadableKey, 2.23.133.10.1.3) and expose keyctl pkey-operations
> directly on key_type_trusted. In addition there are some TPMKey
> interoperability fixes.
> 
> I.e. this my old series with a twist: instead of introducing a separate
> subtype for asymmetric keys, factor out pkey-operations into a separate
> CONFIG_KEYCTL_PKEY-feature, and wire asymmetric operations to
> key_type_trusted.
> 
> This work was originally derived from [3], is direct offspring of [2],
> and folds in the prerequisite tpm2-sessions and tpm-buf cleanups from
> [4].
> 
> [1] https://www.hansenpartnership.com/draft-bottomley-tpm2-keys.html
> [2] https://lore.kernel.org/linux-integrity/20240520184727.22038-1-jarkko@kernel.org/
> [3] https://lore.kernel.org/all/20200518172704.29608-1-prestwoj@gmail.com/
> [4] https://lore.kernel.org/linux-integrity/20261116005105.1573016-1-jarkko@kernel.org/

Could you describe the motivation for these changes here?  And also
include more context directly, for people who aren't already familiar
with all the earlier patches linked to above.

Also, this series is missing a base-commit, and I don't know how to
apply it for review.

- Eric
