Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E6E39182A;
	Wed, 23 Sep 2026 05:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790140596; cv=none; b=bOmchpKLZ5s4/Kzei7NchcOgCljAsOEPag1Is12Db282y/ApT19bijgkLF5D2Fl69w9CdqD5ypvlB/thGKN5mrPvMd3StpRlcUFThZz2HaQhrQcjUxfuy+opsnRTax3zA96gZYNjWh2UGU5RjStH2V6bs3oodpuc0/Qyw3kVcrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790140596; c=relaxed/simple;
	bh=py8Y7hDEb7pKJtcphdi5bTKw33iqAlAcl29p45Jf1bE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dd0sl1x8lneeywJL3cdyXBzIWtrYW0s1KSDeFV0PmL9xhg0AZ2w4vh1Nfm9cgyeUFVbqH0okVUI1VyBkYcp7sczQdkWL+mZWn0B7PFdIs94nZ5kHxm9WdrMSXH/8jSSRsEqV5HCOfM5Xyq+20jwXCgaU9cF/EYlU/cT5GSSUW3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IbjzkM/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IbjzkM/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88031F000FF;
	Wed, 23 Sep 2026 05:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790140595;
	bh=hhq8M0bpMaERJEmL5HHJ4uUb6lbtrmHobr4GrUUBw6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IbjzkM/ajcnT1FwT6w33gdufHf1q3sl3qNUxReQNvImCjgoUQN/HuiQj/Q5aCcYBL
	 LWQjmSjBYQ4APRFTek0I4ncl0Hax3aqVu25b1TNnsYmrSmFrOzZkRYgN8/Uh08/G4E
	 lifY02K7QQIHgl4aMsQZedquCFjiNHQvg9MCx/kRUzRKnobTJNZFOqVvFXHQ1v5sH8
	 ePlcz/XBGnE0SbjEsEwKxoebT1On28FxGNF1NxPZ0qClR3ei1ouJOBvlhISoKKajh/
	 GDTG48rU+aEJr4raac2V9uU+AJXV4PzU2zqx0PQ/w3jgE3cIEKBE/CVW70EXXw7gMb
	 eV/kA/K0G6lEg==
Date: Tue, 22 Sep 2026 22:16:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	srk@ti.com
Subject: Re: [PATCH v2] crypto: sa2ul - Fix stack overflow in
 sa_prepare_iopads
Message-ID: <20260923051633.GF42709@sol>
References: <20260831055141.1632832-1-s-vadapalli@ti.com>
 <aqpawGagrSvRkpTi@gondor.apana.org.au>
 <beba08cf-3e1d-4510-9498-d126482cdaa2@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <beba08cf-3e1d-4510-9498-d126482cdaa2@ti.com>

On Tue, Sep 22, 2026 at 06:33:51PM +0530, Siddharth Vadapalli wrote:
> On 9/16/26 2:30 PM, Herbert Xu wrote:
> > On Mon, Aug 31, 2026 at 11:21:38AM +0530, Siddharth Vadapalli wrote:
> > > 
> > > Since crypto_shash_export() writes 105 bytes into this 104-byte union, it
> > > overflows by one byte into the adjacent stack frame.
> > 
> > This should be converted to crypto_shash_export_core which exports
> > just the hash state without the partial block buffer.
> > > Changes since v1:
> > > - Propagated error from sa_prepare_iopads throughout the call chain.
> > > - Added missing check for authentication key size being within limits.
> > > Above changes are based on Sashiko review of the v1 patch at:
> > > https://sashiko.dev/#/patchset/20260819142357.3950463-1-s-vadapalli%40ti.com
> > 
> > Looks like Sashiko is still not happy:
> > 
> > https://sashiko.dev/#/patchset/20260831055141.1632832-1-s-vadapalli%40ti.com
> > 
> > Let's split this up.  Just do a one-liner to switch shash_export
> > to shash_export_core, that should fix the stack overrun.  Then
> > fix the long key issue in a separate patch.
> > 
> > I think you should support long keys properly by hashing them as
> > crypto/hmac.c does.
> 
> Thank you for reviewing the patch and providing your valuable feedback.
> 
> I will split the patch as you have suggested with the one-line fix patch
> posted first followed by an independent patch posted later for handling long
> keys.

https://lore.kernel.org/linux-crypto/20260923051116.92741-1-ebiggers@kernel.org
fixes both bugs properly by using the crypto library instead.  There's
really no need to even consider workarounds using crypto_shash here.

- Eric
