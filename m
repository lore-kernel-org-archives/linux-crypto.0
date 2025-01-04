Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF6628FC;
	Sat,  4 Jan 2025 01:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735953505; cv=none; b=E9FUG67BuaG4pXH8X+C0Mz9Mr21KlPcGzJusARVRjFT7ouNvdTEOsY9C2N9X3ILW7d1PgTZOYuRNTxKXNqwmvhcs1xwvFA3V3Mmd5ldO6wAJZPD3rOhexADS6nysdOoVdTcDxcC0SBN+jAuYNDmBMOYwE04t7cYsQFNokU71dIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735953505; c=relaxed/simple;
	bh=4Vjg1+cUI6ho2/pWUSrT2vmqJqTp9HZzCDI9E0FjTRA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=i2rDyIxz9SrJVI5tux7g0e573Yv5+3qUzxGlyYFFDd6qXHlypgV7WfqmoktoSwtSM2d6NjePjPxbiX5zy5xjr+b9Q0qjouxZdrEierSj9ty8Q2FLdp2PPeX8E9JWw4LEMinBxjXB3Cy1PrM+Z/rQGMV8a1KDwpNXuO8D1CG7ctY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MU7XJm3A; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MU7XJm3A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5MxNWj9HOlakeZLFeYKbtljltb9M2p1Iww9nM1BniIQ=; b=MU7XJm3AHmYVvvP7xSEOtmt5za
	/AWT99+TYXJuE9di3LfVTVtArn5Fye+lw5GBoTDVWkRZ+p7YPd+tF2fFBPRUSg1CzeWkpl6TCA3pX
	dMIT5OZE3cDKBFTjbZAYMYBjr5ho8FDqjkFOUclkivA5CrXU87ztFbrjp7pr9XqOno/4m+FRV0gFI
	hgjovkzpuaUL9yNi1BzxNFUteU9oIgvOLYSO3hhYlLB8jWWbEpPS18NUZTAEf3ODvT1EnRSn9MUUu
	WLIhqyE6sM1pGHN9AlkVNHnBc2Lfu3V9JB6r3Ec6jB6aOH+wz8Z/yb7dPODgGtUbE/DCSUHd5qlB3
	hb/suHEQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tTsb3-005fbF-0P;
	Sat, 04 Jan 2025 09:18:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Jan 2025 09:18:17 +0800
Date: Sat, 4 Jan 2025 09:18:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, evepolonium@gmail.com,
	shane.wang@intel.com
Subject: Re: [PATCH] crypto: vmac - remove unused VMAC algorithm
Message-ID: <Z3iMWXwCLg36eous@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241226194309.27733-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove the vmac64 template, as it has no known users.  It also continues
> to have longstanding bugs such as alignment violations (see
> https://lore.kernel.org/r/20241226134847.6690-1-evepolonium@gmail.com/).
> 
> This code was added in 2009 by commit f1939f7c5645 ("crypto: vmac - New
> hash algorithm for intel_txt support").  Based on the mention of
> intel_txt support in the commit title, it seems it was added as a
> prerequisite for the contemporaneous patch
> "intel_txt: add s3 userspace memory integrity verification"
> (https://lore.kernel.org/r/4ABF2B50.6070106@intel.com/).  In the design
> proposed by that patch, when an Intel Trusted Execution Technology (TXT)
> enabled system resumed from suspend, the "tboot" trusted executable
> launched the Linux kernel without verifying userspace memory, and then
> the Linux kernel used VMAC to verify userspace memory.
> 
> However, that patch was never merged, as reviewers had objected to the
> design.  It was later reworked into commit 4bd96a7a8185 ("x86, tboot:
> Add support for S3 memory integrity protection") which made tboot verify
> the memory instead.  Thus the VMAC support in Linux was never used.
> 
> No in-tree user has appeared since then, other than potentially the
> usual components that allow specifying arbitrary hash algorithms by
> name, namely AF_ALG and dm-integrity.  However there are no indications
> that VMAC is being used with these components.  Debian Code Search and
> web searches for "vmac64" (the actual algorithm name) do not return any
> results other than the kernel itself, suggesting that it does not appear
> in any other code or documentation.  Explicitly grepping the source code
> of the usual suspects (libell, iwd, cryptsetup) finds no matches either.
> 
> Before 2018, the vmac code was also completely broken due to using a
> hardcoded nonce and the wrong endianness for the MAC.  It was then fixed
> by commit ed331adab35b ("crypto: vmac - add nonced version with big
> endian digest") and commit 0917b873127c ("crypto: vmac - remove insecure
> version with hardcoded nonce").  These were intentionally breaking
> changes that changed all the computed MAC values as well as the
> algorithm name ("vmac" to "vmac64").  No complaints were ever received
> about these breaking changes, strongly suggesting the absence of users.
> 
> The reason I had put some effort into fixing this code in 2018 is
> because it was used by an out-of-tree driver.  But if it is still needed
> in that particular out-of-tree driver, the code can be carried in that
> driver instead.  There is no need to carry it upstream.
> 
> Cc: Atharva Tiwari <evepolonium@gmail.com>
> Cc: Shane Wang <shane.wang@intel.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/arm/configs/pxa_defconfig             |   1 -
> arch/loongarch/configs/loongson3_defconfig |   1 -
> arch/m68k/configs/amiga_defconfig          |   1 -
> arch/m68k/configs/apollo_defconfig         |   1 -
> arch/m68k/configs/atari_defconfig          |   1 -
> arch/m68k/configs/bvme6000_defconfig       |   1 -
> arch/m68k/configs/hp300_defconfig          |   1 -
> arch/m68k/configs/mac_defconfig            |   1 -
> arch/m68k/configs/multi_defconfig          |   1 -
> arch/m68k/configs/mvme147_defconfig        |   1 -
> arch/m68k/configs/mvme16x_defconfig        |   1 -
> arch/m68k/configs/q40_defconfig            |   1 -
> arch/m68k/configs/sun3_defconfig           |   1 -
> arch/m68k/configs/sun3x_defconfig          |   1 -
> arch/mips/configs/bigsur_defconfig         |   1 -
> arch/mips/configs/decstation_64_defconfig  |   1 -
> arch/mips/configs/decstation_defconfig     |   1 -
> arch/mips/configs/decstation_r4k_defconfig |   1 -
> arch/mips/configs/ip27_defconfig           |   1 -
> arch/mips/configs/ip30_defconfig           |   1 -
> arch/s390/configs/debug_defconfig          |   1 -
> arch/s390/configs/defconfig                |   1 -
> crypto/Kconfig                             |  10 -
> crypto/Makefile                            |   1 -
> crypto/tcrypt.c                            |   4 -
> crypto/testmgr.c                           |   6 -
> crypto/testmgr.h                           | 153 -----
> crypto/vmac.c                              | 696 ---------------------
> 28 files changed, 892 deletions(-)
> delete mode 100644 crypto/vmac.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
