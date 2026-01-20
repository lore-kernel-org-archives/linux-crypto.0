Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17263A4AC6;
	Tue, 20 Jan 2026 21:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768943837; cv=none; b=AvaNvSFm3PFFOD6AFRqPtkPXRIG1J1zHjFNLmMqiDIbpEDI8B9EEEuISZy6/odCaIjx7q8af21zT9Tet0huHo/W3KrBS+av5+YwoTQvRpgjsOOuwS+uIEYXJryA+aDg6SLCNEihJGmaREH4CkfjX//up+OFfBGcGlbtv7U8lpAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768943837; c=relaxed/simple;
	bh=t68CISjda46gY+jvScqGjqNWFBqJPn0no/XRg9FMx8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YS3V+6Ig0XCEHqgMHluzTgn9WpZdzeFvR1OWEd0dl3ZQjLlXCoSVZUqizCwqfjFIW81KG6J7O+r6f4tGH5s9yXIz7bpA73R91PYhSeQvTwuRRIuYJUzCesiBLONvHRSlQTqv2mLuldQs+itWzbmR2RvogCoImUAmrEszprB4sC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVjfO57G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVjfO57G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5ABC16AAE;
	Tue, 20 Jan 2026 21:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768943836;
	bh=t68CISjda46gY+jvScqGjqNWFBqJPn0no/XRg9FMx8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SVjfO57G8O0i2lYBO4mw3NrIx9p7vRZ4fDkNlKxzNNB15QAM2RIGry8v1rn70DEVF
	 W5VEQTty26icqoooyHN2g5HUDpsyVS/euyGTPswUBzpnU/Se9jbL61WSJsTtlpceKf
	 iMfwazTKaD48Ya7nZJ7exCaN/N6BFduaCmvKnysMD6b59iXtU56FSfayjGqtaSt/Ci
	 xE2WSeH9haj9nJbQ6JhISfi01n3a86RzHu9u/ifyAKKJ/cKJKvl48/0uYAW5IaUi6d
	 kSJor7tUdEQDbn6mWAbiz/gr3uPhCrQ9W41qfHn5zKcB2BBCBAMajeVpwiLIlqNcMY
	 5abgLDKHyprDw==
Date: Tue, 20 Jan 2026 13:17:13 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@cloudflare.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 04/12] pkcs7, x509: Add ML-DSA support
Message-ID: <20260120211713.GC2657@quark>
References: <20260120145103.1176337-1-dhowells@redhat.com>
 <20260120145103.1176337-5-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120145103.1176337-5-dhowells@redhat.com>

On Tue, Jan 20, 2026 at 02:50:50PM +0000, David Howells wrote:
> Add support for ML-DSA keys and signatures to the PKCS#7 and X.509
> implementations.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Please mention exactly what is supported.  Which versions of ML-DSA,
which hash algorithms, signed attributes, etc.

- Eric
