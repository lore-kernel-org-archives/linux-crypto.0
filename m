Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB4C4E0B91;
	Tue, 29 Sep 2026 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790717102; cv=none; b=BT0iVsQ2rfCAPFS9rLhUOLiykTtAsUwQIMtQ+bId2bUM4VljLr5vUn3vuOIeIzkmuFGMKrfIlGNeXFY0Ep17fXGEwvkBQp/fSVBR4U30mSHPux0mq6/l6GL32VjW3bTOIgeEmXsw1yitnHWaQpKCiUUpnHuyLSzKws/DyXO2HlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790717102; c=relaxed/simple;
	bh=NEbPWLyY8qH8okP99LRDOSngWgUEubh3SvqvK5XZUBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7xwHheibmMmRUvOC54y+kG8aPoyomsJDooDJv9DiT5lxzZNwpLL8Y2v61c/W3AzMwZJ3eoSC8wd/eTIXlNhRuVpoBRQ0IY6HJgR0ja8Qb2MJzRifn9uvBvP1y5Ygiv/5vBTV5tz6VGFVJ5ibP1Wds0wTkz8qLJy1dpOtFJgEE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PV0OYkyL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PV0OYkyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB501F000FF;
	Tue, 29 Sep 2026 21:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790717101;
	bh=PTOpHjEIAP7a4zpl3q6vtnqnVvJ1aaGeDzaauIxGgtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PV0OYkyLCDrCUf2ldFlTRIrosbIaOnXP7IcCkqCXEy8sEHR2a+pRQ/Y6rEq6Mv0uJ
	 oLzntFvZgFDEIpR/DCI1bcQPMvnDTBKZNQb7I3ZIFcezELzMW4kB6nVwHf93slaJpF
	 7pwfGqmEvP7f4+IVMx4/FjbUK88haiKvfnaamhqgXB8XeN48ahLXJYPSOgVNkqD2W6
	 bbM98X5YcBjHbMgowxRNWd0KZIdE16GcvoRL5hR8K6TwnXtVjI+Qi5uC87azTOr8cy
	 nmxgm3cTwbEJQxfQ9DIS9nATnur+lbCpXSs/0DSdZ4pPhKQnZ4j1PXXmZdbOMfd5KY
	 C17ZgsnAhZrCQ==
Date: Tue, 29 Sep 2026 21:24:59 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Stian Halseth <stian@itx.no>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: sparc/aes-xts: Add optimization using the
 AES opcodes
Message-ID: <20260929212459.GA2843629@google.com>
References: <20260929211218.4194135-1-stian@itx.no>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929211218.4194135-1-stian@itx.no>

On Tue, Sep 29, 2026 at 11:12:18PM +0200, Stian Halseth wrote:
> Since commit 94efa0c9fb36 ("crypto: aes - Add XTS support using
> library"), xts(aes) on sparc64 is xts-aes-lib.  sparc64 has no
> aes_xts_*_arch(), so that goes block by block through aes_encrypt(),
> where 7.2 got the xts template over ecb-aes-sparc64.  On a SPARC M7,
> AES-256-XTS through AF_ALG fell from 390 to 144 MiB/s.
> 
> Implement aes_xts_encrypt_arch() and aes_xts_decrypt_arch() with the AES
> opcodes, for AES-128 and AES-256, two blocks per iteration.  AES-192,
> which IEEE 1619 does not specify, and data that is not 8-byte aligned
> are left to the generic code.

It's a little late to be adding new optimized code in 7.3.  But yes,
full AES-XTS performance requires that it be implemented directly, so we
should add this optimized AES-XTS code in 7.4 (assuming people still
care about SPARC, which I guess you do).  For 7.3 let's just suppress
"xts-aes-lib" on sparc.  I left it out of the patch
https://lore.kernel.org/linux-crypto/20260925202353.10763-1-ebiggers@kernel.org/
, but I guess it should be included after all.

- Eric
