Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794596515;
	b=vO/YMIktVjFeSL+UFIGFl6/px6i6RWNtYTqnqI6IRi3mHo2UurnaSlDIowTsdy7671Nw
	 TXP1jvw/3xFft6QP0QrWJ9h85FGxiyb6Z10KQb89pY904BJ5FwE1MXgu1qPxQFigDq1uc
	 6zHdb5U2PWXLo7msdQU3+QpiHT450pd2X02LA5/IpGuQRmfiyWeRHsSMSpZ39sR3JP9yf
	 VsM70DEV06eCERaO5X8xcIvz5yEwfWW3Ck5DVIsF6S7keQvLlsvul2iclhuRIFOIJ1bBR
	 1hEyw1Q+MBwrUWxgVnu9Nop70DhxKBaYFyQgJ8KksA3vkxb/itf3NikrkVI5sPWcvrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794596515;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kYMHJFNVFiFalk04m96v7i/1RAseK2KlDLd9FQ6zj/Q=;
	b=MkNgTFlm0GytSE46moKM1Y0Xxkw/cQfeLD6wxwxNoznwPYcBFZeEaZ0RxiTKLfnJfYQg
	 Ul1Q+BgZ5XMGoSogDIzMrKhj6HUJLM8YJmhEdo+5hPit+nCE7+oz2Vpg1FcTRudQX8Kt/
	 +9eBX7R6gtkx5eh3pTCl8TcAaBlludfY4dB8CJA03cl4nxgQhTG3tiTfGhltVoFS5y1lA
	 rrbEfJJCVte4h+W3J/wmBnapuMMt/Sizuhn++i8IuQ6kap1batut0ZaDE0Lsgi+1Bn9T9
	 L+/YQgFEAo4vWUXtEPaK5FHkSV2JxVlNLQyIUcG0wwo75KJHdDWNZSzFkhLO86uJb3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="jDV/q7oM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221C2606A32E;
	Fri, 13 Nov 2026 19:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDV/q7oM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B431F000C4;
	Fri, 13 Nov 2026 19:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596514;
	bh=kYMHJFNVFiFalk04m96v7i/1RAseK2KlDLd9FQ6zj/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jDV/q7oMWa+7vgvll0P1qJXRQwxO1z8iFN8dVuBgCuncKhAPRW4DjdXTD+QFIU1Q4
	 3NpB5rna/S+VrUs5Il+9NcQt0Eo/rxchHCXoomUJ8oddhzGJ/bBfweWpmThqGIb6iU
	 w3eZa/Mw/NxNozytYgfoLN3lfVzmtYTGF/DYCYuVJ0QjXCfzRAflPKFIy2+pVNHN3L
	 oc2Dg2jzCAFLKd51IlPsehSaRLZWloqxrvhfGQma2H1ZZIFqOJkkpFSBHRGp9rxTeK
	 vZSY6Z9GXW4o7bA+jrdxr2hlaX+rtcthU3jxk6UgF/6uds6UPrLRPVQB2RUzGAW4qU
	 iMguJ74Pz+feA==
Date: Fri, 13 Nov 2026 12:01:50 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 0/4] Get rid of all NEON intrinsics stdint.h type hacks
Message-ID: <20261113190150.GA2857474@ax162>
References: <20261029135020.272082-6-ardb+git@google.com>
 <20261112222720.GA188816@ax162>
 <bc58b973-3d54-4480-aaaa-f5d5269418ea@app.fastmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc58b973-3d54-4480-aaaa-f5d5269418ea@app.fastmail.com>

On Fri, Nov 13, 2026 at 09:23:03AM +0100, Ard Biesheuvel wrote:
> On Thu, 12 Nov 2026, at 23:27, Nathan Chancellor wrote:
> > Who do you think should take this series? It would be nice if it could
> > start making its way to mainline sooner rather than later since tip of
> > tree clang builds have been broken for over a month at this point.
> >
> 
> Are the first two patches sufficient for that? Perhaps Eric can take them
> through the CRC or libcrypto trees, and I can send the remaining ones
> through the respective arch trees the following cycle.

Unfortunately not :/ we need the third patch to resolve the error since
that is where the conflict is originating.

-- 
Cheers,
Nathan
