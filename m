Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052A11F4169;
	Fri, 14 Nov 2025 23:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763161341; cv=none; b=Fgu24mk6Nm27mDkETpxG7LPf3UEw4vETJrpqjf3MnTYu9qnt6Vwi4Nw8vX8MRJKdA2hHZ3TRZKLNVzXgV7C/j/BkI1g7tNiMGy9M0ssaChUTqlADs+cWthTh2KS7mTXCoJFSuT/ziwq7Gtc1gV2DgXpICujNgQFVzayEoi6tOog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763161341; c=relaxed/simple;
	bh=ePDu8J9+wwAv0x370wvH69b+ip84d+q2jA4MDcAjKMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+YOv1Lf8Ofrupua4zyM2c/roaEaWiCOB1NPgEGmXW+NAu2GhjtH9jGFZhH7X3jyfPSsorTMeFo+hgU9tjfFCoRJMtnJeQkzdOt0qp8dR/EKKHz8yT3tuGB6Ji4zCtQNsBI8Kc1A39djH7eQAwmT6kjd5NwJuJvw/o66XNDExcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Az0y2Fye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Az0y2Fye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B84BC4CEF5;
	Fri, 14 Nov 2025 23:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763161340;
	bh=ePDu8J9+wwAv0x370wvH69b+ip84d+q2jA4MDcAjKMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Az0y2FyelRkd0dkfQ0IoAgb1PYeTIqtPKOnjVQYbRdYuMW5tC6i+dy9AGa9DcGXU8
	 vbNT5ZIbLOCecXC28usySjsBpr7q1fYRvjiT9yjpXlJvO+5vGUMg82Ps7JUiudOVtS
	 uz1EZBS3v6NnC2cY5oqpUM/7gvFLsXrztoRShQzKKTu0Pc7i/bSUlwWaVEGffQGEkJ
	 bWe+hFvnjjv7LxRbWVO+QJ8hS+R1OWLfc6jzcUgtdUnRfJfXLQTqU4fd9msFV4i45P
	 anvloU4MnIFTle4aJn/4dN8Pw1rhKX24iBJY7996oiGyuaCs993s1Tb3qurcuhoVNz
	 11nPzWTkAkOfg==
Date: Fri, 14 Nov 2025 15:02:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Colin Ian King <coking@nvidia.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: scatterwalk: propagate errors from failed call
 to skcipher_walk_first
Message-ID: <20251114230218.GA289091@quark>
References: <20251114122620.111623-1-coking@nvidia.com>
 <20251114192810.GA1687@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114192810.GA1687@quark>

On Fri, Nov 14, 2025 at 11:28:10AM -0800, Eric Biggers wrote:
> On Fri, Nov 14, 2025 at 12:26:19PM +0000, Colin Ian King wrote:
> > There are cases where skcipher_walk_first can fail and errors such as
> > -ENOMEM or -EDEADLK are being ignored in memcpy_sglist. Add error checks
> > and propagate the error down to callers.
> > 
> > This fixes silent data loss from callers to memcpy_sglist (since walk is
> > zero'd) or potential encryption on the wrong data.
> > 
> > Signed-off-by: Colin Ian King <coking@nvidia.com>
> 
> There's no need for copying between two scatterlists to be able to fail.
> memcpy_sglist() should just be implemented from first principles instead
> of misusing the skcipher_walk stuff.  I actually suggested this already
> (https://lore.kernel.org/linux-crypto/20250427010834.GB68006@quark/) but
> unfortunately it was disregarded.

Done at https://lore.kernel.org/linux-crypto/20251114225851.324143-2-ebiggers@kernel.org/

- Eric
