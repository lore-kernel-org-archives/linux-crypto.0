Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C26748F
	for <linux-crypto@vger.kernel.org>; Mon, 17 Nov 2025 01:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763344353; cv=none; b=pXUTagahJL4dg6g4cBKiuGc5Y5eoiGhu35JJ7KgIIgcf3ZzEB3CKXsYYreRrud0I1Egc9oCgkkmJV+hu2oV2nrI0MVXPsYFLwJtXnP1gZQZYPstr0yycGAMdqtJbYvJ0hWaLDLkDt0XenTf5jZdQryv8zpA86TihxzAwpcYTVTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763344353; c=relaxed/simple;
	bh=vPc6XCW8k+eJ+h2lZh92rJu4RKyCE1rJeba/epoC+dA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYYrvmG0wrRN4955iyN0b4XrCbcpM0P7J3T67OozxXV8nZqWs9TZkAu+XxWEiBeol4TIkvk5hnCVXLBMMZdwkjoE4NC0M0nMyueXa1egYBHPy20HrV/bbvU67objJDLgn/VTkqupbfEm9tS92LB57K9xLHlz/fy3Mkf5xBcTtjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LHwZyeKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LHwZyeKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBD7C116D0;
	Mon, 17 Nov 2025 01:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763344353;
	bh=vPc6XCW8k+eJ+h2lZh92rJu4RKyCE1rJeba/epoC+dA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LHwZyeKWHXu+n6u5FVpGwSGcL6A5dMpo06e287dbmUdDYGTIj9NN3CtN4Pkh8r2wJ
	 hhgBCbvfsOISGAZEftSa5pmi8vtIm0LY+obBMjHjKLeofFXVSzQ+BLwx2RY9wdDeop
	 5IbtaNcoKhwzSIT0SWWza8nGHlzpxIyu4CDbBE+d+YjkInZbAcPZrlhckpOEhCQvHI
	 gfPIP7q0iE64B5UDNqQtgsXtYDlRZELNK3HmDu0hoe2poAj/M+lYqvKwfcgj5187yX
	 +fOcKBOfHjMK94+5akQgUjq5pTSeKlQqRTZ+sKFuQEiGx/ze48DoLjb3A/vgIf0RRq
	 rKQ8bkM3+xDDg==
Date: Sun, 16 Nov 2025 17:50:52 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 6.12] lib/crypto: arm/curve25519: Disable on
 CPU_BIG_ENDIAN
Message-ID: <20251117015052.GA177915@sol>
References: <20251111202936.242896-1-ebiggers@kernel.org>
 <20251116171942.3613128-1-sashal@kernel.org>
 <20251116193423.GA7489@quark>
 <aRpvevwfpVA4hqr3@laps>
 <20251117012513.GA1761@sol>
 <aRp9sPD7Am9nF-_3@laps>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRp9sPD7Am9nF-_3@laps>

On Sun, Nov 16, 2025 at 08:43:12PM -0500, Sasha Levin wrote:
> On Sun, Nov 16, 2025 at 05:25:13PM -0800, Eric Biggers wrote:
> > On Sun, Nov 16, 2025 at 07:42:34PM -0500, Sasha Levin wrote:
> > > On Sun, Nov 16, 2025 at 11:42:24AM -0800, Eric Biggers wrote:
> > > > On Sun, Nov 16, 2025 at 12:19:42PM -0500, Sasha Levin wrote:
> > > > > Subject: lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
> > > > >
> > > > > Thanks!
> > > >
> > > > I assume that you meant to write something meaningful in this message.
> > > 
> > > What else did you expect to see here?
> > 
> > Maybe some actual information that wasn't already in the email that
> > you're replying to?  What are you trying to accomplish?
> 
> Letting you know that your backport was queued up?

Maybe you should have mentioned that then?

- Eric
