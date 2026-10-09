Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E75A3B3BE6;
	Fri,  9 Oct 2026 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556050; cv=none; b=Cv9XKU4czYZUtRlgr5V0HdHmNWF+BEdzdlRLJ5/IPO/f66iyHErK/Wx6RYWcEQECXJlBy/sb8TS2tLsalHLor9ZncarXR1nMCWk2BKJSSgxUUpsnwe4DH7vpMK5WyDR6St5VnQwykALubu5WrKsZnHYOfoRCjbzX63psxr6LtZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556050; c=relaxed/simple;
	bh=ZIsfiAvIkBJ8O+ptlSECW6OMVaqU0S0nNqdw0bbnFMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TJEJgDSIPBZkQym/iHGPrVuOkOq6K4+wV7zVTEPPNSFuRrh0cPqmCvLyltgqhkslgh/pQYPZmo5BgxLxF2n+KaTttCAjZb9aYQ/lSiNLwUqrM1weDF56i71PMWpo4cOQ0WvAvrablqEHrgNYoVLKQ6+SQqr2hjGupYcIYRVZt8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGpn+/y6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGpn+/y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8E51F00893;
	Fri,  9 Oct 2026 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791556048;
	bh=beX7mL1hLFUigM2s5uq6UXKdAscODUkCRf/QvT/FG8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HGpn+/y6JFULK8YLopLY5ByiiXQouqJiH1FnB62Q8aJR4OlPe3x/L0oIIeEWuQIPU
	 R3+aE5qYS21c0vyswPyqICH//K11vOGXhGmP6Id2DHnpuNTO4Gp5hrzf6Gbpxd8YfB
	 lPycsncsvCpSmP/2c3+WTHgZAsyUjz7UVA6LzTmkN5wbR7g+y0zCd2dtska8gIQxo6
	 dBZP7nbcpXIi92A8irbpi0xG4GzdKH6uyRTyJ2XSDKGLkpa4ASrD9CzjGKiDKRX9vh
	 OlFK4gcGZGoPW+q2nGsXUrO07EhjNIhgwfY7QiZSNPKTjl/sgkeMbP+EdE+DrlHelV
	 a6u+rBQnfIX2g==
Date: Fri, 9 Oct 2026 16:27:22 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: =?iso-8859-1?B?Suly6W15?= Jean <jeremy.jean@oss.cyber.gouv.fr>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] lib/crypto: arm64: Fix lost Poly1305 carry when
 resuming NEON state
Message-ID: <20261009142722.GC321175@quark>
References: <20261008201949.561207-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261008201949.561207-4-Jeremy.Jean@oss.cyber.gouv.fr>
 <20261009130310.GA309826@quark>
 <98223a03dc250211153c1013232f2ce6@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98223a03dc250211153c1013232f2ce6@oss.cyber.gouv.fr>

On Fri, Oct 09, 2026 at 03:26:23PM +0200, Jérémy Jean wrote:
> On 2026-10-09 15:03, Eric Biggers wrote:
> > On Thu, Oct 08, 2026 at 08:19:50PM +0000, Jérémy Jean wrote:
> > > These limbs in base 2^26 represent the value
> > >       4
> > >     + (2^26    ) * 2^26
> > >     + (2^26 - 1) * 2^52
> > >     + (2^26 - 1) * 2^78
> > >     + (2^24 - 1) * 2^104
> > >   = 2^128 + 4,
> > > so converting back to base 2^64 must produce
> > >   h0 = 4, h1 = 0, h2 = 1,
> > > so that h0 + h1 * 2^64 + h2 * 2^128 = 2^128 + 4.
> > > 
> > > The third limb starts at bit 52, so its low 12 bits belong in h0 and
> > > its upper 14 bits belong in h1. The low-word ADDS starts from
> > >   4 + 2^26 * 2^26 = 2^52 + 4
> > > and adds the low 64 bits of
> > >   (2^26 - 1) << 52 = 2^78 - 2^52,
> > > namely 2^64 - 2^52. The sum is 2^64 + 4, so it leaves h0 = 4 and
> > > carry = 1.
> > > 
> > > The middle word contains the upper 14 bits of the third limb, all of
> > > the fourth limb, and the low 24 bits of the fifth limb. The next ADC
> > > adds the carry from h0 to
> > >   ((2^26 - 1) >> 12) + ((2^26 - 1) << 14),
> > > giving
> > >   (2^14 - 1) + (2^40 - 2^14) + 1 = 2^40.
> > > The following ADDS adds the low 64 bits of
> > >   (2^24 - 1) << 40 = 2^64 - 2^40,
> > > so the sum is 2^64, h1 wraps to 0, and carry = 1.
> > > 
> > > The top word starts from the remaining bits of the fifth limb,
> > >   (2^24 - 1) >> 24 = 0.
> > > The final ADC must add the carry from h1 and set h2 = 1. Writing the
> > > carry into d2 instead leaves h2 = 0, so the reconstructed value is 4
> > > instead of 2^128 + 4.
> > 
> > Thanks, but this LLM-generated "explanation" is way too verbose and
> > doesn't really say anything useful.  The new test in patch 2 is also
> > unnecessarily specialized to this exact issue and implementation, isn't
> > properly explained, and it's apparently LLM-generated too.  I'd normally
> > give a bit more time for submitters to fix things up, but since it will
> > likely just go back into the LLM, I don't think there's much point here.
> > So I went ahead and sent out a v3 that addresses these issues.
> 
> I did get help from LLM for the test, but I did write the explanation myself
> to explain the carry propagation in the computations. I thought it explained
> the carry bug nicely enough with an example, sorry that you disagree.

Well, it was written in the repetitive LLM style and basically took a
whole page to explain that there's a carry bit, which seems fairly self-
explanatory when unreduced limbs are allowed.  The space is better used
for other details.  If you wrote it by hand, then I'm sorry, but if you
don't want me to think your text is LLM-generated you shouldn't mix it
together with other LLM-generated stuff.

> I also added a paragraph on the probability that this happens, because it's
> very low and AFAICT, does not really impact current deployements.

Yes, but that part needed some elaboration, which I added.

Anyway, thanks for finding this.

- Eric
