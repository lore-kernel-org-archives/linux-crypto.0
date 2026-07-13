Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6938D2D063E;
	Mon, 13 Jul 2026 02:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783908902; cv=none; b=bXKirD2ohRnF3St/rb0X/j7oMcL1P79DgwsJWyeBIEA4P+35XloLcAj3r5tc/aMvTqDAkz++GtY2aj+z1MYyxxt5h+jEswrGMNB53ebe09U1eIH3yc/GntQvC9+AqebxinO1hXPWuLXPdTf90j5DsFuYb4iFon+SzUMcMh4ar3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783908902; c=relaxed/simple;
	bh=kw+LLP3hpqlsFzEzPizrw/bm2oVbbsC1lVN1pLjWPZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VeYclBWOWSn5qFwVY7AnddQ5r/P5FRy1DeHR/y1ANCe9UAxPZnoMjenFbME0hg/qdazE4xxAxoEzUMNgrr00g+c0ZNbDJ0acHDS2Kh/YZEuzERzKcu5r0oiJ+VPEQLLc3crXVxgbSZ46gHhP3I6p1hD4xQIlo/AVSlKYSLNXTXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1fGFb4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1fGFb4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A561F1F000E9;
	Mon, 13 Jul 2026 02:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783908901;
	bh=/Vb5rf7cT958dL+h9956kOlE3FAHNWGmGnW2LFJCHzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i1fGFb4IvsGPFnxmsvbx4N3hFlstzew2yh0rHKBmINBnh0thLVtJlPfd+tUcx6CQk
	 yDpc1U1CtX6293zQblu9+rGWOTnlrbGEXDyxSSQHbSE8PGdSiF4D7Ih0LaNrj0OTzr
	 mvMBsp2oDc5zxMlbTKUaM8RyQRoT1h0opIxCC8XEaxCbrOBRnFY5sU4iIBGSxUQw1s
	 B0T4xEVkP6IIpVOBXGyzlE+V+7kI/Lt/6n7EI0qcASZTqoK457JUrJTkzDjAFrzjpD
	 U7Lkm1t0mimlFebb15sG2jDzrRXyz1YfIhLnap30/8egTqpCQhECtwn4CCDa+Ij7Fo
	 0UsWhY2yX7MWQ==
Date: Sun, 12 Jul 2026 22:14:58 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: docs: Improve introduction sentence
Message-ID: <20260713021458.GC4362@quark>
References: <20260709022747.44635-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709022747.44635-1-ebiggers@kernel.org>

On Wed, Jul 08, 2026 at 10:27:47PM -0400, Eric Biggers wrote:
> Make it clear that lib/crypto/ is a kernel-internal library.  It's easy
> for people to come across this page, especially the HTML version online,
> without that context.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  Documentation/crypto/libcrypto.rst | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
