Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1D43B83E8;
	Tue, 23 Jun 2026 21:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782251256; cv=none; b=MQg+QZs6+FOAhWzBWGl3reVb83CpdjIxg6OAYv2puDLnccxQnwebO0RALMvqEACOrbwsq3EOjbZNmAgQfswHI/NMyesL+JeSHr82aEnFhJ/zWtwGWvaC8TmZnRMB5nY3t0r8KX3plviu8kK/SVJMouI4XKeXHbQav76LRqGIrQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782251256; c=relaxed/simple;
	bh=C50YuZzkruFEqBK77+6dFlcPFkRrBf15/Wcbq+EjxZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usngXbL1QPt5FbHpwPcZpyA62ayUirkgJJ+/vX+hSIcXTzmL6/je2ICaLqBEhlyDwg+e1SltAAYhvf/O1myJphbvdi0uBxAgrCx2DEv1PERFPdNQhLvFwOJDzYDPnk2xCzxxZn5NkZVO7LHYtGFNVYnRhIUnBj+MmuWBs7bsqdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1rOw1MA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1rOw1MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2EB1F000E9;
	Tue, 23 Jun 2026 21:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782251252;
	bh=ZchPlcDY6TOiRThRYXe4l+YQOg1UcO64uVy4WgUrHwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C1rOw1MA1PA30hM4UgfA7VkeP976wxy5uVCBZWk3vK3KHul2naU4Zkuxne0auZFx7
	 vIu+AajuennLfXcScGSBcr8jFBPK+BvgTyCtcf6hWNYbrPW2wvS/XS1RLQMvvJ5uxO
	 5Gr7I9wQFGvUWhNebrfCfGpP1c3SfcdF5Ymak4iHzFelcFfyQz8P00SsxZe4XqOobF
	 DFWMIlfhb3Jn5YZmTBgrgGb0zERs2JYHF4Ml7l+U6hPBOelR+cZ9hFAJVVaqgFSBf5
	 O1myLI1lZKg65tJ0r7FlAbTnR/CRXpKtqef4IE1056XLI46/siePhw6XcgQkaQigv5
	 ykz8niYSL9Tdg==
Date: Tue, 23 Jun 2026 21:47:30 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, iwd@lists.linux.dev,
	linux-hardening@vger.kernel.org, Milan Broz <gmazyland@gmail.com>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] crypto: af_alg - Add af_alg_restrict sysctl, defaulting
 to 1
Message-ID: <20260623214730.GA3281861@google.com>
References: <20260622234803.6982-1-ebiggers@kernel.org>
 <CAKxU2N_EGTWkvtPOxQXBroxGVXDf1atPoFVyRRu0wHOtEXVWaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKxU2N_EGTWkvtPOxQXBroxGVXDf1atPoFVyRRu0wHOtEXVWaA@mail.gmail.com>

On Tue, Jun 23, 2026 at 02:28:17PM -0700, Rosen Penev wrote:
> > +static const struct af_alg_allowlist_entry hash_allowlist[] = {
> > +       { "cmac(aes)", true }, /* iwd, bluez */
> > +       { "hmac(md5)", true }, /* iwd */
> > +       { "hmac(sha1)", true }, /* iwd */
> > +       { "hmac(sha224)", true }, /* iwd */
> > +       { "hmac(sha256)", true }, /* iwd */
> > +       { "hmac(sha384)", true }, /* iwd */
> > +       { "hmac(sha512)", true }, /* iwd, sha512hmac */
> > +       { "md4", true }, /* iwd */
> > +       { "md5", true }, /* iwd */
> > +       { "sha1", false }, /* iwd, iproute2 < 7.0 */
> > +       { "sha224", true }, /* iwd */
> > +       { "sha256", true }, /* iwd */
> > +       { "sha384", true }, /* iwd */
> > +       { "sha512", true }, /* iwd */
> > +       {},
> In OpenWrt, https://gitlab.com/linux-afs/kafs-client and strongswan
> seem to be the other users of the user API. I haven't looked into what
> they need.

[Please trim your replies, thanks!]

https://gitlab.com/linux-afs/kafs-client uses AF_ALG only for
"hmac(md5)", which I already put on the privileged allowlist due to iwd
also using it.  So it would still work by default with the current
patch, unless it needs to use it unprivileged.

(FWIW, a use of a single obsolete algorithm like this is also a good
candidate for just replacing with local code...)

https://github.com/strongswan/strongswan already supports userspace
crypto libraries.

- Eric
