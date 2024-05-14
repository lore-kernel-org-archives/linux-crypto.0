Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D66E1E4B1
	for <linux-crypto@vger.kernel.org>; Tue, 14 May 2024 12:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715688321; cv=none; b=a7faAr64sdofomlUcXzMNhvOHyHzK9W4hxfi3k/oKaLmy1i+xVvh+bbUUdO2XcCDMzkGwPh9BfSeJ/B8e8MbkCjIiFs4DPse+mL7fIBtJsBDNIKMMHbCg6RPM9mziYcFDfQ50PETsi8f6ihq/I3ucjjZhvOAQA/T1ao3HywX0S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715688321; c=relaxed/simple;
	bh=bEb9YMvk9DRfUyUOyTXbsHtqFsFR8xUcJwKZecSyo7I=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=q26ju0s9YNL07D7WJqUAfA5QTkRDZTdT3liyRQ3cNrs96ddx/nKFwXcr6uDei7XQ/XGNlzU9wF2b1W8nko7bmgrivIdLYqR/AO0kq7/nhhXoZ5yrLmrwtBkpBLhHTPU1gNfxlM4EqUMxUiqzGc2pKlL2OijXSIxLAQXWwxSdax8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMrO2c7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMrO2c7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A07C32781;
	Tue, 14 May 2024 12:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715688320;
	bh=bEb9YMvk9DRfUyUOyTXbsHtqFsFR8xUcJwKZecSyo7I=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=MMrO2c7yhSD3pAEtwDOMb0beA42qWV7/IKD4UDPDQSTAV1cMKXoUGY+b7K9kEv2Xc
	 CIz2S365tWCAIrFHJQo1vO3+Vhwv9rby4nn4feyADEDPPywswKyvlFg2vM36WXjRvx
	 cXbVrv/wPKMM0bk+jGuuF9TznvxoC1s1wzK5ZLX+YXtAk8LkSCzjAf4ssuxcUNdXIT
	 wkJiUoTRBAcDxv8J8XR7lzfXF+GV8nmQVkY9lBjFX/vOQmcf59vRjElqZVYTtMXxs0
	 5fUOW813i3vyeLEhHGzW68eaXEMglNeyNKCV/pe7mfmh9jcIltk9Hp4VTufc1pHN+n
	 ZMS6Azo0Q3SbQ==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 May 2024 15:05:17 +0300
Message-Id: <D19CR04K40QG.30B7EKASUCOB9@kernel.org>
Subject: Re: [PATCH v5 1/2] certs: Move RSA self-test data to separate file
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Joachim Vandersmissen" <git@jvdsn.com>
Cc: "David Howells" <dhowells@redhat.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>, "Simo Sorce"
 <simo@redhat.com>, "Stephan Mueller" <smueller@chronox.de>, "James
 Prestwood" <prestwoj@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240513045507.25615-1-git@jvdsn.com>
 <D18SS8X9VV7L.28F9PNZ1PM96L@kernel.org>
 <d65279ed-20cb-4e23-866c-43b6291f51e2@jvdsn.com>
In-Reply-To: <d65279ed-20cb-4e23-866c-43b6291f51e2@jvdsn.com>

On Tue May 14, 2024 at 5:36 AM EEST, Joachim Vandersmissen wrote:
> On 5/13/24 3:26 PM, Jarkko Sakkinen wrote:
> > On Mon May 13, 2024 at 7:55 AM EEST, Joachim Vandersmissen wrote:
> >> +	pkcs7 =3D pkcs7_parse_message(sig, sig_len);
> >> +	if (IS_ERR(pkcs7))
> >> +		panic("Certs %s selftest: pkcs7_parse_message() =3D %d\n", name, re=
t);
> > Off-topic: wondering if Linux had similar helpers for PKCS#1 padding
> > (and if not, are they difficult to add)?
> PKCS#7 here refers to the message container format, rather than the=20
> padding. Internally, the PKCS#1 v1.5 padding scheme will be used (see=20
> software_key_determine_akcipher). Unless you are referring to PSS=20
> padding (also defined in PKCS#1)?

I think it should be PCKS#1 v1.5 padding as described in RFC 8017 [1]
but just for doing step 5:

https://www.rfc-editor.org/rfc/rfc8017#section-9.2.

This is for refreshing this old patch:

https://lore.kernel.org/all/20200518172704.29608-18-prestwoj@gmail.com/

I asked James if he could refresh it and one of the remarks was that
there is duplicate snippets with:

https://elixir.bootlin.com/linux/v6.9-rc6/source/crypto/rsa-pkcs1pad.c

But now that I look at this padding is not the issue here, but it is
the duplicate digest_info instances.

James has this construct in the old patch:

static const struct asn1_template {
	const char	*name;
	const u8	*data;
	size_t		size;
} asn1_templates[] =3D {
#define _(X) { #X, digest_info_##X, sizeof(digest_info_##X) }
	_(md5),
	_(sha1),
	_(rmd160),
	_(sha256),
	_(sha384),
	_(sha512),
	_(sha224),
	{ NULL }
#undef _
};

static const struct asn1_template *lookup_asn1(const char *name)
{
	const struct asn1_template *p;

	for (p =3D asn1_templates; p->name; p++)
		if (strcmp(name, p->name) =3D 0)
			return p;
	return NULL;
}

Looking at this the very first thing I spot is that the last field
is redundant so let's scrape that away. I neither get why use u8*
instead of struct digest_info * so let's switch to that.

So with those substitutions, renaming and a bit of polishing (but
not yet compiling ;-)) this what I end up with:

static const struct digest_info_mapping {
	char *name;
	struct digest_info *info;
} digest_info_map[] =3D {
#define _(X) { #X, digest_info_##X, }
	_(md5),
	_(sha1),
	_(rmd160),
	_(sha256),
	_(sha384),
	_(sha512),
	_(sha224),
	{ NULL }
#undef _
};

/**
 * find_digest_info() - Find digest info by the hash name
 * @name:	hash name
 *
 * Returns the digest info on success, and NULL on failure.
 *
struct digest_info *find_digest_info(const char *name)
{
	struct digest_info *mapping;
	int i;

	for (i =3D 0; digest_info_map[i] !=3D NULL; i++) {
		mapping =3D digest_info_map[i];
=09
		if (!strcmp(name, mapping->name))
			return mapping->info;
	}

	return NULL;
}
EXPORT_SYMBOL_GPL(find_digest_info);

The instances live in rsa-pcks1pad.c so it is the most trivial
place to add this.

BR, Jarkko
