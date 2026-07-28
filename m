Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8F23F4DFC;
	Tue, 28 Jul 2026 23:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785282475; cv=none; b=uKtf68DgKpExSAPmTRG5o/xKj2/FUronDStA3lKjVTX5Mqxquq3veLB35wRkAhGU7BdJQ+GSoiGa5cB7ZEouL4FZQrjkiHFc2ZE6pcdlrSuLX+S5yEefthKCCmZxLb8RjE5+VQOI490lyyrUN+OsXEPb3C7pyA6Y37raFTzzb2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785282475; c=relaxed/simple;
	bh=eapES+nlwd8BlXmfPmxF16h9x7ia4cJiRiMu5MCUe0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZyADgEe13OrdWpG2X1KWbImJ347zOCJ2IfsYGvyynJU2fpDntXR9vyELBKoJeaIPMyzE0n6dEsgPL7MfiYyfykOvMaTMY4kNUkpTgm5hLO/EORssFExpA8AhrPpaW1K4DqIXpxB0Ms0YsB66xvaK4uXXLeuqR0hyE4b0jgq5Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=GK4kPxgX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="GK4kPxgX"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9780640E00E6;
	Tue, 28 Jul 2026 23:47:51 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id N2YSIUGj4ISB; Tue, 28 Jul 2026 23:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1785282458; bh=rSZ4EZdIcRdfM0sSFblZMIqtReqX+mJVV6LvsiMMjS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GK4kPxgXotMXlZPW3zhJC8bWtnAYYkkC2uUIW+/hRRmuhtZBn6CT8Tvz4znYANNkG
	 jE5WfzpwSZ8v6c1vErnMGlDIBkyavfRuQuXpdzvoCVmMzwJrDCcL1oDt2EgNDaJjFm
	 XvM2kw3BGJY6nvI27gbrFE0Siiv//xwgd/Hctr5k+L11c3DzJk+zMOqkE9034uq89A
	 Csx3l+1TG7L2j+iITJTpyJiE+y9cfym85bo/LzX4aihWwK8p32I+GTkDxxg5KibrT9
	 rwK7BCUUxZS7X52mxecaD5wC5G4on9hnH03O7u08DfEd07NHOv7Pcw9nhyLgAd39T6
	 D/skCRPQBHoJnKUYtyV6GbwWLR4Wi0jYWZ7MhNXR+gxNuVKzUxl+7sr+duTyT857Lo
	 qfJI9RwcUFCUIoEbIcXK8efw3vxco18z5MueueLNwvvPPYVEjkNfWmfs1EZ9+UsFpq
	 q1fWkuhKUIV2gs2iqmk/AtMGlAnkwLQ//Bw6KEfk6Gyr94DCO/ZFa4tIZDFaJRNypW
	 gJ1hPX6QmspD/fSxdzEKdIudCXxi8M0u8LleX4lkDWl5Xe8PbYfsR7miMnX5SzHE2q
	 kusZ2PRApVBzmQRfCOiU8fP5JsfSLY2iRPMOOYj5xpEl9YLYh54TaxvgHNy/grUh16
	 chKGhaBOMb3iuONHN55P2fKM=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 18C8B40E00C3;
	Tue, 28 Jul 2026 23:47:29 +0000 (UTC)
Date: Tue, 28 Jul 2026 16:47:26 -0700
From: Borislav Petkov <bp@alien8.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: x86@kernel.org, linux-um@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 1/8] x86/fpu: Check for missing AVX and AVX-512 xstate
 bits
Message-ID: <20260728234726.GCamk_jnl3LtfGbxoC@fat_crate.local>
References: <20260728021603.79870-1-ebiggers@kernel.org>
 <20260728021603.79870-2-ebiggers@kernel.org>
 <20260728052727.GCamg9v5WxNieTMUwE@fat_crate.local>
 <20260728054532.GA99797@sol>
 <20260728182007.GBamjy17zynlWm2gQT@fat_crate.local>
 <20260728183447.GB3355536@google.com>
 <20260728225936.GBamk0WK38PByPFkxz@fat_crate.local>
 <20260728233430.GA3277@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260728233430.GA3277@quark>

On Tue, Jul 28, 2026 at 04:34:30PM -0700, Eric Biggers wrote:
> I don't know what your suggestion is.  Are you still asking for the
> function to be renamed to clear_cpu_caps_xft()?  Note that the
> abbreviation "xft" doesn't appear anywhere else in arch/x86/.  Maybe you
> want the argument inverted?  I don't know what you want, sorry.

That's fine - I'll take a look at the final version after having gone through
the whole pile and then holler if I still see a need.

> The UML update is in this series.  See patch 2.  Maybe you don't care
> about UML but many people do.  kunit.py uses it by default, for example.

So I've heard.

> fpu__init_system_xstate() is already a function called once on the boot
> CPU.  Is your suggestion that the feature clearing should be once per
> CPU instead of just on the boot CPU?

Yes, we need it to run on every CPU if we're going to enforce the same
xfeatures and CPUID bits configuration everywhere.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
