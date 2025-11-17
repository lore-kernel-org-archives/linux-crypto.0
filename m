Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1816E186E58
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 01:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763342815; cv=none; b=czt8s1vdFBrWetMVvmn8pnBtQyycFcJJxSOCXkt8Y0td4c2auKewc7e3dY5Y7lHhsgjfX4wxNE1cxaIJ9hj++vaqoEVDP3JXABIDBBtrNucl2h/er0oycI8cDzspIFSH+IFHarWFOWEOsql2MNQ1dkookIxM+vhGGaUDhM7ZUcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763342815; c=relaxed/simple;
	bh=dLg+QJBLDylAfdLugGX+GVyJu2Einqiwqj6RT3P49xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VwbbCu10R55d9T8oZXFQbwk/BezNDA1U860BnkrEkJ8bTkmlRj5/bmK5TvrgTcGNeIsLYR5cQAfIOSBeuD952oIMLeLLFlUtHbEzx99eUDBr5/7FC/jfS2i5w0GmiSk6xstqie3nJbAVdwG+s21IulL1icanqFHDGSzBeu8F9p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mU8preq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mU8preq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95538C19421;
	Mon, 17 Nov 2025 01:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763342814;
	bh=dLg+QJBLDylAfdLugGX+GVyJu2Einqiwqj6RT3P49xg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mU8preq2eZMyPFQWs6FXf25uuraqPiTLIaVKiW1oIbIJMEeUwXZTmfq+ef9WuwTb9
	 /lVId9hZDdsGrYGVEL1lplPseGpjsOsUckiXcr0bqUXF319nkUe/iiPiVmZhRklN0z
	 jiycaGKbTiaLOgmXMcaL8KWrszyM45h78FWFLujRAsXC4I9w3gIvhH+TeLMyV/T2RZ
	 aD+p+fe+k+dCcOHSX6CNYUZ1fChAEZPPIHSc6DWvmRR00o/+Ua63n34Gf5xckBKN7v
	 np/s7fW3dPpfdiKaSVmWz9Q7WVGYpTDvsXpmhefm8f3znLNjoaIAhXMqr63PHGD0T6
	 eSBQxykpezLAA==
Date: Sun, 16 Nov 2025 17:25:13 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6.12] lib/crypto: arm/curve25519: Disable on
 CPU_BIG_ENDIAN
Message-ID: <20251117012513.GA1761@sol>
References: <20251111202936.242896-1-ebiggers@kernel.org>
 <20251116171942.3613128-1-sashal@kernel.org>
 <20251116193423.GA7489@quark>
 <aRpvevwfpVA4hqr3@laps>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRpvevwfpVA4hqr3@laps>

On Sun, Nov 16, 2025 at 07:42:34PM -0500, Sasha Levin wrote:
> On Sun, Nov 16, 2025 at 11:42:24AM -0800, Eric Biggers wrote:
> > On Sun, Nov 16, 2025 at 12:19:42PM -0500, Sasha Levin wrote:
> > > Subject: lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
> > > 
> > > Thanks!
> > 
> > I assume that you meant to write something meaningful in this message.
> 
> What else did you expect to see here?

Maybe some actual information that wasn't already in the email that
you're replying to?  What are you trying to accomplish?

- Eric
