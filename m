Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0D3390CBE;
	Tue, 23 Jun 2026 17:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782237508; cv=none; b=iEGM6nMiEDQXTlxMJ7XGeOFTekugRn2fwd5qBPD/yCHWZOS/MqpkXpStwR7nuarXtWLCWIESex/hGZun6AkO1nlkeEuvJi/n1zF5gtmKWFZExKPeU/mA+Oe8pOukaj0VjP7SVXSc9y6dNR8GGj8bL5DEyGHGqMRZdqJGSMIMdik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782237508; c=relaxed/simple;
	bh=M+2ATMwb/KYaWbUmzlvg34hK7H4+tboghH1uw+zvY0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8dHoN4YCC4Src/W+kgmCNS1Q4kN1C5qj/sLjkKHZCTWdaoXj9vlO60A0GXW9qtf7Ae5FtUjeZM9M1USyOJaesARQHMAtw4RpyzY1qguu9r5XrAUt7Fye7Jsn/Jm0wkGcN7rEBOyLMVuOEPwM+wrr75Q0KMQvBGkYtQSNaaC0RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEZsFdE+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEZsFdE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAFB1F000E9;
	Tue, 23 Jun 2026 17:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782237507;
	bh=Hp82ew7GvEjYDGjORH9xNYPaL1WUVWPKbi6D8CbyFhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZEZsFdE+APvBrpKcIEkZPRGRWol9CARYT3JQa5q/PhatOpZcZPa1yNtj3yiD/jxhk
	 9zRpfLfhicclp95uYaRhNLKiD+FtggXECyxcr3oPpTXZ0ZPjPUENvoMCGM8vsb4961
	 azHFdOEeGsDoKO7vcH3lAS7ueQGpBjdbuPktcFr0DfU837XJVn72eTGCos4qvjV1hc
	 YJZfJNPGoodDDrW/xuH8uRZx0e1OFCNv0bm30BZj+Lb1SuTIEbQrW+YwyOdKhZgJoM
	 c+p5IOIO04xsCGcjByc4B28B3zQ5Lf7dWMUwtgCzJVpU5hnAgwpuD2KO35lpfFfUKj
	 Uxp5H2SRKTFkw==
Date: Tue, 23 Jun 2026 17:58:25 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
Message-ID: <20260623175825.GB1850517@google.com>
References: <20260622234803.6982-1-ebiggers@kernel.org>
 <34e20a64-17d3-4994-89f1-6084cd4fae36@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34e20a64-17d3-4994-89f1-6084cd4fae36@gmail.com>

On Tue, Jun 23, 2026 at 01:24:01PM -0400, Demi Marie Obenour wrote:
> I think there is room for something in-between the allowlist provided
> here and "no restrictions".  For instance, I think it makes sense
> to have a mode that allows modern¸ widely-used algorithms (AES-GCM,
> ChaCha20-Poly1305, SHA-3, HMAC, etc) to all users.
> 
> This makes it less likely someone turns off all restrictions.

Would it be worth the complexity when AF_ALG as a whole is deprecated?

> XFRM allows providing an arbitrary algorithm name, and it appears to
> be accessible in unprivileged user namespaces.  That also needs an
> allowlist.

Doesn't XFRM have a fixed list already?  The algorithm comes in as a
string, but it has to be in the list.

> > +	{ "hmac(sha512)", true }, /* iwd, sha512hmac */
> 
> Should this entry have privileged = false?  sha512hmac doesn't
> need privileges.

It's for the FIPS 140-3 integrity check use case, which runs as root.

> > diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
> > index 4dfe7899f8fa..bd522915d56d 100644
> > --- a/crypto/algif_rng.c
> > +++ b/crypto/algif_rng.c
> > @@ -48,10 +48,14 @@
> >  
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
> >  MODULE_DESCRIPTION("User-space interface for random number generators");
> >  
> > +static const struct af_alg_allowlist_entry rng_allowlist[] = {
> > +	{},
> > +};
> 
> Can this whole file be deleted?  You wrote that it isn't actually used.

That's not quite what I said.  There's still one known use case: CAVP
testing for FIPS 140-3 certifications.  But that only accesses the drbg
and jitterentropy RNGs and can run as root.

We could consider deleting it anyway and require that the FIPS people
use custom kernel modules.  But that is out of the scope of this patch.

> > +static const struct af_alg_allowlist_entry skcipher_allowlist[] = {
> > +	{ "adiantum(xchacha12,aes)", false }, /* cryptsetup */
> > +	{ "adiantum(xchacha20,aes)", false }, /* cryptsetup */
> > +	{ "cbc(aes)", true }, /* iwd */
> > +	{ "cbc(des)", true }, /* iwd */
> > +	{ "cbc(des3_ede)", true }, /* iwd */
> > +	{ "ctr(aes)", true }, /* iwd */
> > +	{ "ecb(aes)", true }, /* iwd, bluez */
> > +	{ "ecb(des)", true }, /* iwd */
> > +	{ "hctr2(aes)", false }, /* cryptsetup */
> > +	{ "xts(aes)", false }, /* cryptsetup benchmark */
> > +	{},
> > +};
> 
> Do the cryptsetup ones really need to be accessible to unprivileged users?

If we don't allow them, people running 'cryptsetup benchmark' will
notice the change.  Formatting could also be affected.

Requiring sudo in these cases might be feasible, but we need to strike
the right balance.  Maybe Milan has an opinion.

- Eric
