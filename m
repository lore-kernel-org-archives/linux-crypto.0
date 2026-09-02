Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E624AA3E6;
	Wed,  2 Sep 2026 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788369134; cv=none; b=C6OZATJdjz2qqQUSH6S3nePAd8bPGxmfdZVwM/moyzP8WiX/VtJnDSk3CvdHpFKTtIB4Ibj+rd34wu/xiylK5oDFo3yZSCl+5p+312KUsGspkhMKFVX0gfxTPsqx+i2oGH8BxcK6GhXWYNcInm5et47vE9sfDoiLSjHdKtHUDnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788369134; c=relaxed/simple;
	bh=fZuLt8422EjD3gqkd171TzZ29ULAApNcig44A2pECCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xx968n9gom6197Fb/T+CF6cbUIPu4C7N5u1w8yiqOhffy82RByEVGWmVQbveInNUHv5DtBlPLtjV3oCHQvw4sTeoxWrP0fNhc0dJnXuqj3ZT6OtWSE+AGpgwBkMc/aiKkwVGj1kDrjI3SymXf/hdXnJSkBGBziRzgV6l2zMdqv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VFo0VC5y; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VFo0VC5y"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DD9BF40E024B;
	Wed,  2 Sep 2026 17:12:09 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id PrFqerI28FwX; Wed,  2 Sep 2026 17:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788369119; bh=BYnxpZ5PuXcKYcCY+vQ9h01RB6KiigJqE6JVM0/EOWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VFo0VC5yDMFz9x4xJVqpMuX5QSExt3QmhkPOx6kWaDCARZQGlOLfarhmUjSG7wWwS
	 PzwWYnKuNN1RhtsfoE5oyKuWeSETTiYjq1uBHWxR8SIMK+fUuD/m0iIE41P89Eq01S
	 pqnk4BThuLg2bdx3dGNpA4wzTHuCOvNBi+wC2bw+fSdfTf/GsYLKmaLa9pOGNTtVAN
	 Nxj9HD6kkULdCv9jgV0411H5lwnLuvTQCCyPZssnEEddJ5rY6PS71YbjbR/+OIVdGv
	 474i6Uh0dZxDDGA7sl5HdVGPmKyOz8U3nqMK+586CRLE0I9rRrDQpo1L/Chs67Nra5
	 GsdKRiomMuzYIvC9F/sPWAo7nDDicoSA0DQ9PndoknAGkIr5MSpG2DOLAARibk0HB6
	 WV4TIiDdwP2gf4pDekZhlvEtL1LF1qUHUSo1SHaQPDxwZOODHyHFOAyR4l1D9D6U3H
	 gBEBjhejERQXpQNuRalRFn+K1o6W708YU8juwFqMMY3KQlbHNb4D+G7gtv/B8VG6jy
	 db1vMbk0exYnV9aeP3VKZ1pKc0bJiwiMCtk2f2ucEFySNq5wPjn5lyFxFOFSYwrJwa
	 DaF0l2q+GHZaXcA+2d3V11EM8EGk9IBmCeNB8KbsK67lnHAdMJcNZgGQlZtLogU8sL
	 dcCMcKKrO9Hm/Kx3WcoBaOUE=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1325840E027F;
	Wed,  2 Sep 2026 17:11:50 +0000 (UTC)
Date: Wed, 2 Sep 2026 10:11:47 -0700
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 0/8] x86: Remove cpu_has_xfeatures() and add AVX-512
 xor_gen()
Message-ID: <20260902171147.GKaphY04eCQFoweH04@fat_crate.local>
References: <20260901145740.42337-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260901145740.42337-1-ebiggers@kernel.org>

On Tue, Sep 01, 2026 at 07:57:32AM -0700, Eric Biggers wrote:
> Please consider this series for the x86 tree for 7.4.

Yeah, lemme take a look.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
