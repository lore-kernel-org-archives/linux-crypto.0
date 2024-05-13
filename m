Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E174C81
	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 01:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715563944; cv=none; b=D091JqU/aQZotQ+AV/KbJPrckJw0J+4xcdbsXMN8PcPjyum6M8fadkTpdZvM7FxG9roMdxAVDfcv2rqcaQSjWQ1roPrO8ODmuEN+Esye5BZGf+WPoTl62r5o9aeEHNrESCl6LIkpaRTrdqsP7mBzm9FveC0SuxODDmI5UvswoRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715563944; c=relaxed/simple;
	bh=YwLHu0iowsyoV2nhz/bYehSGn5fetrpehx0vk7y+dYQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=CflMfQ/C6tJi3C7EOTtGXjY1argw1Ox4HlBD5xdfftPRb21rjbLmFn7IdHPNBKhpSMjZ6KeN8GE4dK+W1T19We7wTxIV2ijkgZdI3z826Y4fn2dxiM7mDQh48TvZv6BEQJUYiv2Eh7JEtjtL5SLXl5HBIk9wlFUAgzSKLrE9zh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olh28ZRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olh28ZRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39581C116B1;
	Mon, 13 May 2024 01:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715563943;
	bh=YwLHu0iowsyoV2nhz/bYehSGn5fetrpehx0vk7y+dYQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=olh28ZRBNPX++6j9p6hlLBuqz0kp5svQ95vAMcUbCWr+gfBAj5SWVJTQA0lhNd2x4
	 zjabWCIffyPYznB+EnsEJj77Y6ae/vN0klWpL2VrcAwkiGaSw6kj/A13LMc2on6T2l
	 XRhtmkIirquswFZLp4Zc6vvhieDsRaSSrAKLShrYWRn8mCaV1zc2h1a3mUXOyIRiBI
	 tROEgDFxx7OP0hJ/UZOy3etE8es9W4oanijTW1PXMX+jNSCOGUbv4N6kqqljiLLIM+
	 lm02qD1+BLSdf2M1rqjDC2n7UH1iZ1tT2a5GAc8I7lt/s60U/kID6THtuaWXxorXLw
	 IjKkyse19lMFA==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 May 2024 04:32:20 +0300
Message-Id: <D184NU1V1GK5.38B7O2NKVESUE@kernel.org>
Subject: Re: [PATCH v4 1/2] certs: Move RSA self-test data to separate file
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Joachim Vandersmissen" <git@jvdsn.com>
Cc: <linux-crypto@vger.kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David Howells" <dhowells@redhat.com>, "Simo
 Sorce" <simo@redhat.com>, "Stephan Mueller" <smueller@chronox.de>
X-Mailer: aerc 0.17.0
References: <20240511062354.190688-1-git@jvdsn.com>
 <D181O1G1V18T.1SFRUIEFUPCQI@kernel.org>
 <70b6dbf0-eb54-4e23-a295-6f7f0d02a23c@jvdsn.com>
In-Reply-To: <70b6dbf0-eb54-4e23-a295-6f7f0d02a23c@jvdsn.com>

On Mon May 13, 2024 at 4:11 AM EEST, Joachim Vandersmissen wrote:
> On 5/12/24 6:11 PM, Jarkko Sakkinen wrote:
> > On Sat May 11, 2024 at 9:23 AM EEST, Joachim Vandersmissen wrote:
> >> v4: FIPS_SIGNATURE_SELFTEST_RSA is no longer user-configurable and wil=
l
> >> be set when the dependencies are fulfilled.
> >>
> >> ---8<---
> > This is in wrong place. If the patch is applied it will be included to
> > the kernel git log. Please put your log before diffstat.
> I will keep it in mind for the next round.
> >
> >> In preparation of adding new ECDSA self-tests, the existing data is
> >> moved to a separate file. A new configuration option is added to
> >> control the compilation of the separate file. This configuration optio=
n
> >> also enforces dependencies that were missing from the existing
> >> CONFIG_FIPS_SIGNATURE_SELFTEST option.
> > 1. Please just call the thing by its name instead of building tension
> >     with "the new configuration option".
> > 2. Lacks the motivation of adding a new configuration option.
> The configuration option is there to ensure that the RSA (or ECDSA)=20
> self-tests only get compiled in when RSA (or ECDSA) is actually enabled.=
=20
> Otherwise, the self-test will panic on boot. I can make this more=20
> explicit in the commit message.
> >
> >> The old fips_signature_selftest is no longer an init function, but now
> >> a helper function called from fips_signature_selftest_rsa.
> > This is confusing, please remove.
> Fair enough, I'll remove it from the commit message.

Yeah, I mean it is good to enough to have a code change no need to
document it here :-)

> >
> > So why just send this and not this plus the selftest? Feels incomplete
> > to me.
>
> Do you mean the ECDSA self-test? I didn't include that one here because=
=20
> I didn't want to make the commit too big.

So, I'd suggest to make a patch set with the second patch containing
the tests.

BR, Jarkko
